# Return to Castle Wolfenstein Single Player GPL Source Release

At Feb 1, 2012 source code of RTCW was released.
This is slightly patched original source code based at hexameron commits.

You can be interested in [original readme](README.txt) also.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to run the project.

### Prerequisites

You need toolchain for build anything.
You need to install needed for building libraries: SDL2, libgl.

For Arch Linux:
```shell
# pacman -S extra/sdl2 extra/libglvnd
```

Also you need to create folder for the project (in this tutorial it will be `~/RTCW`):
```shell
$ mkdir ~/RTCW
```

### Cloning the repository

```shell
$ cd ~/RTCW
$ git clone https://github.com/akaWolf/RTCW-SP.git sources
```

### Building

Supported build system now is CMake:
```shell
$ cd ~/RTCW
$ mkdir build
$ mkdir -p game/main
$ cd build
$ cmake ~/RTCW/sources
$ make -j $(nproc)
```

It will build release version.
You can specify build type: `cmake -DCMAKE_BUILD_TYPE=Debug ...`.

## Deployment

You have need to populate such tree:
```
~/RTCW/game
├── main
│   ├── cgame-rtcw.so
│   ├── pak0.pk3
│   ├── qagame-rtcw.so
│   ├── sp_pak1.pk3
│   ├── sp_pak2.pk3
│   ├── sp_pak3.pk3
│   ├── sp_pak4.pk3
│   └── ui-rtcw.so
└── wolf
```

As you can see, you need to copy binaries:
```shell
$ cd ~/RTCW/build
$ cp wolf ../game/
$ cp *.so ../game/main/
```

and game files from existing game:
```shell
$ cd /path/to/installed/game
$ cp {Main/pak0.pk3,Main/sp_pak?.pk3} ~/RTCW/game/main
```

## Run

```shell
$ cd ~/RTCW/game
$ ./wolf
```

You can specify needed parameters at command line like so: `./wolf +set r_mode -1 +set r_customheight 1440 +set r_customwidth 2560 +set r_fullscreen 1`.

## License

This project is licensed under the GPL License - see the [COPYING.txt](COPYING.txt) file for details

## Acknowledgments

* John Carmack with a team
* hexameron
