set(__CPPMODULE_TEMP_BOOST_LIB__
    Boost::boost
    Boost::system Boost::atomic
    Boost::thread
    Boost::context
    Boost::coroutine
    Boost::chrono
    Boost::filesystem
    Boost::date_time
    Boost::regex
    Boost::timer
    Boost::exception
    Boost::random
    Boost::program_options
    Boost::asio
    Boost::test
    Boost::beast
)

set(Boost_USE_STATIC_LIBS ON)
set(Boost_USE_STATIC_RUNTIME ON)

if ((CPPMODULE_BOOSTCMAKE_ENABLE_ALL OR CPPMODULE_BOOSTCMAKE_ENABLE_SERIALIZATION) AND NOT CPPMODULE_BOOSTCMAKE_DISABLE_SERIALIZATION)
  set(USE_BOOST_SERIALIZATION ON)
  set(__CPPMODULE_TEMP_BOOST_LIB__ ${__CPPMODULE_TEMP_BOOST_LIB__}
      Boost::serialization
  )
endif ()

if ((CPPMODULE_BOOSTCMAKE_ENABLE_ALL OR CPPMODULE_BOOSTCMAKE_ENABLE_FIBER) AND NOT CPPMODULE_BOOSTCMAKE_DISABLE_FIBER)
  set(USE_BOOST_FIBER ON)
  set(__CPPMODULE_TEMP_BOOST_LIB__ ${__CPPMODULE_TEMP_BOOST_LIB__}
      Boost::fiber
  )
endif ()

if ((CPPMODULE_BOOSTCMAKE_ENABLE_ALL OR CPPMODULE_BOOSTCMAKE_ENABLE_LOCALE) AND NOT CPPMODULE_BOOSTCMAKE_DISABLE_LOCALE)
  set(USE_BOOST_LOCALE ON)
  set(__CPPMODULE_TEMP_BOOST_LIB__ ${__CPPMODULE_TEMP_BOOST_LIB__}
      Boost::locale
  )
endif ()

add_subdirectory(${CPPMODULE_ROOTPATH}/boost-cmake ${CPPMODULE_BINARY_SUBDIR}/boost-cmake)
target_include_directories(cmake_include_interface INTERFACE ${CPPMODULE_ROOTPATH}/boost-cmake)

set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} ${__CPPMODULE_TEMP_BOOST_LIB__})
set(CPPMODULE_LINK_LIBRARIES_BOOSTCMAKE ${__CPPMODULE_TEMP_BOOST_LIB__})