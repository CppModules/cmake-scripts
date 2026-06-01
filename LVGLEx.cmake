include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET lvgl_ex)
  cppmodule_add_subdirectory(lvgl_ex "${CPPMODULE_ROOTPATH}/LVGLEx")
endif()

if(NOT TARGET cppmodule::lvgl_ex)
  add_library(cppmodule::lvgl_ex INTERFACE IMPORTED GLOBAL)
  target_include_directories(cppmodule::lvgl_ex INTERFACE ${CPPMODULE_ROOTPATH}/LVGLEx/include)
  target_link_libraries(cppmodule::lvgl_ex INTERFACE LVGLEx-static)
endif()
