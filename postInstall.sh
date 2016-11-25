#!/bin/bash
# Run without sudo

# Add Repos
sudo add-apt-repository -y "deb http://dl.google.com/linux/chrome/deb stable main"
sudo add-apt-repository -y ppa:webupd8team/sublime-text-2
sudo add-apt-repository -y ppa:webupd8team/java
sudo add-apt-repository -y ppa:videolan/stable-daily
sudo add-apt-repository -y ppa:jfi/psensor-unstable

# Download Eclipse
# Check if file exists, then don't redownload
if [ ! -f ~/Downloads/eclipse.tar.gz ]; then
	wget -O ~/Downloads/eclipse.tar.gz "http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/1a/eclipse-cpp-neon-1a-linux-gtk-x86_64.tar.gz&r=1"
fi
sudo tar xvzf ~/Downloads/eclipse.tar.gz -C /opt
# Create Eclipse Launcher
sudo cp eclipse.desktop ~/.local/share/applications
sudo chmod +x ~/.local/share/applications/eclipse.desktop
# Download Pydev
if [ ! -f ~/Downloads/pydev.zip ]; then
	wget -O ~/Downloads/pydev.zip "http://downloads.sourceforge.net/project/pydev/pydev/PyDev%205.3.1/PyDev%205.3.1.zip?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fpydev%2Ffiles%2F&ts=1480079950&use_mirror=internode"
fi
sudo unzip -o ~/Downloads/pydev.zip -d /opt/eclipse/dropins

# Make Sublime the default text editor
sudo sed -i -e 's/gedit/sublime-text-2/g' /etc/gnome/defaults.list

# Start Psensor on startup
sudo mkdir ~/.config/autostart
sudo cp psensor.desktop ~/.config/autostart/psensor.desktop
sudo chmod +x ~/.config/autostart/psensor.desktop

# Basic Update
sudo apt-get -y --force-yes update
sudo update-desktop-database # Refresh Launcher Apps

# Install Apps
sudo apt-get -y --allow-unauthenticated install google-chrome-stable sublime-text
sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install vlc
sudo apt-get -y install lm-sensors hddtemp
sudo sensors-detect --auto
sudo service kmod start
sudo apt-get -y install psensor
sudo apt-get -y install indicator-multiload
sudo apt-get -y install git

# Change indicator-multiload settings
dconf dump /de/mh21/indicator-multiload/ > multiloadSettingsOld.txt
sed -i -e 's/ambiance/traditional/g' multiloadSettingsOld.txt
echo -e "\n[graphs/net]\nenabled=true\n\n[graphs/disk]\nenabled=true\n\n[graphs/load]\nenabled=true\n\n[graphs/mem]\nenabled=true\n" >> multiloadSettingsOld.txt
dconf load /de/mh21/indicator-multiload/ < multiloadSettingsOld.txt

# Add Launchers
launchStr="['application://ubiquity.desktop', 'application://org.gnome.Nautilus.desktop', 'application://google-chrome.desktop', 'application://eclipse.desktop', 'application://vlc.desktop', 'application://libreoffice-writer.desktop', 'application://libreoffice-calc.desktop', 'application://org.gnome.Software.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"
gsettings set com.canonical.Unity.Launcher favorites "$launchStr"

echo "1. Turn off psensor showing at startup."
echo "2. Check that pydev is loaded correctly in eclipse."
echo "3. Restart the computer."

