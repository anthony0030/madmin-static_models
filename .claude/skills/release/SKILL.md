---
name: release
description: Release a new version of madmin-static_models to RubyGems and GitHub. Use when asked to release, publish, cut, ship or bump a version (patch, minor or major), including maintenance releases on an older series branch like 0-1-stable.
---

# Releasing madmin-static_models

A release has four public outputs: a pushed branch, a `vX.Y.Z` tag, a gem on RubyGems, and a GitHub release. None of them can be cleanly undone (a yanked gem version can never be reused), so prepare and verify everything locally first, then **stop and get the user's go-ahead before the first push**.

## Branches and series

- `main` holds the current series (0.2.x, Madmin 3.2+).
- Older series live on `<major>-<minor>-stable` branches, e.g. `0-1-stable` for 0.1.x (Madmin 2.6–2.x). Release a fix for an old series from its stable branch, never from `main`.
- When a new series raises the Madmin requirement, first cut a patch on the old series that caps madmin below the new major (as 0.1.1 did with `< 3`), and publish it **before** the new series. That way apps on the old Madmin get the cap before the new version becomes the newest one.

## 1. Check the starting state

```sh
git fetch --tags origin
git status -sb                      # clean, and not behind origin
git tag --sort=-v:refname | head    # last released versions
gem list -r '^madmin-static_models$' --all
gh release list
```

Pick the version (semver): patch for fixes, minor for new features or a changed Madmin requirement while still pre-1.0. Make sure the version isn't already on RubyGems or tagged.

## 2. Files to change

| File | Change |
| --- | --- |
| `lib/madmin/static_models/version.rb` | Bump `VERSION`. |
| `CHANGELOG.md` | Add `## X.Y.Z` at the top with one bullet per user-facing change. Mention any change to the Madmin requirement. |
| `madmin-static_models.gemspec` | Only if supported Madmin versions change: update `spec.add_dependency "madmin", ">= A", "< B"`. Keep an upper bound at the next Madmin major. |
| `README.md` | Update the compatibility table under **Installation** whenever a series or Madmin range changes. Keep a row per supported series. On a stable branch, keep the line that points Madmin 3 users to the newer series. |
| `lib/madmin/static_models/railtie.rb` | If the minimum Madmin changes, update the version in the `warn` message. |

To find the lowest Madmin version that has a required API, unpack candidate versions into a scratch directory (`gem fetch madmin -v X`, then `tar -xOf madmin-X.gem data.tar.gz | tar -xz -C <dir>`) and grep them. Don't guess.

Look for stale mentions of anything that changed (e.g. `grep -rni pagy --exclude-dir=.git .`).

## 3. Verify locally

```sh
bundle update madmin             # if the dependency changed; Gemfile.lock is gitignored
bundle exec rake test
bundle exec standardrb
```

If the Madmin range changed, also run the tests against its lower bound. Pin it temporarily, test, and restore the Gemfile and lock:

```sh
cp Gemfile Gemfile.bak && cp Gemfile.lock Gemfile.lock.bak
echo 'gem "madmin", "<lowest supported>"' >> Gemfile && bundle install && bundle exec rake test
mv Gemfile.bak Gemfile && mv Gemfile.lock.bak Gemfile.lock && bundle install
```

Build the gem to check the gemspec. `rake build` writes to `pkg/`, which is gitignored. Don't use `gem build` in the repo root:

```sh
bundle exec rake build           # -> pkg/madmin-static_models-X.Y.Z.gem
```

## 4. Commit

Commit the release on the right branch (`main`, or the stable branch). If the work was done on a feature branch, fast-forward it into `main` (`git merge --ff-only`). Don't push yet.

**Stop here.** Show the user the version, the CHANGELOG entry, the branch, and the test results, and confirm before going on.

## 5. Publish (in this order)

```sh
git push origin <branch>
git tag vX.Y.Z                   # lightweight tags, "v" prefix, like the existing ones
git push origin vX.Y.Z
gem push pkg/madmin-static_models-X.Y.Z.gem --otp <code>
```

- `gem push` needs a RubyGems one-time code. Claude can't enter it (the command hangs waiting for the prompt), so hand this command to the user to run, with the full path to the built gem.
- Don't use `rake release`. It tags, pushes and publishes in one step, with no checkpoint between them.
- If Claude Code's permission check blocks a push, don't retry it another way. Give the user the commands.

## 6. GitHub release

Create one for every tag. The releases page doesn't get them from tags on its own.

```sh
gh release create vX.Y.Z --verify-tag --title vX.Y.Z --latest --notes '<CHANGELOG entry as one short paragraph>'
```

- Title is the bare tag. Notes are the CHANGELOG entry as prose, plus which Madmin versions it's for.
- For a release on an older series (a stable branch), pass `--latest=false` so the newest series stays marked as latest.

## 7. Confirm

```sh
git ls-remote origin             # branch and tag at the release commit
gem list -r '^madmin-static_models$' --all
gh release list
```

Report each public output with its link: tag, RubyGems version, GitHub release.
