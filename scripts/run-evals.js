#!/usr/bin/env node
// TF-IDF trigger-routing and description-collision evals.
//
// Routing: ranks each prompt in evals/routing-prompts.json against every
// skill description in skills/*/SKILL.md using TF-IDF + cosine similarity,
// and reports where the expected skill ranked. CI enforces a rank-1 floor.
//
// Collisions: computes pairwise similarity between skill descriptions and
// flags pairs at or above the threshold — near-duplicate descriptions make
// model-side skill routing unreliable.
//
// No dependencies; runs on Node 18+.
//
// Usage:
//   node scripts/run-evals.js                         # report only
//   node scripts/run-evals.js --min-rank1 75          # fail if <75% of prompts rank their skill #1
//   node scripts/run-evals.js --collision-threshold 0.75
//   node scripts/run-evals.js --fail-on-collision     # collisions become errors, not warnings
//   node scripts/run-evals.js --root /path/to/repo    # eval another repo's skills/
//   node scripts/run-evals.js --collisions-only       # skip routing (no prompts file needed)

'use strict';

const fs = require('fs');
const path = require('path');

// --- CLI args ---------------------------------------------------------------

const args = process.argv.slice(2);
function argValue(flag, fallback) {
  const i = args.indexOf(flag);
  if (i === -1 || i + 1 >= args.length) return fallback;
  return args[i + 1];
}
const MIN_RANK1 = argValue('--min-rank1', null); // percentage, e.g. "75"
const COLLISION_THRESHOLD = parseFloat(argValue('--collision-threshold', '0.75'));
const FAIL_ON_COLLISION = args.includes('--fail-on-collision');
const COLLISIONS_ONLY = args.includes('--collisions-only');

const ROOT = path.resolve(argValue('--root', path.resolve(__dirname, '..')));
const SKILLS_DIR = path.join(ROOT, 'skills');
const PROMPTS_FILE = path.join(ROOT, 'evals', 'routing-prompts.json');

// --- Frontmatter description extraction -------------------------------------

function extractDescription(skillMd) {
  const content = fs.readFileSync(skillMd, 'utf8');
  const lines = content.split('\n');
  if (lines[0] !== '---') return null;
  const fm = [];
  for (let i = 1; i < lines.length; i++) {
    if (lines[i] === '---') break;
    fm.push(lines[i]);
  }
  // Find "description:" and consume any following indented continuation
  // lines (plain multi-line values and >-/|-style block scalars).
  for (let i = 0; i < fm.length; i++) {
    const m = fm[i].match(/^description:\s*(.*)$/);
    if (!m) continue;
    let value = m[1].replace(/^[>|][+-]?\s*$/, '');
    const parts = value ? [value] : [];
    for (let j = i + 1; j < fm.length; j++) {
      if (/^\s+\S/.test(fm[j])) {
        parts.push(fm[j].trim());
      } else {
        break;
      }
    }
    return parts.join(' ').trim();
  }
  return null;
}

// --- Tokenization + TF-IDF ---------------------------------------------------

const STOPWORDS = new Set([
  'a', 'an', 'and', 'are', 'as', 'at', 'be', 'by', 'for', 'from', 'has',
  'have', 'in', 'into', 'is', 'it', 'its', 'like', 'of', 'on', 'or', 'that',
  'the', 'their', 'them', 'then', 'these', 'this', 'to', 'use', 'used',
  'user', 'via', 'when', 'whether', 'which', 'with', 'you', 'your', 'me',
  'my', 'can', 'do', 'does', 'how', 'not', 'no', 'so', 'if', 'we', 'us',
  'invoke', 'invoked', 'mentions', 'asks', 'says', 'skill',
]);

function tokenize(text) {
  return text
    .toLowerCase()
    .split(/[^a-z0-9]+/)
    .filter((t) => t.length > 1 && !STOPWORDS.has(t));
}

function termFreq(tokens) {
  const tf = new Map();
  for (const t of tokens) tf.set(t, (tf.get(t) || 0) + 1);
  return tf;
}

function buildIdf(docTfs) {
  const n = docTfs.length;
  const df = new Map();
  for (const tf of docTfs) {
    for (const term of tf.keys()) df.set(term, (df.get(term) || 0) + 1);
  }
  const idf = new Map();
  for (const [term, count] of df) {
    idf.set(term, Math.log((n + 1) / (count + 1)) + 1);
  }
  return idf;
}

function vectorize(tf, idf) {
  const vec = new Map();
  for (const [term, count] of tf) {
    // Unseen terms get the max-rarity IDF so prompt-only terms still count.
    const w = idf.get(term) || Math.log((idf.size + 1) / 1) + 1;
    vec.set(term, count * w);
  }
  return vec;
}

function cosine(a, b) {
  let dot = 0;
  for (const [term, wa] of a) {
    const wb = b.get(term);
    if (wb) dot += wa * wb;
  }
  const norm = (v) => Math.sqrt([...v.values()].reduce((s, w) => s + w * w, 0));
  const na = norm(a);
  const nb = norm(b);
  if (na === 0 || nb === 0) return 0;
  return dot / (na * nb);
}

// --- Load skills --------------------------------------------------------------

if (!fs.existsSync(SKILLS_DIR)) {
  console.error(`ERROR: ${SKILLS_DIR} not found`);
  process.exit(1);
}

const skills = [];
for (const entry of fs.readdirSync(SKILLS_DIR, { withFileTypes: true })) {
  if (!entry.isDirectory()) continue;
  const skillMd = path.join(SKILLS_DIR, entry.name, 'SKILL.md');
  if (!fs.existsSync(skillMd)) continue;
  const description = extractDescription(skillMd);
  if (!description) {
    console.error(`ERROR: no description in ${skillMd}`);
    process.exit(1);
  }
  skills.push({ name: entry.name, description });
}

if (skills.length === 0) {
  console.error('ERROR: no skills found under skills/');
  process.exit(1);
}

const docTfs = skills.map((s) => termFreq(tokenize(s.description)));
const idf = buildIdf(docTfs);
const docVecs = docTfs.map((tf) => vectorize(tf, idf));

let failures = 0;

// --- Description collision check ---------------------------------------------

console.log('== Description collision check ==');
console.log(`   threshold: ${COLLISION_THRESHOLD} | skills: ${skills.length}`);
const collisions = [];
for (let i = 0; i < skills.length; i++) {
  for (let j = i + 1; j < skills.length; j++) {
    const sim = cosine(docVecs[i], docVecs[j]);
    if (sim >= COLLISION_THRESHOLD) {
      collisions.push({ a: skills[i].name, b: skills[j].name, sim });
    }
  }
}
if (collisions.length === 0) {
  console.log('   ✓ no collisions\n');
} else {
  for (const c of collisions.sort((x, y) => y.sim - x.sim)) {
    const marker = FAIL_ON_COLLISION ? '✗' : '⚠';
    console.log(`   ${marker} ${c.a} <-> ${c.b}  similarity ${(c.sim * 100).toFixed(1)}%`);
  }
  console.log(
    `   ${collisions.length} collision(s) — near-duplicate descriptions degrade skill routing; ` +
      'differentiate trigger phrases and scope boundaries.\n'
  );
  if (FAIL_ON_COLLISION) failures++;
}

// --- Routing eval --------------------------------------------------------------

if (COLLISIONS_ONLY) {
  process.exit(failures > 0 ? 1 : 0);
}

console.log('== Trigger-routing eval ==');
if (!fs.existsSync(PROMPTS_FILE)) {
  console.error(`ERROR: ${PROMPTS_FILE} not found — populate routing prompts before running evals`);
  process.exit(1);
}

const promptData = JSON.parse(fs.readFileSync(PROMPTS_FILE, 'utf8'));
const cases = promptData.prompts || [];
if (cases.length === 0) {
  console.error('ERROR: evals/routing-prompts.json has no prompts');
  process.exit(1);
}

const skillIndex = new Map(skills.map((s, i) => [s.name, i]));
let rank1Count = 0;

for (const c of cases) {
  if (!skillIndex.has(c.expect)) {
    console.error(`   ✗ prompt expects unknown skill "${c.expect}": "${c.prompt}"`);
    failures++;
    continue;
  }
  const promptVec = vectorize(termFreq(tokenize(c.prompt)), idf);
  const scored = skills
    .map((s, i) => ({ name: s.name, score: cosine(promptVec, docVecs[i]) }))
    .sort((a, b) => b.score - a.score);
  const rank = scored.findIndex((s) => s.name === c.expect) + 1;
  const top = scored[0];
  if (rank === 1) {
    rank1Count++;
    console.log(`   ✓ rank 1  [${c.expect}] "${c.prompt}"`);
  } else {
    console.log(
      `   ✗ rank ${rank}  [${c.expect}] "${c.prompt}" — top match was ${top.name} (${(top.score * 100).toFixed(1)}%)`
    );
  }
}

const graded = cases.filter((c) => skillIndex.has(c.expect)).length;
const pct = graded === 0 ? 0 : (rank1Count / graded) * 100;
console.log(`\n   rank-1: ${rank1Count}/${graded} (${pct.toFixed(1)}%)`);

if (MIN_RANK1 !== null) {
  const floor = parseFloat(MIN_RANK1);
  if (pct < floor) {
    console.error(`   ✗ below --min-rank1 floor of ${floor}%`);
    failures++;
  } else {
    console.log(`   ✓ meets --min-rank1 floor of ${floor}%`);
  }
}

process.exit(failures > 0 ? 1 : 0);
