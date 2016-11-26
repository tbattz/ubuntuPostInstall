#!/bin/bash
# Run without sudo

# Add Repos
echo " ================================= Adding PPAs ================================= "
#sudo add-apt-repository -y "deb http://dl.google.com/linux/chrome/deb stable main"
#sudo add-apt-repository -y ppa:webupd8team/sublime-text-2
#sudo add-apt-repository -y ppa:webupd8team/java
#sudo add-apt-repository -y ppa:videolan/stable-daily
#sudo add-apt-repository -y ppa:jfi/psensor-unstable
#sudo add-apt-repository -y ppa:pinta-maintainers/pinta-stable
#sudo add-apt-repository -y ppa:lyx-devel/release

# Download Eclipse
# Check if file exists, then don't redownload
echo " =================================== Eclipse =================================== "
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

# Texmaker install
echo " ================================== Texmaker ================================== "
if [ ! -f ~/Downloads/texmaker.deb ]; then
	wget -O ~/Downloads/texmaker.deb "http://www.xm1math.net/texmaker/texmaker_ubuntu_16.04_4.5_amd64.deb"
fi
sudo dpkg -i ~/Downloads/texmaker.deb

# Lyx install
echo " ==================================== Lyx ===================================== "
#sudo apt-get remove lyx
#sudo apt-get autoremove

# Make Sublime the default text editor
echo " ============================== Program Defaults ============================== "
sudo sed -i -e 's/gedit/sublime-text-2/g' /etc/gnome/defaults.list

# Start Psensor on startup
echo " =============================== PSensor Startup ============================== "
sudo mkdir ~/.config/autostart
sudo cp psensor.desktop ~/.config/autostart/psensor.desktop
sudo chmod +x ~/.config/autostart/psensor.desktop

# Basic Update
echo " ================================ Basic Update ================================ "
sudo apt-get -y --force-yes update
#sudo apt-get -y dist-upgrade
sudo update-desktop-database # Refresh Launcher Apps

# Install Apps
echo " ============================== App Installation ============================== "
sudo apt-get -y --allow-unauthenticated install google-chrome-stable sublime-text
sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install vlc
sudo apt-get -y install lm-sensors hddtemp
sudo sensors-detect --auto
sudo service kmod start
sudo apt-get -y install psensor
sudo apt-get -y install indicator-multiload
sudo apt-get -y install git
sudo apt-get -y install bmon htop byobu sl
sudo apt-get -y install vnstat vnstati
sudo apt-get -y install pinta
sudo apt-get -y install lyx
sudo apt-get -f -y install

# Change indicator-multiload settings
echo " ========================== System Monitor Settings ========================== "
dconf dump /de/mh21/indicator-multiload/ > multiloadSettingsOld.txt
sed -i -e 's/ambiance/traditional/g' multiloadSettingsOld.txt
echo -e "\n[graphs/net]\nenabled=true\n\n[graphs/disk]\nenabled=true\n\n[graphs/load]\nenabled=true\n\n[graphs/mem]\nenabled=true\n" >> multiloadSettingsOld.txt
dconf load /de/mh21/indicator-multiload/ < multiloadSettingsOld.txt

# Setup vnstat bandwidth monitoring
echo " ============================= vnstat Monitoring ============================= "
sudo vnstat -u -i wlp2s0
sudo vnstat -u -i enp0s31f6
sudo /etc/init.d/vnstat start
sudo cp rc.local /etc/rc.local
sudo chown $SUDO_USER -R vnstat:vnstat /var/lib/vnstat

# Add Launchers
echo " ============================== Setup Launcher =============================== "
launchStr="['application://ubiquity.desktop', 'application://org.gnome.Nautilus.desktop', 'application://google-chrome.desktop', 'application://eclipse.desktop', 'application://vlc.desktop', 'application://texmaker.desktop', 'application://libreoffice-writer.desktop', 'application://libreoffice-calc.desktop', 'application://org.gnome.Software.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"
gsettings set com.canonical.Unity.Launcher favorites "$launchStr"

echo " ================================== Finished ================================= "
echo "1. Turn off psensor showing at startup."
echo "2. Change/create terminal profile."
echo "3. Check that pydev is loaded correctly in eclipse."
echo "4. Set git user and email."
echo "5. Restart the computer."

