include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)
include(CheckCXXCompilerFlag)

if(NOT TARGET xsimd)
  set(BUILD_TESTS OFF CACHE BOOL "" FORCE)
  cppmodule_add_subdirectory(xsimd "${CPPMODULE_ROOTPATH}/xsimd")
endif()

if(NOT TARGET cppmodule::xsimd)
  add_library(cppmodule::xsimd INTERFACE IMPORTED GLOBAL)
  target_include_directories(cppmodule::xsimd INTERFACE
      "${CPPMODULE_ROOTPATH}/xsimd/include"
  )
  target_link_libraries(cppmodule::xsimd INTERFACE xsimd)

  # --- SIMD 架构自动适配与指令集优化 ---
  # 自动检测并启用当前架构下最佳的 SIMD 指令集 (SSE4.2, AVX, AVX2, FMA, NEON 等)
  if(MSVC)
      # MSVC 环境下，尝试开启 AVX2 (包含 AVX 和 FMA)
      # 正常情况下, x64 平台默认开启 SSE2
      check_cxx_compiler_flag("/arch:AVX2" XSIMD_HAS_AVX2)
      if(XSIMD_HAS_AVX2)
          target_compile_options(cppmodule::xsimd INTERFACE "/arch:AVX2")
      else()
          check_cxx_compiler_flag("/arch:AVX" XSIMD_HAS_AVX)
          if(XSIMD_HAS_AVX)
              target_compile_options(cppmodule::xsimd INTERFACE "/arch:AVX")
          endif()
      endif()
  else()
      # GCC / Clang 环境下
      if(NOT CMAKE_CROSSCOMPILING)
          # 非交叉编译时，优先尝试 -march=native 以获取宿主机的最佳性能
          check_cxx_compiler_flag("-march=native" XSIMD_HAS_NATIVE)
          if(XSIMD_HAS_NATIVE)
              target_compile_options(cppmodule::xsimd INTERFACE "-march=native")
          endif()
      endif()

      # 如果 native 不可用或处于交叉编译，则根据处理器手动适配常用指令集
      if(NOT XSIMD_HAS_NATIVE)
          if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|amd64|AMD64")
              check_cxx_compiler_flag("-mavx2" XSIMD_HAS_AVX2)
              if(XSIMD_HAS_AVX2)
                  target_compile_options(cppmodule::xsimd INTERFACE "-mavx2" "-mfma")
              else()
                  check_cxx_compiler_flag("-msse4.2" XSIMD_HAS_SSE42)
                  if(XSIMD_HAS_SSE42)
                      target_compile_options(cppmodule::xsimd INTERFACE "-msse4.2")
                  endif()
              endif()
          elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "arm64|aarch64|AARCH64")
              # AArch64 通常默认开启 NEON 指令集，无需额外标志
          endif()
      endif()
  endif()
endif()
