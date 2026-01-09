include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET cppmodule::xtl)
    add_library(cppmodule::xtl INTERFACE IMPORTED GLOBAL)
    target_include_directories(cppmodule::xtl INTERFACE "${CPPMODULE_ROOTPATH}/xtl/include")
endif()
