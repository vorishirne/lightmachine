#!/bin/sh

USERNAME=${USERNAME:-velcrine}
PASSWORD=${PASSWORD:-" "}

groupadd -g ${DOCKERGROUP} dockerengine
groupadd -g ${RENDERGROUP} render
useradd -u 1000 -d /home/$USERNAME -G sudo,dockerengine,render,audio,video -m -p "$(openssl passwd -1 "$PASSWORD")" -s /bin/bash $USERNAME

service ssh start

set +e
pushd /
git add -A 2>/dev/null
git commit -am "init" 2>/dev/null
popd
set -e

cd /home/$USERNAME