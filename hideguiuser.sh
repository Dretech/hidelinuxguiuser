#!/bin/bash

# **********************************************************************
# This shell script hides or unhides a Linux user in the list of names
# that can login in the Graphical User Interface (GUI).

# Usage: hideguiuser username { yes | no }
# Version: 1.0

# Copyright (C) 2022 Dretech software (dretech at-sign hetnetwerk.org)

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses.
# **********************************************************************

error_message() {
   echo -e "\nusage: hideguiuser username { yes | no }"
   echo -e "\nYou must have root privileges if you want to change settings.\n"
}

if [ "$1" != "" ] && [ "$2" = "yes" -o "$2" = "no" ]
then
   path=/var/lib/AccountsService/users
   if [ -f "$path/$1" ]; then
      systemaccount=$(grep 'SystemAccount' $path/$1)
      if [ "$systemaccount" == "SystemAccount=true" ] && [ $2 == "no" ]
      then
         sed -i 's/SystemAccount=true/SystemAccount=false/g' $path/$1
      elif [ "$systemaccount" == "SystemAccount=true" ] && [ $2 == "yes" ]
      then
         echo "The GUI for user '$1' is already enabled. No settings are changed."
      elif [ "$systemaccount" == "SystemAccount=false" ] && [ $2 == "yes" ]
      then
         sed -i 's/SystemAccount=false/SystemAccount=true/g' $path/$1
      elif [ "$systemaccount" == "SystemAccount=false" ] && [ $2 == "no" ]
      then
         echo "The GUI for user '$1' is already disabled. No settings are changed."
      fi
   else
      echo -e "\nUsername '$1' does not exist. No settings are changed. Valid usernames are:"
      ls -w1 $path
      error_message
   fi
else
  error_message
fi
