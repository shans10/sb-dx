install-nix:
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
        sh -s -- install ostree --no-confirm --persistence=/var/lib/nix

install-chrome-rpm:
    #!/usr/bin/env bash

    # Tell this script to exit if there are any errors
    set -oue pipefail

    # Display script header
    printf "\n############### INSTALLING GOOGLE CHROME RPM ###############\n"

    # Enable the google-chrome repo
    printf "Enabling google-chrome yum repo...\n\n"
    sudo sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/google-chrome.repo

    # Disable gpgcheck
    printf "Disabling gpgcheck for google-chrome repo...\n\n"
    sudo sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/google-chrome.repo

    # Install Google Chrome
    printf "Installing Google Chrome...\n\n"
    rpm-ostree install google-chrome-stable

    # Signal end
    printf "DONE!\n"
