set dotenv-load
just := just_executable()
make := `which make`

build:
    mkdir -p build
    {{ just }} cosmic-applets/build-release
    {{ just }} cosmic-applibrary/build-release
    {{ just }} cosmic-bg/build-release
    {{ make }} -C cosmic-comp all
    {{ just }} cosmic-edit/build-release
    {{ just }} cosmic-greeter/build-release
    {{ just }} cosmic-launcher/build-release
    {{ just }} cosmic-notifications/build-release
    {{ make }} -C cosmic-osd all
    {{ just }} cosmic-panel/build-release
    {{ just }} cosmic-screenshot/build-release
    {{ just }} cosmic-settings/build-release
    {{ make }} -C cosmic-settings-daemon all
    {{ just }} cosmic-session/all
    {{ make }} -C cosmic-workspaces-epoch all
    {{ make }} -C xdg-desktop-portal-cosmic all

sysext dir=`echo $(pwd)/cosmic-sysext` version=("nightly-" + `git rev-parse --short HEAD`): build && (_extension_release dir version)
    mkdir -p {{dir}}/usr/lib/extension-release.d/
    {{ just }} rootdir={{dir}} cosmic-applets/install
    {{ just }} rootdir={{dir}} cosmic-applibrary/install
    {{ just }} rootdir={{dir}} cosmic-bg/install
    {{ make }} -C cosmic-comp install DESTDIR={{dir}}
    {{ just }} rootdir={{dir}} cosmic-edit/install
    {{ just }} rootdir={{dir}} cosmic-greeter/install
    {{ just }} rootdir={{dir}} cosmic-icons/install
    {{ just }} rootdir={{dir}} cosmic-launcher/install
    {{ just }} rootdir={{dir}} cosmic-notifications/install
    {{ make }} -C cosmic-osd install DESTDIR={{dir}} prefix=/usr
    {{ just }} rootdir={{dir}} cosmic-panel/install
    {{ just }} rootdir={{dir}} cosmic-screenshot/install
    {{ just }} rootdir={{dir}} cosmic-settings/install
    {{ make }} -C cosmic-settings-daemon install DESTDIR={{dir}} prefix=/usr
    {{ just }} rootdir={{dir}} cosmic-session/install
    {{ make }} -C cosmic-workspaces-epoch install DESTDIR={{dir}} prefix=/usr
    {{ make }} -C xdg-desktop-portal-cosmic install DESTDIR={{dir}} prefix=/usr

_extension_release dir version:
    #!/usr/bin/env sh
    cat >{{dir}}/usr/lib/extension-release.d/extension-release.cosmic-sysext <<EOF
    NAME="Cosmic DE"
    VERSION={{version}}
    $(cat /etc/os-release | grep '^ID=')
    $(cat /etc/os-release | grep '^VERSION_ID=')
    EOF
    echo "Done"

clean:
    rm -rf cosmic-applets/target
    rm -rf cosmic-applibrary/target
    rm -rf cosmic-bg/target
    rm -rf cosmic-comp/target
    rm -rf cosmic-edit/target
    rm -rf cosmic-greeter/target
    rm -rf cosmic-launcher/target
    rm -rf cosmic-panel/target
    rm -rf cosmic-notifications/target
    rm -rf cosmic-osd/target
    rm -rf cosmic-screenshot/target
    rm -rf cosmic-settings/target
    rm -rf cosmic-settings-daemon/target
    rm -rf cosmic-session/target
    rm -rf cosmic-workspaces-epoch/target
    rm -rf xdg-desktop-portal-cosmic/target
