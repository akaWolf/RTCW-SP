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

## Some variables

Set `r_fullscreen` to `1` for fullscreen mode.

`r_mode` is a resolution mode. it can be:

* `-2` (desktop resolution)
* `-1` (resolution is `r_customwidth` x `r_customheight`)
* `0` .. `12` (see [tr_init.c](src/renderer/tr_init.c#L383))

`fs_basepath` is the path to the directory holding all the game directories and usually the executable.

`fs_cdpath` is the path to an alternate hierarchy that will be searched if a file is not located in the base path.

You can set `fs_basepath` to the directory where all compiled files are located and `fs_cdpath` to the directory where all resources are located.

Set `fs_debug` to `1` for debugging filesystem subsystem.

Set `developer` to `1` for verbose log.

## License

This project is licensed under the GPL License - see the [COPYING.txt](COPYING.txt) file for details

## Acknowledgments

* John Carmack with a team
* hexameron
