# Aliyun sts server 
## Purpose
* Redurce the requests to aliyun sts service.   
* More efficient realization of the same function as  aliyun sts server [sample code](https://github.com/xiongcw/aliyun_log_sts_server_example)
## How to use
1. Prepare Environment variable  
   ```bash
   cat <<EOF>test.env
   ACCESS_KEY_ID=LTAXXXXXXXXXXXXXXXXXXX
   ACCESS_KEY_SECRET=XXXXXXXXXX
   ROLE_ARN=acs:ram::100000000000000000000:role/test
   REGION=cn-hangzhou
   DURATIONSECONDS=1000
   EOF
   ```
1. Build docker images
   ```bash
   docker build -t sts-server .
   ```
1. Run local
   ```bash
   docker run --env-file=./test.env -d -p 80:80 ghcr.io/fdiskbrain/sts-server
   ```
1. Check the result
   ```bash
   curl -v localhost
   ```
## Todo
1. Realize health check
1. kubernets deployment 