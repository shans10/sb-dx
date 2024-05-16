#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# For now disabling gpgcheck seems to be the only sane way to
# install google-chrome via rpm-ostree.
echo "Enable google-chrome yum repo"
# Enable the google-chrome repo
sed -i '/enabled/d' /etc/yum.repos.d/google-chrome.repo
echo "enabled=1" >> /etc/yum.repos.d/google-chrome.repo
echo "Disable gpgcheck for google-chrome repo"
# Disable gpgcheck
sed -i '/gpgcheck/d' /etc/yum.repos.d/google-chrome.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/google-chrome.repo
