include_guard(GLOBAL)

# --- 静态编译约束 ---
# 依赖子树默认静态；宿主已显式设置 BUILD_SHARED_LIBS 时不覆盖。
if(NOT DEFINED BUILD_SHARED_LIBS)
    set(BUILD_SHARED_LIBS OFF CACHE BOOL "Default static linking")
endif()

if(MSVC)
    set(CMAKE_POLICY_DEFAULT_CMP0091 NEW)
    # 依赖子树默认静态 CRT；宿主已设置不同值时沿用宿主并给出诊断。
    set(_cppmodule_msvc_rt "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    if(NOT DEFINED CMAKE_MSVC_RUNTIME_LIBRARY)
        set(CMAKE_MSVC_RUNTIME_LIBRARY "${_cppmodule_msvc_rt}")
    elseif(NOT CMAKE_MSVC_RUNTIME_LIBRARY STREQUAL "${_cppmodule_msvc_rt}")
        message(WARNING "[CppModule] host CMAKE_MSVC_RUNTIME_LIBRARY='${CMAKE_MSVC_RUNTIME_LIBRARY}' differs from the HIY-UI static CRT policy '${_cppmodule_msvc_rt}'; the HIY-UI subtree keeps the host setting")
    endif()
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

            add_subdirectory("${PATH}" "${CMAKE_CURRENT_BINARY_DIR}/_deps/${NAME}-build" )
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
        $<$<BOOL:${EMSCRIPTEN}>:_HOST_EMSCRIPTEN_>
        $<$<STREQUAL:${CMAKE_SYSTEM_NAME},iOS>:_HOST_IOS_>
    )
endif()
