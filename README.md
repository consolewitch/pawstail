
sudo apt-get install git python pip build-essential libssl-dev libffi-dev python-dev
sudo pip install ansible 

  git config --global user.email "you@example.com"
    git config --global user.name "Your Name"


ANSIBLE_HOST=localhost ANSIBLE_GROUPS=workstation ansible-playbook ./site.yml -vv -i ./dynamic.py


