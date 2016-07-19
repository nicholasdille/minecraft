# Introduction

This repository contains the configuration for my Minecraft server. I have automated the following steps:

- Download of plugins
- Injection of worlds
- Injection of server JAR
- Injection of RCON password

Note: This repository does not provide a quickstart configuration for a Minecraft server. The configuration is specific to my needs.

# Customization

You need to change the following files to customize the configuration:

- Edit any configuration file provided by the Minecraft server or any of its plugins
- *server.properties.template* contains the settings that will be added to server.properties. The RCON password is added when building the server directory (see below)
- Config.json contains source paths for worlds and JARs
- *Plugins.json* contains a list of plugins approved for this configuration

# Building the server directory

```powershell
Invoke-psake -buildFile psake.ps1
```

# Running the server

```powershell
.\Start-Server.ps1
```