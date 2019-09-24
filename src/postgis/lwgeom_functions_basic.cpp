// --- Lwgeomutils Includes --- //
#include <postgis/postgis.sql.h>

// --- Proj Includes --- //
#include <proj_api.h>

namespace postgis
{

////////////////////////////////////////////////////////////////////////////////
LWGEOM* collectionextract( LWGEOM* lwgeom, int type )
{
    lwgeom = lwgeom_clone_deep( lwgeom );
    LWGEOM* lwcol = nullptr;
    int lwgeom_type = lwgeom->type;

    //Ensure the right type was input
    if( !( type == POINTTYPE || type == LINETYPE || type == POLYGONTYPE ) )
    {
        throw std::runtime_error( "postgis::collectionextract: "
            "only point, linestring and polygon may be extracted" );
    }

    //Mirror non-collections right back
    if( !lwgeom_is_collection( lwgeom ) )
    {
        //Non-collections of the matching type go back
        if( lwgeom_type == type )
        {
            return lwgeom;
        }
        //Others go back as EMPTY
        else
        {
            lwcol = lwgeom_construct_empty( type, lwgeom->srid,
                FLAGS_GET_Z( lwgeom->flags ), FLAGS_GET_M( lwgeom->flags ) );
        }
    }
    else
    {
        lwcol = lwcollection_as_lwgeom(
            lwcollection_extract( (LWCOLLECTION*)lwgeom, type ) );
    }

    return lwcol;
}
////////////////////////////////////////////////////////////////////////////////
LWGEOM* segmentize( LWGEOM* lwgeom, double max_segment_length )
{
    return lwgeom_segmentize2d( lwgeom, max_segment_length );
}
////////////////////////////////////////////////////////////////////////////////

}
