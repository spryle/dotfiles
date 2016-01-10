# Default applications
set -xU EDITOR "vim"
set -xU BROWSER "google-chrome"

# HiDPI
set -xU QT_DEVICE_PIXEL_RATIO 2
set -xU GDK_QT_DEVICE_PIXEL_RATIO 2
set -xU GDK_SCALE 2

# Encoding
set -xU LANG en_US.UTF-8
set -xU LC_ALL en_US.UTF-8

set -xU DOCKER_HOST tcp://localhost:4243

# $PATH's
set PATH $HOME/.bin $PATH
set PATH $HOME/.local/bin $PATH

# Fishmarks (http://github.com/techwizrd/fishmarks)
. $HOME/.fishmarks/marks.fish

set fish_greeting ""

# Powerline (http://powerline.readthedocs.org/en/master/index.html)
set fish_function_path $fish_function_path "$HOME/.local/lib/python2.7/site-packages/powerline/bindings/fish"
powerline-setup
