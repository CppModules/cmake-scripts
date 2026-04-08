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

# LVGLEx 项目根目录（cmake/ 的上一级）
get_filename_component(LVGLEX_ROOT_DIR "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE)

# 平台模板选择
if(NOT DEFINED LVGL_TEMPLATE_FILE)
    if(EMSCRIPTEN)
        set(LVGL_TEMPLATE_FILE "${LVGLEX_ROOT_DIR}/privately/lv_conf_template_wasm.h.in")
    elseif(WIN32)
        set(LVGL_TEMPLATE_FILE "${LVGLEX_ROOT_DIR}/privately/lv_cong_template_win.h.in")
    elseif(ANDROID)
        # TODO: Android 模板
    elseif(UNIX)
        # TODO: Linux 模板
    endif()
endif()

# ==============================================================================
# 构建 LVGL
# ==============================================================================
if(NOT TARGET lvgl)
    # 根据平台模板生成 lv_conf.h 到 third_party/ 目录
    if(DEFINED LVGL_TEMPLATE_FILE AND EXISTS "${LVGL_TEMPLATE_FILE}")
        configure_file("${LVGL_TEMPLATE_FILE}" "${CPPMODULE_ROOTPATH}/lv_conf.h" @ONLY)
    else()
        message(WARNING "[CppModule] No LVGL config template defined for this platform: LVGL_TEMPLATE_FILE=${LVGL_TEMPLATE_FILE}")
    endif()

    # 告诉 LVGL 的 CMake 去正确的位置找 lv_conf.h
    set(LV_BUILD_CONF_PATH "${CPPMODULE_ROOTPATH}/lv_conf.h" CACHE PATH "" FORCE)

    cppmodule_add_subdirectory(lvgl "${CPPMODULE_ROOTPATH}/lvgl")

    # LVGL 编译 SDL/FreeType 驱动时需要对应头文件路径
    if(TARGET lvgl)
        if(TARGET SDL2-static)
            target_link_libraries(lvgl PRIVATE SDL2::SDL2-static)
        elseif(EMSCRIPTEN)
            # Emscripten 通过编译选项提供 SDL2
            target_compile_options(lvgl PRIVATE -sUSE_SDL=2)
        endif()
        if(TARGET freetype)
            target_link_libraries(lvgl PRIVATE freetype)
        endif()
    endif()
endif()

if(NOT TARGET cppmodule::lvgl)
    add_library(cppmodule::lvgl INTERFACE IMPORTED GLOBAL)
    target_include_directories(cppmodule::lvgl INTERFACE
        "${CPPMODULE_ROOTPATH}"
        "${CPPMODULE_ROOTPATH}/lvgl/src")
    target_link_libraries(cppmodule::lvgl INTERFACE lvgl::lvgl)
endif()
