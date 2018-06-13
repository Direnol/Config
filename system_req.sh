#!/bin/bash

function pre_install
{
    echo Pre install
    # sublime
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    
}

function post_install
{
    echo Post install
}

#pre_install
sudo apt update
cat ~/.config/install_packages | sudo apt install -y
post_install
