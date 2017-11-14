FROM nvidia/cuda:8.0-cudnn7-devel-ubuntu16.04

MAINTAINER Alvaro Antelo <alvaro.antelo@gmail.com>

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        ffmpeg \
        git \
        libfreetype6-dev \
        pkg-config \
        python \
        python-dev \
        software-properties-common \
        sudo \
        unzip \
    	wget \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install \
        Pillow \
        h5py \
        numpy \
        scikit-image \
        scipy \
        cffi \
        http://download.pytorch.org/whl/cu80/torch-0.2.0.post3-cp27-cp27mu-manylinux1_x86_64.whl \
        torchvision

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
	apt install -y git-lfs && \
	git lfs install

RUN git clone https://github.com/torch/distro.git /torch --recursive && \
        cd /torch && \
        bash install-deps && \
        ./install.sh

RUN git clone https://bitbucket.org/arthurchau10/slow-motion && \
        cd slow-motion && \
	    git pull && \
        chmod +x install.bash && \
        bash install.bash && \
       	mkdir -p /input && \
    	mkdir -p /output

WORKDIR "/slow-motion"

ENTRYPOINT ["python", "./main.py"]

CMD ["-h"]
