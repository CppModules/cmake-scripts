include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT DEFINED LVGL_CONF_GEN_DIR)
    set(LVGL_CONF_GEN_DIR "${CMAKE_BINARY_DIR}/generated")
endif()
file(MAKE_DIRECTORY "${LVGL_CONF_GEN_DIR}")

if(NOT TARGET lvgl)
    if(DEFINED LVGL_TEMPLATE_FILE AND EXISTS "${LVGL_TEMPLATE_FILE}")
        configure_file("${LVGL_TEMPLATE_FILE}" "${LVGL_CONF_GEN_DIR}/lv_conf.h" @ONLY)
    else()
        message(WARNING "[CppModule] No LVGL config template defined for this platform: LVGL_TEMPLATE_FILE=${LVGL_TEMPLATE_FILE}")
    endif()

    set(LV_BUILD_CONF_PATH "${LVGL_CONF_GEN_DIR}/lv_conf.h" CACHE PATH "" FORCE)
    cppmodule_add_subdirectory(lvgl "${CPPMODULE_ROOTPATH}/lvgl")

    if(TARGET lvgl)
        if(TARGET SDL3-static)
            target_link_libraries(lvgl PRIVATE SDL3::SDL3-static)
        elseif(EMSCRIPTEN)
            target_compile_options(lvgl PRIVATE -sUSE_SDL=3)
        endif()
        if(TARGET freetype)
            target_link_libraries(lvgl PRIVATE freetype)
        endif()
    endif()
endif()

if(NOT TARGET cppmodule::lvgl)
    add_library(cppmodule::lvgl INTERFACE IMPORTED GLOBAL)
    target_include_directories(cppmodule::lvgl INTERFACE
        "${LVGL_CONF_GEN_DIR}"
        "${CPPMODULE_ROOTPATH}/lvgl/src")
    target_link_libraries(cppmodule::lvgl INTERFACE lvgl::lvgl)
endif()
