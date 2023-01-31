# Pull ---
docker pull pytorch/pytorch:1.12.1-cuda11.3-cudnn8-runtime
docker pull quay.io/qiime2/core:2022.11

# run image with certain setup ----

docker run -it -m 60G --gpus=all --name NAAM \
-v D:/docker_share_D:/data/docker_qiime2_share_container_D \
-v E:/docker_qiime2_E/data/docker_qiime2_share_container_E \
-v F:/docker_share_F:/data/docker_qiime2_share_container_F \
-p 80:80 pytorch/pytorch:1.12.1-cuda11.3-cudnn8-runtime /bin/bash

# setup OPTIONAL----

pip install jupyter -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install jupyter_contrib_nbextensions -i https://pypi.tuna.tsinghua.edu.cn/simple
jupyter contrib nbextension install --user

pip install ipython -i https://pypi.tuna.tsinghua.edu.cn/simple

$ ipython

    from notebook.auth import passwd

    passwd()

    'argon2:$argon2id$v=19$m=10240,t=10,p=8$2ENvg6zjYaYxuOnHqxeShg$lBmZl8JTjMkegE2wPjA8aOv+m3PvJdhL634Fxwyp2QE'

    exit()

# source bionic OPTIONAL ----
cp /etc/apt/sources.list /etc/apt/sources.list.bak

sed -i 's/.*//' /etc/apt/sources.list

apt-get install apt-transport-https

echo "deb https://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

# deb https://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" | tee -a /etc/apt/sources.list


apt update
apt install vim
apt-get install screen

# jupy set ----
jupyter notebook --generate-config --allow-root

vi ~/.jupyter/jupyter_notebook_config.py

vim ~/.jupyter/jupyter_notebook_config.py
# into ~/.jupyter/jupyter_notebook_config.py ----
c.NotebookApp.ip = '*'

c.NotebookApp.password =u'argon2:$argon2id$v=19$m=10240,t=10,p=8$2ENvg6zjYaYxuOnHqxeShg$lBmZl8JTjMkegE2wPjA8aOv+m3PvJdhL634Fxwyp2QE'

c.NotebookApp.open_browser = False

c.NotebookApp.port = 80

# exec ----
docker exec -it c4311f036c31 /bin/bash

# open in browser
