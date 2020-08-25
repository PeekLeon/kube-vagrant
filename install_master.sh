#!/bin/bash

## install master for k8s

TOKEN="abcdef.0123456789abcdef"
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - install master - "$IP

echo "[0]: reset cluster if exist"
kubeadm reset -f

echo "[1]: kubadm init"
kubeadm init --apiserver-advertise-address=$IP --token="$TOKEN" --pod-network-cidr=10.244.0.0/16

echo "[2]: create config file"
mkdir $HOME/.kube
cp /etc/kubernetes/admin.conf $HOME/.kube/config

echo "[3]: create flannel pods network"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
 
echo "[4]: restart and enable kubelet"
systemctl enable kubelet
service kubelet restart

echo "[5]: Alias kubectl"
alias k='kubectl'
alias kcc='kubectl config current-context'
alias kg='kubectl get'
alias kga='kubectl get all --all-namespaces'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias ksgp='kubectl get pods -n kube-system'
alias kuc='kubectl config use-context'

echo "[6]: zsh - kagnoster"
apt-get install -y zsh -qq >/dev/null
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
chsh -s /bin/zsh root
chsh -s /bin/zsh vagrant
sed -i 's/ZSH_THEME=\".*\"/ZSH_THEME=\"kagnoster\"/g' ~/.zshrc
sed -i 's/plugins=.*/plugins=(git kubectl)/g' ~/.zshrc
cp /home/vagrant/.oh-my-zsh/themes/kagnoster.zsh-theme /root/.oh-my-zsh/themes/kagnoster.zsh-theme

echo "END - install master - " $IP
