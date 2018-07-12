#!/bin/bash
bosh -d rabbitmq deploy rabbitmq.yml \
  -o ops-files/version/cf-rabbitmq-v249.0.0.yml \
  -o ops-files/rabbitmq-enable-tls.yml \
  -o ops-files/rabbitmq-add-haproxy.yml \
  -l <(cat <<EOF
haproxy_vm_type: default
rabbitmq_vm_type: default
rabbitmq_disk_type: 5GB
tls.common_name: rabbitmq.cf.internal
tls.alternative_names:
- "*.sslip.io"
- "*.ap-northeast-1.elb.amazonaws.com"
EOF) \
  --no-redact \
