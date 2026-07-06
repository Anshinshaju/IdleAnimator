#include "src/Config.h"
#include "src/AnimationManager.h"
#include "src/IdleDetector.h"
#include "src/Timeline.h"
#include <thread>

#include <iostream>

int main()
{
    Config config("config.json");

    if (!config.load())
    {
        std::cerr << "Failed to load config.json\n";
        return 1;
    }

    AnimationManager animationManager(config);

    IdleDetector idleDetector;

    if (!idleDetector.initialize())
    {
        std::cerr << "Failed to initialize IdleDetector\n";
        return 1;
    }

    Timeline timeline(config, animationManager);

    idleDetector.setIdleCallback([&]()
    {
        std::cout << "Idle callback\n";

        std::thread([&]()
        {
            timeline.start();
        }).detach();
    });
    idleDetector.setResumeCallback([&]()
    {
        std::cout << "Resume callback\n";
        timeline.reset();
    });

    idleDetector.start();

    return 0;
}

       