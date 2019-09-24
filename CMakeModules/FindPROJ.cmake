#---
# File: FindPROJ.cmake
#
# Find the native PROJ includes and libraries.
#
# This module defines:
#
# PROJ_INCLUDE_DIR, where to find proj_api.h, etc.
# PROJ_LIBRARY, libraries to link against to use PROJ.
# PROJ_FOUND, true if found, false if one of the above are not found.

# Find include path
find_path( PROJ_INCLUDE_DIR
  NAMES
    proj_api.h
  HINTS
    ${PROJ_DIR}/include
  PATHS
    /usr/include
    /usr/local/include
    /opt/local/include
    /sw/include
  PATH_SUFFIXES
    proj4 )

# Set PROJ_VERSION
if( PROJ_INCLUDE_DIR )
  set( _versionFile "${PROJ_INCLUDE_DIR}/proj_api.h" )
  if( NOT EXISTS ${_versionFile} )
    message( SEND_ERROR "Can't find ${_versionFile}" )
  else()
    file( READ "${_versionFile}" _versionContents )

    string( REGEX MATCH "PJ_VERSION ([0-9])([0-9])([0-9])" _ ${_versionContents} )
    set( PROJ_VERSION_MAJOR ${CMAKE_MATCH_1} )
    set( PROJ_VERSION_MINOR ${CMAKE_MATCH_2} )
    set( PROJ_VERSION_MICRO ${CMAKE_MATCH_3} )

    set( PROJ_VERSION
      "${PROJ_VERSION_MAJOR}.${PROJ_VERSION_MINOR}.${PROJ_VERSION_MICRO}" )
  endif()
endif()

# Support preference of static libs
set( CMAKE_FIND_LIBRARY_SUFFIXES_ORIG "${CMAKE_FIND_LIBRARY_SUFFIXES}" )
if( PROJ_USE_STATIC_LIBS )
  if( NOT WIN32 )
    set( CMAKE_FIND_LIBRARY_SUFFIXES .a )
  endif()
endif()

# If the user changed static libs preference, flush previous results
if( NOT PROJ_USE_STATIC_LIBS STREQUAL PROJ_USE_STATIC_LIBS_LAST )
  unset( PROJ_LIBRARY CACHE )
endif()

# Find PROJ library
find_library( PROJ_LIBRARY
  NAMES
    proj
    proj_${PROJ_VERSION_MAJOR}_${PROJ_VERSION_MINOR}
  HINTS
    ${PROJ_DIR}/lib
  PATHS
    /usr/lib
    /usr/local/lib
    /opt/local/lib
    /sw/lib )

# Restore the original find library ordering
set( CMAKE_FIND_LIBRARY_SUFFIXES "${CMAKE_FIND_LIBRARY_SUFFIXES_ORIG}" )

# Set PROJ_FOUND if variables are valid
include( FindPackageHandleStandardArgs )
find_package_handle_standard_args( PROJ
  FOUND_VAR PROJ_FOUND
  REQUIRED_VARS PROJ_LIBRARY PROJ_INCLUDE_DIR
  VERSION_VAR PROJ_VERSION )

if( PROJ_FOUND )
  if( NOT PROJ_FIND_QUIETLY )
    message( STATUS "Found PROJ..." )
   endif()
else()
  if( NOT PROJ_FIND_QUIETLY )
    message( WARNING "Could not find PROJ" )
   endif()
endif()

if( NOT PROJ_FIND_QUIETLY )
  message( STATUS "PROJ_INCLUDE_DIR=${PROJ_INCLUDE_DIR}" )
  message( STATUS "PROJ_LIBRARY=${PROJ_LIBRARY}" )
endif()

# Record last used values of input variables
if( DEFINED PROJ_USE_STATIC_LIBS )
  set( PROJ_USE_STATIC_LIBS_LAST "${PROJ_USE_STATIC_LIBS}"
    CACHE INTERNAL "Last used PROJ_USE_STATIC_LIBS value.")
else()
  unset( PROJ_USE_STATIC_LIBS_LAST CACHE )
endif()
