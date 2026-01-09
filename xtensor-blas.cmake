include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/xtensor.cmake)

if(NOT TARGET cppmodule::xtensor-blas)
    add_library(cppmodule::xtensor-blas INTERFACE IMPORTED GLOBAL)
    target_link_libraries(cppmodule::xtensor-blas INTERFACE cppmodule::xtensor)
    target_include_directories(cppmodule::xtensor-blas INTERFACE "${CPPMODULE_ROOTPATH}/xtensor-blas/include")
endif()
