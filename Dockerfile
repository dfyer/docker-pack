FROM nvidia/cuda:8.0-cudnn5-devel
MAINTAINER hgpark@kdb.snu.ac.kr

# Change timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime    \

# Set local
    && locale-gen en_US.UTF-8       \
    && apt-get update               \
    && apt-get install -y           \
        software-properties-common  \
        wget                        \
        sudo                        \

# Install necessary tools
    && apt-get update       \
    && apt-get install -y   \
        apt-transport-https \
        curl                \
        git                 \
        openssh-server      \
        python-dev          \
        python-pip          \
        tmux                \
        vim                 

# Add hgpark user
RUN useradd -m -u 12345 -d /home/hgpark/ hgpark              \
    && chsh -s /bin/bash hgpark                                 \
    && echo "hgpark:$(openssl rand -base64 20)" | chpasswd      \
    && echo "hgpark ALL=NOPASSWD: ALL" > /etc/sudoers.d/hgpark  \

# Run SSH server
    && mkdir /var/run/sshd                                                                                 \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

USER hgpark
RUN echo "export PATH=/usr/local/nvidia/bin:\$PATH" >> /home/hgpark/.bashrc    \
    && echo "export LD_LIBRARY_PATH=\"/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda/lib64:/usr/local/lib:/usr/local/cuda/extras/lib64:\$LD_LIBRARY_PATH\"" >> /home/hgpark/.bashrc    \
    && echo "export CUDA_HOME=/usr/local/cuda" >> /home/hgpark/.bashrc

USER root

# FIX: enable ipython notebook
RUN pip install --upgrade "ipython[notebook]"

# Install tensorflow
RUN export TF_BINARY_URL=https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-0.12.0rc0-cp27-none-linux_x86_64.whl \
    && pip install --upgrade $TF_BINARY_URL
RUN ln -sf /usr/lib/x86_64-linux-gnu/libcudnn.so.4 /usr/lib/x86_64-linux-gnu/libcudnn.so    \
    && ln -sf /usr/local/nvidia/lib64/libcuda.so.361.45.11 /usr/local/lib/libcuda.so

# Ports
EXPOSE 22


CMD ["/usr/sbin/sshd", "-D", "-E", "/var/log/sshd"]
