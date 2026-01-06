VolumePath= /home/trans/prom/volume
DockerCompose = ./srcs/main-docker-compose.yml

up: create
	docker compose -f $(DockerCompose) up -d  
down:
	@docker compose -f $(DockerCompose) down -v
clean:
	@docker system prune -af >/dev/null

fclean: down destroy clean
create:
	@if [ ! -d $(VolumePath) ]; then \
		mkdir $(VolumePath) ;\
		mkdir $(VolumePath)/graf \
		mkdir $(VolumePath)/graf/PrometheusData; \
		mkdir $(VolumePath)/graf/GrafanaData; \
	fi

destroy:
	@if [ -d $(VolumePath) ]; then \
		rm -rf $(VolumePath) ;\
	fi
