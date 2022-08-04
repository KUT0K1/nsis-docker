# NSIS Compiler

NSIS images to compile installers on Docker/Linux based CI.
Used to compile `*.nsi` installer scripts and run them on a Windows platform.
## Tags

Currently supported tags are:

* bullseye-slim-3.08, latest - normal nsis compiler
* bullseye-slim-3.08-log, latest-log, log - normal nsis compiler
* bullseye-slim-3.08-strlen, latest-strlen, strlen - normal nsis compiler

## Variants

*Attention*: there is no image with log and extended string support combined yet, I think that is needed a croos-compiler image so the stubs can be generated respectively.

### Log

This version could be use as a test version of the installer, it will create an `install.log` file on the install folder with the detail of each section that has the `SetLog on` diretive.


### Strlen 8192

This version has support for larger string lengths, if your installer changes the current Window path (can be very large indeed), it's a good ideia to use it.

# Using

To make your installer, just run the image with a volume pointing to `/build:rw` and the output folder to be within the same folder.
The arguments can be passed as the original `makensis.exe` executable would parse *BUT* the Linux executable uses `-` instead of the original `/` character to indicate parameters:

On Windows:
```powershell
makensis.exe /DAPP_VERSION="1.0.0" /X"SetCompressor /SOLID lzma" ./examples/installer.nsi
```

On Docker/Podman:
```powershell
podman run --rm -v "${PWD}:/build:rw" albertowd/nsis:latest -DAPP_VERSION="1.0.0" -X"SetCompressor /SOLID lzma" ./examples/installer.nsi
```

## TODO

* Combined log+strlen image
* Smaller size image
* Tag ref for the README and DockerHub
