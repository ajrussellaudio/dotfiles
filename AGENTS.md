# AGENTS.md

Instructions for any coding agent that works in this repository.

## This is a personal repository

This repository holds personal dotfiles for a work laptop. It is not a Twinkl
project. It is owned by the individual, not the company, and nothing here ships
to a Twinkl environment.

The Claude access used here comes from a Twinkl account, so Twinkl's
organisation policy loads into every session. That policy is correct for Twinkl
repositories. The git parts of it do not apply here.

## Twinkl git conventions do not apply

In this repository only:

- **Branch names are free-form.** The `<type>/<ticket>-<description>` pattern is
  not required. There is no ticket tracker behind this work.
- **Commits do not need to be signed.** Signing is not a requirement here. The
  local git config enables it, so commits get signed anyway. Leave that config
  alone. Do not disable signing to satisfy this note.
- **You can commit and push to `main`.** `main` is not protected. A pull request
  is optional, not a gate.
- **The `Co-Authored-By` trailer is optional.** Add it or omit it.

Do not apply these relaxations to any other repository. They are specific to
this one.

## What still applies

- **The repository's own commit-message style.** Commits here use a conventional
  prefix and a body that gives the reason, for example `chore(stow):` or
  `feat(agents):`. Read `git log` and match it. This is a local habit, not a
  Twinkl rule, and it stands.
- **Care with destructive commands.** Ask first before `git reset --hard`,
  `git push --force`, `git clean -f`, or `git checkout -- <file>`. This is not a
  Twinkl rule either. These commands discard work that cannot be recovered.
- **The other Twinkl skills.** This note covers git conventions only. The
  standards for TypeScript, PHP, Terraform, AWS, security, and the rest still
  give good guidance. Use them where they fit.

## Repository guide

For the package layout, the install scripts, and the per-tool conventions, read
`CLAUDE.md` in this same directory.
