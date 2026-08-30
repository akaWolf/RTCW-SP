file(GLOB CXX_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp")
list(SORT CXX_SOURCES)

add_library(splines STATIC ${CXX_SOURCES})
target_compile_options(splines PRIVATE -Wno-write-strings)
