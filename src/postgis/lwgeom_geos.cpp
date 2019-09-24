// --- Lwgeomutils Includes --- //
#include <postgis/postgis.sql.h>

// --- Proj Includes --- //
#include <proj_api.h>

namespace postgis
{

////////////////////////////////////////////////////////////////////////////////
valid_detail isvaliddetail( LWGEOM* lwgeom, int flags )
{
    char* values[ 3 ]; /* valid bool, reason text, location geometry */
    char* geos_reason = nullptr;
    std::string reason;
    GEOSGeometry* geos_location = nullptr;
    LWGEOM* location = nullptr;
    char valid = 0;

    auto lwpgnotice = []( const char* fmt, ... ){};
    initGEOS( lwpgnotice, lwgeom_geos_error );

    GEOSGeometry const* g1 = LWGEOM2GEOS( lwgeom, 0 );
    if( g1 )
    {
        valid = GEOSisValidDetail( g1, flags, &geos_reason, &geos_location );
        GEOSGeom_destroy( (GEOSGeometry*)g1 );
        if( geos_reason )
        {
            reason = geos_reason;
            GEOSFree( geos_reason );
        }
        if( geos_location )
        {
            location = GEOS2LWGEOM( geos_location, GEOSHasZ( geos_location ) );
            GEOSGeom_destroy( geos_location );
        }

        if( valid == 2 )
        {
            throw std::runtime_error( "postgis::isvaliddetail: "
                "GEOS isvaliddetail() threw an exception!" );
        }
    }
    else
    {
        reason = lwgeom_geos_errmsg;
    }

    /* the boolean validity */
    values[0] =  valid ? "t" : "f";

    /* the reason */
    values[1] =  reason;

    /* the location */
    values[2] =  location ? lwgeom_to_hexwkb(location, WKB_EXTENDED, 0) : 0;

    tuple = BuildTupleFromCStrings(attinmeta, values);
    result = (HeapTupleHeader) palloc(tuple->t_len);
    memcpy(result, tuple->t_data, tuple->t_len);
    heap_freetuple(tuple);

    PG_RETURN_HEAPTUPLEHEADER(result);
}
////////////////////////////////////////////////////////////////////////////////

}
