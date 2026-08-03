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
endif()
