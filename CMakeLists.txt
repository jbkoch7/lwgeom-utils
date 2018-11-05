
cmake_minimum_required( VERSION 3.0.0 )
project( lwgeom-utils )

set( LWGEOMUTILS_MAJOR_VERSION 0 )
set( LWGEOMUTILS_MINOR_VERSION 1 )
set( LWGEOMUTILS_MICRO_VERSION 0 )
string( CONCAT LWGEOMUTILS_VERSION
  "${LWGEOMUTILS_MAJOR_VERSION}."
  "${LWGEOMUTILS_MINOR_VERSION}."
  "${LWGEOMUTILS_MICRO_VERSION}" )
message( STATUS "Configuring ${CMAKE_PROJECT_NAME}: v${v}\n" )

set( CMAKE_CXX_STANDARD 11 )
set( CMAKE_CXX_STANDARD_REQUIRED ON )
set( CMAKE_CXX_EXTENSIONS OFF )

set( INSTALL_LIBDIR lib )
set( INSTALL_BINDIR bin )
set( INSTALL_INCDIR include )
set( INSTALL_SHRDIR share )

if( WIN32 )
  string( REGEX REPLACE "(^| )[/-]D *NDEBUG($| )" " "
    CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}" )
  string( REGEX REPLACE "(^| )[/-]D *NDEBUG($| )" " "
    CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}" )

  if( MSVC )
    if( ${CMAKE_GENERATOR} MATCHES "Win64" )
      set( VC_PLATFORM "x64" )
    else()
      set( VC_PLATFORM "Win32" )
    endif()
    message( STATUS "VC++ Platform: ${VC_PLATFORM}\n" )
  endif()
endif()

# Set a default build type if none was specified
if( NOT WIN32 AND NOT CMAKE_BUILD_TYPE )
  set( CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Set build type" FORCE )
endif()

# Update cmake module path
set( CMAKE_MODULE_PATH
  "${PROJECT_SOURCE_DIR}/CMakeModules" ${CMAKE_MODULE_PATH} )

# LWGEOM
set( LWGEOM_DIR CACHE PATH "Location of LWGEOM installation" )
find_package( LWGEOM 2.5 REQUIRED )

#set( GDAL_DIR CACHE PATH "Location of GDAL installation" )

# GEOS
set( GEOS_DIR CACHE PATH "Location of GEOS installation" )
find_package( GEOS 3.5 REQUIRED )
set( POSTGIS_GEOS_VERSION "${GEOS_VERSION_MAJOR}${GEOS_VERSION_MINOR}" )

# PROJ
set( PROJ_DIR CACHE PATH "Location of PROJ installation" )
find_package( PROJ 4.9 REQUIRED )

# JSON-C
set( JSON_C_DIR CACHE PATH "Location of JSON-C installation" )
find_package( JSONC 0.13 )

# Configure files
#configure_file( ${PROJECT_SOURCE_DIR}/src/lwgeomutils_config.h.in
  #${PROJECT_SOURCE_DIR}/src/lwgeomutils_config.h @ONLY )

#add_subdirectory( src )
add_subdirectory( apps )
