Example project for using Swift with dynamic library dependencies on Linux.

This project builds the `KrustyKrab` executable against version 1.0.0 of [libKrabbyPatty](https://github.com/tayloraswift/swift-edsl-example), and should be compatible future versions of the same library.

**SwiftPM does not understand all the various Linux distributions that exist in the world**. Therefore, you must set the `SWIFTPM_KK_PLATFORM` environment variable to one of the following, in order to build against the correct binary artifact:

```bash
export SWIFTPM_KK_PLATFORM="Ubuntu-24.04-X64"
export SWIFTPM_KK_PLATFORM="Ubuntu-22.04-X64"
export SWIFTPM_KK_PLATFORM="Amazon-Linux-2-X64"
export SWIFTPM_KK_PLATFORM="macOS-ARM64"
```

## Example for Ubuntu 24.04

```bash
# Tell SwiftPM that we are on Ubuntu 24.04. This is defined by `libKrabbyPatty`, not SwiftPM.
export SWIFTPM_KK_PLATFORM="Ubuntu-24.04-X64"

# Use modified SwiftPM to build, setting @rpath to where you expect to deploy `libKrabbyPatty`
../swift-package-manager/.build/release/swift-build -c release \
    -Xlinker -rpath \
    -Xlinker main.artifactbundle/KrabbyPatty

# Download Version 2 of `libKrabbyPatty` and unpack it to the expected location
curl https://download.swiftinit.org/swift-edsl-example/2.0.0/$SWIFTPM_KK_PLATFORM/main.artifactbundle.zip -o main.artifactbundle.zip
unzip main.artifactbundle.zip

# Run the executable
.build/release/KrustyKrab
```

You should see the following output:

```
Latest Krabby Patty formula version: v1
```

This is because SwiftPM copies the version of `libKrabbyPatty` that it was built against into the `.build` directory. To use the library installed at the `@rpath` you configured, delete that copy:

```bash
rm .build/release/libKrabbyPatty.so
```

You should see the following output:

```
Latest Krabby Patty formula version: v2
```
