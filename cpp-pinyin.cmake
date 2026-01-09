include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET cpp-pinyin)
    cppmodule_add_subdirectory(cpp-pinyin "${CPPMODULE_ROOTPATH}/cpp-pinyin")
endif()

if(NOT TARGET cppmodule::pinyin)
    add_library(cppmodule::pinyin INTERFACE IMPORTED GLOBAL)
    target_link_libraries(cppmodule::pinyin INTERFACE cpp-pinyin)
endif()
