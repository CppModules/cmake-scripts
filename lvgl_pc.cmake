
#CHECK_SUB(CPPMODULE_SDL CPPMODULE_FREETYPE2)

include_directories(${CPPMODULE_ROOTPATH}/lvgl)
set(BUILD_SHARED_LIBS OFF)

# 颜色位深度
set(LVGL_CFG_COLOR_DEPTH 32)
# 启用字体支持
set(LVGL_CFG_USE_FREETYPE 1)

# TODO: RTOS可以更换
#set(LVGL_CFG_USE_STDLIB LV_STDLIB_CLIB)
set(LVGL_CFG_USE_STDLIB LV_STDLIB_BUILTIN)

# 启用矩阵变换
set(LVGL_CFG_DRAW_TRANSFORM_USE_MATRIX 1)
if (LVGL_CFG_DRAW_TRANSFORM_USE_MATRIX)
  set(LVGL_CFG_USE_MATRIX 1)
  set(LVGL_CFG_USE_FLOAT 1)
endif ()


# 启用SDL绘图后端
set(LVGL_CFG_USE_DRAW_SDL 0)
set(LVGL_CFG_USE_GPU 0)

set(LVGL_CFG_USE_OPENGLES 0)
set(LVGL_CFG_USE_SDL 0)
set(LVGL_CFG_USE_DMA2D 0)

set(LVGL_CFG_USE_SDL 0)
set(LVGL_CFG_USE_X11 0)
set(LVGL_CFG_USE_WAYLAND 0)
set(LVGL_CFG_USE_NUTTX 0)
# Framebuffer
set(LVGL_CFG_USE_LINUX_FBDEV 0)



# 系统支持
if (WIN32)
SET(TEMPLATE_FILE "lv_cong_template_win.h.in")
elseif (ANDROID)

elseif (UNIX)

elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "STM32")

elseif (${CMAKE_SYSTEM_NAME} MATCHES "FreeRTOS")

elseif (${CMAKE_SYSTEM_NAME} MATCHES "RT-Thread")

elseif (${CMAKE_SYSTEM_NAME} MATCHES "MQX")

else ()
  set(LVGL_CFG_USE_OS "LV_OS_NONE")
endif ()


include_directories("${CPPMODULE_ROOTPATH}")
include_directories("${CPPMODULE_ROOTPATH}/lvgl/src")
set(LVGL_CFG_TEMPLATE_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/privately/${TEMPLATE_FILE}")
#configure_file(${LVGL_CFG_TEMPLATE_HEADER} "${CPPMODULE_ROOTPATH}/lvgl/lv_conf.h" @ONLY)
configure_file(${LVGL_CFG_TEMPLATE_HEADER} "${CMAKE_SOURCE_DIR}/lv_conf.h" @ONLY)
add_subdirectory(${CPPMODULE_ROOTPATH}/lvgl ${CPPMODULE_BINARY_SUBDIR}/lvgl)
#target_compile_options(lvgl::lvgl PUBLIC /utf-8 )
set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} lvgl::lvgl)
set(CPPMODULE_LINK_LIBRARIES_GPTSOVITSCPP lvgl::lvgl)
target_include_directories(cmake_include_interface INTERFACE "${CPPMODULE_ROOTPATH}")
target_include_directories(cmake_include_interface INTERFACE "${CPPMODULE_ROOTPATH}/lvgl/src")