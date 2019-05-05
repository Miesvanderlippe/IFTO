# IFTO portable workstation 

The purpose of this script is to transform a Debian 9 install to a portable workstation for basic forensic task. This is a school exercise and shouldn't be used for anything but educational use. 

## The setup 

This script is supposed to run on a VM which then can later be cloned to a thumbdrive. It relies on the user being called 'ifto'. 

After installation, run the following commands on the guest; 

```
su
apt-get install git
git clone https://github.com/Miesvanderlippe/IFTO.git
```

## Running the script

Go to the cloned directry and run as root, on the guest;

```
sh system_setup.sh | tee log.txt
```

It may be wise to reboot the system now. 

## Take away some persistency

In order to take away some of the cross-contamination risk we can make the home-dir a tmpfs mount. 

As root run; 

```
mkdir /home_source
crontab -e 
```

Add the following line; 

> @reboot cp -a /home_source/* /home

Then; 

```
nano /etc/fstab
```

And add;

> tmpfs   /home   tmpfs   rw,nosuid,nodev,noatime 0 0

Lastly, copy the original home-dir contents to the persistent home_source; 

```
cp -rp /home/* /home_source
```

## Cloning the VM

On the host, run the following commands

```
sudo vmware-mount -f -r [path to vmdk] [path to mountpoint]
sudo dd if=[path to mountpoint] of=[/dev/sdX]
```
