#include "AnimationManager.h"
#include "Config.h"
#include <thread>
#include <cstdlib>

#include <filesystem>
#include <iostream>

namespace fs = std::filesystem;

AnimationManager::AnimationManager(const Config& config)
    : config(config)
{
}

bool AnimationManager::prepareAnimations()
{
    fs::path runtimeDir = config.getRuntimeDirectory();

    // Create runtime directory if it doesn't exist
    fs::create_directories(runtimeDir);

    // Delete everything inside it
    for (const auto& entry : fs::directory_iterator(runtimeDir))
    {
        fs::remove_all(entry.path());
    }

    bool success = true;

    try
    {
        fs::copy_file(
            config.getFadePath(),
            runtimeDir / "fade.qml",
            fs::copy_options::overwrite_existing);
    }
    catch (...)
    {
        success = false;
    }

    try
    {
        fs::copy_file(
            config.getSleepPath(),
            runtimeDir / "sleep.qml",
            fs::copy_options::overwrite_existing);
    }
    catch (...)
    {
        success = false;
    }

    return success;
}

void AnimationManager::launchFade()
{
    std::thread([]()
    {
        std::system("qmlscene6 animations/fade.qml");
    }).detach();
}

void AnimationManager::launchSleep()
{
    std::thread([]()
    {
        std::system("qmlscene6 animations/sleep.qml");
    }).detach();
}

void AnimationManager::stopFade()
{
    std::system("pkill -f \"qmlscene.*fade.qml\"");
}

void AnimationManager::stopSleep()
{
    std::system("pkill -f \"qmlscene.*sleep.qml\"");
}

void AnimationManager::stopAll()
{
    stopFade();
    stopSleep();
}