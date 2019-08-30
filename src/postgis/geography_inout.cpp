// --- Lwgeomutils Includes --- //
#include <postgis/postgis.h>

// --- Proj Includes --- //
#include <proj_api.h>

namespace postgis
{

////////////////////////////////////////////////////////////////////////////////
LWGEOM* geography_from_geometry( LWGEOM* lwgeom )
{
    if( geography_valid_type( gserialized_get_type( geom ) ) )
    {
        throw std::runtime_error( "postgis::geography_from_geometry: "
            "" );
    }

    //Force default SRID
    if( lwgeom->srid <= 0 )
    {
        lwgeom->srid = SRID_DEFAULT;
    }

    //Error on any SRID != default
    //srid_is_latlong( fcinfo, lwgeom->srid );
    if( lwgeom->srid != SRID_DEFAULT )
    {
        throw std::runtime_error( "postgis::geography_from_geometry: "
            "Only lon/lat coordinate systems are supported in geography" );
    }

    //Force the geometry to have valid geodetic coordinate range
    lwgeom_nudge_geodetic( lwgeom );
    if ( lwgeom_force_geodetic( lwgeom ) == LW_TRUE )
    {
        throw std::runtime_error( "postgis::geography_from_geometry: "
            "Coordinate values were coerced into range "
            "[-180 -90, 180 90] for GEOGRAPHY" );
    }
    lwgeom_set_geodetic( lwgeom, true );

    //Force recalculate of box
    if( lwgeom->bbox )
    {
        lwgeom_refresh_bbox( lwgeom );
    }

    return lwgeom
}
////////////////////////////////////////////////////////////////////////////////

}
