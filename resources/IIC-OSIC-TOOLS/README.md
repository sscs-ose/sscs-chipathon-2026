# IIC-OSIC-TOOLS Startup Scripts

In this folder you can find the startup scripts for the IIC-OSIC-TOOLS. These scripts are designed to help you quickly set up your environment for the IIC-OSIC-TOOLS.

## Overview

Per default, all the start scripts use the IEEE Chipathon specific Docker image tag "chipathon". It should be noted that these start scripts are only compatible with that specific tag. This means that no additional configuration is required.
X86_64 (Classic Intel or AMD based PCs) and arm64 (e.g. Raspberry Pi or Apple Silion Macs) are supported natively.

### Types of operating modes

The IIC-OSIC-TOOLS for the Chipathon support three different operating modes:

| Operating Mode|  Graphical Interface                                                     | Upsides                                                                                   | Downsides                                                                               |
|---------------|--------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|
| X11/Wayland   | Uses local X-Server or Wayland display                                   | Fast, integrated well with local desktop                                                  | No full desktop environment, all applications need to be started from terminal.         |
| VNC           | Full desktop environment in a VNC-Server, browser-based client integrated| Full Desktop Environment makes usage easier, can be run on a server and accessed remotely.| Due to VNC, the graphical performance is limited. No integration with the local desktop.|
| Jupyter       | Can only be accessed by using the Jupyter Lab in the browser.            | Fast, can be run on a server and accessd remotely.                                        | No graphical desktop environment or other UI available.                                 |

All scripts are preconfigured in a way so they provide useful defaults and should work out of the box.
The VNC Server is available on Port 5901 (for using any VNC client of your liking). It is also possible to conveniently accessed by a web-based client which is available at [http://localhost:80](http://localhost:80) after starting. The default password is "abc123".
The Jupyter Server is available on Port 8888, which can be found [http://localhost:8888](http://localhost:8888) after starting.
There is a folder, that is shared with the host system, which can be found at `/foss/designs/` inside of the container.

### Linux and macOS Users

This scripts require bash (or a compatible shell) to run. Compatible with most of the common Linux distributions and MacOS.

#### Available start scripts

- `start_chipathon_x.sh`: This script starts the IIC-OSIC-TOOLS environment with an X11/Wayland display server.
- `start_chipathon_vnc.sh`: This script starts the IIC-OSIC-TOOLS environment with a VNC server for remote access.
- `start_chipathon_jupyter.sh`: This script starts the IIC-OSIC-TOOLS environment with a Jupyter server for interactive computing.

#### Details Linux

For Linux in the X11/Wayland mode using Docker CE (not Docker Desktop) per default the script detects the local X-Server and, if available, the GPU and also a Wayland display and makes them available to the container. This mode provides the fastest graphical user experience.
If alternatively Docker Desktop is used, the container can only use the X-Server through a local TCP connection, which has degraded performance compared to Docker CE. The start script for the X11 mode uses `socat` to forward the X11-socket to the container. For this, please install it in the following way:
To install socat, here are the commands for popular distributions:
- Ubuntu/Debian (deb-based): `sudo apt-get -y install socat`
- Arch/Manjaro (pacman-based): `pacman -S socat`
- Fedora/RHEL/Rocky/Alma (rpm-based, RHEL-clones): `dnf -y install socat`
- SuSE/openSUSE (rpm-based, SuSE-clones): `zypper install socat`

The `/foss/designs/` folder is, per default, shared with your hosts directory `$HOME/eda/designs/`.

#### Details MacOS

On MacOS, a separately installed X-Server needs to be installed. We recommend XQuartz, see [IIC-OSIC-TOOLS Repo, Installing X11-Server](https://github.com/iic-jku/iic-osic-tools?tab=readme-ov-file#434-installing-x11-server). This mode uses X-Quartz through a local TCP connection.
The `/foss/designs/` folder is, per default, shared with your hosts directory `$HOME/eda/designs/`.

### Windows Users

This scripts are inteded to be run in a Windows CMD. This can either be achieved by either opening a CMD and executing the scripts from there or double clicking in the Windows Explorer.

#### Available start scripts

- `start_chipathon_x.bat`: This script starts the IIC-OSIC-TOOLS environment with an X11/Wayland display server.
- `start_chipathon_vnc.bat`: This script starts the IIC-OSIC-TOOLS environment with a VNC server for remote access.
- `start_chipathon_jupyter.bat`: This script starts the IIC-OSIC-TOOLS environment with a Jupyter server for interactive computing.

#### Details

The X11/Wayland mode in Windows is using the WSL2/WSLg graphical mode, which is integrated in new versions of WSL2. This mode provides a high performance mode. It is **not** required to install an additional X-Server in Windows, but WSL2 must be updated to the latest version on Windows 10 (WSLg is available per default on Windows 11).
The `/foss/designs/` folder is, per default, shared with your hosts directory `%USERPROFILE%\eda\designs`, which usually maps to `C:\Users\<username\eda\designs`.
