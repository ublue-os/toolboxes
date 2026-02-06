# toolboxes

Centralized repository of containers designed for Toolbox/Distrobox with batteries included. These toolboxes strive for:

- Instant launch
- Include quadlets and systemd service units for management
- Intended to be used as general purpose toolboxes for "daily driver" usage
- Can be used with [boxkit](https://github.com/ublue-os/boxkit) as base images to manage your own custom setup

## Images

- `ubuntu-toolbox` - an Ubuntu base image
- `debian-toolbox` - a Debian base image
- `fedora-toolbox` - a Fedora base image
- `arch-toolbox` - an Arch base image
- `bazzite-arch` - an Arch based image that includes gaming utilities and Steam
- `bazzite-arch-gnome` - Variation of Bazzite-arch for GNOME
- `wolfi-toolbox` - a WolfiOS base image
- `docker-distrobox` - an Ubuntu distrobox with Docker-CE. It will export the docker socket to the host.
- `incus-distrobox` - an Ubuntu distrobox with Incus packages from Zabbly.

It is strongly recommended that the [Ptyxis terminal](https://gitlab.gnome.org/chergert/ptyxis) be used with these toolboxes and is the default experience in both [Bazzite](https://bazzite.gg) and [Bluefin](https://projectbluefin.io).

## Automatic Toolbox Startup

### Quadlets

Podman supports starting containers via a systemd generator. Quadlets replaced the `podman generate systemd` command and provide a method to create a systemd service for managing your container. The generated unit file can automatically start your container on login, automatically check for updates from the registry, and automatically clean-up the container and any transient volumes when the container stops. This provides an ideal way to have a clean slate on each login.

Inside the quadlets directory are example quadlets each of the toolboxes listed above. Distrobox and Toolbox provide a convenient way to integrate the containers into your host.`ubuntu-toolbox` and `fedora-toolbox` can use either toolbox or distrobox. `wolfi-toolbox`, (WolfiOS base) is currently only compatible with distrobox.

The quadlets mimic the create and enter commands to setup the container. You can use these by copying them to `~/.config/containers/systemd`. When using the Prompt terminal, they will appear in the menu as available containers. The `Exec=` line of the distrobox quadlets can be modified to include additional packages.

To get automatic updates you will need to enable `podman-auto-update.timer` which by default will auto-update at midnight. Quadlets support creating volumes using a `.volume` unit. These volumes can be accessed by other containers by prepending the name of `.volume` with `systemd`.

### Systemd one-shots

An alternative method for having automatic toolbox startup is to leverage systemd one-shot services and distrobox assemble commands.

Distrobox assemble enables the user to declare a setup without going through the process of creating a customized image. Instead, an ini style file can be used with `distrobox-assemble` and `distrobox-enter` to setup and enter a modified container. Example assemble files are available here and on the universal-blue discourse.

To utilize these, place the user service file in `~/.config/systemd/user` and make sure the assemble file is in place. The ones inside the repo are set to replace the existing container of the same to behave similar to the quadlet. Again you can access `.volume` by using the name of the volume unit prepended with `systemd`.

`wolfi-toolbox` has a Wolfi developer variant built from the Wolfi SDK image, intended for Wolfi package and image development. They include utilities such as melange, wolfictl, and apko. This imis labelled as `wolfi-dx-toolbox`.

### Incus and Docker Distrobox

Both `incus-distrobox` and `docker-distrobox` are designed to be run with a rootful, init distrobox. [Incus](https://linuxcontainers.org/incus/) uses packages built by [Zabbly](https://github.com/zabbly/incus). [Docker](https://www.docker.com/) uses the [convience install script](https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script) from Docker. Both are built from the ubuntu-toolbox built in this repo. Example distrobox-assemble files are with each of them. Both work well with a volume mount for their respective files in `/var/lib/{docker,incus}`. Both can be setup to autostart on boot with a `systemd service`. However, your user sockets for `Xorg`, `Wayland`, and `Pulseaudio` will not be setup until you login. For the `docker-distrobox` you can customize the group of the exported `docker socket` by setting an environment variable at distrobox creation time for `DOCKERGROUP`. The assemble file has more information. Both the `incus-distrobox` and `docker-distrobox` set the unix-groups. For incus, matching `incus-admin` inside the distrobox and on the host will enable you to use the `incus socket` from the host.

# Stats

## Star History

![Alt](https://repobeats.axiom.co/api/embed/7c5f037d792c6deb1946e5bc040f64a0fc8abeab.svg "Repobeats analytics image")

<a href="https://star-history.com/#ublue-os/toolboxes&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=ublue-os/toolboxes&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=ublue-os/toolboxes&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=ublue-os/toolboxes&type=Date" />
  </picture>
</a>
