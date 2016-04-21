#!/bin/bash

PS3="Choose image suffix: "
QUIT=".QUIT."; touch "$QUIT"

select image_suffix in sshd:debian sshd:alpine dev-env:debian dev-env:alpine; do
  case $image_suffix in
        "$QUIT")
          echo "Exiting."
          break
          ;;
        *)
          echo "You picked: $REPLY. $FILENAME"
          ;;
  esac
done; rm "$QUIT"; image_suffix="${image_suffix:sshd:alpine}

set -x

IMAGE="elifarley/docker$image_suffix"

project_root="$1"; shift
test "$project_root" || exec ssh -o StrictHostKeyChecking=no -p2200 app@localhost

project_name="$(basename "$project_root")"

docker pull "$IMAGE"

docker rm -f "$image_suffix"

DDE_BASH_HISTORY=~/.dde/bash-history-"$project_name"
DDE_VIMINFO=~/.dde/viminfo/"$project_name"
mkdir -p "$(dirname "$DDE_VIMINFO")" && \
touch "$DDE_BASH_HISTORY" && \
touch "$DDE_VIMINFO"

exec docker run --name "$image_suffix" --hostname "$project_name" \
-d \
-p 2200:2200 -p 3000:3000 \
-v ~/.ssh/id_rsa.pub:/mnt-ssh-config/authorized_keys:ro \
-v ~/.ssh/id_rsa:/mnt-ssh-config/id_rsa:ro \
-v ~/.ssh/known_hosts:/mnt-ssh-config/known_hosts:ro \
-v "$DDE_BASH_HISTORY":/app/.bash_history \
-v "$(dirname "$DDE_VIMINFO")":/app/.vim/viminfo \
-v "$project_root":/data \
"$IMAGE" "$@"