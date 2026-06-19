# component.yml Cheatsheet

A reference for the most common patterns in `<component>.component.yml`. Always include `$schema` so your IDE gives you autocomplete and validation.

## Minimum viable component

```yaml
$schema: https://git.drupalcode.org/project/drupal/-/raw/HEAD/core/assets/schemas/v1/metadata.schema.json
name: Card
status: stable
group: Content
props:
  type: object
  properties: {}
```

## Typed props with required, enum, default

```yaml
$schema: https://git.drupalcode.org/project/drupal/-/raw/HEAD/core/assets/schemas/v1/metadata.schema.json
name: Alert
status: stable
group: Feedback
props:
  type: object
  required:
    - message
  properties:
    variant:
      title: Variant
      type: string
      enum: [info, success, warning, danger]
      default: info
    heading_level:
      title: Heading level
      type: integer
      enum: [2, 3, 4, 5, 6]
      default: 2
    dismissible:
      title: Dismissible?
      type: boolean
      default: false
    message:
      title: Message
      type: string
      description: Plain-text alert message. For rich content, use the body slot.
```

## Slots for arbitrary renderables

```yaml
slots:
  heading:
    title: Heading
    description: Optional heading rendered above the body.
  body:
    title: Body
    description: Main content. Accepts any renderable.
  actions:
    title: Actions
    description: Action buttons or links.
```

## Library overrides (extra CSS/JS, dependencies)

```yaml
libraryOverrides:
  dependencies:
    - core/drupal
    - core/once
    - core/components.my_theme--icon
  css:
    component:
      card.css: {}
      card.print.css: { media: print }
  js:
    card.js: { attributes: { defer: true } }
```

## Replacing a component from another theme/module

```yaml
# In the overriding theme's <component>.component.yml:
replaces: 'sdc_examples:card'
```

Only themes can replace components, and both components must define a schema.

## Component with no props (still needs schema for validation)

```yaml
props:
  type: object
  additionalProperties: false
  properties: {}
```

## Status values

- `experimental` — API may change
- `stable` — production-ready (most common)
- `deprecated` — still works but slated for removal
- `obsolete` — do not use

## Props you should *not* declare yourself

SDC automatically provides:

- `attributes` — always available; just declare the others
- `componentMetadata` — path, machineName, status, name, group (for debugging)
- `variant` (Drupal 11.2+ when variants are wired up)

If you want to accept *additional* `Attribute` objects (e.g. for an inner element), declare them with the PHP namespace escape hatch:

```yaml
props:
  type: object
  properties:
    title_attributes:
      type: 'Drupal\Core\Template\Attribute'
```

This bypasses JSON schema validation, which is needed because Attribute objects don't fit the JSON type system. Don't use this trick for anything other than Attribute objects.
