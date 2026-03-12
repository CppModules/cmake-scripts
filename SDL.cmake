include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET SDL2-static)
    set(SDL_STATIC ON CACHE BOOL "" FORCE)
    set(SDL_SHARED OFF CACHE BOOL "" FORCE)

    if(WIN32)
        set(SDL_LIBC ON CACHE BOOL "" FORCE)
    endif()

    cppmodule_add_subdirectory(SDL "${CPPMODULE_ROOTPATH}/SDL")
endif()

if(NOT TARGET cppmodule::sdl)
    add_library(cppmodule::sdl INTERFACE IMPORTED GLOBAL)
    target_link_libraries(cppmodule::sdl INTERFACE SDL2::SDL2main SDL2::SDL2-static)

    # OpenGL 支持 (通过 CPPMODULE_SDL_ENABLE_OPENGL 启用)
    if(CPPMODULE_SDL_ENABLE_OPENGL)
        if(WIN32)
            target_link_libraries(cppmodule::sdl INTERFACE
                opengl32.lib Winmm Setupapi Imm32 Version dwmapi legacy_stdio_definitions)
        elseif(APPLE)
            target_link_libraries(cppmodule::sdl INTERFACE OpenGL::GL)
        elseif(UNIX)
            target_link_libraries(cppmodule::sdl INTERFACE X11 GL GLU glut)
        endif()
    endif()
endif()
