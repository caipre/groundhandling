### Release

This document describes the release process.
Inspiration for the process taken from
[Tuist](https://github.com/tuist/tuist/blob/master/RELEASE.md)

1. Ensure the head commit builds and that tests pass.
   ```
   tuist build
   ```

1. Run `make minor` or `make major`.

   * Minor by default.
   * Major for breaking changes.

1. Run `git push --tags`.
