VolumePath= /home/trans/prom/volume

up: create
	docker compose -f ./srcs/docker-compose.yml up 
down:
	@docker compose -f ./srcs/docker-compose.yml down -v
clean:
	@docker system prune -af

fclean: down destroy clean
create:
	@if [ ! -d $(VolumePath) ]; then \
		mkdir $(VolumePath) ;\
		mkdir $(VolumePath)/PrometheusData; \
		mkdir $(VolumePath)/GrafanaData; \
	fi

destroy:
	@if [ -d $(VolumePath) ]; then \
		rm -rf $(VolumePath) ;\
	fi
