# Demo for cocoapods-spm/112

Duplicate class in EX and EXTests

If Logger is a static framework and being used in both EX (app target) and EXTests (unit test target):
- Logger is both statically linked into both EX binary and EXTests binary
- Therefore, `Logger.shared.id` in EX and in EXTests return different value
