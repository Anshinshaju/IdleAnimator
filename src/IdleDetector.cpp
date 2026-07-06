#include "IdleDetector.h"

#include <iostream>
#include <string>

#include <wayland-client.h>

extern "C" {
#include "../protocols/ext-idle-notify-client-protocol.h"
}

// -----------------------------------------------------------------------------
// Prototype globals
// -----------------------------------------------------------------------------

static wl_display *display = nullptr;
static wl_registry *registry = nullptr;
static wl_seat *seat = nullptr;

static ext_idle_notifier_v1 *idleNotifier = nullptr;
static ext_idle_notification_v1 *notification = nullptr;

static IdleDetector *instance = nullptr;

// -----------------------------------------------------------------------------
// Idle callbacks
// -----------------------------------------------------------------------------

static void idle(void *data, ext_idle_notification_v1 *notification)
{
    std::cout << "IDLE" << std::endl;

    if (instance)
        instance->onIdle();
}

static void resumed(void *data, ext_idle_notification_v1 *notification)
{
    std::cout << "ACTIVE" << std::endl;

    if (instance)
        instance->onResume();
}

static const ext_idle_notification_v1_listener idleListener =
{
    idle,
    resumed
};

// -----------------------------------------------------------------------------
// Registry callbacks
// -----------------------------------------------------------------------------

static void registryGlobal(
    void *data,
    wl_registry *registry,
    uint32_t name,
    const char *interface,
    uint32_t version)
{
    std::string iface(interface);

    if (iface == wl_seat_interface.name)
    {
        seat = static_cast<wl_seat*>(
            wl_registry_bind(
                registry,
                name,
                &wl_seat_interface,
                1));
    }

    if (iface == ext_idle_notifier_v1_interface.name)
    {
        idleNotifier = static_cast<ext_idle_notifier_v1*>(
            wl_registry_bind(
                registry,
                name,
                &ext_idle_notifier_v1_interface,
                1));
    }
}

static void registryRemove(
    void *data,
    wl_registry *registry,
    uint32_t name)
{
}

static const wl_registry_listener registryListener =
{
    registryGlobal,
    registryRemove
};

// -----------------------------------------------------------------------------
// IdleDetector
// -----------------------------------------------------------------------------

IdleDetector::IdleDetector()
{
    instance = this;
}

bool IdleDetector::initialize()
{
    display = wl_display_connect(nullptr);

    if (!display)
    {
        std::cerr << "Failed to connect to Wayland." << std::endl;
        return false;
    }

    registry = wl_display_get_registry(display);

    wl_registry_add_listener(
        registry,
        &registryListener,
        nullptr);

    wl_display_roundtrip(display);

    if (!seat || !idleNotifier)
    {
        std::cerr << "Idle protocol unavailable." << std::endl;
        return false;
    }

    return true;
}

void IdleDetector::start()
{
    notification =
        ext_idle_notifier_v1_get_idle_notification(
            idleNotifier,
            5000,
            seat);

    ext_idle_notification_v1_add_listener(
        notification,
        &idleListener,
        nullptr);

    while (wl_display_dispatch(display) != -1)
    {
    }
}

void IdleDetector::stop()
{
    if (notification)
    {
        ext_idle_notification_v1_destroy(notification);
        notification = nullptr;
    }

    if (registry)
    {
        wl_registry_destroy(registry);
        registry = nullptr;
    }

    if (display)
    {
        wl_display_disconnect(display);
        display = nullptr;
    }
}

void IdleDetector::setIdleCallback(std::function<void()> callback)
{
    idleCallback = callback;
}

void IdleDetector::setResumeCallback(std::function<void()> callback)
{
    resumeCallback = callback;
}
void IdleDetector::onIdle()
{
    if (idleCallback)
        idleCallback();
}

void IdleDetector::onResume()
{
    if (resumeCallback)
        resumeCallback();
}