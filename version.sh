#!/bin/bash
echo "正要发布的版本是 $1"

cat > ./devops/deploy.yaml << EOF
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: busybox
spec:
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: busybox
  strategy:
  #动态更新配置
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: busybox
    spec:
      containers:
      - image: 192.168.6.190/test/busybox:$1
        imagePullPolicy: IfNotPresent
        name: busybox
EOF

cp ./devops/deploy.yaml ./devops/oldyaml/deploy.yaml.$1

cat > ./devops/docker.sh << EOF
docker build -t 192.168.6.190/test/busybox:$1 .
docker push 192.168.6.190/test/busybox:$1
EOF

git add --all
git commit -m "$1"
