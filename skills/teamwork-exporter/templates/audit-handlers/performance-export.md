# Performance Audit Export Handler

Transform performance scan results into Little Task templates.

## Input Format

Performance scan results (Lighthouse, Core Web Vitals) with:
- Core Web Vitals metrics
- Lighthouse scores
- Performance bottlenecks
- Optimization opportunities

## Output Template

Little Task for improvements

## Example Transformation

### Input Finding:

```markdown
### High: Large JavaScript Bundle Size

**Impact:** 1.2s delay in Time to Interactive
**File:** `bundle.js` (847 KB)
**Lighthouse Score:** 62/100

Main JavaScript bundle is too large, causing slow page load. Multiple unused libraries included.

**Recommendation:**
- Remove unused dependencies
- Implement code splitting
- Lazy load non-critical modules
```

### Exported Task:

```markdown
# Little Task: Reduce JavaScript Bundle Size

## Task Description
Optimize main JavaScript bundle (`bundle.js`) which is currently 847 KB and causing 1.2s delay in Time to Interactive. Performance audit identified unused libraries and lack of code splitting.

**Current State:**
- Bundle size: 847 KB
- TTI delay: 1.2s
- Lighthouse score: 62/100

**Target:**
- Bundle size: < 300 KB
- TTI delay: < 500ms
- Lighthouse score: > 90/100

## Acceptance Criteria
- [ ] Remove unused dependencies (identified in audit)
- [ ] Implement code splitting for route-based chunks
- [ ] Lazy load non-critical modules (analytics, chat widget)
- [ ] Bundle size reduced to < 300 KB
- [ ] Lighthouse performance score > 90
- [ ] Time to Interactive < 500ms

## Technical Approach
1. **Analyze bundle:** Run `npm run analyze` to identify large dependencies
2. **Remove unused:**
   - `lodash` (use individual imports)
   - `moment` (replace with `date-fns`)
   - Unused vendor libraries
3. **Code split:** Implement route-based splitting with React.lazy()
4. **Lazy load:** Move analytics and chat to separate chunks

## Testing Steps
1. Run `npm run build`
2. Check bundle size: `ls -lh dist/*.js`
3. Run Lighthouse audit
4. Test page load on 3G connection (DevTools throttling)
5. Verify all features still work

## Validation
- Test URL: https://staging.example.com
- Expected result: Lighthouse score > 90, bundle < 300 KB, TTI < 500ms

## Files to Change
- `webpack.config.js` - Add code splitting config
- `src/App.js` - Implement React.lazy()
- `package.json` - Remove unused dependencies
- `src/analytics.js` - Lazy load analytics

## Deployment Notes
- Clear CDN cache after deployment
- Monitor bundle size in CI (add check to prevent regression)

## Priority
**P2 (Medium)** - Performance optimization, not blocking but impacts user experience
```
