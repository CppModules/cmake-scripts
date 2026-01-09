include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

if(NOT TARGET tokenizers_cpp)
    cppmodule_add_subdirectory(tokenizers-cpp "${CPPMODULE_ROOTPATH}/tokenizers-cpp")
endif()

if(NOT TARGET cppmodule::tokenizers)
    add_library(cppmodule::tokenizers INTERFACE IMPORTED GLOBAL)
    target_link_libraries(cppmodule::tokenizers INTERFACE tokenizers_cpp)
endif()
