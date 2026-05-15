include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET pugixml-static)
    set(BUILD_TESTS OFF CACHE BOOL "" FORCE)
    cppmodule_add_subdirectory(pugixml "${CPPMODULE_ROOTPATH}/pugixml")
endif()

if(NOT TARGET cppmodule::pugixml)
    add_library(cppmodule::pugixml INTERFACE IMPORTED GLOBAL)
    target_link_libraries(cppmodule::pugixml INTERFACE pugixml-static)
endif()
