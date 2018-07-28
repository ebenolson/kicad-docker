FROM ubuntu:18.04
LABEL Maintainer="Eben Olson <eben.olson@gmail.com>"

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    subversion \
    cmake \
    swig3.0 \
    libgtk2.0-dev \
    libboost-all-dev \
    libglew-dev \
    libglm-dev \
    freeglut3-dev \ 
    libcairo2-dev \
    python-dev \
    libcurl4-openssl-dev \
    liboce-ocaf-dev \ 
    libssl-dev \
    bison \
    flex

WORKDIR /tmp
RUN git clone https://github.com/wxWidgets/wxWidgets.git
WORKDIR ./wxWidgets
RUN git checkout v3.0.2 && ./configure && make && make install

WORKDIR /tmp
RUN git clone https://github.com/wxWidgets/wxPython.git
WORKDIR ./wxPython
RUN git checkout wxPy-3.0.2.0 
RUN ./configure
WORKDIR ./wxPython
RUN ./bin/subrepos-make
RUN CFLAGS=-Wno-format-security python build-wxpython.py --install --no_wxbuild --build_dir=../bld

WORKDIR /tmp
RUN git clone https://github.com/KiCad/kicad-source-mirror.git
WORKDIR ./kicad-source-mirror
RUN git checkout ${KICAD_COMMIT:-5.0.0}
WORKDIR ./scripts
RUN chmod +x get_libngspice_so.sh
RUN ./get_libngspice_so.sh && ./get_libngspice_so.sh install

RUN ldconfig

WORKDIR /tmp/kicad-source-mirror
RUN cmake DCMAKE_BUILD_TYPE=Release -DKICAD_SCRIPTING_ACTION_MENU=ON .
RUN make && make install
