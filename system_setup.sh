# Java installer PPA
echo "deb http://ppa.launchpad.net/linuxuprising/java/ubuntu bionic main" | tee /etc/apt/sources.list.d/linuxuprising-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 73C3DB2A
apt-get update

# Packages required for workstation
apt-get install $(grep -vE "^\s*#" packages.list  | tr "\n" " ")

# Add ifto user to sudo 
usermod -aG sudo ifto

