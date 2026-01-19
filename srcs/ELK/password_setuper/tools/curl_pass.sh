#!/bin/bash
set -e

MAX_RETRIES=${MAX_RETRIES:-5}
COUNT=0

until curl -s --cacert /usr/share/elasticsearch/config/certs/ca.crt \
      -u "elastic:${ELS_PASS}" https://elasticsearch:9200 | grep -q "number"; do
  
  COUNT=$((COUNT+1))
  
  if [ "$COUNT" -ge "$MAX_RETRIES" ]; then
	  curl -v --cacert /usr/share/elasticsearch/config/certs/ca.crt \
      -u "elastic:${ELS_PASS}" https://elasticsearch:9200 
    exit 1
  fi
  sleep 3
done

echo "successfully connected to elasticsearch container"
RESPONSE=$(curl -s -w "%{http_code}" -X POST --cacert /usr/share/elasticsearch/config/certs/ca.crt \
	-u "elastic:${ELS_PASS}" \
	-H "Content-type: application/json" \
	https://elasticsearch:9200/_security/user/kibana_system/_password \
	-d "{\"password\":\"${KIBANA_PASS}\"}")

HTTP_CODE="${RESPONSE:${#RESPONSE}-3}"

	if [ "$HTTP_CODE" -eq 200 ]; then
		echo "password changed sucessfylly for kibana_user"
	else
		echo $RESPONSE
fi

RESPONSE=$(curl -s -w "%{http_code}" -X POST --cacert /usr/share/elasticsearch/config/certs/ca.crt \
	-u "elastic:${ELS_PASS}" \
	-H "Content-type: application/json" \
	https://elasticsearch:9200/_security/user/logstash_system/_password \
	-d "{\"password\":\"${LOGSTASH_PASS}\"}")

HTTP_CODE="${RESPONSE:${#RESPONSE}-3}"

	if [ "$HTTP_CODE" -eq 200 ]; then
		echo "password changed sucessfylly for logstash_user"
	else
		echo $RESPONSE
fi

echo "all password successfully changed"
