include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET cpptrace)

  cppmodule_add_subdirectory(cpptrace "${CPPMODULE_ROOTPATH}/cpptrace")
endif()

if(NOT TARGET cppmodule::cpptrace)
  add_library(cppmodule::cpptrace INTERFACE IMPORTED GLOBAL)
  target_link_libraries(cppmodule::cpptrace INTERFACE cpptrace::cpptrace)
  target_include_directories(cppmodule::cpptrace INTERFACE "${CPPMODULE_ROOTPATH}/cpptrace/include")
endif()
