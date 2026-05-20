# SDC Twig Patterns

Copy-pasteable Twig patterns for the situations you hit most.

## Calling a component (props only)

```twig
{{ include('my_theme:button', {
  label: 'Sign up'|t,
  variant: 'primary',
  url: '/register',
}, with_context = false) }}
```

Always pass `with_context = false`. The component should be a closed black box that receives exactly what you pass it.

## Calling a component with slots

```twig
{% embed 'my_theme:card' with { variant: 'feature' } only %}
  {% block media %}
    {{ include('my_theme:image', {
      src: node.field_image.entity.uri.value|image_style('card_hero'),
      alt: node.field_image.alt,
    }, with_context = false) }}
  {% endblock %}

  {% block heading %}
    {{ node.label }}
  {% endblock %}

  {% block body %}
    {{ node.body|view }}
  {% endblock %}

  {% block actions %}
    <a class="button" href="{{ url('entity.node.canonical', { node: node.id }) }}">
      {{ 'Read more'|t }}
    </a>
  {% endblock %}
{% endembed %}
```

The `only` keyword (equivalent to `with_context = false` for embed) is what keeps the child component isolated.

## Component template skeleton

```twig
{#
/**
 * @file
 * Card component.
 *
 * Available variables:
 * - attributes: Attribute object — must be printed on the root.
 * - variant: 'default' | 'feature' (string, enum)
 * - heading_level: 2..6 (integer, default 2)
 * - media: slot (image or media element)
 * - heading: slot
 * - body: slot
 * - actions: slot (buttons/links)
 */
#}
<article{{ attributes.addClass('card', 'card--' ~ variant|default('default')) }}>
  {% if media is not empty %}
    <div class="card__media">{{ media }}</div>
  {% endif %}

  <div class="card__content">
    {% if heading is not empty %}
      <h{{ heading_level|default(2) }} class="card__heading">{{ heading }}</h{{ heading_level|default(2) }}>
    {% endif %}

    {% if body is not empty %}
      <div class="card__body">{{ body }}</div>
    {% endif %}

    {% if actions is not empty %}
      <div class="card__actions">{{ actions }}</div>
    {% endif %}
  </div>
</article>
```

Notes:

- Root element prints `attributes` — non-negotiable.
- `is not empty` is the correct test for "did the consumer pass anything to this slot?"
- Class names use BEM. The variant becomes a modifier class.
- `heading_level` is a prop, not a slot — the template needs to know the integer to interpolate it.

## Attaching a library from a non-SDC template

```twig
{{ attach_library('core/components.my_theme--card') }}
```

## Conditional classes via the Attribute API

Do this:

```twig
<button{{ attributes
  .addClass('button')
  .addClass(variant ? 'button--' ~ variant)
  .addClass(is_disabled ? 'is-disabled')
  .setAttribute('type', type|default('button'))
}}>
  {{ label }}
</button>
```

Not this:

```twig
{# ❌ Don't stringify and concatenate #}
<button class="button button--{{ variant }} {{ attributes.class }}">
```

## Passing arbitrary HTML to a component as a slot

```twig
{# Capture markup, then pass it via include() #}
{% set body %}
  <p>This <em>HTML</em> will survive.</p>
{% endset %}

{{ include('my_theme:card', { body: body }, with_context = false) }}
```

Or with embed (preferred when you're using multiple slots):

```twig
{% embed 'my_theme:card' only %}
  {% block body %}
    <p>This <em>HTML</em> will survive.</p>
  {% endblock %}
{% endembed %}
```

## Using a component from a render array (PHP)

```php
$build['card'] = [
  '#type' => 'component',
  '#component' => 'my_theme:card',
  '#props' => [
    'variant' => 'feature',
    'heading_level' => 2,
  ],
  '#slots' => [
    'heading' => ['#markup' => $node->label()],
    'body' => $node->get('body')->view('teaser'),
    'actions' => $build_actions,
  ],
];
```

`#slots` accepts render arrays — this is the cleanest way to compose components from backend code.

## Anti-patterns to flag in review

- `.html.twig` extension on an SDC template → rename to `.twig`.
- Slot values passed as escaped HTML strings → switch to a slot or `{% set %}` + slot.
- Hard-coded `include()` calls for child components inside a parent component → expose a slot instead.
- Missing `attributes` on the root element.
- Logic that branches on slot *content* (e.g. parsing strings, checking for substrings) — move that decision to a prop.
- Calling `preprocess` on an SDC — it doesn't run. Compute upstream.
- Declaring `attributes` in the YAML schema — already provided automatically.
- `{% include 'my_theme:card' ... %}` (tag form) without `only`/`with_context = false` — leaks parent context.
