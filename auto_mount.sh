#!/bin/sh

#  auto_mount.sh
#  
#
#  Created by Jeremiah Baker on 5/14/14.
#  Modified 5/22/14

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

dir[0]="/Volumes/$user"
dir[1]="/Volumes/Shared"
dir[2]="/Volumes/Private"
dir[3]="/Volumes/DOCS"

echo ${dir[@]}

## The mount variables are where you specify the different shares you want to mount, this can be as many as you want, but should be equal to the number of mount directories

mount[0]="/sbin/mount_smbfs //$user@va1srvgenfs01.dco-intranet.lan/Users/$user /Volumes/$user"
mount[1]="/sbin/mount_smbfs //$user@va1srvgenfs01.dco-intranet.lan/Shared /Volumes/Shared"
mount[2]="/sbin/mount_smbfs //$user@va1srvgenfs01.dco-intranet.lan/Shared/IT/Private /Volumes/Private"
mount[3]="/sbin/mount_smbfs //$user@va1srvgenfs01.dco-intranet.lan/Shared/IT/Private/DOCS /Volumes/DOCS"

echo ${mount[@]}

##########################################################
## New Section

## Function that will try to ping an internal resource, if successful, will use the arguments passed in to create the necessary mount point and mount the share
main(){
    if ping -q -c 1 dco-intranet.lan; then
        if mount | grep $1 > /dev/null; then
            echo "$1 is already mounted"
        else
            echo "$1 not mounted"
            if [ ! -d  $1 ]; then
                mkdir $1;
            else
                echo "$1 exists";
            fi
            $2
        fi
    fi
}



## Counter that will cycle through both arrays $dir and $mount and use each one as an argument for the main() function

count=0
for i in ${dir[@]};
do
    main "${dir[$count]}" "${mount[$count]}";
    echo $count;
    ((count++));
done

##########################################################

##########################################################
## OLD SECTION

## Sets a while loop so if it isn't on the network, it tries for 1 minute by pinging an internal resource

# i=1
# while [ $i -lt 12 ];
# do
#     ((i++))
#     if ping -q -c 1 INTERNAL_RESOURCE; then
#         if mount | grep $dir1 > /dev/null; then
#             echo "$dir1 is already mounted"
#         else
#             echo "$dir1 not mounted"
#             if [ ! -d  $dir1 ]; then
#                 mkdir $dir1;
#             else
#                 echo "$dir1 exists";
#             fi
#             mounts[$[${#mounts[@]}+1]]=$mount1
#         fi
#         if mount | grep $dir2 > /dev/null; then
#             echo "$dir2 is already mounted"
#         else
#             echo "$dir2 not mounted"
#             if [ ! -d  $dir2 ]; then
#                 mkdir $dir2;
#             else
#                 echo "$dir2 exists";
#             fi
#             mounts[$[${#mounts[@]}+1]]=$mount2
#         fi
#         if mount | grep $dir3 > /dev/null; then
#             echo "$dir3 is already mounted"
#         else
#             echo "$dir3 not mounted"
#             if [ ! -d  $dir3 ]; then
#                 mkdir $dir3;
#             else
#                 echo "$dir3 exists";
#             fi
#             mounts[$[${#mounts[@]}+1]]=$mount3
#         fi
#         if mount | grep $dir4 > /dev/null; then
#             echo "$dir4 is already mounted"
#         else
#             echo "$dir4 not mounted"
#             if [ ! -d  $dir4 ]; then
#                 mkdir $dir4;
#             else
#                 echo "$dir4 exists";
#             fi
#             mounts[$[${#mounts[@]}+1]]=$mount4
#         fi
#         break;
#     fi
# done
# echo ${mounts[@]};

# count=1
# for j in ${mounts[@]};
# do
#     ${mounts[$count]};
#     echo $count;
#     ((count++));
# done

# #mount_drives(){
# #    1 =
# #}
#     ## this will break the loop if it was able to successfully ping the internal resource
# #    break
# #    else
# #        sleep 5
# #        echo "Could not ping internal resource"
# #    fi
# #mount_drives($j)
# #done
##########################################################

exit 0;