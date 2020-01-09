# don't blame me
#           -Kai
# this is what Docker runs to build the container

ARG UBUNTU_VERSION=18.04
#FROM ubuntu:${UBUNTU_VERSION} as base
#RUN apt-get update && apt-get install -y curl

ARG ARCH=
ARG CUDA=10.0
FROM nvidia/cuda${ARCH:+-$ARCH}:${CUDA}-base-ubuntu${UBUNTU_VERSION} as base
# ARCH and CUDA are specified again because the FROM directive resets ARGs
# (but their default value is retained if set previously)
ARG ARCH
ARG CUDA
ARG CUDNN=7.6.2.24-1

# Needed for string substitution
SHELL ["/bin/bash", "-c"]
# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-${CUDA/./-} \
        cuda-cublas-${CUDA/./-} \
        cuda-cufft-${CUDA/./-} \
        cuda-curand-${CUDA/./-} \
        cuda-cusolver-${CUDA/./-} \
        cuda-cusparse-${CUDA/./-} \
        curl \
        libcudnn7=${CUDNN}+cuda${CUDA} \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        pkg-config \
        software-properties-common \
        unzip

RUN apt-get install -y git python3-pip

RUN pip3 install --upgrade pip
RUN apt-get install -y protobuf-compiler python-pil python-lxml python-scipy

RUN pip3 install tensorflow-gpu==2.0.0 && \
    pip3 install numpy pandas scipy sklearn matplotlib seaborn jupyter pyyaml h5py && \
    pip3 install keras --no-deps && \
    pip3 install imutils && \
    pip3 install Pillow && \
    pip3 install awscli && \
    #pip3 install tensorflow-gpu && \
    apt-get install unzip

RUN apt-get install -y --no-install-recommends wget

RUN [ ${ARCH} = ppc64le ] || (apt-get update && \
        apt-get install -y --no-install-recommends libnvinfer5=5.1.5-1+cuda${CUDA} \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*)

# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Link the libcuda stub to the location where tensorflow is searching for it and reconfigure
# dynamic linker run-time bindings
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 \
    && echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf \
    && ldconfig

RUN mkdir -p /tf/demo-horsemans && chmod -R a+rwx /tf/

COPY /project /tf/demo-horsemans

RUN mkdir /.local && chmod a+rwx /.local

RUN apt-get autoremove -y && apt-get remove -y wget
WORKDIR /tf

EXPOSE 8888

RUN python3 -m ipykernel.kernelspec

#CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/tf", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
CMD ["bash", "-c", "source /etc/bash.bashrc && jupyter notebook --notebook-dir=/tf --ip 0.0.0.0 --port=8888 --no-browser --allow-root"]
