#pragma once

#include <string>

class Config;

class AnimationManager
{
public:
    explicit AnimationManager(const Config& config);

    bool prepareAnimations();

    void launchFade();
    void launchSleep();

    void stopFade();
    void stopSleep();

    void stopAll();

private:
    const Config& config;
};