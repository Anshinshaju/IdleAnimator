#pragma once

class Config;
class AnimationManager;

class Timeline
{
public:
    Timeline(const Config& config,
             AnimationManager& animationManager);

    void start();
    void stop();
    void reset();

private:
    const Config& config;
    AnimationManager& animationManager;

    bool running = false;

};