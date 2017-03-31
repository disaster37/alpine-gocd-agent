#!/usr/bin/with-contenv sh

cat << EOF > ${CONFD_HOME}/etc/conf.d/gocd-run.toml
[template]
prefix = "${CONFD_PREFIX_KEY}"
src = "gocd-run.tmpl"
dest = "/etc/services.d/gocd/run"
mode = "0744"
keys = [
  "/config",
  "/plugin"
]
EOF


cat << EOF > ${CONFD_HOME}/etc/conf.d/autoregister.properties.toml
[template]
prefix = "${CONFD_PREFIX_KEY}"
src = "autoregister.properties.tmpl"
dest = "/data/config/autoregister.properties"
mode = "0744"
keys = [
  "/config"
]
EOF
