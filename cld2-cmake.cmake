target_include_directories(cmake_include_interface INTERFACE ${CPPMODULE_ROOTPATH}/cld2-cmake/public)
add_subdirectory(${CPPMODULE_ROOTPATH}/cld2-cmake ${CPPMODULE_BINARY_SUBDIR}/cld2-cmake)
set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} CLD2-static)
set(CPPMODULE_LINK_LIBRARIES_LIBCLD2 CLD2-static)