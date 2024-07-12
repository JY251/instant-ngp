for pkg in build-essential git python3-dev python3-pip libopenexr-dev libxi-dev libglfw3-dev libglew-dev libomp-dev libxinerama-dev libxcursor-dev; do
    if dpkg -l | grep -q "^ii  $pkg"; then
        echo "$pkg is installed."
    else
        echo "$pkg is NOT installed."
    fi
done

# OK