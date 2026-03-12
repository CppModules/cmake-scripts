include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

# ==============================================================================
# LVGL 配置选项
# ==============================================================================

# 颜色位深度
set(LVGL_CFG_COLOR_DEPTH 32)

# 启用字体支持
set(LVGL_CFG_USE_FREETYPE 1)

# 标准库选择 (TODO: RTOS 可以更换)
set(LVGL_CFG_USE_STDLIB LV_STDLIB_BUILTIN)

# 启用矩阵变换
set(LVGL_CFG_DRAW_TRANSFORM_USE_MATRIX 1)
if(LVGL_CFG_DRAW_TRANSFORM_USE_MATRIX)
    set(LVGL_CFG_USE_MATRIX 1)
    set(LVGL_CFG_USE_FLOAT 1)
endif()

# 显示后端 (全部禁用)
set(LVGL_CFG_USE_DRAW_SDL 0)
set(LVGL_CFG_USE_GPU 0)
set(LVGL_CFG_USE_OPENGLES 0)
set(LVGL_CFG_USE_SDL 0)
set(LVGL_CFG_USE_DMA2D 0)
set(LVGL_CFG_USE_X11 0)
set(LVGL_CFG_USE_WAYLAND 0)
set(LVGL_CFG_USE_NUTTX 0)
set(LVGL_CFG_USE_LINUX_FBDEV 0)

# 平台模板选择
if(WIN32)
    set(TEMPLATE_FILE "lv_cong_template_win.h.in")
elseif(ANDROID)
    # TODO: Android 模板
elseif(UNIX)
    # TODO: Linux 模板
endif()

# ==============================================================================
# 构建 LVGL
# ==============================================================================
if(NOT TARGET lvgl)
    # 根据平台模板生成 lv_conf.h
    if(DEFINED TEMPLATE_FILE)
        set(LVGL_CFG_TEMPLATE_HEADER "${CMAKE_SOURCE_DIR}/privately/${TEMPLATE_FILE}")
        configure_file(${LVGL_CFG_TEMPLATE_HEADER} "${CMAKE_SOURCE_DIR}/lv_conf.h" @ONLY)
    else()
        message(WARNING "[CppModule] No LVGL config template defined for this platform")
    endif()

    cppmodule_add_subdirectory(lvgl "${CPPMODULE_ROOTPATH}/lvgl")
endif()

if(NOT TARGET cppmodule::lvgl)
    add_library(cppmodule::lvgl INTERFACE IMPORTED GLOBAL)
    target_include_directories(cppmodule::lvgl INTERFACE
        "${CPPMODULE_ROOTPATH}"
        "${CPPMODULE_ROOTPATH}/lvgl/src")
    target_link_libraries(cppmodule::lvgl INTERFACE lvgl::lvgl)
endif()
