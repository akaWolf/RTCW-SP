cmake_minimum_required(VERSION 3.12)

project(wolf C CXX)

option(ENABLE_DEMO "Build demo version" OFF)
option(ENABLE_LTO "Link time optimisation" OFF)

# set default Release build
if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Release")
endif()

# the C++ part (splines) must see the same char signedness and aliasing rules
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pipe -fsigned-char -fno-strict-aliasing -Wall -Wno-unused")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pipe -fsigned-char -fno-strict-aliasing -Wall -Wno-unused")
set(CMAKE_C_FLAGS_DEBUG "-ggdb3")
set(CMAKE_CXX_FLAGS_DEBUG "-ggdb3")
# no -ffast-math: float args go through int punning in VM calls
set(CMAKE_C_FLAGS_RELEASE "-O2 -DNDEBUG")
set(CMAKE_CXX_FLAGS_RELEASE "-O2 -DNDEBUG")

if(ENABLE_LTO)
	include(CheckIPOSupported)
	check_ipo_supported(RESULT WOLF_IPO OUTPUT WOLF_IPO_MSG)
	if(WOLF_IPO)
		set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
	else()
		message(WARNING "LTO not supported: ${WOLF_IPO_MSG}")
	endif()
endif()

if(ENABLE_DEMO)
	add_definitions(-DWOLF_SP_DEMO)
endif()

# the executable and the game modules end up next to each other, so the
# build directory can be used as fs_basepath right away
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

add_subdirectory(src)

# set default install directory
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
	set(CMAKE_INSTALL_PREFIX "$ENV{HOME}/RTCW" CACHE PATH "install prefix" FORCE)
endif()
