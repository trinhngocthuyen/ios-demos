ARCH = arm64-apple-macos
TARGET = arm64-apple-macosx14.3.0

MODULE = $(basename $@)
SRC_DIR = src/$(MODULE)
BUILD_DIR = build/$(MODULE)

all:
	make \
		CommonUI.framework \
		Logger.lib \
		Greeter.pcm-o \
		DebugKit.modulemap-o

clean:
	rm -rf build

%.framework: %.o %.swiftmodule
	mkdir -p $(BUILD_DIR)/$(MODULE).framework/Headers $(BUILD_DIR)/$(MODULE).framework/Modules
	rsync --delete -ra $(BUILD_DIR)/$(MODULE).swiftmodule $(BUILD_DIR)/$@/Modules/
	libtool -static -o $(BUILD_DIR)/$@/$(MODULE) $(BUILD_DIR)/*.o

%.lib: %.o %.swiftmodule
	libtool -static -o $(BUILD_DIR)/lib$(MODULE).a $(BUILD_DIR)/*.o

%.modulemap-o: %.mo
	rsync --delete -ra $(SRC_DIR)/*.{h,modulemap} $(BUILD_DIR)/

%.pcm-o: %.mo
	swiftc \
		-emit-pcm \
		-target $(TARGET) \
		-o $(BUILD_DIR)/$(MODULE).pcm \
		$(SRC_DIR)/*.modulemap

%.mo:
	mkdir -p $(BUILD_DIR)
	clang -c -x objective-c -o $(BUILD_DIR)/$(MODULE).o $(SRC_DIR)/*.m

%.o:
	swiftc \
		-emit-library \
		-emit-object \
		-target $(TARGET) \
		-o $(BUILD_DIR)/$(MODULE).o \
		$(SRC_DIR)/*.swift

%.swiftmodule:
	swiftc \
		-emit-module \
		-module-name $(MODULE) \
		-target $(TARGET) \
		-o $(BUILD_DIR)/$(MODULE).swiftmodule/$(ARCH).swiftmodule \
		$(SRC_DIR)/*.swift
