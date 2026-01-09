include_guard(GLOBAL)

# --- 全局静态编译约束 ---
set(BUILD_SHARED_LIBS OFF CACHE BOOL "Force static linking" FORCE)

if(MSVC)
    # 强制所有依赖使用静态运行时库 (/MT 或 /MTd)
    # 这样可以保证生成的 .exe 不依赖 msvcp140.dll 等
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING "" FORCE)
    add_compile_options("/utf-8")
else()
    add_compile_options("-finput-charset=UTF-8" "-fexec-charset=UTF-8")
endif()

# --- 路径探测逻辑 ---
# 自动定位 third_party 目录，支持多级嵌套项目
if(NOT CPPMODULE_ROOTPATH)
    if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/../third_party")
        set(CPPMODULE_ROOTPATH "${CMAKE_CURRENT_LIST_DIR}/../third_party" CACHE PATH "Path to third_party")
    elseif(EXISTS "${CMAKE_SOURCE_DIR}/third_party")
        set(CPPMODULE_ROOTPATH "${CMAKE_SOURCE_DIR}/third_party" CACHE PATH "Path to third_party")
    endif()
endif()

message(STATUS "[CppModule] RootPath: ${CPPMODULE_ROOTPATH}")

# --- 辅助宏 ---

# 保护性添加子目录 (防止重复 add_subdirectory 导致的报错)
macro(cppmodule_add_subdirectory NAME PATH)
    if(NOT TARGET ${NAME})
        if(EXISTS "${PATH}/CMakeLists.txt")

            add_subdirectory("${PATH}" "${CMAKE_BINARY_DIR}/_deps/${NAME}-build" )
        else()
            message(WARNING "[CppModule] ${NAME} not found at ${PATH}")
        endif()
    endif()
endmacro()

# 基础接口 Target，所有项目都应链接此目标以获得全局宏定义
if(NOT TARGET cppmodule::base)
    add_library(cppmodule::base INTERFACE IMPORTED GLOBAL)
    target_compile_definitions(cppmodule::base INTERFACE 
        -DCPPMODULE_PROJECT_ROOT_PATH="${CMAKE_CURRENT_SOURCE_DIR}"
        $<$<PLATFORM_ID:Windows>:_HOST_WINDOWS_>
        $<$<PLATFORM_ID:Linux>:_HOST_LINUX_>
        $<$<PLATFORM_ID:Android>:_HOST_ANDROID_>
        $<$<PLATFORM_ID:Darwin>:_HOST_APPLE_>
    )
endif()