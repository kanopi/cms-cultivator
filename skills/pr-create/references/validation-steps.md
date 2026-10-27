# Validation Steps

Every step in Steps to Validate is a checkbox the reviewer ticks once it is tested:

```markdown
## Steps to Validate
- [ ] Open [/about](https://pr-123-clientsite.pantheonsite.io/about) and confirm the hero keeps its spacing in the sidebar region.
- [ ] Open [/news/budget-2026](https://pr-123-clientsite.pantheonsite.io/news/budget-2026) and confirm the same hero in the full-width view mode.
- [ ] Run `ddev drush cron` and confirm the import queue empties with no errors.
```

Use `- [ ]` even when the template's placeholder is a numbered list. GitHub renders
`- [ ]` as a checkbox the reviewer can tick in place.

## Find the real usages first

Search for every usage of what changed before writing any step. You cannot pick usages that
differ from each other without seeing them all. Then test a short, varied set, not the whole
list (see "Pick dissimilar scenarios" below).

### Theme and front end

Templates, partials, components, blocks, CSS, and JS:

- **Every template that pulls it in.** Search for the file and component name and every
  way it is included: `include`, `embed`, `extends`, `{% render %}`, `get_template_part`,
  `block.json` names, and SDC component IDs.
- **Every template its selectors reach.** For a CSS or JS change, search the templates for
  the classes, IDs, and data attributes it targets.
- **Real content that renders it.** Query the site rather than guessing which pages use it:
  - Drupal: find the content types, paragraph types, blocks, view modes, and Views that
    render it, then real items of each, for example
    `ddev drush sqlq "SELECT nid, title FROM node_field_data WHERE type = '<bundle>' LIMIT 5"`.
  - WordPress: find the templates and template parts, then posts using the block or
    shortcode, for example
    `ddev wp post list --post_type=any --s='wp:<namespace>/<block>' --fields=ID,post_title`.

### Backend

Services, hooks, controllers, form alters, queries, cron, queues, and API handlers:

- **Every caller.** Search for the function, method, class, service ID, hook name, route
  name, or event the change touches.
- **Every entry point.** Map each caller to something a reviewer can trigger: a page, a form
  submission, an admin action, a Drush or WP-CLI command, a cron run, a queue item, a
  webhook, or an API request.
- **One step per kind of entry point,** naming the input that exercises it. A form and a
  cron run differ; two forms that call it the same way do not.
- **At least one edge case:** empty input, a user without the permission, a missing
  reference, or the failure path.

### Flows

For a multi-step journey such as registration, checkout, an import, or a migration, walk the
flow end to end in one step, then add a step for each branch the change touches.

## Pick dissimilar scenarios

The search finds every usage; the steps cover the ones that differ. Two usages are the
same scenario when they run the same code path, in the same context, with the same kind of
data, for the same kind of user. Test one of them and skip the rest.

A usage earns its own step when it differs in something the change could break on:

- **Context:** a different template, region, view mode, layout, or breakpoint.
- **Data:** empty, long, missing, multi-valued, translated, or unpublished content.
- **Entry point:** a page view versus a form submission, a cron run, a queue item, or an
  API call.
- **User:** anonymous versus logged in, or a role without the permission.

Aim for the smallest set that covers that variety: usually 3–5 steps, including at least one
edge case. Add a step only for a scenario the others do not already exercise, never to list
more pages that behave the same way.

For example, a hero partial renders on 40 landing pages, the homepage, and news teasers.
The 40 landing pages are one scenario. The homepage (full width, video background) and a
teaser (small view mode) each differ. That is three steps: one landing page, the homepage,
and one teaser, plus an edge case for a landing page whose hero has no image.

## Writing each step

- **Name the real thing** the search found: the page title or path, the node, the route,
  the command. Never "a typical page" or "any article".
- **Deep-link pages on the testing environment** when the repository deploys to one
  ([`testing-environment.md`](testing-environment.md)).
- **One line per step:** what to open or run, and what to confirm.
- **No real content locally?** With an empty database or no DDEV, say so under Assumptions,
  and write the step against the content type or route, with the query that finds real
  items on the testing environment.
