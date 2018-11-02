#---
# File: FindJSONC.cmake
#
# Find the native JSON-C includes and libraries.
#
# This module defines:
#
# JSON_C_INCLUDE_DIR, where to find json-c/json.h, etc.
# JSON_C_LIBRARY, libraries to link against to use JSON-C.
# JSON_C_FOUND, true if found, false if one of the above are not found.

# Find include path
find_path( JSON_C_INCLUDE_DIR
  NAMES
    json-c/json.h
  HINTS
    ${JSON_C_DIR}/include
  PATHS
    /usr/include
    /usr/local/include )

  # Set JSON_C_VERSION
if( JSON_C_INCLUDE_DIR )
  set( _versionFile "${JSON_C_INCLUDE_DIR}/json-c/json_c_version.h" )
  if( NOT EXISTS ${_versionFile} )
    message( SEND_ERROR "Can't find ${_versionFile}" )
  else()
    file( READ "${_versionFile}" _versionContents )

    string( REGEX MATCH "JSON_C_MAJOR_VERSION ([0-9]*)" _ ${_versionContents} )
    set( JSON_C_VERSION_MAJOR ${CMAKE_MATCH_1} )

    string( REGEX MATCH "JSON_C_MINOR_VERSION ([0-9]*)" _ ${_versionContents} )
    set( JSON_C_VERSION_MINOR ${CMAKE_MATCH_1} )

    string( REGEX MATCH "JSON_C_MICRO_VERSION ([0-9]*)" _ ${_versionContents} )
    set( JSON_C_VERSION_MICRO ${CMAKE_MATCH_1} )

    set( JSON_C_VERSION
      "${JSON_C_VERSION_MAJOR}.${JSON_C_VERSION_MINOR}.${JSON_C_VERSION_MICRO}" )
  endif()
endif()

# Support preference of static libs
if( JSON_C_USE_STATIC_LIBS )
  set( CMAKE_FIND_LIBRARY_SUFFIXES_ORIG "${CMAKE_FIND_LIBRARY_SUFFIXES}" )
  if( WIN32 )
    set( CMAKE_FIND_LIBRARY_SUFFIXES -static.lib )
  else()
    set( CMAKE_FIND_LIBRARY_SUFFIXES .a )
  endif()
endif()

# If the user changed static libs preference, flush previous results
if( NOT JSON_C_USE_STATIC_LIBS STREQUAL JSON_C_USE_STATIC_LIBS_LAST )
  unset( JSON_C_LIBRARY CACHE )
endif()

# Find JSON-C library
find_library( JSON_C_LIBRARY
  NAMES json-c
  HINTS
    ${JSON_C_DIR}/lib
  PATHS
    /usr/lib64
    /usr/lib
    /usr/local/lib )

# Restore the original find library ordering
if( JSON_C_USE_STATIC_LIBS )
  set( CMAKE_FIND_LIBRARY_SUFFIXES "${CMAKE_FIND_LIBRARY_SUFFIXES_ORIG}" )
endif()

# Set JSON_C_FOUND if variables are valid
include( FindPackageHandleStandardArgs )
find_package_handle_standard_args( JSON_C
  FOUND_VAR JSON_C_FOUND
  REQUIRED_VARS JSON_C_LIBRARY JSON_C_INCLUDE_DIR
  VERSION_VAR JSON_C_VERSION )

if( JSON_C_FOUND )
  if( NOT JSON_C_FIND_QUIETLY )
    message( STATUS "Found JSON_C..." )
  endif()
else()
  if( NOT JSON_C_FIND_QUIETLY )
    message( WARNING "Could not find JSON_C" )
  endif()
endif()

if( NOT JSON_C_FIND_QUIETLY )
  message( STATUS "JSON_C_INCLUDE_DIR=${JSON_C_INCLUDE_DIR}" )
  message( STATUS "JSON_C_LIBRARY=${JSON_C_LIBRARY}" )
endif()

# Record last used values of input variables
if( DEFINED JSON_C_USE_STATIC_LIBS )
  set( JSON_C_USE_STATIC_LIBS_LAST "${JSON_C_USE_STATIC_LIBS}"
    CACHE INTERNAL "Last used JSON_C_USE_STATIC_LIBS value.")
else()
  unset( JSON_C_USE_STATIC_LIBS_LAST CACHE )
endif()
