#include "Config.h"

#include <fstream>
#include <stdexcept>

#include <nlohmann/json.hpp>

using json = nlohmann::json;

namespace
{
    std::string runtimeDirectory;
    std::string fadePath;
    std::string sleepPath;

    int idleStart;
    int fadeStart;
    int fadeDuration;

    int sleepStart;
    int sleepFadeIn;
    int sleepEnd;
    int sleepFadeOut;

    int lockTime;
}

Config::Config(const std::string& configPath)
    : configPath(configPath)
{
}

bool Config::load()
{
    std::ifstream file(configPath);

    if (!file.is_open())
        return false;

    json config;
    file >> config;

    auto animations = config["animations"];
    auto timings = config["timings"];

    runtimeDirectory = animations["runtimeDirectory"];
    fadePath = animations["fade"];
    sleepPath = animations["sleep"];

    idleStart = timings["idleStart"];
    fadeStart = timings["fadeStart"];
    fadeDuration = timings["fadeDuration"];

    sleepStart = timings["sleepStart"];
    sleepFadeIn = timings["sleepFadeIn"];
    sleepEnd = timings["sleepEnd"];
    sleepFadeOut = timings["sleepFadeOut"];

    lockTime = timings["lockTime"];

    return true;
}

std::string Config::getRuntimeDirectory() const
{
    return runtimeDirectory;
}

std::string Config::getFadePath() const
{
    return fadePath;
}

std::string Config::getSleepPath() const
{
    return sleepPath;
}

int Config::getIdleStart() const
{
    return idleStart;
}

int Config::getFadeStart() const
{
    return fadeStart;
}

int Config::getFadeDuration() const
{
    return fadeDuration;
}

int Config::getSleepStart() const
{
    return sleepStart;
}

int Config::getSleepFadeIn() const
{
    return sleepFadeIn;
}

int Config::getSleepEnd() const
{
    return sleepEnd;
}

int Config::getSleepFadeOut() const
{
    return sleepFadeOut;
}

int Config::getLockTime() const
{
    return lockTime;
}