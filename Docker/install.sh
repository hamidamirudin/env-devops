yum install yum-utils -y
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
yum install git -y
yum install nano -y 
cp Config/daemon.json /etc/docker/daemon.json
systemctl start docker 
docker network create docker-net
