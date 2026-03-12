include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET portaudio)
    cppmodule_add_subdirectory(portaudio "${CPPMODULE_ROOTPATH}/portaudio")
endif()

if(NOT TARGET cppmodule::portaudio)
    add_library(cppmodule::portaudio INTERFACE IMPORTED GLOBAL)
    target_include_directories(cppmodule::portaudio INTERFACE "${CPPMODULE_ROOTPATH}/portaudio/include")
    target_link_libraries(cppmodule::portaudio INTERFACE portaudio)
endif()
