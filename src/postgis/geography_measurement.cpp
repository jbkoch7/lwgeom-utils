// --- Lwgeomutils Includes --- //
#include <postgis/geography.sql.h>

// --- Proj Includes --- //
#include <proj_api.h>

namespace postgis
{

////////////////////////////////////////////////////////////////////////////////
double geography_distance_uncached(
    LWGEOM* g1, LWGEOM* g2, double tolerance, bool use_spheroid )
{
    error_if_srid_mismatch( g1->srid, g2->srid );

    //Initialize spheroid
    SPHEROID s;
    //spheroid_init_from_srid(fcinfo, g1->srid, &s );

    //Set to sphere if requested
    if( !use_spheroid ) s.a = s.b = s.radius;

    //Check for empty geographies
    if( lwgeom_is_empty( g1 ) || lwgeom_is_empty( g2 ) )
    {
        throw std::runtime_error( "postgis::geography_distance_uncached: "
            "geography is empty" );
    }

    //Make sure we have boxes attached
    lwgeom_add_bbox_deep( g1, nullptr );
    lwgeom_add_bbox_deep( g2, nullptr );

    double distance = lwgeom_distance_spheroid( g1, g2, &s, tolerance );

    //Something went wrong, negative return
    if( distance < 0.0 )
    {
        throw std::runtime_error( "postgis::geography_distance: "
            "distance returned negative" );
    }

    return distance;
}
////////////////////////////////////////////////////////////////////////////////

} //postgis
