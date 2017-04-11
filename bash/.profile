PATH=$PATH:$HOME/.bin:$HOME/.local/bin
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
n v6.9.1
