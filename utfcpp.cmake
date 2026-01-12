include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET utfcpp_cpp)
  cppmodule_add_subdirectory(utfcpp "${CPPMODULE_ROOTPATH}/utfcpp")
endif()

if(NOT TARGET cppmodule::utfcpp)
  add_library(cppmodule::utfcpp INTERFACE IMPORTED GLOBAL)
  target_link_libraries(cppmodule::utfcpp INTERFACE utfcpp)
  target_include_directories(cppmodule::utfcpp INTERFACE ${CPPMODULE_ROOTPATH}/utfcpp/source)
endif()