#!/bin/bash
# Add tray icon to Ubuntu Unity  whitelist if needed

# Since we might run the install script under sudo we want to get the current non-root user for whitelisting
[ $SUDO_USER ] && CURRENT_USER=$SUDO_USER || CURRENT_USER=$(whoami)
SCHEMA="com.canonical.Unity.Panel"
OBJECT="systray-whitelist"
APP="YourAppName"

# Let's check if the user uses Unity
if [ ! "$(gsettings get $SCHEMA $OBJECT 2>/dev/null || echo FALSE)" = "FALSE" ]; then
  echo "Whitelisting $APP to work with Unity system-tray"
  OBJARRAY=$(sudo -u $CURRENT_USER gsettings get $SCHEMA $OBJECT | sed -s -e "s#\['##g" -e "s#', '# #g" -e "s#'\]##g")
  if [[ "${OBJARRAY[@]}" =~ "$APP" ]]; then
    echo "$APP already whitelisted, skipping"
  else
    echo "$APP not whitelisted, let's whitelist"
    OBJARRAY=("${OBJARRAY[@]}" $APP)
    OBJARRAY=$(echo ${OBJARRAY[@]} | sed -s -e "s# #', '#g")
    OBJSET="['"$OBJARRAY"']"
    sudo -u $CURRENT_USER gsettings set $SCHEMA $OBJECT "$OBJSET"
  fi
fi