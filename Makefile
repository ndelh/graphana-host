VolumePath= /home/trans/prom/volume
DockerCompose = ./srcs/main-docker-compose.yml

up: create
	docker compose -f $(DockerCompose) up  
down:
	@docker compose -f $(DockerCompose) down -v
clean:
	@docker system prune -af >/dev/null

fclean: down destroy clean
create:
	@if [ ! -d $(VolumePath) ]; then \
		mkdir $(VolumePath) ;\
		mkdir $(VolumePath)/graf; \
		mkdir $(VolumePath)/graf/PrometheusData; \
		mkdir $(VolumePath)/graf/GrafanaData; \
		mkdir $(VolumePath)/ELK; \
		mkdir $(VolumePath)/ELK/fb_data; \
		mkdir $(VolumePath)/ELK/logstash_queue; \
	fi

destroy:
	@if [ -d $(VolumePath) ]; then \
		rm -rf $(VolumePath) ;\
	fi
