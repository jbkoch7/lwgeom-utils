
if( JSON_C_FOUND )
  set( TARGET_VERSION ${${CMAKE_PROJECT_NAME}_VERSION} )
  set( TARGET_EXPORT ${CMAKE_PROJECT_NAME}Targets )
  set( TARGET_NAME make_valid )
  set( TARGET_CATEGORY Test )
  set( TARGET_LANGUAGE CXX )

  add_executable( ${TARGET_NAME} ${TARGET_NAME}.cpp )
  target_include_directories( ${TARGET_NAME} PUBLIC
    ${LWGEOM_INCLUDE_DIR}
    ${GEOS_INCLUDE_DIR}
    ${PROJ_INCLUDE_DIR}
    ${JSON_C_INCLUDE_DIR} )
  target_link_libraries( ${TARGET_NAME}
    ${LWGEOM_LIBRARY}
    ${GEOS_LIBRARY}
    ${PROJ_LIBRARY}
    ${JSON_C_LIBRARY} )

  include( ModuleInstall )
endif()

if( JSON_C_FOUND )
  set( TARGET_VERSION ${${CMAKE_PROJECT_NAME}_VERSION} )
  set( TARGET_EXPORT ${CMAKE_PROJECT_NAME}Targets )
  set( TARGET_NAME segmentize )
  set( TARGET_CATEGORY Test )
  set( TARGET_LANGUAGE CXX )

  add_executable( ${TARGET_NAME} ${TARGET_NAME}.cpp )
  target_include_directories( ${TARGET_NAME} PUBLIC
    ${LWGEOM_INCLUDE_DIR}
    ${GEOS_INCLUDE_DIR}
    ${PROJ_INCLUDE_DIR}
    ${JSON_C_INCLUDE_DIR} )
  target_link_libraries( ${TARGET_NAME}
    ${LWGEOM_LIBRARY}
    ${GEOS_LIBRARY}
    ${PROJ_LIBRARY}
    ${JSON_C_LIBRARY} )

  include( ModuleInstall )
endif()

if( JSON_C_FOUND )
  set( TARGET_VERSION ${${CMAKE_PROJECT_NAME}_VERSION} )
  set( TARGET_EXPORT ${CMAKE_PROJECT_NAME}Targets )
  set( TARGET_NAME fixup )
  set( TARGET_CATEGORY Test )
  set( TARGET_LANGUAGE CXX )

  add_executable( ${TARGET_NAME} ${TARGET_NAME}.cpp )
  target_include_directories( ${TARGET_NAME} PUBLIC
    ${CMAKE_SOURCE_DIR}/src
    ${LWGEOM_INCLUDE_DIR}
    ${GEOS_INCLUDE_DIR}
    ${PROJ_INCLUDE_DIR}
    ${JSON_C_INCLUDE_DIR} )
  target_link_libraries( ${TARGET_NAME}
    postgis
    ${LWGEOM_LIBRARY}
    ${GEOS_LIBRARY}
    ${PROJ_LIBRARY}
    ${JSON_C_LIBRARY} )

  include( ModuleInstall )
endif()
