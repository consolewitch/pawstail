
sudo apt-get install git python pip build-essential libssl-dev libffi-dev python-dev
sudo pip install ansible 

note: the vault file is not committed to github. It can be found in the secrets archive.

  git config --global user.email "you@example.com"
    git config --global user.name "Your Name"


ANSIBLE_HOST=localhost ANSIBLE_GROUPS=workstation ansible-playbook ./site.yml -vv -i ./dynamic.py -K


