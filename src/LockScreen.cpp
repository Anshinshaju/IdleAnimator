#include "LockScreen.h"

#include <cstdlib>
#include <iostream>

LockScreen::LockScreen()
{
}

void LockScreen::lock()
{
    std::cout << "Locking screen..." << std::endl;

    int result = std::system("loginctl lock-session");

    if (result != 0)
    {
        std::cerr << "Failed to lock screen." << std::endl;
    }
}