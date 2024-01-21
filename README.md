# toolboxes
Centralized repository of containers designed for Toolbox/Distrobox.

## Automatic Toolbox Startup

### Quadlets
Podman supports starting containers via a systemd generator. Quadlets replaced the `podman generate systemd` command and provide a method to create a systemd service for managing your container. The generated unit file can automatically start your container on login, automatically check for updates from the registry, and automatically clean-up the container and any transient volumes when the container stops. This provides an ideal way to have a clean slate on each login.

Inside the quadlets directory are example quadlets for ubuntu, fedora, wolfi, and bluefin-cli. Distrobox and Toolbox provide a convenient way to integrate the containers into your host. For both ubuntu and fedora you can use either toolbox or distrobox. Wolfi and bluefin-cli are currently only compatible with distrobox. The quadlets mimic the create and enter commands to setup the container. You can use these by copying them to `~/.config/containers/systemd`. When using the prompt terminal, they will appear in the menu as available containers. The `Exec=` line of the distrobox quadlets can be modified to include additional packages.

To get automatic updates you will need to enable `podman-auto-update.timer` which by default will auto-update at midnight. Quadlets support creating volumes using a `.volume` unit. These volumes can be accessed by other containers by prepending the name of `.volume` with `systemd`.

### Systemd one-shots
An alternative method for having automatic toolbox startup is to leverage systemd one-shot services and distrobox assemble commands.

Distrobox assemble enables the user to declare a setup without going through the process of creating a customized image. Instead, an ini style file can be used with `distrobox-assemble` and `distrobox-enter` to setup and enter a modified container. Example assemble files are available here and on the universal-blue discourse.

To utilize these, place the user service file in `~/.config/systemd/user` and make sure the assemble file is in place. The ones inside the repo are set to replace the existing container of the same to behave similar to the quadlet. Again you can access `.volume` by using the name of the volume unit prepended with `systemd`.

### Bluefin-CLI
Bluefin-cli is built from our wolfi-toolbox. It has `linuxbrew` configured to work and have your `linuxbrew` packages preserved between container rebuilds. This works by bind mounting a directory from your `$HOME`. Updates to brew itself happen automatically with container rebuilds while you manage when to update your brew packages. 

# Stats

![Alt](https://repobeats.axiom.co/api/embed/7c5f037d792c6deb1946e5bc040f64a0fc8abeab.svg "Repobeats analytics image")
