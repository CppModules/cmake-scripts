include_guard(GLOBAL)
include("${CMAKE_CURRENT_LIST_DIR}/base.cmake")

if(NOT TARGET litehtml)
    cppmodule_add_subdirectory(litehtml "${CPPMODULE_ROOTPATH}/litehtml")
    if(TARGET litehtml)
        set_property(DIRECTORY "${CPPMODULE_ROOTPATH}/litehtml" PROPERTY EXCLUDE_FROM_ALL TRUE)
    endif()
endif()

if(NOT TARGET cppmodule::litehtml)
    add_library(cppmodule::litehtml INTERFACE IMPORTED GLOBAL)
    target_link_libraries(cppmodule::litehtml INTERFACE litehtml)
endif()
