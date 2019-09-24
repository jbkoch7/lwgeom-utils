// --- Lwgeomutils Includes --- //
#include <postgis/postgis.sql.h>

// --- Proj Includes --- //
#include <proj_api.h>

namespace postgis
{

////////////////////////////////////////////////////////////////////////////////
LWGEOM* transform( LWGEOM* lwgeom, int srid, bool clone )
{
    lwgeom = lwgeom_clone_deep( lwgeom );
    if( !lwgeom->srid )
    {
        throw std::runtime_error( "postgis::transform: input srid undefined" );
    }
    projPJ input_pj, output_pj;
    std::string input_pj_def = "+init=epsg:" + std::to_string( lwgeom->srid );
    std::string output_pj_def = "+init=epsg:" + std::to_string( srid );
    if( !( input_pj = pj_init_plus( input_pj_def.c_str() ) ) )
    {
        throw std::runtime_error( "postgis::transform: input srid init error" );
    }
    if( !( output_pj = pj_init_plus( output_pj_def.c_str() ) ) )
    {
        throw std::runtime_error( "postgis::transform: output srid init error" );
    }
    if( !lwgeom_transform( lwgeom, input_pj, output_pj ) )
    {
        throw std::runtime_error( "postgis::transform: lwgeom_transform failed" );
    }
    lwgeom->srid = srid;
    if( lwgeom->bbox )
    {
        lwgeom_refresh_bbox( lwgeom );
    }
    return lwgeom;
}
////////////////////////////////////////////////////////////////////////////////

}
