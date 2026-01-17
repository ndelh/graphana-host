#!/bin/bash
set -e
OUTPUT_DIR="/usr/share/elasticsearch/config/certs"

if [ ! -f ${OUTPUT_DIR}/ca.crt ]; then
	/usr/share/elasticsearch/bin/elasticsearch-certutil ca --silent --pem -out "$OUTPUT_DIR/ca.zip"
	unzip "$OUTPUT_DIR/ca.zip" -d "$OUTPUT_DIR"
  	rm "$OUTPUT_DIR/ca.zip"
	echo "certificate autority successfully generated"	
fi
echo "$OUTPUT_DIR"/elasticsearch
if [ ! -d ${OUTPUT_DIR}/elasticsearch ] ; then
	cat <<EOF > "$OUTPUT_DIR/instances.yml"
instances:
  - name: elasticsearch
    dns: [elasticsearch, localhost]
  - name: kibana
    dns: [kibana, localhost]
  - name: logstash
    dns: [logstash, localhost]
  - name: filebeat
    dns: [filebeat, localhost]
EOF
	/usr/share/elasticsearch/bin/elasticsearch-certutil cert --silent --pem --in "$OUTPUT_DIR/instances.yml" \
    --out "$OUTPUT_DIR/certs.zip" \
    --ca-cert "$OUTPUT_DIR/ca/ca.crt" \
    --ca-key "$OUTPUT_DIR/ca/ca.key"
	unzip "$OUTPUT_DIR/certs.zip" -d "$OUTPUT_DIR"
	openssl pkcs8 -inform PEM -in "$OUTPUT_DIR/logstash/logstash.key" \
    -topk8 -nocrypt -out "$OUTPUT_DIR/logstash/logstash.pkcs8.key"
	rm "$OUTPUT_DIR/certs.zip" "$OUTPUT_DIR/instances.yml"
	echo "certificates successfully generated"
fi
	echo "changing file properties"
	chown -R 1000:0 "$OUTPUT_DIR"
	find "$OUTPUT_DIR" -type d -exec chmod 755 {} +
	find "$OUTPUT_DIR" -type f -exec chmod 644 {} +
	sleep 3;
