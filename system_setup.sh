# Java installer PPA
apt-get update
apt-get install dirmngr -y

echo "deb http://ppa.launchpad.net/linuxuprising/java/ubuntu bionic main" | tee /etc/apt/sources.list.d/linuxuprising-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 73C3DB2A
apt-get update

# Packages required for workstation
apt-get remove $(grep -vE "^\s*#" unwanted.packages.list  | tr "\n" " ") -y
apt-get install $(grep -vE "^\s*#" packages.list  | tr "\n" " ") -y
apt-get autoremove -y

# Add ifto user to sudo 
usermod -aG sudo ifto

# Turning off auto-mounting and hiding any devices on the system
gsettings set org.gnome.desktop.media-handling automount false
python3 scripts/hide-partitions-rules.py > /etc/udev/rules.d/90-hide-partitions.rules

# Chowning some Gsettings folders to user so they can set the permission next.
# Somehow this is broken in default configs. 
chown ifto /run/user/0 -R  -v