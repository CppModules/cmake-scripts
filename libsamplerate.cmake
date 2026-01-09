include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET samplerate)
    set(LIBSAMPLERATE_EXAMPLES OFF CACHE BOOL "" FORCE)
    set(LIBSAMPLERATE_INSTALL OFF CACHE BOOL "" FORCE)
    cppmodule_add_subdirectory(libsamplerate "${CPPMODULE_ROOTPATH}/libsamplerate")
endif()

if(NOT TARGET cppmodule::samplerate)
    add_library(cppmodule::samplerate INTERFACE IMPORTED GLOBAL)
    target_link_libraries(cppmodule::samplerate INTERFACE samplerate)
endif()
