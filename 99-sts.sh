#!/usr/bin/env bash
## refresh sts 
init_nginx(){
	sed -i.bak -r 's/(worker_connections)(.*)$/\1 40960;/' /etc/nginx/nginx.conf
	sed -i.bak -r '/server_name/a\    rewrite ^/(.*) /sts.json break;'  /etc/nginx/conf.d/default.conf 
}
get_sts() {
	ex=0
	DURATIONSECONDS=${DURATIONSECONDS:-1000}
	while true; do
		export REGION=${REGION:-cn-hangzhou}
		if [[ $(($ex - $(date +%s))) -lt $(($DURATIONSECONDS / 2)) ]]; then
			# aliyun sts AssumeRole  --RoleArn acs:ram::1399362309222301:role/qa --RoleSessionName test --DurationSeconds 600
			echo "$(date) info: renew sts ${ACCESS_KEY_ID} ${ROLE_ARN} ${REGION}"
			aliyun sts AssumeRole \
				--RoleArn ${ROLE_ARN} \
				--RoleSessionName sts-$(date +%H) \
				--DurationSeconds ${DURATIONSECONDS} | jq -r -c .Credentials |tee /usr/share/nginx/html/sts.json \
				|| echo "$(date) warn: refresh sts faild"
			ex=$(date -d "$(cat /usr/share/nginx/html/sts.json | jq -r .Expiration)" +%s)
			echo "$(date) info: new key will exprise at $ex  "
		fi
		sleep 30
	done
}
init_nginx
get_sts &
