include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET SDL3-static)
    set(SDL_STATIC ON CACHE BOOL "" FORCE)
    set(SDL_SHARED OFF CACHE BOOL "" FORCE)

    if(WIN32)
        set(SDL_LIBC ON CACHE BOOL "" FORCE)
    endif()

    cppmodule_add_subdirectory(SDL3 "${CPPMODULE_ROOTPATH}/SDL3")
endif()

if(NOT TARGET cppmodule::sdl3)
    add_library(cppmodule::sdl INTERFACE IMPORTED GLOBAL)
    target_link_libraries(cppmodule::sdl INTERFACE SDL3::SDL3-static)

    # OpenGL 支持 (通过 LVGLEX_RENDER_SELECTED == OPENGLES 自动启用)
    if(LVGLEX_RENDER_SELECTED STREQUAL "OPENGLES")
        if(WIN32)
            target_link_libraries(cppmodule::sdl3 INTERFACE
                opengl32.lib Winmm Setupapi Imm32 Version dwmapi legacy_stdio_definitions)
        elseif(APPLE)
            target_link_libraries(cppmodule::sdl3 INTERFACE OpenGL::GL)
        elseif(UNIX)
            target_link_libraries(cppmodule::sdl3 INTERFACE X11 GL GLU glut)
        endif()
    endif()
endif()
