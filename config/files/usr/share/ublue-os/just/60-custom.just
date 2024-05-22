install-nix-hm: 
    #!/usr/bin/env bash

    # Display script header
    printf "\n############### NIX/HOME-MANAGER INSTALLER ###############\n\n"

    # Exit script if home-manager is already installed
    if [ -x "$(command -v home-manager)" ]; then
      printf "Nix and home-manager already installed. Exiting...\n"
      exit
    fi

    # Install nix package manager using Determinate Systems installer
    printf 'Installing `nix` package manager...\n'
    if [ ! -x "$(command -v nix)" ]; then
      curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
        sh -s -- install ostree --no-confirm --persistence=/var/lib/nix
      # Load nix env in current shell
      printf "\nLoading nix env in current shell...\n"
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    else
      printf 'Already installed. Continuing `channel` configuration...\n'
    fi
    printf "\n"

    # Add appropriate channels
    printf 'Adding `nixpkgs` channel...\n'
    nix-channel --add https://nixos.org/channels/nixos-unstable nixpkgs
    printf 'Adding `home-manager` channel...\n'
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    printf "\nUpdating channels...\n"
    nix-channel --update
    printf "\n"

    # Install home-manager
    printf 'Installing `home-manager`...\n'
    nix-shell '<home-manager>' -A install

    # Configure shell profile for home-manager
    if [ ! -f "$HOME/.profile" ] || [ ! "$(cat $HOME/.profile | grep hm-session-vars)" ]
    then
      printf "\nConfiguring shell for home-manager...\n"
      echo -e "\n# Source home-manager session vars" >> $HOME/.profile
      echo '. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"' >> $HOME/.profile
    fi

    # Signal end
    printf "DONE!\n"

install-chrome-rpm:
    #!/usr/bin/env bash

    # Tell this script to exit if there are any errors
    set -oue pipefail

    # Display script header
    printf "\n############### GOOGLE CHROME RPM INSTALLER ###############\n\n"

    # Enable the google-chrome repo
    printf "Enabling google-chrome yum repo...\n\n"
    sudo sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/google-chrome.repo

    # Disable gpgcheck
    printf "Disabling gpgcheck for google-chrome repo...\n\n"
    sudo sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/google-chrome.repo

    # Install Google Chrome
    printf "Installing Google Chrome...\n"
    rpm-ostree install google-chrome-stable

    # Signal end
    printf "DONE!\n"
