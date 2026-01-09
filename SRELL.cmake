include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET cppmodule::srell)
    add_library(cppmodule::srell INTERFACE IMPORTED GLOBAL)
    target_include_directories(cppmodule::srell INTERFACE "${CPPMODULE_ROOTPATH}/SRELL")
endif()
