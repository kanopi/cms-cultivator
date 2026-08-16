# Eval fixture: DDEV project with site-specific commands

A Kanopi-style DDEV project whose command set is deliberately NOT the add-on
default. There is no `db-refresh`, no `theme-build`, and no `theme-npm` here.
The commands that exist are `project-init`, `db-refresh-scrubbed`, and
`assets-compile`, each declaring its own aliases in its header.

An agent that recites the add-on's usual command names instead of reading
`.ddev/commands/` will name commands this project does not have.
