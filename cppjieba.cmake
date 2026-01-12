include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET cppjieba)
    set(CPPJIEBA_BUILD_TESTS OFF CACHE BOOL "" FORCE)
    cppmodule_add_subdirectory(cppjieba "${CPPMODULE_ROOTPATH}/cppjieba")
endif()

if(NOT TARGET cppmodule::cppjieba)
    add_library(cppmodule::cppjieba INTERFACE IMPORTED GLOBAL)
    target_include_directories(cppmodule::cppjieba INTERFACE 
        "${CPPMODULE_ROOTPATH}/cppjieba/include"
#        "${CPPMODULE_ROOTPATH}/cppjieba/deps/limonp/include"
    )
    target_link_libraries(cppmodule::cppjieba INTERFACE cppjieba_static)
endif()
