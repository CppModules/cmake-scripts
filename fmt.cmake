include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET fmt)
    # 关闭安装和测试，减少干扰
    set(FMT_INSTALL OFF CACHE BOOL "" FORCE)
    set(FMT_TEST OFF CACHE BOOL "" FORCE)
    
    cppmodule_add_subdirectory(fmt "${CPPMODULE_ROOTPATH}/fmt")
endif()

if(NOT TARGET cppmodule::fmt)
    add_library(cppmodule::fmt INTERFACE IMPORTED GLOBAL)
    target_link_libraries(cppmodule::fmt INTERFACE fmt)
endif()
