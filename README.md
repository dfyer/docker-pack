# How-to-Use the NVIDIA-docker

1. Install docker

2. Install nvidia-docker

https://github.com/NVIDIA/nvidia-docker

3. (Optional) Modify the Dockerfile for further use

4. Build docker

nvidia-docker build .

5. Start a container

docker run --privileged -d --restart=always --hostname=<hostname> \
    --name=<cont_name> -p <ssh_port>:22 \
    -v /shared/test:/shared/test:ro \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro <image_name>
