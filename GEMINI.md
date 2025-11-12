# Gemini Agent Configuration

This file provides context to the Gemini agent to help it understand and work with this Nix configuration repository.

## Project Overview

This is a personal Nix configuration for a desktop workstation used for software development. The primary goals are to:

*   Create a keyboard-driven workflow using Hyprland.
*   Achieve a visually appealing and "pretty" desktop environment.
*   Support both work and personal use cases, including managing separate profiles for web applications.
*   Eventually, extend the configuration to manage other machines, such as servers.
*   The configuration is inspired by "Omarchy", and aims to incorporate some of its nice default settings where possible.

## Key Features

*   **Declarative Desktop:** Uses NixOS to declaratively manage the entire system configuration.
*   **Tiling Window Manager:** Employs Hyprland for a keyboard-centric, dynamic tiling experience.
*   **Web App Integration:** Focuses on integrating web applications seamlessly into the desktop environment.
*   **Profile Management:** Supports launching multiple instances of the same web application (e.g., "Gmail (Work)" and "Gmail (Personal)"), each with its own isolated data and login, facilitating distinct work and personal contexts.

## Web App Management

The configuration uses `home/emmetdelaney/web-apps.nix` to define and manage web applications, now with enhanced profile support.

*   **PWA Support:** Web applications can be configured to run as Progressive Web Apps (PWAs) using Chromium.
*   **Isolated Profiles:** Each PWA definition now includes a `profile` attribute (e.g., "work", "personal", "default"). The `launch-pwa` script utilizes this profile, along with the app's name, to create a dedicated Chromium user data directory (`--user-data-dir`). This ensures complete separation of cookies, cache, and other data between different instances of the same web app (e.g., work vs. personal Gmail) and between different web apps.
*   **Launchers:**
    *   A Rofi-based launcher (`web-apps`) provides a convenient menu to select and launch configured web apps, correctly passing the associated profile to the `launch-pwa` script.
    *   Individual launcher scripts (e.g., `launch-gmailWork`, `launch-gmailPersonal`) are generated for direct keybinding integration, allowing for quick access to specific web app instances with their respective profiles.
    *   Desktop entries are also generated with the correct profile information, ensuring seamless launching from desktop environments.
*   **Browser Choice:** While PWAs use Chromium for a native app-like experience, other web links or non-PWA web apps can be configured to open in Firefox.
