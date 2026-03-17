profileDir="wjdkjjdw.default-release"
dir="$HOME/Library/Application Support/Firefox/Profiles/$profileDir/chrome"

git -C "$dir" fetch --all && git -C "$dir" pull
