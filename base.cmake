add_library(cmake_include_interface INTERFACE)

set(CPPMODULE_ROOTPATH ${CMAKE_CURRENT_LIST_DIR}/../third_party  CACHE INTERNAL "CPPMODULE_ROOTPATH")

set(CPPMODULE_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})
message("CPPMODULE_ROOTPATH=${CPPMODULE_ROOTPATH}")

message("Check Variables")
if (CPPMODULE_BINARY_DIR)
  message("CPPMODULE_BINARY_DIR=${CPPMODULE_BINARY_DIR}")
  set(CPPMODULE_BINARY_SUBDIR ${CPPMODULE_BINARY_DIR}/CPPMODULE_BIN)
else ()
  message(FATAL_ERROR "CPPMODULE_BINARY_DIR is not defined. Please define it.
Example:
set(CPPMODULE_BINARY_DIR \${CMAKE_CURRENT_BINARY_DIR})")
endif ()

if (MSVC)
  #  add_compile_options(/source-charset:utf-8 /execution-charset:utf-8)
#  add_compile_options(/utf-8)
#  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /utf-8"  CACHE INTERNAL "cmake c flags")
#  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /utf-8" CACHE INTERNAL "cmake cxx flags")
  target_compile_options(cmake_include_interface INTERFACE /utf-8 )
else ()
  target_compile_options(cmake_include_interface INTERFACE -finput-charset=UTF-8 -fexec-charset=UTF-8)
#  add_compile_options(-finput-charset=UTF-8 -fexec-charset=UTF-8)
endif ()

if (MSVC)

  set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} /NODEFAULTLIB:msvcrt.lib")
  set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} legacy_stdio_definitions.lib)

  #  set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /NODEFAULTLIB:msvcrt.lib")
endif ()

# =========

set(CPPMODULE_LINK_ALL_LIBRARIES "")
set(CPPMODULE_LINK_SOURCES "")

if (CMAKE_SYSTEM_NAME STREQUAL "Android")
  set(OS_IS_ANDROID TRUE)
  target_compile_definitions(cmake_include_interface INTERFACE -D_HOST_ANDROID_)
elseif ((CMAKE_HOST_SYSTEM_NAME MATCHES "Darwin"))
  set(OS_IS_APPLE TRUE  CACHE INTERNAL "System Type")
  target_compile_definitions(cmake_include_interface INTERFACE -D_HOST_APPLE_)
elseif (CMAKE_HOST_WIN32)
  set(OS_IS_WINDOWS TRUECACHE  CACHE INTERNAL "System Type")
  target_compile_definitions(cmake_include_interface INTERFACE -D_HOST_WINDOWS_)
  if ()
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
  endif ()
elseif (CMAKE_HOST_UNIX)
  set(OS_IS_LINUX TRUECACHE  CACHE INTERNAL "System Type")
  target_compile_definitions(cmake_include_interface INTERFACE -D_HOST_LINUX_)
else ()
  message(FATAL_ERROR "The platform is not currently supported")
endif ()

target_compile_definitions(cmake_include_interface INTERFACE -DCPPMODULE_PROJECT_ROOT_PATH=\"${CMAKE_CURRENT_SOURCE_DIR}\")
set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} cmake_include_interface)
set(CPPMODULE_LINK_LIBRARIES_BASE cmake_include_interface)
