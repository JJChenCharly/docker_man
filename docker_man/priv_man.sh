# Pull ---
docker pull pytorch/pytorch:1.12.1-cuda11.3-cudnn8-runtime
docker pull quay.io/qiime2/core:2022.11

# run image with certain setup ----

docker run -it -m 60G --gpus=all --name NAAM \
-v D:/docker_share_D:/data/docker_qiime2_share_container_D \ # setup mount and shared folder
-v E:/docker_qiime2_E：/data/docker_qiime2_share_container_E \
-v F:/docker_share_F:/data/docker_qiime2_share_container_F \
-p 80:80 pytorch/pytorch:1.12.1-cuda11.3-cudnn8-runtime /bin/bash

# source bionic OPTIONAL!!!!!!!!! ----
# https://developer.aliyun.com/mirror/

# back up source list
cp /etc/apt/sources.list /etc/apt/sources.list.bak 

# clean current source list
sed -i 's/.*//' /etc/apt/sources.list
# or
echo "" > /etc/apt/sources.list

# some containers may need this
apt-get install apt-transport-https

# some source may need new key
apt-get install gnupg
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32

# write in new sources
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

# some normal set up
apt update
apt upgrade

apt install vim
apt-get install screen

# setup for jupyter ----
# you may not need every thing if you already have them
apt install python3
apt-get install python3-pip

pip install jupyter -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install jupyter_contrib_nbextensions -i https://pypi.tuna.tsinghua.edu.cn/simple
jupyter contrib nbextension install --user

pip install ipython -i https://pypi.tuna.tsinghua.edu.cn/simple

# input ipython in prompt and start ipython interface
$ ipython

    from notebook.auth import passwd

    passwd()
       
    # after input your own password and confirm, system will pring this copy and keep it somewhere
    'argon2:$argon2id$v=19$m=10240,t=10,p=8$2ENvg6zjYaYxuOnHqxeShg$lBmZl8JTjMkegE2wPjA8aOv+m3PvJdhL634Fxwyp2QE'

    exit()

# jupy set ----
# create .config
jupyter notebook --generate-config --allow-root

# edit with one of this
vi ~/.jupyter/jupyter_notebook_config.py
vim ~/.jupyter/jupyter_notebook_config.py

# write these into ~/.jupyter/jupyter_notebook_config.py ----
c.NotebookApp.ip = '*'

# replace entire string after u with the string you get after input password in ipython step
c.NotebookApp.password =u'argon2:$argon2id$v=19$m=10240,t=10,p=8$2ENvg6zjYaYxuOnHqxeShg$lBmZl8JTjMkegE2wPjA8aOv+m3PvJdhL634Fxwyp2QE'

c.NotebookApp.open_browser = False

c.NotebookApp.port = 80

# exec ----
docker exec -it c4311f036c31 /bin/bash

# `jupyter notebook --allow-root` and then open in browser
