#!/bin/sh

#  auto_mount.sh
#  
#
#  Created by Jeremiah Baker on 5/14/14.
#

##########################################################
## This script is intended for Macs bound to an Active Directory with Network accounts
## It is meant to be used as a LaunchAgent and should be able to work for any and all users
##
## In order to not have to specify passwords in plain text, the machine must be bound to the same domain you are trying to mount network shares on
##
##
##########################################################

## First gets the logged in user to use for authentication
user=`logname`

## The directory variables are where the network shares will be mounted, this can be as many as you want, but should be equal to the number of network mounts
## $dir1 will only work properly if your login name is the same as your network shares. This is typically the case with computers that are on a domain

dir1=/Volumes/$user
dir2=/Volumes/Shared
dir3=/Volumes/Private
dir4=/Volumes/DOCS

## The mount variables are where you specify the different shares you want to mount, this can be as many as you want, but should be equal to the number of mount directories

mount1="/sbin/mount_smbfs //$user@va1srvgenfs01.dco-intranet.lan/Users/$user /Volumes/$user"
mount2="/sbin/mount_smbfs //$user@va1srvgenfs01.dco-intranet.lan/Shared /Volumes/Shared"
mount3="/sbin/mount_smbfs //$user@va1srvgenfs01.dco-intranet.lan/Shared/IT/Private /Volumes/Private"
mount4="/sbin/mount_smbfs //$user@va1srvgenfs01.dco-intranet.lan/Shared/IT/Private/DOCS /Volumes/DOCS"


## Sets a while loop so if it isn't on the network, it tries for 1 minute by pinging an internal resource

i=1
while [ $i -lt 12 ];
do
    ((i++))
    if ping -q -c 1 INTERNAL_RESOURCE; then
        if mount | grep $dir1 > /dev/null; then
            echo "$dir1 is already mounted"
        else
            echo "Share not mounted"
            if [ ! -d  $dir1 ]; then
                mkdir $dir1;
            else
                echo "$dir1 exists";
            fi
            mounts[$[${#mounts[@]}+1]]=$mount1
        fi
        if mount | grep $dir2 > /dev/null; then
            echo "$dir2 is already mounted"
        else
            echo "Share not mounted"
            if [ ! -d  $dir2 ]; then
                mkdir $dir2;
            else
                echo "$dir2 exists";
            fi
            mounts[$[${#mounts[@]}+1]]=$mount2
        fi
        if mount | grep $dir3 > /dev/null; then
            echo "$dir3 is already mounted"
        else
            echo "Share not mounted"
            if [ ! -d  $dir3 ]; then
                mkdir $dir3;
            else
                echo "$dir3 exists";
            fi
            mounts[$[${#mounts[@]}+1]]=$mount3
        fi
        if mount | grep $dir4 > /dev/null; then
            echo "$dir4 is already mounted"
        else
            echo "Share not mounted"
            if [ ! -d  $dir4 ]; then
                mkdir $dir4;
            else
                echo "$dir4 exists";
            fi
            mounts[$[${#mounts[@]}+1]]=$mount4
        fi
        break;
    fi
done
echo ${mounts[@]};

count=1
for i in ${mounts[@]};
do
    ${mounts[$count]};
    echo $count;
    ((count++));
done

#mount_drives(){
#    1 =
#}
    ## this will break the loop if it was able to successfully ping the internal resource
#    break
#    else
#        sleep 5
#        echo "Could not ping internal resource"
#    fi
#mount_drives($j)
#done
exit 0;