#pragma once

// --- Standard Includes --- //
#include <cstddef> // must be before extern C below

// --- Lwgeom Includes --- //
extern "C"
{
#include <liblwgeom.h>
}

// --- Lwgeomutils Includes --- //
#include <lwgeomutils_config.h>

// --- Standard Includes --- //
#include <stdexcept>
#include <string>

namespace postgis
{

///
LWGEOMUTILS_EXPORTS
LWGEOM* geography_from_geometry( LWGEOM* lwgeom );

///Returns double distance in meters
LWGEOMUTILS_EXPORTS
double geography_distance_uncached(
    LWGEOM* lwg1, LWGEOM* lwg2, double tolerance, bool use_spheroid = true );

///
LWGEOMUTILS_EXPORTS
void geography_valid_type( LWGEOM* lwgeom );

} //postgis
