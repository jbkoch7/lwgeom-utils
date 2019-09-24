// --- Lwgeomutils Includes --- //
#include <postgis/geography.sql.h>

// --- Proj Includes --- //
#include <proj_api.h>

namespace postgis
{

////////////////////////////////////////////////////////////////////////////////
LWGEOM* geography_from_geometry( LWGEOM* lwgeom )
{
    lwgeom = lwgeom_clone_deep( lwgeom );

    //Check that this is a type we can handle
    geography_valid_type( lwgeom );

    //Force default SRID
    if( lwgeom->srid <= 0 )
    {
        lwgeom->srid = SRID_DEFAULT;
    }

    //Error on any SRID != default
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

    return lwgeom;
}
////////////////////////////////////////////////////////////////////////////////
void geography_valid_type( LWGEOM* lwgeom )
{
    auto type = lwgeom->type;
    if( !( type == POINTTYPE || type == MULTIPOINTTYPE ||
           type == LINETYPE || type == MULTILINETYPE ||
           type == POLYGONTYPE || type == MULTIPOLYGONTYPE ||
           type == COLLECTIONTYPE ) )
    {
        throw std::runtime_error( std::string( "postgis::geography_valid_type"
            "Geography type does not support " ) + lwtype_name( type ) );
    }
}
////////////////////////////////////////////////////////////////////////////////

} //postgis
