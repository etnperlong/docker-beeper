# Third-party notices

The [MIT license](LICENSE) covers this project's own packaging code and documentation, not the contents of the entire container image. Bundled software keeps its upstream licenses and notices.

| Component | Upstream source and terms |
| --- | --- |
| LinuxServer.io Selkies base image | [Base image source](https://github.com/linuxserver/docker-baseimage-selkies), [GPL-3.0-only](https://github.com/linuxserver/docker-baseimage-selkies/blob/master/LICENSE). The `SELKIES_TAG` build argument selects the base image tag. |
| Selkies streaming server and web client | [Selkies source](https://github.com/selkies-project/selkies), [MPL-2.0](https://github.com/selkies-project/selkies/blob/main/LICENSE). Other base components are listed in the [upstream component documentation](https://docs.linuxserver.io/selkies/components/). |
| Firefox ESR | Installed from [Debian](https://packages.debian.org/trixie/firefox-esr) on Debian bases or [Mozilla's APT repository](https://packages.mozilla.org/apt/) on Ubuntu bases. See [Mozilla's licensing information](https://www.mozilla.org/MPL/). |
| libsecret and other system packages | See the individual notices under `/usr/share/doc/<package>/copyright` in the image and the [Debian](https://sources.debian.org/) or [Ubuntu](https://launchpad.net/ubuntu) source packages. |
| Beeper Desktop | The build downloads the official [Beeper Desktop](https://www.beeper.com/download) AppImage. Beeper's [terms](https://www.beeper.com/terms) apply; this repository grants no rights to redistribute Beeper. Electron and Chromium notices from the AppImage remain under `/opt/beeper/`. |

Before publishing or redistributing the image, verify Beeper redistribution rights and meet the notice and corresponding-source requirements of the bundled licenses. The links above identify upstream projects; they are not a substitute for those obligations.
