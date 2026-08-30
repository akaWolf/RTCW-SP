# Return to Castle Wolfenstein Single Player GPL Source Release

At Feb 1, 2012 the source code of RTCW was released. This is a patched
version of the original single player code (based on hexameron's commits)
that builds and runs on current Linux systems: SDL2 for video, input and
sound, 64 bit clean, wide screen aware, with the accumulated engine fixes.

The [original readme](README.txt) describes the 2012 release.

## Prerequisites

A C/C++ toolchain, CMake 3.12 or newer and the development files of SDL2,
OpenGL and libjpeg (libjpeg-turbo).

Arch Linux:
```shell
# pacman -S base-devel cmake sdl2 libglvnd libjpeg-turbo
```

Debian / Ubuntu:
```shell
# apt install build-essential cmake libsdl2-dev libgl1-mesa-dev libjpeg-dev
```

NixOS (ad hoc shell):
```shell
$ nix-shell -p gcc cmake gnumake pkg-config SDL2 libGL xorg.libX11 xorg.libXext libjpeg
```

You also need the game data (`pak0.pk3` and `sp_pak1.pk3` .. `sp_pak3.pk3`
from the `Main` directory of an installed game).

## Building

```shell
$ cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
$ cmake --build build -j $(nproc)
```

`build/` then contains the executable `wolf` and the game modules
`cgame-rtcw.so`, `qagame-rtcw.so` and `ui-rtcw.so`. Options:

* `-DCMAKE_BUILD_TYPE=Debug` for a debug build
* `-DENABLE_LTO=ON` for link time optimisation
* `-DCMAKE_INSTALL_PREFIX=...` and `cmake --install build` copy the
  executable and the modules (into `~/RTCW` by default)

## Running

The executable looks for the modules and the game data in `fs_basepath`
(the directory of the executable by default) and in `fs_cdpath`; both are
expected to contain a `main` directory. The simplest layout:

```
~/RTCW
├── main
│   ├── cgame-rtcw.so
│   ├── pak0.pk3
│   ├── qagame-rtcw.so
│   ├── sp_pak1.pk3
│   ├── sp_pak2.pk3
│   ├── sp_pak3.pk3
│   └── ui-rtcw.so
└── wolf
```

```shell
$ ~/RTCW/wolf
```

The game data can also stay where it is:

```shell
$ ./build/wolf +set fs_cdpath /path/to/rtcw +set r_mode -1 +set r_customwidth 1920 +set r_customheight 1080 +set r_fullscreen 1
```

Configuration, saved games and screenshots go to `~/.wolf` if that
directory exists, otherwise to `$XDG_DATA_HOME/wolf`
(`~/.local/share/wolf`).

## Useful variables

Set them on the command line with `+set name value` or in the console.

* `r_mode`: `-2` desktop resolution, `-1` `r_customwidth` x `r_customheight`,
  `0`..`12` the classic modes (see `r_vidModes` in
  [tr_init.c](src/renderer/tr_init.c))
* `r_fullscreen`: `1` for full screen. On Wayland the window gets the size
  the compositor allows and the engine adapts to it.
* `cg_fixedAspect` (default `1`): 4:3 field of view and HUD layout on wide
  screens instead of stretching
* `r_picmip`, `r_textureMode`, `r_ext_texture_filter_anisotropic`,
  `r_ext_compressed_textures`: texture quality; the defaults suit current
  hardware, an old `wolfconfig.cfg` may still carry the 2001 values
* `r_overBrightBits` works without a hardware gamma ramp (Wayland) through
  a post pass
* `s_khz` (default `44`), `s_mixahead` (default `0.1`): sound quality and
  latency
* `in_joystick 1` enables joysticks; a device with an SDL game controller
  mapping is used as a twin stick game pad (`in_gamepadLookSpeed`)
* `in_charset cp1251` maps Cyrillic text input to the 8 bit fonts of
  localised game data
* `fs_basepath`, `fs_cdpath`, `fs_homepath`: the search paths described
  above; `fs_debug 1` traces the file system
* `developer 1` for a verbose log, `logfile 2` to write it to
  `rtcwconsole.log` in the home directory

## Testing

`tools/smoke.sh <build dir> <data dir>` starts the intro movie, the main
menu and a level with a save/load cycle, takes screenshots and checks the
log. It needs a display and the game data.

## License

This project is licensed under the GPL License - see the
[COPYING.txt](COPYING.txt) file for details.

## Acknowledgments

* John Carmack with a team
* hexameron
