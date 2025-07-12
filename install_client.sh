####################################################################
########################### 42post.ru ##############################
### install NIO-EUSB admin mode & run it on login for every user ###
############### (C) Ilya Putilin, https://42post.ru ################
####################################################################
####################################################################

# run this script with sudo
# use admin password when prompted for owmnership fix

universal=/Applications/rhclUniversal.app/Contents/MacOS/rhclUniversal
agent="ru.42post.rhcl.admin.client.plist"
launchagents="/Library/LaunchAgents"
prefs_location="/Users/Shared/rhcl"
prefs="${prefs_location}/rhcl_shared_preferences"
server="10.100.101.150:17602"
app_link="https://github.com/fantopop/usbserver-agent/releases/latest/download/rhclUniversal.zip"
agent_link="https://github.com/fantopop/usbserver-agent/releases/latest/download/rhcl.RUN.THIS.APP.zip"

# Welcome
echo "This utility will configure NIO-EUSB client to run automatically in admin mode as user logs in"
read -p "Continue? (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

# Check that client is installed in system
if test -f "$universal"
then
    echo "\nrhcl Universal app installed\n"
    binary=$universal

else
    echo "rhcl client is not installed, downloading from ${app_link}"
    curl -L "${app_link}" > ~/Downloads/client_app.zip
    echo "\nMoving app to /Applications folder..."
    ditto -xk ~/Downloads/client_app.zip /Applications
    # delete zip file
    rm ~/Downloads/client_app.zip

    echo "\nFixing permissions..."
    xattr -d com.apple.quarantine /Applications/rhclUniversal.app
    sudo chown -R root /Applications/rhclUniversal.app
    sudo chmod -R 755 /Applications/rhclUniversal.app
    binary=$universal
    # exit 1
fi

# Create a folder for shared prefs if needed
if test -d "$prefs_location"
then
    printf "$prefs_location directory exists\n"
else
    printf "Creating directory for shared prefs...\n"
    printf "$prefs_location\n"
    mkdir $prefs_location
fi

# fix ownership for preferences folder
sudo chmod 777 $prefs_location

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

printf "Writing initial client configuration...\n\n"
printf "${prefs_body}\n"
echo "${prefs_body}" > $prefs

# fix ownership for the preferences file
echo "Fixing ownership for the preferences file..."
sudo chown root $prefs
sudo chmod 777 $prefs

# Install LaunchAgent
agent_body="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
        <key>Label</key>
        <string>$agent</string>
        <key>ServiceDescription</key>
        <string>Run NIO-EUSB Universal in Admin Mode</string>
        <key>ProgramArguments</key>
        <array>
                <string>$binary</string>
                <string>-a</string>
                <string>-c=$prefs</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
</dict>
</plist>
"

printf "\nInstalling LaunchAgent to:\n${launchagents}/${agent}\n"
# printf "${agent_body}"
sudo echo "${agent_body}" > ${launchagents}/${agent}

# fix ownership for agent
sudo chown root ${launchagents}/${agent}
sudo chmod 755 ${launchagents}/${agent}

echo "\nUnloading old agent if present..."
# unload old agent
launchctl unload ${launchagents}/${agent}
echo "\nLoading agent into system...\n"
# load agent and mark as enabled
launchctl load -w ${launchagents}/${agent}

echo "\nDownloading custom app to run..."
curl -L "${agent_link}" > ~/Downloads/client_agent.zip
echo "\nMoving app to /Applications folder..."
ditto -xk ~/Downloads/client_agent.zip /Applications
# delete zip file
rm ~/Downloads/client_agent.zip

echo "\nFixing permissions..."
xattr -d com.apple.quarantine /Applications/rhcl\ RUN\ THIS\ APP.app
sudo chown -R root /Applications/rhcl\ RUN\ THIS\ APP.app
sudo chmod -R 755 /Applications/rhcl\ RUN\ THIS\ APP.app

echo "\nDone! Reboot your computer now."
echo "\nRun client in admin mode using Applications/rhcl RUN THIS APP.app"
