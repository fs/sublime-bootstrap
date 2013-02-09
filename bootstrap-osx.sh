#!/bin/sh

APP_DIR="/Applications/Sublime Text 2.app"
SUBLIME_DIR="$HOME/Library/Application Support/Sublime Text 2"

if [ -d "$APP_DIR" ]
then
  echo 'Sublime Text 2 application found.'
else
  echo 'Sublime Text 2 not installed. Please install it to /Applications folder first.'
  open 'http://www.sublimetext.com/2'
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
    APP_CMD="$HOME/.bin/subl"
  elif [ -d "$HOME/bin" ]
  then
    APP_CMD="$HOME/bin/subl"
  else
    APP_CMD="/usr/local/bin/subl"
  fi
  echo "Adding terminal command 'subl' into $APP_CMD"
  ln -s "$APP_DIR/Contents/SharedSupport/bin/subl" "$APP_CMD"
fi

# Install package control
# http://wbond.net/sublime_packages/package_control/installation

if [ -d "$SUBLIME_DIR" ]
then
  echo 'Config directory found.'
else
  echo 'Creating config directory'
  open -g "$APP_DIR" && sleep '0.5' && osascript -e 'tell application "Sublime Text 2" to quit'
fi

if [ -f "$SUBLIME_DIR/Installed Packages/Package Control.sublime-package" ]
then
  echo 'Package Control already installed.'
else
  echo 'Downloading Package Control'
  curl --silent --show-error --fail --location \
    'http://sublime.wbond.net/Package%20Control.sublime-package' \
    --output "$SUBLIME_DIR/Installed Packages/Package Control.sublime-package"
fi

echo 'Add default packages and configs...'

curl --silent --show-error --fail --location \
  'https://github.com/fs/sublime-bootstrap/tarball/master' | \
  tar --strip 1 -zxvf - fs-sublime-bootstrap*/settings > /dev/null

cp -f ./settings/* "$SUBLIME_DIR/Packages/User/"
rm -rf ./settings

echo | $APP_CMD --stay --wait - <<TXT
# Almost done

Now Sublime Text 2 installing packages and "Soda Theme"
(that's why Sublime Text 2 looks bad right now).

Packages downloading can take some time (minute or so)
please be patient.

You can press Ctrl-\` and monitor installing process.

When it's done (you should see 'Package Control: No updated packages' line)
please close Sublime Text 2 (cmd-q). ST2 will restart automatically.

--
https://github.com/fs/sublime-bootstrap
TXT

open "$APP_DIR"
echo 'Done.'
