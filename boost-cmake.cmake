include_guard(GLOBAL)
include(${CMAKE_CURRENT_LIST_DIR}/base.cmake)

# Boost-cmake 配置
set(Boost_USE_STATIC_LIBS ON)
set(Boost_USE_STATIC_RUNTIME ON)

# 根据用户变量配置 Boost 组件
if(CPPMODULE_BOOSTCMAKE_ENABLE_ALL)
    set(USE_BOOST_SERIALIZATION ON)
    set(USE_BOOST_FIBER ON)
    set(USE_BOOST_LOCALE ON)
endif()

if(NOT TARGET boost-cmake)
    cppmodule_add_subdirectory(boost-cmake "${CPPMODULE_ROOTPATH}/boost-cmake")
endif()

if(NOT TARGET cppmodule::boost)
    add_library(cppmodule::boost INTERFACE IMPORTED GLOBAL)
    
    # 定义基础依赖
    set(_BOOST_LIBS 
        Boost::boost Boost::system Boost::atomic Boost::thread 
        Boost::context Boost::coroutine Boost::chrono Boost::filesystem 
        Boost::date_time Boost::regex Boost::timer Boost::exception 
        Boost::random Boost::program_options Boost::asio Boost::beast
    )
    
    # 动态添加组件
    if(USE_BOOST_SERIALIZATION)
        list(APPEND _BOOST_LIBS Boost::serialization)
    endif()
    if(USE_BOOST_FIBER)
        list(APPEND _BOOST_LIBS Boost::fiber)
    endif()
    if(USE_BOOST_LOCALE)
        list(APPEND _BOOST_LIBS Boost::locale)
    endif()

    target_link_libraries(cppmodule::boost INTERFACE ${_BOOST_LIBS})
    target_include_directories(cppmodule::boost INTERFACE "${CPPMODULE_ROOTPATH}/boost-cmake")
endif()
