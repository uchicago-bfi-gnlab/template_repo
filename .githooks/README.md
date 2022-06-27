This directory contains a copy of the git standard `.git/hooks` folders with an addition `pre-commit` that automates linting of R files on commit.

Run `git config core.hooksPath .githooks` in the command line to get git to use these hooks rather than `.git/hooks/`.

This [blog post](https://www.viget.com/articles/two-ways-to-share-git-hooks-with-your-team/) explains why.