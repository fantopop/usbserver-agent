#!/bin/bash

# (C) Ilya Putilin @ 42POST
# https://github.com/fantopop/
# Install & uninstall NIO-EUSB client & agent to run in admin mode

# Run this script with sudo
# Use admin password when prompted for owmnership fix

# Text colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Variables & paths
launchagents="/Library/LaunchAgents"
shared="/Users/Shared"

rhcl_universal_app="/Applications/rhclUniversal.app"
rhcl_agent_app="/Applications/rhcl RUN THIS APP.app"
rhcl_universal_binary="${rhcl_universal_app}/Contents/MacOS/rhclUniversal"
rhcl_agent="ru.42post.rhcl.admin.client.plist"
rhcl_config="${shared}/rhcl"

vh_universal_app="/Applications/VirtualHereUniversal.app"
vh_agent_app="/Applications/VirtualHere RUN THIS APP.app"
vh_agent="ru.42post.virtualhere.admin.plist"
vh_daemon="/Library/LaunchDaemons/com.virtualhere.vhclient.plist"
vh_config="${shared}/VirtualHere"

server="10.100.101.150:17602"
app_link="https://github.com/fantopop/usbserver-agent/releases/latest/download/rhclUniversal.zip"
agent_link="https://github.com/fantopop/usbserver-agent/releases/latest/download/rhcl.RUN.THIS.APP.zip"


# Install rhcl (NIO-EUSB) client & service agent
function install() {
    # Welcome
    echo "This utility will configure NIO-EUSB client to run automatically in admin mode as user logs in"
    read -p "Continue? (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

    # Check that client is installed in system
    if test -f "$rhcl_universal_binary"
    then
        printf "\nrhcl Universal rhcl app ${GREEN}installed!${NC}\n"
        binary=$rhcl_universal_binary

    else
        printf "\nrhcl client is ${RED}not installed${NC}, downloading from ${app_link}\n"
        curl -L "${app_link}" > ~/Downloads/client_app.zip
        printf "\nMoving app to /Applications folder...\n"
        ditto -xk ~/Downloads/client_app.zip /Applications
        # delete zip file
        rm ~/Downloads/client_app.zip

        printf "\nFixing permissions...\n"
        xattr -d com.apple.quarantine /Applications/rhclUniversal.app
        sudo chown -R root /Applications/rhclUniversal.app
        sudo chmod -R 755 /Applications/rhclUniversal.app
        
        if test -f "$rhcl_universal_binary"
        then
            binary=$rhcl_universal_binary
        else
            printf "${RED}Installation unsuscessfull${NC}, try installing client manualy."
            exit 1
        fi
    fi

    # Create a folder for shared prefs if needed
    if test -d "$rhcl_config"
    then
        printf "\nConfiguration folder exists\n"
        printf "${GREEN}$rhcl_config${NC}\n"
    else
        printf "\nCreating directory for shared prefs...\n"
        printf "${GREEN}$rhcl_config${NC}\n"
        mkdir $rhcl_config
    fi

    # fix ownership for preferences folder
    sudo chmod 777 $rhcl_config

    # create preferences files with default server
    prefs_body="[General]
    MainFrameWidth=800
    MainFrameHeight=700
    AutoFind=0
    MainFrameX=100
    MainFrameY=100
    [Settings]
    ManualHubs=$server
    "

    config="${rhcl_config}/config"
    printf "Writing initial client configuration...\n\n"
    printf "${prefs_body}\n"
    echo "${prefs_body}" > $config

    # fix ownership for the preferences file
    echo "Fixing ownership for the configuration file..."
    sudo chown root $config
    sudo chmod 777 $config

    # Install LaunchAgent
    agent_body="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
    <plist version=\"1.0\">
    <dict>
            <key>Label</key>
            <string>$rhcl_agent</string>
            <key>ServiceDescription</key>
            <string>Run NIO-EUSB Universal in Admin Mode</string>
            <key>ProgramArguments</key>
            <array>
                    <string>$binary</string>
                    <string>-a</string>
                    <string>-c=$config</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
    </dict>
    </plist>
    "

    printf "\nInstalling LaunchAgent to:\n${GREEN}$launchagents/$rhcl_agent${NC}\n"
    # printf "${agent_body}"
    sudo echo "${agent_body}" > ${launchagents}/${rhcl_agent}

    # fix ownership for agent
    sudo chown root ${launchagents}/${rhcl_agent}
    sudo chmod 755 ${launchagents}/${rhcl_agent}

    printf "\nUnloading old agent if present...\n"
    # unload old agent
    launchctl unload ${launchagents}/${rhcl_agent}
    printf "\nLoading agent into system...\n\n"
    # load agent and mark as enabled
    launchctl load -w ${launchagents}/${rhcl_agent}

    printf "\nDownloading custom app to run...\n"
    curl -L "${agent_link}" > ~/Downloads/client_agent.zip
    printf "\nMoving app to /Applications folder...\n"
    ditto -xk ~/Downloads/client_agent.zip /Applications
    # delete zip file
    rm ~/Downloads/client_agent.zip

    printf "\nFixing permissions...\n"
    xattr -d com.apple.quarantine /Applications/rhcl\ RUN\ THIS\ APP.app
    sudo chown -R root /Applications/rhcl\ RUN\ THIS\ APP.app
    sudo chmod -R 755 /Applications/rhcl\ RUN\ THIS\ APP.app

    printf "\n${GREEN}Done!${NC}\n"
    printf "\nReboot your computer now.\n"
    printf "Run client in admin mode using ${GREEN}$rhcl_agent_app${NC}\n"
}

function uninstall_rhcl() {
    # Welcome
    echo "This utility will uninstall NIO-EUSB client and agent"
    read -p "Continue? (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

    # Stop any running client
    printf "\nStopping agent: ${GREEN}$rhcl_agent${NC}\n";
    launchctl stop $rhcl_agent;

    # Remove application
    printf "\nRemoving application: ${GREEN}$rhcl_universal_app${NC}\n";
    sudo rm -r ${rhcl_universal_app};

    # Remove agent application
    printf "Removing agent application: ${GREEN}$rhcl_agent_app${NC}\n";
    sudo rm -r "${rhcl_agent_app}";

    # Remove configuration
    printf "Removing configurations folder: ${GREEN}$rhcl_config${NC}\n";
    sudo rm -r ${rhcl_config};

    # Remove 42post agent
    printf "Removing rhcl agent: ${GREEN}$rhcl_agent${NC}\n";
    sudo rm "${launchagents}/${rhcl_agent}";

    printf "\nDone!"
}

function uninstall_vh() {
    # Welcome
    echo "This utility will ininstall VirtualHere client and agent"
    read -p "Continue? (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

    # Stop any running client
    printf "\nStopping agent: ${GREEN}$vh_agent${NC}";
    launchctl stop $vh_agent;
    printf "\nStopping daemon: ${GREEN}$vh_daemon${NC}\n";
    launchctl stop $vh_daemon;

    # Remove application
    printf "\nRemoving application: ${GREEN}$vh_universal_app${NC}\n";
    sudo rm -r ${vh_universal_app};

    # Remove agent application
    printf "Removing agent application: ${GREEN}$vh_agent_app${NC}\n";
    sudo rm -r "${vh_agent_app}";

    # Remove configuration
    printf "Removing configurations folder: ${GREEN}$vh_config${NC}\n";
    sudo rm -r ${vh_config};

    # Remove 42post agent
    printf "Removing VirtualHere agent: ${GREEN}$vh_agent${NC}\n";
    sudo rm "${launchagents}/${vh_agent}";

    # Remove VirtualHere daemon
    printf "Removing VirtualHere daemon: ${GREEN}$vh_daemon${NC}\n";
    sudo rm "${launchagents}/${vh_daemon}";

    printf "\nDone!\n"
}

echo "Install / uninstall USB Server client & agent"
printf "\nChoose your action:\n"
echo "1. Install rhcl (NIO-EUSB) client & agent"
echo "2. Uninstall rhcl (NIO-EUSB) client & agent"
echo "3. Uninstall VirtualHere client & agent"
echo "4. Quit"
read USER_INPUT

case $USER_INPUT in
    "1") install;;
    "2") uninstall_rhcl;;
    "3") uninstall_vh;;
    *) exit 0
esac
