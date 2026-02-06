include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET xsimd)
  set(BUILD_TESTS OFF CACHE BOOL "" FORCE)
  cppmodule_add_subdirectory(xsimd "${CPPMODULE_ROOTPATH}/xsimd")
endif()

if(NOT TARGET cppmodule::xsimd)
  add_library(cppmodule::xsimd INTERFACE IMPORTED GLOBAL)
  target_include_directories(cppmodule::xsimd INTERFACE
      "${CPPMODULE_ROOTPATH}/xsimd/include"
  )
  target_link_libraries(cppmodule::xsimd INTERFACE xsimd)
endif()
