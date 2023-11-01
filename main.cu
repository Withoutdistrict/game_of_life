
#include "render_app.hpp"

#include <cstdlib>
#include <iostream>
#include <stdexcept>

int main()
{
    // int k, l;
    // for(int i = 0; i < 9; i++){
    //     k = (i%3) - 1;
    //     l = (i+3)/3 - 2;
    //     std::cout << k << "\t" << l << std::endl;
    // }

    RenderApp app{};

    try
    {
        app.run();
    }
    catch (const std::exception &e)
    {
        std::cerr << e.what() << '\n';
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}