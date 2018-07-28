# kicad-docker

## Usage:

    xhost +local:root; \
    docker run -d \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v $HOME:/root:rw \
    ebenolson/kicad:5.0.0 \
    kicad
