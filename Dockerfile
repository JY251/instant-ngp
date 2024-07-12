FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu20.04

RUN apt-get update

# # Set the timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime 

RUN apt-get install -y build-essential git python3-dev python3-pip libopenexr-dev libxi-dev \
										libglfw3-dev libglew-dev libomp-dev libxinerama-dev libxcursor-dev wget
RUN	rm -rf /var/lib/apt/lists/*

# Install CMake 3.21.4 (CMake must be newer than 3.18 for instant-ngp)
RUN wget https://github.com/Kitware/CMake/releases/download/v3.21.4/cmake-3.21.4-linux-x86_64.sh \
    && chmod +x cmake-3.21.4-linux-x86_64.sh \
    && ./cmake-3.21.4-linux-x86_64.sh --skip-license --prefix=/usr/local \
    && rm cmake-3.21.4-linux-x86_64.sh

RUN git clone --recursive https://github.com/nvlabs/instant-ngp

# ENV HOME /root
RUN export PATH="/usr/local/cuda-12.1/bin:$PATH" >> ~/.bashrc
RUN LD_LIBRARY_PATH="/usr/local/cuda-12.1/lib64:$LD_LIBRARY_PATH" >> ~/.bashrc

RUN cd instant-ngp && cmake . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo
RUN cd instant-ngp && cmake --build build --config RelWithDebInfo -j

# NOTE:
# `[ 60%] Building CUDA object dependencies/tiny-cuda-nn/CMakeFiles/tiny-cuda-nn.dir/src/fully_fused_mlp.cu.o` might takes a long time.