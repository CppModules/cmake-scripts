
include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET cld2_cmake)
  cppmodule_add_subdirectory(cld2 "${CPPMODULE_ROOTPATH}/cld2-cmake")
endif()

if(NOT TARGET cppmodule::cld2_cmake)
  add_library(cppmodule::cld2_cmake INTERFACE IMPORTED GLOBAL)
  target_link_libraries(cppmodule::cld2_cmake INTERFACE CLD2-static)
  target_include_directories(cppmodule::cld2_cmake INTERFACE ${CPPMODULE_ROOTPATH}/cld2-cmake/public)
endif()