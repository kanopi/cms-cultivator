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

The aim is coverage of everywhere the change runs, not a sample. Before writing any step,
search for every usage of what changed, and test each distinct one.

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

One step per distinct context: each template, region, content type, view mode, or variation
that renders it differently. Ten articles in the same template and view mode are one step,
not ten.

### Backend

Services, hooks, controllers, form alters, queries, cron, queues, and API handlers:

- **Every caller.** Search for the function, method, class, service ID, hook name, route
  name, or event the change touches.
- **Every entry point.** Map each caller to something a reviewer can trigger: a page, a form
  submission, an admin action, a Drush or WP-CLI command, a cron run, a queue item, a
  webhook, or an API request.
- **One step per entry point,** naming the input that exercises it.
- **At least one edge case:** empty input, a user without the permission, a missing
  reference, or the failure path.

### Flows

For a multi-step journey such as registration, checkout, an import, or a migration, walk the
flow end to end in one step, then add a step for each branch the change touches.

## Writing each step

- **Name the real thing** the search found: the page title or path, the node, the route,
  the command. Never "a typical page" or "any article".
- **Deep-link pages on the testing environment** when the repository deploys to one
  ([`testing-environment.md`](testing-environment.md)).
- **One line per step:** what to open or run, and what to confirm.
- **No cap on the count.** Cover every distinct usage. When a search returns dozens of
  identical usages, cover each distinct context, then add a final step that gives the
  search so the reviewer can spot-check the rest.
- **No real content locally?** With an empty database or no DDEV, say so under Assumptions,
  and write the step against the content type or route, with the query that finds real
  items on the testing environment.
