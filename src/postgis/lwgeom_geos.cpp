// --- Lwgeomutils Includes --- //
#include <postgis/postgis.sql.h>

// --- Proj Includes --- //
#include <proj_api.h>

namespace postgis
{

////////////////////////////////////////////////////////////////////////////////
valid_detail isvaliddetail( LWGEOM* lwgeom, int flags )
{
    valid_detail values = { false };

    initGEOS( lwnotice, lwgeom_geos_error );

    GEOSGeometry const* g1 = LWGEOM2GEOS( lwgeom, 0 );
    if( g1 )
    {
        char* geos_reason = nullptr;
        GEOSGeometry* geos_location = nullptr;
        char val = GEOSisValidDetail( g1, flags, &geos_reason, &geos_location );
        GEOSGeom_destroy( (GEOSGeometry*)g1 );
        if( geos_reason )
        {
            values.reason = geos_reason;
            GEOSFree( geos_reason );
        }
        if( geos_location )
        {
            LWGEOM* location =
                GEOS2LWGEOM( geos_location, GEOSHasZ( geos_location ) );
            if( location ) values.location = lwgeom_to_ewkt( location );
            GEOSGeom_destroy( geos_location );
            lwfree( location );
        }

        if( val == 2 )
        {
            throw std::runtime_error( "postgis::isvaliddetail: "
                "GEOS isvaliddetail() threw an exception!" );
        }
        else
        {
            values.valid = ( val == 1 ) ? true : false;
        }
    }
    else
    {
        values.reason = lwgeom_geos_errmsg;
    }

    return values;
}
////////////////////////////////////////////////////////////////////////////////

}
