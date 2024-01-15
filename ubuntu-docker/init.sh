#!/bin/bash
groupadd -g ${PGID} ${USERNAME} \
            && useradd -u ${PUID} -g ${USERNAME} -d /home/${USERNAME} ${USERNAME} \
            && mkdir /home/${USERNAME} \
            && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

echo "${USERNAME}  ALL=(ALL)       NOPASSWD: ALL" | tee -a /etc/sudoers > /dev/null
sed -i "s:^Defaults\tsecure_path:#Defaults\tsecure_path:g" /etc/sudoers

# register username and email
git config user.email > /dev/null || git config --global user.email "you@example.com"
git config user.name > /dev/null || git config --global user.name "Your Name"

echo ""
echo "Welcome to $DISTRO $VERSION builder"
echo ""

echo "export LANG=en_US.UTF-8" > /home/${USERNAME}/.bash_profile
su - ${USERNAME}
