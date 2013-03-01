#!/bin/sh

APP_NAME="Sublime Text"
APP_DIR="/Applications/User/$APP_NAME.app"
SUBLIME_DIR="$HOME/Library/Application Support/Sublime Text 3"

if [ -d "$APP_DIR" ]
then
  echo 'Sublime Text 3 application found.'
else
  echo 'Sublime Text 3 not installed. Please install it to /Applications folder first.'
  open 'http://www.sublimetext.com/3'
  exit 1
fi

# Add `subl` terminal command
command -v subl > /dev/null
if [ $? -eq 0 ]
then
  echo "Terminal command 'subl' already installed"
else
  if [ -d "$HOME/.bin" ]
  then
    CMD_PATH="$HOME/.bin"
  elif [ -d "$HOME/bin" ]
  then
    CMD_PATH="$HOME/bin"
  else
    CMD_PATH="/usr/local/bin"
  fi

  echo "Adding terminal command 'subl' into $CMD_PATH"
  ln -s "$APP_DIR/Contents/SharedSupport/bin/subl" "$CMD_PATH/subl"
fi

if [[ :$PATH: != *:"$CMD_PATH":* ]] ; then
  echo "\033[0;31m ! \033[0m $CMD_PATH NOT found in \$PATH"
fi

# Install package control
# http://wbond.net/sublime_packages/package_control/installation#ST3

if [ -d "$SUBLIME_DIR" ]
then
  echo 'Config directory found.'
else
  echo 'Creating config directory'
  open -g "$APP_DIR" && \
  sleep '0.5' && \
  osascript -e "tell application \"$APP_NAME\" to quit"
fi

if [ -d "$SUBLIME_DIR/Packages/Package Control" ]
then
  echo 'Package Control already installed.'
else
  echo 'Installing Package Control'

  git clone --quiet --branch python3 --depth 1 \
    https://github.com/wbond/sublime_package_control.git \
    "$SUBLIME_DIR/Packages/Package Control"
fi

echo 'Add default packages and configs...'

curl --silent --show-error --fail --location \
  'https://github.com/nicck/sublime-bootstrap/tarball/st3' | \
  tar --strip 1 -zxvf - *-sublime-bootstrap-*/settings > /dev/null

cp -f ./settings/* "$SUBLIME_DIR/Packages/User/"
rm -rf ./settings

echo | $CMD_PATH/subl --stay --wait - <<TXT
# Almost done

Now Sublime Text 3 installing packages and "Soda Theme"
(that's why Sublime Text 3 looks bad right now).

Packages downloading can take some time (minute or so)
please be patient.

You can press Ctrl-\` and monitor installing process.

--
https://github.com/nicck/sublime-bootstrap/tree/st3
TXT

open "$APP_DIR"
echo 'Done.'
