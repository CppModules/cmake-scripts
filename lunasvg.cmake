include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET lunasvg)
  cppmodule_add_subdirectory(lunasvg "${CPPMODULE_ROOTPATH}/lunasvg")
endif()

if(NOT TARGET cppmodule::lunasvg)
  add_library(cppmodule::lunasvg INTERFACE IMPORTED GLOBAL)
  target_include_directories(cppmodule::lunasvg INTERFACE ${CPPMODULE_ROOTPATH}/lunasvg/include)
  target_link_libraries(cppmodule::lunasvg INTERFACE lunasvg::lunasvg)
endif()
