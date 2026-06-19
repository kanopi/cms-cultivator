---
name: drupal-sdc-twig
description: Best practices for building Drupal Single Directory Components (SDC) with Twig — including props vs slots, the `attributes` object, `include` vs `embed`, escaping rules, accessibility, schema and validation, and overriding components. Invoke when the user mentions "SDC", "Single Directory Component", "component.yml", working with `components/` folders in a Drupal theme or module, writing or reviewing an SDC Twig template, or asks "how should I structure this Drupal component", "props or slots?", "embed vs include in SDC", or "best practices for Drupal components".
---

# Drupal SDC + Twig Best Practices

Use this skill whenever you are creating, reviewing, or refactoring a Drupal Single Directory Component, or writing the Twig template that ships inside one. SDC has been part of Drupal core since 10.3, so assume it is available unless the user explicitly states an older version.

## Anatomy of an SDC

Every component lives in its own folder inside a top-level `components/` directory of a theme or module:

```
components/
└── card/
    ├── card.component.yml   # Metadata + schema (props, slots, libraryOverrides)
    ├── card.twig            # Template — note: .twig, NOT .html.twig
    ├── card.css             # Auto-attached as a library asset
    ├── card.js              # Auto-attached as a library asset
    └── thumbnail.png        # Optional preview image
```

Subdirectories are allowed (`components/molecules/card/...`). Components are referenced by namespace `theme_or_module:component_name`, e.g. `my_theme:card`.

## The Ten Rules I Apply Every Time

Apply these rules when generating or reviewing SDC Twig code. They are derived from the official Drupal SDC docs and the SDC FAQ on drupal.org.

### 1. Use `.twig`, not `.html.twig`

SDC templates use the bare `.twig` extension. This is the one place in Drupal where you do **not** use `.html.twig`. The Twig filename must match the component machine name (the folder name).

### 2. Decide props vs slots before you write any Twig

This is the most important design decision in an SDC and the source of most refactors. The rule:

- **Props** = strictly typed primitive data (strings, numbers, booleans, enums, arrays of primitives). Use props when the template needs to make a UI decision based on the value (`{% if dismissible %}`, `<h{{ heading_level }}>`).
- **Slots** = arbitrary renderables (render arrays, nested components, HTML markup, objects implementing `Stringable` / `RenderableInterface` / `MarkupInterface`). Use slots when you only need to know "is this empty or not?" and then print it.

If you would ever want to pass a nested component, another Twig render result, or a chunk of HTML, it must be a slot — not a prop. Props that are serialized HTML strings are an anti-pattern.

### 3. Always declare a schema, even if there are no props

A schema (`props.type: object` with `properties`) is required for:

- Validation during development
- Replacing/overriding the component
- Integration with Storybook, UI Patterns, SDC Display
- Variants (Drupal 11.2+)

For a propless component, use the empty-props pattern:

```yaml
props:
  type: object
  additionalProperties: false
  properties: {}
```

To enforce schemas across a theme, add `enforce_prop_schemas: true` to `theme.info.yml`.

### 4. Always print `attributes` on the root element

Every SDC template automatically receives an `attributes` variable (a `\Drupal\Core\Template\Attribute` object). You must use it because Drupal core, SEO modules, accessibility modules, translation, and style utilities inject classes, `lang`, `data-*`, and ARIA attributes through it.

```twig
<div{{ attributes.addClass('card') }}>
  ...
</div>
```

Use `.addClass()`, `.setAttribute()`, `.removeClass()` — do not stringify and concatenate. Do not redeclare `attributes` in the schema; SDC adds it automatically. (You may declare `body_attributes` etc. as `type: 'Drupal\Core\Template\Attribute'` — that's a known escape hatch for passing additional Attribute objects.)

### 5. `embed` for slots, `include()` for props-only

Both work, but use them deliberately:

- **`include()` function** — clean syntax for components with props and no markup-bearing slots. Always pass `with_context = false` to avoid leaking the parent context.
- **`embed` tag** — required when consumers need to override slots with Twig `{% block %}` markup, because slots are implemented as Twig blocks under the hood.

```twig
{# Props only — use include() #}
{{ include('my_theme:button', {
  label: 'Sign up'|t,
  variant: 'primary',
}, with_context = false) }}

{# Slots — use embed #}
{% embed 'my_theme:card' with { variant: 'feature' } only %}
  {% block media %}
    {{ include('my_theme:image', { src: node.field_image|file_url }, with_context = false) }}
  {% endblock %}
  {% block body %}
    <p>{{ node.body.summary }}</p>
  {% endblock %}
{% endembed %}
```

Use `only` (or `with_context = false`) by default so the child component is isolated from the parent's variables. This makes components portable and prevents surprising regressions.

### 6. Never pass raw HTML through a prop

Twig will escape it. If you need to pass HTML, use a slot. Two patterns:

```twig
{# Pattern A: capture markup into a variable, pass to a slot via include() #}
{% set body %}
  <p><em>Any</em> HTML stays intact.</p>
{% endset %}
{{ include('my_theme:card', { body: body }, with_context = false) }}

{# Pattern B: use embed with a block (preferred for slots) #}
{% embed 'my_theme:card' only %}
  {% block body %}<p><em>Any</em> HTML stays intact.</p>{% endblock %}
{% endembed %}
```

### 7. Render slots simply — no business logic

Inside the component template, do not branch on the *contents* of a slot — only on whether it is empty:

```twig
{% if heading %}
  <h{{ heading_level|default(2) }} class="card__heading">{{ heading }}</h{{ heading_level }}>
{% endif %}
{{ body }}
```

All UI logic (variant switching, conditional classes, ARIA states) should run off **props**, which are typed and predictable.

### 8. Compose components via slots, not hard-coded includes

When a Card needs Buttons inside, do **not** hard-code `{{ include('my_theme:button', ...) }}` inside `card.twig`. Instead, expose an `actions` slot and let the consumer pass the buttons in. This keeps components decoupled and reusable.

```twig
{# card.twig — good #}
<article{{ attributes.addClass('card') }}>
  <div class="card__body">{{ body }}</div>
  {% if actions is not empty %}
    <div class="card__actions">{{ actions }}</div>
  {% endif %}
</article>
```

### 9. Attach libraries the SDC way

Each component automatically gets a library named `core/components.<theme_or_module>--<component-name-with-dashes>`. To attach it from a non-SDC template:

```twig
{{ attach_library('core/components.my_theme--card') }}
```

For extra CSS/JS and dependencies on other libraries, use `libraryOverrides` in the component's YAML:

```yaml
libraryOverrides:
  dependencies:
    - core/drupal
    - core/once
    - core/components.my_theme--icon
  js:
    card.js: { attributes: { defer: true } }
```

For high-traffic sites, consider attaching `core/components.all` globally to maximize browser-cache hit rate. To override an upstream component's assets, use `libraries-override` in `theme.info.yml`.

### 10. Preprocess does not run on SDC — design accordingly

SDC templates **do not** go through `hook_preprocess_*`. If a prop needs computed values (formatted dates, derived classes, fallback logic), compute it in the parent template/preprocess or in the render array that calls the component. Inside the SDC template, keep logic to display-only Twig (`|default`, `|t`, conditionals).

## Quick Decision Tree

When the user asks "should this be a prop or a slot?":

1. Will the template's HTML structure or class set change based on this value? → **prop** (typed, with enum if possible).
2. Will the template render the value 1:1 inside a container? → **slot**.
3. Could the value be a render array, another component, or HTML someday? → **slot**.
4. Is it a flag, count, or strictly enumerated string? → **prop**.

## Override and Replace

- Only **themes** can override components, not modules.
- To replace another component, add `replaces: 'source_module_or_theme:component-name'` and ensure both components have a schema.
- To override just CSS/JS without replacing the component, use `libraries-override` in `theme.info.yml`.

## Variants (Drupal 11.2+)

Variants let one component declare multiple visual variations with shared structure. Prefer variants over duplicate components when the markup is largely the same. The current SDC variant feature was added in Drupal 11.2 — confirm version compatibility before using.

## Accessibility Checklist for Every Component

- Use semantic HTML on the root (`<article>`, `<section>`, `<button>`, `<nav>`) — not generic `<div>` unless that is genuinely correct.
- Keep `attributes` on the root so ARIA attributes injected by modules survive.
- For interactive components (accordion, tabs, modal), expose props for `id`, `aria-controls`, `aria-expanded`, etc., so consumers can wire them correctly.
- Headings inside slots: expose a `heading_level` prop (enum `[2,3,4,5,6]`) so consumers can place the component at the right level of the document outline.
- Provide visible focus styles in the component CSS; never rely on `:focus { outline: none }`.

## References

- `references/component.yml-cheatsheet.md` — annotated schema cheatsheet
- `references/twig-patterns.md` — copy-pasteable patterns for common SDC Twig situations
- `assets/card-example/` — a complete, idiomatic card component (yml + twig)

## Authoritative Sources

- [Using Single-Directory Components — Drupal.org](https://www.drupal.org/docs/develop/theming-drupal/using-single-directory-components)
- [SDC FAQ — Drupal.org](https://www.drupal.org/docs/develop/theming-drupal/using-single-directory-components/frequently-asked-questions)
- [Props and Slots in SDC — Drupal.org](https://www.drupal.org/docs/develop/theming-drupal/using-single-directory-components/what-are-props-and-slots-in-drupal-sdc-theming)
- [Annotated component.yml — Drupal.org](https://www.drupal.org/docs/develop/theming-drupal/using-single-directory-components/annotated-example-componentyml)
- [Add a Twig Template to Your SDC — Drupalize.Me](https://drupalize.me/tutorial/add-twig-template-your-single-directory-component)
