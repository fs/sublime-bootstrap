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
if [ $(which subl > /dev/null) ]
then
  echo '`subl` terminal command already installed'
else
  if [ -d "$HOME/.bin" ]
  then
    ln -s "$APP_DIR/Contents/SharedSupport/bin/subl" "$HOME/.bin/subl"
  else
    ln -s "$APP_DIR/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
  fi
fi

# Install package control
# http://wbond.net/sublime_packages/package_control/installation

if [ -d "$SUBLIME_DIR" ]
then
  echo 'Config directory found.'
else
  echo 'Creating config directory'
  subl --background && sleep '0.5' && osascript -e 'tell application "Sublime Text 2" to quit'
fi

if [ -f "$SUBLIME_DIR/Installed Packages/Package Control.sublime-package" ]
then
  echo 'Package Control already installed.'
else
  echo 'Downloading Package Control'
  curl --silent --show-error 'http://sublime.wbond.net/Package%20Control.sublime-package' --output "$SUBLIME_DIR/Installed Packages/Package Control.sublime-package"
fi

echo 'Add default packages and configs...'

# consider replacing by `cp settings/* $SUBLIME_DIR/Packages/User/'
cp -f "settings/Preferences.sublime-settings" \
      "settings/Package Control.sublime-settings" \
      "settings/Default (OSX).sublime-keymap" \
      "$SUBLIME_DIR/Packages/User/"

echo | subl --wait <<TXT
# Almost done

Now Sublime Text 2 installing packages and "Soda Theme"
(that's why Sublime Text 2 looks bad right now).

Packages downloading can take some time (minute or so)
please be patient.

You can press Ctrl-\` and monitor installing process.

When it's done (you should see 'Package Control: No updated packages' line)
please close Sublime Text 2 (cmd-q). ST2 will restart automatically.

--
nicck
TXT

subl ./
