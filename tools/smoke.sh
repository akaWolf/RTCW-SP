#!/usr/bin/env bash
# Smoke test with real game data: intro movie, main menu, a level with a
# save/load cycle. Needs a display (SDL opens a window) and the pak files.
#
#   tools/smoke.sh <build dir> <data dir containing main/pak0.pk3> [out dir]
#
# Screenshots and logs of every case end up in the out dir; the exit code is
# the number of failed cases.
set -u

BUILD=${1:?build dir}
DATA=${2:?data dir}
OUT=${3:-$(mktemp -d)}
FAILED=0

fatal_pattern='Sys_Error|Received signal|Hunk_Alloc failed|G_Error|failed dlopen|Couldn'"'"'t load|DOUBLE SIGNAL'

run_case() {
	local name=$1 shots=$2 cfg=$3
	shift 3
	local home=$OUT/$name log=$OUT/$name/main/rtcwconsole.log
	mkdir -p "$home/main"
	printf '%s\n' "$cfg" > "$home/main/smoke.cfg"
	timeout 180 "$BUILD/wolf" +set fs_basepath "$BUILD" +set fs_cdpath "$DATA" +set fs_homepath "$home" \
		+set r_fullscreen 0 +set r_mode -1 +set r_customwidth 1280 +set r_customheight 720 \
		+set in_mouse 0 +set s_volume 0 +set s_musicvolume 0 +set logfile 2 +set developer 1 \
		+set com_introplayed 1 "$@" +exec smoke.cfg > "$home/stdout" 2>&1
	local rc=$? ok=1
	if [ ! -f "$log" ]; then
		echo "FAIL $name: no log written (exit $rc)"; FAILED=$((FAILED + 1)); return
	fi
	if grep -Eq "$fatal_pattern" "$log"; then
		echo "FAIL $name: fatal message in log"; grep -E "$fatal_pattern" "$log" | head -3; ok=0
	fi
	local n
	n=$(find "$home/main/screenshots" -name 'shot*.jpg' -size +20k 2>/dev/null | wc -l)
	if [ "$n" -lt "$shots" ]; then
		echo "FAIL $name: $n of $shots screenshots (exit $rc)"; tail -5 "$log"; ok=0
	fi
	if [ "$ok" = 1 ]; then echo "PASS $name ($n screenshots)"; else FAILED=$((FAILED + 1)); fi
}

# the intro movie (a few seconds in) and the main menu
run_case intro 1 $'cinematic wolfintro.RoQ 3\nwait 240\nscreenshotJPEG\nwait 10\nquit'
run_case menu 1 $'wait 120\nscreenshotJPEG\nwait 10\nquit'
# a level: click through the briefing, play a bit, save, load, screenshot.
# The UI appends its own commands after a click, so everything after the
# click has to run from a bind rather than from the cfg.
run_case level 2 $'bind F12 "wait 300; screenshotJPEG; wait 300; savegame smoketest; wait 60; loadgame smoketest; wait 400; screenshotJPEG; wait 10; quit"\nspdevmap escape2\nwait 1000\nkeyevent MOUSE1 600 450\nwait 60\nkeyevent F12'

echo "results in $OUT"
exit $FAILED
