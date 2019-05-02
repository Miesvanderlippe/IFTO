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
python3 ./scripts/hide-partitions.rules.py | tee /etc/udev/rules.d/90-hide-partitions.rules

# Chowning some Gsettings folders to user so they can set the permission next.
# Somehow this is broken in default configs. 
chown ifto /run/user/0 -R  -v

# Setting the Java Home var for Autopsy
echo 'JAVA_HOME="/usr/lib/jvm/java-11-oracle"' >> /etc/environment
source /etc/environment

# Sleuthkit 
wget https://github.com/sleuthkit/autopsy/releases/download/autopsy-4.6.0-linux1/sleuthkit-java_4.6.0-1_amd64.deb
dpkg -i sleuthkit-java_4.6.0-1_amd64.deb
rm sleuthkit-java_4.6.0-1_amd64.deb

## Autopsy
current_pwd=pwd
autopsy_dir="/home/ifto/Autopsy"

mkdir $autopsy_dir

wget https://github.com/sleuthkit/autopsy/releases/download/autopsy-4.6.0-linux1/autopsy-4.6.0-linux1.zip
unzip autopsy-4.6.0-linux1.zip -d $autopsy_dir
rm autopsy-4.6.0-linux1.zip

cd $autopsy_dir
sh unix_setup.sh

cd $current_pwd

wget https://gist.githubusercontent.com/Miesvanderlippe/3ee596297d5f9af6d393ae91daa2d81c/raw/4951f6a1331d7c4cc91fdd577dc04f32f9f0cf0c/autopsy.desktop -O /usr/share/applications/autopsy.desktop
