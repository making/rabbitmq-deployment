# Deploying RabbitMQ with BOSH


## on AWS

```
cp terraform.tfvars.sample terraform.tfvars
```

```
terraform init terraform/aws
terraform plan -out plan terraform/aws/
terraform apply plan
```

```
LB_DNS_NAME=$(cat terraform.tfstate | jq -r '.modules[0].outputs.rabbitmq_lb_dns_name.value')
LB_NAME=$(cat terraform.tfstate | jq -r '.modules[0].outputs.rabbitmq_lb_name.value')
```


```
bosh update-cloud-config <(bosh cloud-config) \
  -o ops-files/cloud-config-add-lb.yml \
  -v rabbitmq_lb_name=${LB_NAME} \
```

```
./deploy-rabbitmq.sh
```

## on Laptop (BOSH-Lite)

```
./deploy-rabbitmq-lite.sh
```