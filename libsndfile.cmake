include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET sndfile)
    # 确保不与 CMAKE_MSVC_RUNTIME_LIBRARY 冲突
    unset(ENABLE_STATIC_RUNTIME CACHE)
    
    set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
    set(BUILD_REGTEST OFF CACHE BOOL "" FORCE)
    set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
    set(ENABLE_PACKAGE_CONFIG OFF CACHE BOOL "" FORCE)
    
    cppmodule_add_subdirectory(libsndfile "${CPPMODULE_ROOTPATH}/libsndfile")
endif()

if(NOT TARGET cppmodule::sndfile)
    add_library(cppmodule::sndfile INTERFACE IMPORTED GLOBAL)
    target_include_directories(cppmodule::sndfile INTERFACE ${CPPMODULE_ROOTPATH}/libsndfile/include)
    target_link_libraries(cppmodule::sndfile INTERFACE sndfile)
endif()
