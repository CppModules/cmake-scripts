# icon_font.cmake - Material Symbols 图标字体 CMake 集成模块
#
# 用法:
#   include(cmake/icon_font.cmake)
#   target_link_icon_font(<target> [EMBED_DIR <dir>])
#   target_link_embed(<target> [EMBED_DIR <dir>])
#
# 注意: target_link_icon_font 必须在 target_link_embed 之前调用,
#       字体会被复制到 embed 目录，由 target_link_embed 统一嵌入。
#
# CMake 选项:
#   LX_ICON_FULL_FONT       - ON 时嵌入完整字体，跳过裁剪（默认 OFF）
#   LX_PYTHON_EXECUTABLE    - 自定义 Python 解释器路径（留空自动查找）

include_guard(GLOBAL)

option(LX_ICON_FULL_FONT "嵌入完整 Material Symbols 字体，跳过裁剪" OFF)

set(LX_ICON_RES_DIR "${CMAKE_CURRENT_LIST_DIR}/../third_party/material_symbols/res" CACHE PATH "图标资源目录")
set(LX_ICON_CODEPOINTS_FILE "${LX_ICON_RES_DIR}/MaterialSymbolsOutlined.codepoints" CACHE FILEPATH "码点映射文件")
set(LX_ICON_FONT_FILE "${LX_ICON_RES_DIR}/MaterialSymbolsOutlined.ttf" CACHE FILEPATH "图标字体文件")
set(LX_ICON_SCRIPTS_DIR "${CMAKE_CURRENT_LIST_DIR}/../third_party/material_symbols/scripts" CACHE PATH "图标脚本目录")

set(LX_PYTHON_EXECUTABLE "" CACHE FILEPATH "自定义 Python 解释器路径（留空则自动查找）")

if(LX_PYTHON_EXECUTABLE AND EXISTS "${LX_PYTHON_EXECUTABLE}")
    set(_LX_PYTHON "${LX_PYTHON_EXECUTABLE}" CACHE INTERNAL "")
    set(_LX_PYTHON_FOUND TRUE CACHE INTERNAL "")
else()
    find_package(Python3 QUIET COMPONENTS Interpreter)
    if(Python3_FOUND)
        set(_LX_PYTHON "${Python3_EXECUTABLE}" CACHE INTERNAL "")
        set(_LX_PYTHON_FOUND TRUE CACHE INTERNAL "")
    else()
        set(_LX_PYTHON_FOUND FALSE CACHE INTERNAL "")
    endif()
endif()

# ==============================================================================
# target_link_icon_font(<target> [EMBED_DIR <dir>])
#
# 将裁剪后的字体复制到 EMBED_DIR，由后续 target_link_embed 统一嵌入。
# ==============================================================================
function(target_link_icon_font target)
    cmake_parse_arguments(_ARG "" "EMBED_DIR" "" ${ARGN})

    set(_out_dir "${CMAKE_BINARY_DIR}/icon_gen/${target}")
    set(_header_dir "${_out_dir}/include")
    set(_header "${_header_dir}/icon_codepoints.h")

    # 字体输出目录: 用户指定 > 默认 embed
    if(DEFINED _ARG_EMBED_DIR)
        set(_embed_dir "${_ARG_EMBED_DIR}")
    else()
        set(_embed_dir "${INCBIN_EMBED_DIR}")
    endif()
    if(NOT IS_ABSOLUTE "${_embed_dir}")
        set(_embed_dir "${CMAKE_SOURCE_DIR}/${_embed_dir}")
    endif()

    file(MAKE_DIRECTORY "${_header_dir}")
    file(MAKE_DIRECTORY "${_embed_dir}")

    # ---- 前置检查 ----
    if(NOT EXISTS "${LX_ICON_CODEPOINTS_FILE}")
        message(WARNING "ICON_FONT: 找不到 codepoints 文件: ${LX_ICON_CODEPOINTS_FILE}")
        return()
    endif()
    if(NOT _LX_PYTHON_FOUND)
        message(WARNING "ICON_FONT: 找不到 Python3。可通过 -DLX_PYTHON_EXECUTABLE=<path> 指定")
        return()
    endif()
    if(NOT EXISTS "${LX_ICON_FONT_FILE}")
        message(WARNING "ICON_FONT: 找不到字体文件: ${LX_ICON_FONT_FILE}")
        return()
    endif()

    # ---- 步骤 1: 生成码点头文件 ----
    execute_process(
        COMMAND ${_LX_PYTHON}
            "${LX_ICON_SCRIPTS_DIR}/generate_icon_header.py"
            "${LX_ICON_CODEPOINTS_FILE}"
            "${_header}"
        RESULT_VARIABLE _gen_result
        OUTPUT_VARIABLE _gen_stdout
        ERROR_VARIABLE  _gen_stderr
    )
    if(NOT _gen_result EQUAL 0)
        message(WARNING "ICON_FONT: 码点头文件生成失败 (exit ${_gen_result})\n-- stdout:\n${_gen_stdout}\n-- stderr:\n${_gen_stderr}")
        return()
    endif()

    target_include_directories(${target} PRIVATE "${_header_dir}")

    # ---- 生成 icon_font_data.h: 稳定的 embed 符号引用 ----
    # 按 incbin.cmake 的规则计算字体文件的 embed 符号名
    set(_font_filename "MaterialSymbolsOutlined.ttf")
    file(RELATIVE_PATH _font_rel "${CMAKE_SOURCE_DIR}" "${_embed_dir}/${_font_filename}")
    string(REGEX REPLACE "^[/\\\\]+" "" _font_sym "${_font_rel}")
    string(REGEX REPLACE "[/\\\\]" "_" _font_sym "${_font_sym}")
    string(REGEX REPLACE "\\." "_" _font_sym "${_font_sym}")
    string(TOLOWER "${_font_sym}" _font_sym)

    set(_font_data_header "${_header_dir}/icon_font_data.h")
    file(WRITE "${_font_data_header}"
        "// 自动生成，勿手动编辑\n"
        "#pragma once\n"
        "#include \"embed_data.h\"\n\n"
        "#define LX_ICON_FONT_DATA  ${_font_sym}_data\n"
        "#define LX_ICON_FONT_SIZE  ${_font_sym}_size\n"
    )

    # ---- 步骤 2 & 3: 裁剪或全量复制到 embed 目录 ----
    set(_subset_ttf "${_embed_dir}/MaterialSymbolsOutlined.ttf")

    if(LX_ICON_FULL_FONT)
        file(COPY "${LX_ICON_FONT_FILE}" DESTINATION "${_embed_dir}")
        message(STATUS "ICON_FONT: 全量模式 (LX_ICON_FULL_FONT=ON)")
    else()
        get_target_property(_sources ${target} SOURCES)
        get_target_property(_source_dir ${target} SOURCE_DIR)

        set(_all_codepoints "")
        foreach(_src IN LISTS _sources)
            if(NOT IS_ABSOLUTE "${_src}")
                set(_src "${_source_dir}/${_src}")
            endif()
            if(EXISTS "${_src}")
                file(STRINGS "${_src}" _matches REGEX "LX_ICON_[A-Z0-9_]+")
                foreach(_match IN LISTS _matches)
                    string(REGEX MATCHALL "LX_ICON_[A-Z0-9_]+" _icons "${_match}")
                    list(APPEND _all_codepoints ${_icons})
                endforeach()
            endif()
        endforeach()

        if(_all_codepoints)
            list(REMOVE_DUPLICATES _all_codepoints)
        endif()

        file(STRINGS "${LX_ICON_CODEPOINTS_FILE}" _cp_lines)
        set(_hex_list "")
        foreach(_icon IN LISTS _all_codepoints)
            string(REGEX REPLACE "^LX_ICON_" "" _name "${_icon}")
            string(TOLOWER "${_name}" _name)
            foreach(_line IN LISTS _cp_lines)
                string(REGEX MATCH "^${_name} ([0-9a-fA-F]+)" _m "${_line}")
                if(_m)
                    list(APPEND _hex_list "${CMAKE_MATCH_1}")
                    break()
                endif()
            endforeach()
        endforeach()

        if(_hex_list)
            list(REMOVE_DUPLICATES _hex_list)
            list(LENGTH _hex_list _count)
            message(STATUS "ICON_FONT: 裁剪模式 - ${_count} 个图标码点")

            execute_process(
                COMMAND ${_LX_PYTHON}
                    "${LX_ICON_SCRIPTS_DIR}/subset_icon_font.py"
                    "${LX_ICON_FONT_FILE}"
                    "${_subset_ttf}"
                    ${_hex_list}
                RESULT_VARIABLE _sub_result
                OUTPUT_VARIABLE _sub_stdout
                ERROR_VARIABLE  _sub_stderr
            )
            if(NOT _sub_result EQUAL 0)
                message(WARNING "ICON_FONT: 字体裁剪失败 (exit ${_sub_result})，回退全量模式\n-- stdout:\n${_sub_stdout}\n-- stderr:\n${_sub_stderr}")
                file(COPY "${LX_ICON_FONT_FILE}" DESTINATION "${_embed_dir}")
            endif()
        else()
            message(STATUS "ICON_FONT: 未检测到 LX_ICON_* 宏使用，复制完整字体")
            file(COPY "${LX_ICON_FONT_FILE}" DESTINATION "${_embed_dir}")
        endif()
    endif()

    message(STATUS "ICON_FONT: 已配置 ${target} (字体输出: ${_embed_dir})")
endfunction()
