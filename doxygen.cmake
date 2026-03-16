# ==============================================================================
# Doxygen 文档生成
# ==============================================================================
# 添加 `doc` 构建目标：cmake --build . --target doc
# 生成 XML 输出到 ${CMAKE_BINARY_DIR}/doxygen/xml，供脚本转换为 VitePress Markdown

find_package(Doxygen QUIET)

if(DOXYGEN_FOUND)
    set(DOXYGEN_INPUT_DIR  "${CMAKE_CURRENT_LIST_DIR}/../include")
    set(DOXYGEN_OUTPUT_DIR "${CMAKE_BINARY_DIR}/doxygen")

    configure_file(
        "${CMAKE_CURRENT_LIST_DIR}/../Doxyfile.in"
        "${CMAKE_BINARY_DIR}/Doxyfile"
        @ONLY
    )

    add_custom_target(doc
        COMMAND ${DOXYGEN_EXECUTABLE} "${CMAKE_BINARY_DIR}/Doxyfile"
        WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/.."
        COMMENT "Generating Doxygen XML → ${DOXYGEN_OUTPUT_DIR}/xml"
        VERBATIM
    )
else()
    message(STATUS "Doxygen not found — 'doc' target disabled")
endif()
