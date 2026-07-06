#pragma once

#include <string>

class Config
{
public:
    explicit Config(const std::string& configPath);

    bool load();

    std::string getRuntimeDirectory() const;

    std::string getFadePath() const;
    std::string getSleepPath() const;

    int getIdleStart() const;
    int getFadeStart() const;
    int getFadeDuration() const;

    int getSleepStart() const;
    int getSleepFadeIn() const;
    int getSleepEnd() const;
    int getSleepFadeOut() const;

    int getLockTime() const;

private:
    std::string configPath;
};