include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

# nlohmann/json 是 Header-only 的
if(NOT TARGET cppmodule::json)
    add_library(cppmodule::json INTERFACE IMPORTED GLOBAL)
    set(JSON_INCLUDE_DIR "${CPPMODULE_ROOTPATH}/json/include")
    
    if(EXISTS "${JSON_INCLUDE_DIR}")
        target_include_directories(cppmodule::json INTERFACE "${JSON_INCLUDE_DIR}")
    else()
        message(FATAL_ERROR "[CppModule] json include directory not found: ${JSON_INCLUDE_DIR}")
    endif()
endif()
