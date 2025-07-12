# Uninstall rhcl client services

app="/Applications/rhclUniversal.app"
app_agent="/Applications/rhcl RUN THIS APP.app"
config="/Users/Shared/rhcl"
agent_42post="/Library/LaunchAgents/ru.42post.rhcl.admin.client.plist"

# Welcome
echo "This utility will ininstall NIO-EUSB client and services"
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

# Remove 42post agent
echo "Removing 42post agent: ${agent_42post}"
sudo rm ${agent_42post}

echo "Done!"
