# Uninstall virtualhere client services

app="/Applications/VirtualHereUniversal.app"
app_agent="/Applications/VirtualHere RUN THIS APP.app"
config="/Users/Shared/VirtualHere"
agent_42post="/Library/LaunchAgents/ru.42post.virtualhere.admin.plist"
agent_virtualhere="/Library/LaunchDaemons/com.virtualhere.vhclient.plist"

# Welcome
echo "This utility will ininstall VirtualHere client and services"
read -p "Continue? (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

# Remove application
echo "Removing application: ${app}"
sudo rm -r ${app}

# Remove application
echo "Removing agent application: ${app_agent}"
sudo rm -r "${app_agent}"

# Remove configuration
echo "Removing configurations: ${config}"
sudo rm -r ${config}

# Remove VirtualHere agent
echo "Removing VirtualHere agent: ${agent_virtualhere}"
sudo rm ${agent_virtualhere}

# Remove 42post agent
echo "Removing 42post agent: ${agent_42post}"
sudo rm ${agent_42post}

echo "Done!"
