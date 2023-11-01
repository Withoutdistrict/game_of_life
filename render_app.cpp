#include "cuda_gol.h"
#include "render_app.hpp"

#include <chrono>

// #include <cuda.h>
// #include <cuda_runtime.h>

#define SIZE 1000
// #define row 250
// #define col 250

class StatisticSystem
{
public:
    int *A = new int[SIZE * SIZE];
    int *B = new int[SIZE * SIZE];
    int *c_A = NULL, *c_B = NULL;
    GameObject *c_physicsObjs = NULL;

    void update(std::vector<GameObject> &physicsObjs)
    {
        fct_cuda_stat_updt(A, c_A, B, c_B, SIZE);
        fct_cuda_objs_updt(A, c_A, &physicsObjs, c_physicsObjs, SIZE);
    }
    StatisticSystem(std::vector<GameObject> &physicsObjs)
    {
        srand(time(NULL));
        for (int i = 0; i < SIZE * SIZE; i++)
        {
            rand() % 3 == 0 ? A[i] = 1 : A[i] = 0;
        }
        fct_cuda_stat_init(A, &c_A, B, &c_B, SIZE);
        fct_cuda_objs_init(&physicsObjs, &c_physicsObjs, SIZE);
    }
    ~StatisticSystem()
    {
        delete[] A;
        delete[] B;
        fct_cuda_stat_free(c_A, c_B);
        fct_cuda_objs_free(c_physicsObjs);
    }
};

std::unique_ptr<Model> createSquareModel(Device &device, glm::vec2 offset)
{
    std::vector<Model::Vertex> vertices =
        {
            {{-0.5f, -0.5f}},
            {{0.5f, 0.5f}},
            {{-0.5f, 0.5f}},
            {{-0.5f, -0.5f}},
            {{0.5f, -0.5f}},
            {{0.5f, 0.5f}},
        };
    for (auto &v : vertices)
    {
        v.position += offset;
    }
    return std::make_unique<Model>(device, vertices);
}

RenderApp::RenderApp() { loadGameObjects(); }

RenderApp::~RenderApp() {}

void RenderApp::run()
{
    // create some square models
    std::shared_ptr<Model> squareModel = createSquareModel(device, {0, 0});

    // create statistic Objects
    std::vector<GameObject> statisticObjects{};
    int gridCount = SIZE;
    float scale_x = (float)(1 / (float)gridCount) * 2;
    float scale_y = (float)(1 / (float)gridCount) * 2;
    for (int i = 0; i < gridCount; i++)
    {
        for (int j = 0; j < gridCount; j++)
        {
            auto vf = GameObject::createGameObject();
            vf.transform2d.scale = {scale_x, scale_y};
            vf.transform2d.translation =
                {
                    (float)i * scale_x - 1 + scale_x / 2,
                    (float)j * scale_y - 1 + scale_y / 2};
            vf.color = glm::vec3(1.0f);
            vf.model = squareModel;
            statisticObjects.push_back(std::move(vf));
        }
    }

    StatisticSystem statisticSystem{statisticObjects};

    SimpleRenderSystem simpleRenderSystem{device, renderer.getSwapChainRenderPass()};

    while (!window.shouldClose())
    {
        int64_t t21;
        int64_t t43;
        std::chrono::_V2::system_clock::time_point t3 = std::chrono::high_resolution_clock::now();
        glfwPollEvents();

        if (auto commandBuffer = renderer.beginFrame())
        {
            // begin update systems
            std::chrono::_V2::system_clock::time_point t1 = std::chrono::high_resolution_clock::now();
            statisticSystem.update(statisticObjects);
            std::chrono::_V2::system_clock::time_point t2 = std::chrono::high_resolution_clock::now();
            t21 = (std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1)).count();
            // end update systems
            //
            renderer.beginSwapChainRenderPass(commandBuffer);
            // begin render system
            simpleRenderSystem.renderGameObjects(commandBuffer, statisticObjects);
            // end render system
            renderer.endSwapChainRenderPass(commandBuffer);
            renderer.endFrame();
        }

        std::chrono::_V2::system_clock::time_point t4 = std::chrono::high_resolution_clock::now();
        t43 = (std::chrono::duration_cast<std::chrono::milliseconds>(t4 - t3)).count();

        int64_t t4321 = t43 - t21;

        std::cout << "loop duration: " << t43 << "\t update duration: " << t21 << "\t frame render duration: " << t4321 << std::endl;
    }

    vkDeviceWaitIdle(device.device());
}

void RenderApp::loadGameObjects()
{
}
