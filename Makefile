VolumePath= /home/trans/prom/volume
DockerCompose = ./srcs/main-docker-compose.yml

up: create
	docker compose -f $(DockerCompose) up -d
down:
	@docker compose -f $(DockerCompose) down 
clean:
	@docker system prune -af >/dev/null

fclean: destroy clean
	@docker compose -f$(DockerCompose) down -v
create:
	@if [ ! -d $(VolumePath) ]; then \
		mkdir $(VolumePath) ;\
		mkdir $(VolumePath)/graf; \
		mkdir $(VolumePath)/graf/PrometheusData; \
		mkdir $(VolumePath)/graf/GrafanaData; \
		mkdir $(VolumePath)/ELK; \
		mkdir $(VolumePath)/ELK/certs; \
		mkdir $(VolumePath)/ELK/fb_data; \
		mkdir $(VolumePath)/ELK/logstash_queue;	\
		mkdir $(VolumePath)/ELK/els_data; \
		mkdir $(VolumePath)/ELK/els_logs; \
		mkdir $(VolumePath)/ELK/kibana_data; \
	fi

destroy:
	@if [ -d $(VolumePath) ]; then \
		rm -rf $(VolumePath) ;\
	fi
