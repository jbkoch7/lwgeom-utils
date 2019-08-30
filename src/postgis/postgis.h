#pragma once

// --- Lwgeom Includes --- //
extern "C"
{
#include <liblwgeom.h>
}

// --- Lwgeomutils Includes --- //
#include <lwgeomutils_config.h>

// --- Standard Includes --- //
#include <string>

namespace postgis
{

///st_transform
LWGEOMUTILS_EXPORTS
LWGEOM* transform( LWGEOM* lwgeom, int srid, bool clone = true );

///st_transform
LWGEOMUTILS_EXPORTS
LWGEOM* geography_from_geometry( LWGEOM* lwgeom );

} //postgis
