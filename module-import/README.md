# Demo for Module Imports

## Running the Demo

```bash
make build
```

## Hightlights

Module imports and their symbols: [main.swift](https://github.com/trinhngocthuyen/ios-demos/blob/main/module-import/EX/main.swift)

### Module Structures

**CommonUI**: shipped as framework:
```
modules/build/CommonUI/ -- CommonUI.framework
```

**Logger**: shipped as library
```
modules/build/Logger/ -- libLogger.a
                         Logger.swiftmodule
```

**DebugKit**: Objective-C module with a `.modulemap`
```
modules/build/DebugKit/ -- DebugKit.o
                           DebugKit.h
                           DebugKit.modulemap
```

**Greeter**: Objective-C module with a `.pcm`
```
modules/build/Greeter/ -- Greeter.o
                          Greeter.pcm
```

### Build Settings

Refer to: [Config.xcconfig](https://github.com/trinhngocthuyen/ios-demos/blob/main/module-import/Config.xcconfig)

Integrating CommonUI (framework):
- Add `$(MODULES_BUILD_DIR)/CommonUI` to the framework search paths
- Linker flags: `-framework "CommonUI"`

Integrating Logger (library):
- Add `$(MODULES_BUILD_DIR)/Logger` to the library search paths
- Add `$(MODULES_BUILD_DIR)/Logger` to the import paths (for compiler to pick up the `.swiftmodule`)
- Linker flags: `-l"Logger"`

Integrating DebugKit (modulemap):
- Add `$(MODULES_BUILD_DIR)/DebugKit` to the library search paths
- Swift flags: `-Xcc -fmodule-map-file=$(MODULES_BUILD_DIR)/DebugKit/module.modulemap`
- Linker flags: `-l"DebugKit.o"`

Integrating Greeter (pcm):
- Add `$(MODULES_BUILD_DIR)/Greeter` to the library search paths
- Swift flags: `-Xcc -fmodule-file=$(MODULES_BUILD_DIR)/Greeter/Greeter.pcm`
- Linker flags: `-l"Greeter.o"`
