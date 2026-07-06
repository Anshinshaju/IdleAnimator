#pragma once

#include <functional>

class IdleDetector
{
public:
    IdleDetector();

    bool initialize();

    void start();
    void stop();

    void setIdleCallback(std::function<void()> callback);
    void setResumeCallback(std::function<void()> callback);

    // Prototype helper functions
    void onIdle();
    void onResume();

private:
    std::function<void()> idleCallback;
    std::function<void()> resumeCallback;
};