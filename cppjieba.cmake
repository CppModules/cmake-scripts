include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET cppmodule::cppjieba)
    add_library(cppmodule::cppjieba INTERFACE IMPORTED GLOBAL)
    target_include_directories(cppmodule::cppjieba INTERFACE 
        "${CPPMODULE_ROOTPATH}/cppjieba/include"
        "${CPPMODULE_ROOTPATH}/cppjieba/deps"
    )
endif()
