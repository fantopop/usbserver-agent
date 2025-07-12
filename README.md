# Install &amp; run NIO-EUSB client in admin mode

1. Copy these lines into Terminal and enter admin password when prompted. If there are any previous VirtualHere or rhcl (NIO-EUSB) installations, chose options 2/3 to uninstall them. Then run the script again and install USB Client & Service Agent.

        curl -L "https://github.com/fantopop/usbserver-agent/raw/refs/heads/main/install_client.sh" > ~/Downloads/install_client.sh
        chmod a+x ~/Downloads/install_client.sh
        sudo ~/Downloads/install_client.sh

2. Accept all macOS Security prompts.
3. Reboot!
