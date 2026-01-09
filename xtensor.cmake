include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/xtl.cmake)

if(NOT TARGET cppmodule::xtensor)
    add_library(cppmodule::xtensor INTERFACE IMPORTED GLOBAL)
    target_link_libraries(cppmodule::xtensor INTERFACE cppmodule::xtl)
    target_include_directories(cppmodule::xtensor INTERFACE "${CPPMODULE_ROOTPATH}/xtensor/include")
    
    # xtensor 依赖一些宏定义
    target_compile_definitions(cppmodule::xtensor INTERFACE XTENSOR_USE_XSIMD)
endif()
