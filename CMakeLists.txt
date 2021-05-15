project(wolf)

cmake_minimum_required(VERSION 2.9)
if(COMMAND cmake_policy)
	cmake_policy(SET CMP0003 NEW)
endif()

option(ENABLE_DEMO "Build demo version")

# set default Release build
if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Release")
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pipe -fsigned-char -fno-strict-aliasing -Wall")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-unused")

set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS} -ggdb3")
# -O3 and -ffast-math breaks passing parameters through VM calls
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS} -DNDEBUG")

if(ENABLE_DEMO)
add_definitions(-DWOLF_SP_DEMO)
endif()

set(LIBRARY_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR})

add_subdirectory(src)

# set default install directory
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
	set(CMAKE_INSTALL_PREFIX "$ENV{HOME}/RTCW")
endif()
