# CppModule CMake 架构脚本

[English](./README.md)

一套优雅的、面向目标（Target-Oriented）的 CMake 依赖管理系统。专为需要严格控制静态链接、依赖自动去重以及模块化架构的复杂 C++ 项目设计。

## 🚀 核心理念

*   **面向目标**: 彻底告别全局变量。每个依赖项都是一个带命名空间的目标（`cppmodule::xxx`）。
*   **静态优先**: 强制执行静态链接和静态运行时（Windows 上的 MT/MTd），确保编译产物可单文件分发。
*   **全局保护**: 所有脚本均受 `include_guard` 保护，支持在多层嵌套项目中随意引入而不会导致目标重定义。
*   **零污染**: 子库通过 `EXCLUDE_FROM_ALL` 引入，确保构建树只包含你真正用到的部分。

## 🛠 快速上手

### 1. 初始化基础配置
在主项目的 `CMakeLists.txt` 中引入核心逻辑：
```cmake
include(cmake/base.cmake)
```

### 2. 引入模块
声明依赖并进行链接。系统会自动处理头文件路径和递归依赖。
```cmake
# 声明
include(cmake/fmt.cmake)
include(cmake/JSON.cmake)

# 链接
target_link_libraries(你的目标 PRIVATE 
    cppmodule::fmt 
    cppmodule::json
)
```

## 🏗 如何扩展（封装新库）

若要封装一个新的三方库（例如 `sqlite3`），创建 `cmake/sqlite3.cmake`：

```cmake
include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

# 存在性检查与子目录添加
if(NOT TARGET sqlite3)
    # 使用宏安全添加子目录
    cppmodule_add_subdirectory(sqlite3 "${CPPMODULE_ROOTPATH}/sqlite3")
endif()

# 定义全局命名空间目标
if(NOT TARGET cppmodule::sqlite3)
    add_library(cppmodule::sqlite3 INTERFACE IMPORTED GLOBAL)
    target_link_libraries(cppmodule::sqlite3 INTERFACE sqlite3)
endif()
```

## 📐 目录结构
- `base.cmake`: 全局编译参数、强制静态运行时、核心辅助宏。
- `<module>.cmake`: 各个库的封装脚本，将子模块转换为全局接口目标。
- `third_party/`: 实际的源码存放处（通过 Git Submodules 管理）。
