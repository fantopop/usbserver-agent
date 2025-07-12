# usbserver-agent
Install &amp; run NIO-EUSB client in admin mode

1. Delete any previous VirtualHere client installation if needed:

        curl -L "https://github.com/fantopop/usbserver-agent/raw/refs/heads/main/uninstall_virtualhere_services.sh" > ~/Downloads/uninstall_virtualhere_services.sh
        chmod a+x ~/Downloads/uninstall_virtualhere_services.sh
        sudo ~/Downloads/uninstall_virtualhere_services.sh

1. Download install script and and run with sudo:

        curl -L "https://github.com/fantopop/usbserver-agent/raw/refs/heads/main/install_client.sh" > ~/Downloads/install_client.sh
        chmod a+x ~/Downloads/install_client.command
        sudo ~/Downloads/install_client.command

4. Accept all macOS Security prompts.
5. Reboot!
