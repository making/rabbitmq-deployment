#!/bin/bash
bosh -d rabbitmq deploy rabbitmq.yml \
  -o ops-files/rabbitmq-enable-tls.yml \
  -o ops-files/rabbitmq-enable-management-tls.yml \
  -o ops-files/rabbitmq-add-haproxy.yml \
  -o ops-files/rabbitmq-add-lb.yml \
  -l <(cat <<EOF
haproxy_vm_type: default
rabbitmq_vm_type: default
rabbitmq_disk_type: default
tls.common_name: rabbitmq.cf.internal
tls.alternative_names:
- "*.sslip.io"
- "*.ap-northeast-1.elb.amazonaws.com"
EOF) \
  --no-redact \