#---
# File: FindGEOS.cmake
#
# Find the native GEOS(Geometry Engine - Open Source) includes and libraries.
#
# This module defines:
#
# GEOS_INCLUDE_DIR, where to find geos.h, etc.
# GEOS_LIBRARY, libraries to link against to use GEOS.
# GEOS_FOUND, true if found, false if one of the above are not found.

# Find include path
find_path( GEOS_INCLUDE_DIR
  NAMES
    geos_c.h
  HINTS
    ${GEOS_DIR}/include
  PATHS
    /usr/include
    /usr/local/include )

# Set GEOS_VERSION
if( GEOS_INCLUDE_DIR )
  set( _versionFile "${GEOS_INCLUDE_DIR}/geos/version.h" )
  if( NOT EXISTS ${_versionFile} )
    message( SEND_ERROR "Can't find ${_versionFile}" )
  else()
    file( READ "${_versionFile}" _versionContents )

    string( REGEX MATCH "GEOS_VERSION_MAJOR ([0-9]*)" _ ${_versionContents} )
    set( GEOS_VERSION_MAJOR ${CMAKE_MATCH_1} )

    string( REGEX MATCH "GEOS_VERSION_MINOR ([0-9]*)" _ ${_versionContents} )
    set( GEOS_VERSION_MINOR ${CMAKE_MATCH_1} )

    string( REGEX MATCH "GEOS_VERSION_PATCH ([0-9]*)" _ ${_versionContents} )
    set( GEOS_VERSION_MICRO ${CMAKE_MATCH_1} )

    set( GEOS_VERSION
      "${GEOS_VERSION_MAJOR}.${GEOS_VERSION_MINOR}.${GEOS_VERSION_MICRO}" )
  endif()
endif()

# Support preference of static libs
if( GEOS_USE_STATIC_LIBS )
  set( CMAKE_FIND_LIBRARY_PREFIXES_ORIG "${CMAKE_FIND_LIBRARY_PREFIXES}" )
  set( CMAKE_FIND_LIBRARY_SUFFIXES_ORIG "${CMAKE_FIND_LIBRARY_SUFFIXES}" )
  if( WIN32 )
    set( CMAKE_FIND_LIBRARY_PREFIXES lib )
  else()
    set( CMAKE_FIND_LIBRARY_SUFFIXES .a )
  endif()
endif()

# If the user changed static libs preference, flush previous results
if( NOT GEOS_USE_STATIC_LIBS STREQUAL GEOS_USE_STATIC_LIBS_LAST )
  unset( GEOS_LIB CACHE )
  unset( GEOS_C_LIB CACHE )
  unset( GEOS_LIBRARY CACHE )
endif()

# Find GEOS C library
find_library( GEOS_C_LIB
  NAMES geos_c
  HINTS
    ${GEOS_DIR}/lib
  PATHS
    /usr/lib64
    /usr/lib
    /usr/local/lib )

# Find GEOS library
find_library( GEOS_LIB
  NAMES geos
  HINTS
    ${GEOS_DIR}/lib
  PATHS
    /usr/lib64
    /usr/lib
    /usr/local/lib )

# Set the GEOS_LIBRARY
if( GEOS_C_LIB AND GEOS_LIB )
  set( GEOS_LIBRARY ${GEOS_C_LIB} ${GEOS_LIB} CACHE LIST INTERNAL )
endif()

# Restore the original find library ordering
if( GEOS_USE_STATIC_LIBS )
  set( CMAKE_FIND_LIBRARY_PREFIXES "${CMAKE_FIND_LIBRARY_PREFIXES_ORIG}" )
  set( CMAKE_FIND_LIBRARY_SUFFIXES "${CMAKE_FIND_LIBRARY_SUFFIXES_ORIG}" )
endif()

# Set GEOS_FOUND if variables are valid
include( FindPackageHandleStandardArgs )
find_package_handle_standard_args( GEOS
  FOUND_VAR GEOS_FOUND
  REQUIRED_VARS GEOS_LIBRARY GEOS_INCLUDE_DIR
  VERSION_VAR GEOS_VERSION )

if( GEOS_FOUND )
  if( NOT GEOS_FIND_QUIETLY )
    message( STATUS "Found GEOS..." )
  endif()
else()
  if( NOT GEOS_FIND_QUIETLY )
    message( WARNING "Could not find GEOS" )
  endif()
endif()

if( NOT GEOS_FIND_QUIETLY )
  message( STATUS "GEOS_INCLUDE_DIR=${GEOS_INCLUDE_DIR}" )
  message( STATUS "GEOS_LIBRARY=${GEOS_LIBRARY}" )
endif()

# Record last used values of input variables
if( DEFINED GEOS_USE_STATIC_LIBS )
  set( GEOS_USE_STATIC_LIBS_LAST "${GEOS_USE_STATIC_LIBS}"
    CACHE INTERNAL "Last used GEOS_USE_STATIC_LIBS value.")
else()
  unset( GEOS_USE_STATIC_LIBS_LAST CACHE )
endif()
