# Install &amp; run NIO-EUSB client in admin mode

1. Copy these lines into Terminal and enter admin password when prompted. If there are any previous VirtualHere or rhcl (NIO-EUSB) installations, chose options 2/3 to uninstall them first! Then run the script again and install USB Client & Service Agent.

        curl -L "https://github.com/fantopop/usbserver-agent/raw/refs/heads/main/setup_usb_client.sh" > ~/Downloads/setup_usb_client.sh
        chmod a+x ~/Downloads/setup_usb_client.sh
        sudo ~/Downloads/setup_usb_client.sh

2. Accept all macOS Security prompts.
3. Reboot!
