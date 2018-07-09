#!/bin/bash
bosh -d rabbitmq deploy rabbitmq.yml \
  -o ops-files/rabbitmq-enable-tls.yml \
  -o ops-files/rabbitmq-add-lb.yml \
  -l <(cat <<EOF
rabbitmq_vm_type: small
tls.common_name: rabbitmq.cf.internal
tls.alternative_names:
- "*.sslip.io"
- "*.ap-northeast-1.elb.amazonaws.com"
EOF) \
  --no-redact \


#  -o ops-files/rabbitmq-add-haproxy.yml \