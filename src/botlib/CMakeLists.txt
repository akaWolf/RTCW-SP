cmake_minimum_required(VERSION 2.9)

# Get all C source files
file(GLOB C_SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "*.c")

# Sort the C sources into a neat list
list(SORT C_SOURCES)

add_definitions(-DBOTLIB)

# Set the compiler to use
# Set_source_files_properties(${C_SOURCES} PROPERTIES LANGUAGE C COMPILE_FLAGS "-g")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--no-as-needed")

# Add to our library.
add_library(botlib.a STATIC ${C_SOURCES})
set_target_properties(botlib.a PROPERTIES LINKER_LANGUAGE C PREFIX "" SUFFIX "")
