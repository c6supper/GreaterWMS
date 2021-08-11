#!/bin/sh

set -ex

patch_conf() {
  defined_envs=$(printf '${%s} ' $(env | cut -d= -f1))
#   envsubst "$defined_envs" < "$OPENVPN_DIR/server.conf.template" > "$OPENVPN_DIR/server.conf"
  pip install pip -U && pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
  cd /code && git clone https://gitee.com/coding-nerd/sartun-wms.git && cd sartun && \
  pip install -r requirements.txt && python manage.py makemigrations && python manage.py migrate
}

if [ ! -f "$SARTUN_INITIALIZED_MARK" ]; then
  patch_conf
  touch $SARTUN_INITIALIZED_MARK
  echo
  echo 'Sartun init process complete; ready for start up.'
  echo
else
  echo
  echo 'Skipping initialization'
  echo
fi


if [ "$RUN_AFTER_SIDECAR" = "yes" ]; then
	until wget --spider localhost:15000 > /dev/null; do echo '>>> Waiting for sidecar'; sleep 2 ; done ; echo '>>> Sidecar available';sleep 5;
fi
/bin/sh -c "$@"