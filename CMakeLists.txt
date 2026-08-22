cmake_minimum_required(VERSION 3.10)

project(wolf)

option(ENABLE_DEMO "Build demo version")

# set default Release build
if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Release")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pipe -fsigned-char -fno-strict-aliasing -Wall")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-unused")
# the C++ part (splines) must see the same char signedness and aliasing rules
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pipe -fsigned-char -fno-strict-aliasing -Wall -Wno-unused")
set(CMAKE_CXX_FLAGS_DEBUG "-ggdb3")
set(CMAKE_CXX_FLAGS_RELEASE "-O2 -DNDEBUG")

# CMAKE_C_FLAGS is appended automatically, no need to repeat it here
set(CMAKE_C_FLAGS_DEBUG "-ggdb3")
# no -ffast-math: float args go through int punning in VM calls
set(CMAKE_C_FLAGS_RELEASE "-O2 -DNDEBUG")

if(ENABLE_DEMO)
add_definitions(-DWOLF_SP_DEMO)
endif()

set(LIBRARY_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR})

add_subdirectory(src)

# set default install directory
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
	set(CMAKE_INSTALL_PREFIX "$ENV{HOME}/RTCW")
endif()
