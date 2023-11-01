#ifndef RENDER_APP_H
#define RENDER_APP_H


#include "renderer.hpp"

class RenderApp
{
public:
    static constexpr int WIDTH = 1000;
    static constexpr int HEIGHT = 1000;

    RenderApp();
    ~RenderApp();

    RenderApp(const RenderApp &) = delete;
    RenderApp &operator=(const RenderApp &) = delete;

    void run();

private:
    void loadGameObjects();

    Window window{WIDTH, HEIGHT, "Vulkan Tutorial"};
    Device device{window};
    Renderer renderer{window, device};

    std::vector<GameObject> gameObjects;
};

#endif