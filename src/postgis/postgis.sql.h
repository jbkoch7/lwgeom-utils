#pragma once

// --- Standard Includes --- //
#include <cstddef> // must be before extern C below

// --- Lwgeom Includes --- //
extern "C"
{
#include <liblwgeom.h>
#include <lwgeom_geos.h>
#include <lwgeom_log.h>
}

// --- Lwgeomutils Includes --- //
#include <lwgeomutils_config.h>

// --- Standard Includes --- //
#include <stdexcept>
#include <string>

namespace postgis
{

///
struct valid_detail
{
    bool valid;
    std::string reason;
    std::string location;
};

/// postgis/lwgeom_functions_basic.c
LWGEOMUTILS_EXPORTS
LWGEOM* collectionextract( LWGEOM* lwgeom, int type );

/// postgis/lwgeom_geos.c
LWGEOMUTILS_EXPORTS
valid_detail isvaliddetail( LWGEOM* lwgeom, int flags = 0 );

///
LWGEOMUTILS_EXPORTS
LWGEOM* segmentize( LWGEOM* lwgeom, double max_segment_length );

/// postgis/lwgeom_transform.c
LWGEOMUTILS_EXPORTS
LWGEOM* transform( LWGEOM* lwgeom, int srid );

} //postgis
