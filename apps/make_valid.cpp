
// --- Lwgeom Includes --- //
extern "C"
{
#include <liblwgeom.h>
}

// --- Standard Includes --- //
#include <cfloat>
#include <iostream>
#include <stdexcept>
#include <string>

////////////////////////////////////////////////////////////////////////////////
int main(
    int argc,
    char** argv )
{
    bool success = false;
    int has_bbox = 0;
    int precision = DBL_DIG;
    char* srs = nullptr;
    LWGEOM* gin = nullptr;
    LWGEOM* gout = nullptr;

    try
    {
        if( argc != 2 ) throw std::invalid_argument(
            "Wrong number of arguments provided" );
        std::string geojson = argv[ 1 ];
        gin = lwgeom_from_geojson( geojson.c_str(), &srs );
        gout = lwgeom_make_valid( gin );
        geojson = lwgeom_to_geojson( gout, srs, precision, has_bbox );
        std::cout << geojson;
        success = true;
    }
    catch( std::exception const& e )
    {
        std::cerr << "*** std::exception caught: " << e.what() << std::endl;
    }

    lwfree( srs );
    lwfree( gin );
    lwfree( gout );

    return ( success ) ? EXIT_SUCCESS : EXIT_FAILURE;
}
////////////////////////////////////////////////////////////////////////////////
