if(CMAKE_SCRIPT_MODE_FILE)
    include("${CMAKE_CURRENT_LIST_DIR}/embed_resources.cmake")
    return()
endif()

include_guard(GLOBAL)
include("${CMAKE_CURRENT_LIST_DIR}/base.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/embed_resources.cmake")

if(NOT TARGET cppmodule::incbin)
    add_library(cppmodule::incbin INTERFACE IMPORTED GLOBAL)
    target_include_directories(cppmodule::incbin INTERFACE
        "${CPPMODULE_ROOTPATH}/incbin")
endif()

if(NOT MSVC AND NOT EMSCRIPTEN AND NOT CMAKE_ASM_COMPILER)
    enable_language(ASM)
endif()
