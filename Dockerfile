From openresty/openresty:1.19.9.1-2-buster-fat
WORKDIR /
RUN apt update \
    && apt install wget jq  -y && apt clean all
## https://github.com/aliyun/aliyun-cli/releases/download/v3.0.188/aliyun-cli-linux-3.0.188-amd64.tgz
RUN CLI_ARCH=$(uname -m|sed -e 's/aarch64/arm64/g' -e 's/x86_64/amd64/g') && wget https://github.com/aliyun/aliyun-cli/releases/download/v3.0.188/aliyun-cli-linux-3.0.188-${CLI_ARCH}.tgz \
    && tar zxvf aliyun-cli-linux-3.0.188-${CLI_ARCH}.tgz && mv aliyun /usr/bin/ && rm aliyun-cli-linux-3.0.188-${CLI_ARCH}.tgz
ADD 99-sts.sh 	/docker-entrypoint.d
