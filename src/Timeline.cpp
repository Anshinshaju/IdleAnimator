#include "Timeline.h"

#include "AnimationManager.h"
#include "Config.h"
#include "LockScreen.h"

#include <chrono>
#include <iostream>
#include <thread>

Timeline::Timeline(const Config& config,
                   AnimationManager& animationManager)
    : config(config),
      animationManager(animationManager)
{
}

void Timeline::start()
{
    running = true;

    std::cout << "Timeline Started\n";

    animationManager.prepareAnimations();

    int seconds = 0;

    while (running)
    {
        std::this_thread::sleep_for(std::chrono::seconds(1));

        seconds++;

        if (seconds == config.getFadeStart())
        {
            std::cout << "Fade Start\n";
            //animationManager.launchFade();
        }

        if (seconds == config.getSleepStart())
        {
            std::cout << "Sleep Start\n";
            animationManager.launchSleep();
        }

        if (seconds == config.getSleepEnd())
        {
            std::cout << "Sleep End\n";
            animationManager.stopSleep();
        }

        if (seconds == config.getLockTime())
        {
            std::cout << "Lock Screen\n";

            animationManager.stopSleep();
            //animationManager.stopFade();

            LockScreen locker;
            locker.lock();

            running = false;
            break;
        }
    }
}

void Timeline::stop()
{
    running = false;

    animationManager.stopAll();

    std::cout << "Timeline Stopped\n";
}

void Timeline::reset()
{
    stop();

    std::cout << "Timeline Reset\n";
}