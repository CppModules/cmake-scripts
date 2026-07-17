include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET cppmodule::stb)
  add_library(cppmodule::stb INTERFACE IMPORTED GLOBAL)
  target_include_directories(cppmodule::stb INTERFACE ${CPPMODULE_ROOTPATH}/stb)
endif()
