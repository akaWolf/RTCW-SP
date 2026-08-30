# the engine: client, server, renderer, common code and the platform layer

file(GLOB RENDERER_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/../renderer/*.c")
file(GLOB QCOMMON_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/../qcommon/*.c")
file(GLOB SERVER_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/../server/*.c")
file(GLOB CLIENT_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/*.c")
list(SORT RENDERER_SOURCES)
list(SORT QCOMMON_SOURCES)
list(SORT SERVER_SOURCES)
list(SORT CLIENT_SOURCES)

# only native game modules are used
list(REMOVE_ITEM QCOMMON_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/../qcommon/vm_x86.c")

set(UNIX_SOURCES
	${CMAKE_SOURCE_DIR}/src/unix/unix_main.c
	${CMAKE_SOURCE_DIR}/src/unix/unix_net.c
	${CMAKE_SOURCE_DIR}/src/unix/unix_shared.c
	${CMAKE_SOURCE_DIR}/src/unix/linux_common.c
	${CMAKE_SOURCE_DIR}/src/unix/sdl2_gamma.c
	${CMAKE_SOURCE_DIR}/src/unix/sdl2_glimp.c
	${CMAKE_SOURCE_DIR}/src/unix/sdl2_input.c
	${CMAKE_SOURCE_DIR}/src/unix/sdl2_snd.c
)

set(SHARED_SOURCES
	${CMAKE_SOURCE_DIR}/src/game/q_shared.c
	${CMAKE_SOURCE_DIR}/src/game/q_math.c
)

# SDL2: the CMake config of SDL2 / sdl2-compat, or pkg-config as a fallback
find_package(SDL2 QUIET)
if(TARGET SDL2::SDL2)
	set(WOLF_SDL2_LIBRARIES SDL2::SDL2)
	set(WOLF_SDL2_INCLUDE_DIRS ${SDL2_INCLUDE_DIRS})
elseif(SDL2_FOUND)
	set(WOLF_SDL2_LIBRARIES ${SDL2_LIBRARIES})
	set(WOLF_SDL2_INCLUDE_DIRS ${SDL2_INCLUDE_DIRS})
else()
	find_package(PkgConfig REQUIRED)
	pkg_check_modules(SDL2 REQUIRED sdl2)
	set(WOLF_SDL2_LIBRARIES ${SDL2_LIBRARIES})
	set(WOLF_SDL2_INCLUDE_DIRS ${SDL2_INCLUDE_DIRS})
endif()
# the sources include <SDL2/SDL.h>, so the parent of an .../include/SDL2 directory is needed as well
foreach(dir ${WOLF_SDL2_INCLUDE_DIRS})
	get_filename_component(parent "${dir}" DIRECTORY)
	list(APPEND WOLF_SDL2_INCLUDE_DIRS "${parent}")
endforeach()

find_package(OpenGL REQUIRED)
# the system libjpeg (libjpeg-turbo) replaces the bundled jpeg-6
find_package(JPEG REQUIRED)

add_executable(${PROJECT_NAME}
	${CLIENT_SOURCES} ${RENDERER_SOURCES} ${QCOMMON_SOURCES} ${SERVER_SOURCES} ${UNIX_SOURCES} ${SHARED_SOURCES}
)
target_include_directories(${PROJECT_NAME} PRIVATE ${WOLF_SDL2_INCLUDE_DIRS} ${JPEG_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} PRIVATE ${WOLF_SDL2_LIBRARIES} OpenGL::GL ${JPEG_LIBRARIES} botlib splines ${CMAKE_DL_LIBS} m)

install(TARGETS ${PROJECT_NAME} DESTINATION .)
