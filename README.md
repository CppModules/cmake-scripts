# CppModule CMake Infrastructure

[简体中文](./README_zh.md)

An elegant, target-oriented CMake dependency management system. Designed for complex C++ projects that require absolute control over static linking, dependency deduplication, and modular architecture.

## 🚀 Key Philosophy

*   **Target-Oriented**: Forget about global variables. Every dependency is a namespaced target (`cppmodule::xxx`).
*   **Static-First**: Hardcoded for static linking and static runtimes (MT/MTd on Windows) to ensure single-binary distribution.
*   **Include-Guard Protected**: Safe to include anywhere, at any level, without fearing target redefinition.
*   **Zero Pollution**: Sub-libraries are added with `EXCLUDE_FROM_ALL`, keeping your build tree clean.

## 🛠 Quick Start

### 1. Initialize Base
Include the core logic in your main `CMakeLists.txt`:
```cmake
include(cmake/base.cmake)
```

### 2. Use a Module
Declare the dependency and link it. The system handles include paths and recursive dependencies automatically.
```cmake
# Declare
include(cmake/fmt.cmake)
include(cmake/JSON.cmake)

# Link
target_link_libraries(your_app PRIVATE 
    cppmodule::fmt 
    cppmodule::json
)
```

## 🏗 How to Extend (Add New Library)

To encapsulate a new library (e.g., `sqlite3`), create `cmake/sqlite3.cmake`:

```cmake
include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

# 1. Protection & Subdirectory
if(NOT TARGET sqlite3)
    cppmodule_add_subdirectory(sqlite3 "${CPPMODULE_ROOTPATH}/sqlite3")
endif()

# 2. Namespaced Export
if(NOT TARGET cppmodule::sqlite3)
    add_library(cppmodule::sqlite3 INTERFACE IMPORTED GLOBAL)
    target_link_libraries(cppmodule::sqlite3 INTERFACE sqlite3)
endif()
```

## 📐 Architecture
- `base.cmake`: Global compiler flags, static runtime enforcement, and utility macros.
- `<module>.cmake`: Individual wrappers that convert submodules into global interface targets.
- `third_party/`: The actual source code (managed via Git Submodules).