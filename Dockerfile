FROM trzeci/emscripten:latest

# Update distro and install essentials
RUN apt-get -y install bzip2 \
    wget \
    bzip2 \
    sed \
    unzip

RUN cd /usr

# Get latest opencv
RUN wget https://github.com/opencv/opencv/archive/3.4.0.zip && \
    unzip 3.4.0.zip && \
    cd opencv-3.4.0 && \
    python ./platforms/js/build_js.py build_wasm --build_wasm

# Install dlib
RUN wget http://dlib.net/files/dlib-19.17.tar.bz2 && \
    tar xvf dlib-19.17.tar.bz2 && \
    cd dlib-19.17/ && \
    sed -i '404 d' dlib/image_processing/shape_predictor.h
    mkdir build && \
    cd build && \
    cmake .. && \
    cmake --build . --config Release && \
    make install && \
    ldconfig && \
    cd ..

WORKDIR /usr/src/app

RUN cd /usr/src/app

RUN wget http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2 && \
    bzip2 -d -v shape_predictor_68_face_landmarks.dat.bz2 && \
    wget https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_frontalface_alt2.xml

RUN cd /usr/src/app
