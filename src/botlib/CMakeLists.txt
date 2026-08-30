file(GLOB C_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/*.c")
list(SORT C_SOURCES)

add_library(botlib STATIC ${C_SOURCES})
target_compile_definitions(botlib PRIVATE BOTLIB)
