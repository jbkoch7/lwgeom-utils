#---
# File: FindLWGEOM.cmake
#
# Find the native LWGEOM(Lightweight Geometry) includes and libraries.
#
# This module defines:
#
# LWGEOM_INCLUDE_DIR, where to find liblwgeom.h, etc.
# LWGEOM_LIBRARY, libraries to link against to use LWGEOM.
# LWGEOM_FOUND, true if found, false if one of the above are not found.

# Find include path
find_path( LWGEOM_INCLUDE_DIR
  NAMES
    liblwgeom.h
  HINTS
  ${LWGEOM_DIR}/include
  PATHS
    /usr/include
    /usr/local/include
    /opt/local/include
    /sw/include
  PATH_SUFFIXES
    liblwgeom )

# Set LWGEOM_VERSION
if( LWGEOM_INCLUDE_DIR )
  set( _versionFile "${LWGEOM_INCLUDE_DIR}/liblwgeom.h" )
  if( NOT EXISTS ${_versionFile} )
    message( SEND_ERROR "Can't find ${_versionFile}" )
  else()
    file( READ "${_versionFile}" _versionContents )

    string( REGEX MATCH
      "LIBLWGEOM_VERSION_MAJOR \"([0-9]*)\"" _ ${_versionContents} )
    set( LWGEOM_VERSION_MAJOR ${CMAKE_MATCH_1} )

    string( REGEX MATCH
      "LIBLWGEOM_VERSION_MINOR \"([0-9]*)\"" _ ${_versionContents} )
    set( LWGEOM_VERSION_MINOR ${CMAKE_MATCH_1} )

    string( REGEX MATCH
      "LIBLWGEOM_VERSION \"([0-9\\.]*)\"" _ ${_versionContents} )
    set( LWGEOM_VERSION ${CMAKE_MATCH_1} )
  endif()
endif()

# Support preference of static libs
if( LWGEOM_USE_STATIC_LIBS )
  set( CMAKE_FIND_LIBRARY_PREFIXES_ORIG "${CMAKE_FIND_LIBRARY_PREFIXES}" )
  set( CMAKE_FIND_LIBRARY_SUFFIXES_ORIG "${CMAKE_FIND_LIBRARY_SUFFIXES}" )
  if( WIN32 )
    #set( CMAKE_FIND_LIBRARY_PREFIXES lib )
  else()
    set( CMAKE_FIND_LIBRARY_SUFFIXES .a )
  endif()
endif()

# If the user changed static libs preference, flush previous results
if( NOT LWGEOM_USE_STATIC_LIBS STREQUAL LWGEOM_USE_STATIC_LIBS_LAST )
  unset( LWGEOM_LIB CACHE )
  unset( LWGEOM_C_LIB CACHE )
  unset( LWGEOM_LIBRARY CACHE )
endif()

# Find LWGEOM library
find_library( LWGEOM_LIBRARY
  NAMES liblwgeom
  HINTS
  ${LWGEOM_DIR}/lib
  PATHS
    /usr/lib
    /usr/local/lib
    /opt/local/lib
    /sw/lib )

# Restore the original find library ordering
if( LWGEOM_USE_STATIC_LIBS )
  set( CMAKE_FIND_LIBRARY_PREFIXES "${CMAKE_FIND_LIBRARY_PREFIXES_ORIG}" )
  set( CMAKE_FIND_LIBRARY_SUFFIXES "${CMAKE_FIND_LIBRARY_SUFFIXES_ORIG}" )
endif()

# Set LWGEOM_FOUND if variables are valid
include( FindPackageHandleStandardArgs )
find_package_handle_standard_args( LWGEOM
  DEFAULT_MSG LWGEOM_LIBRARY LWGEOM_INCLUDE_DIR )

if( LWGEOM_FOUND )
  if( NOT LWGEOM_FIND_QUIETLY )
    message( STATUS "Found LWGEOM..." )
  endif()
else()
  if( NOT LWGEOM_FIND_QUIETLY )
    message( WARNING "Could not find LWGEOM" )
  endif()
endif()

if( NOT LWGEOM_FIND_QUIETLY )
  message( STATUS "LWGEOM_INCLUDE_DIR=${LWGEOM_INCLUDE_DIR}" )
  message( STATUS "LWGEOM_LIBRARY=${LWGEOM_LIBRARY}" )
endif()

# Record last used values of input variables
if( DEFINED LWGEOM_USE_STATIC_LIBS )
  set( LWGEOM_USE_STATIC_LIBS_LAST "${LWGEOM_USE_STATIC_LIBS}"
    CACHE INTERNAL "Last used LWGEOM_USE_STATIC_LIBS value.")
else()
  unset( LWGEOM_USE_STATIC_LIBS_LAST CACHE )
endif()
