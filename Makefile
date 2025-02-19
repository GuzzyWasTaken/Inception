LOGIN = guzzy
ENV_FILE = ./srcs/.env

# Load .env file to access DOMAIN_NAME variable
ifneq ("$(wildcard $(ENV_FILE))","")
	include $(ENV_FILE)
endif

all: check_domain_name
	echo "Incepting Inception"
	@if [ -d "/home/$(LOGIN)/data/wordpress" ]; then \
		echo "/home/$(LOGIN)/data/wordpress already exists"; \
	else \
		sudo mkdir -p /home/$(LOGIN)/data/wordpress; \
		echo "wordpress directory created successfully"; \
	fi

	@if [ -d "/home/$(LOGIN)/data/mariadb" ]; then \
		echo "/home/$(LOGIN)/data/mariadb already exists"; \
	else \
		sudo mkdir -p /home/$(LOGIN)/data/mariadb; \
		echo "mariadb directory created successfully"; \
	fi

	@if ! grep -q "127.0.0.1 $(DOMAIN_NAME)" /etc/hosts; then \
		echo "127.0.0.1 $(DOMAIN_NAME)" | sudo tee -a /etc/hosts > /dev/null && \
		echo "Added $(DOMAIN_NAME) to /etc/hosts"; \
	else \
		echo "$(DOMAIN_NAME) is already in /etc/hosts"; \
	fi; \

	sudo docker compose -f ./srcs/docker-compose.yml up --build

check_domain_name:
	@if [ -z "$(DOMAIN_NAME)" ]; then \
		echo "DOMAIN_NAME is not set in the .env file!" \
		"\nPlease run 'make env' to create it. Don't forget to set values!"; \
		exit 1; \
	fi

down:
	sudo docker compose -f ./srcs/docker-compose.yml down

reset:
	@if [ -d "/home/$(LOGIN)/data/wordpress" ]; then \
		sudo rm -rf /home/$(LOGIN)/data/wordpress && \
		echo "successfully removed all contents from /home/$(LOGIN)/data/wordpress/"; \
	fi;

	@if [ -d "/home/$(LOGIN)/data/mariadb" ]; then \
		sudo rm -rf /home/$(LOGIN)/data/mariadb && \
		echo "successfully removed all contents from /home/$(LOGIN)/data/mariadb/"; \
	fi;

fclean:
	sudo docker compose -f ./srcs/docker-compose.yml down --rmi all -v
	@if [ -d "/home/$(LOGIN)/data/wordpress" ]; then \
		sudo rm -rf /home/$(LOGIN)/data/wordpress && \
		echo "successfully removed all contents from /home/$(LOGIN)/data/wordpress/"; \
	fi;

	@if [ -d "/home/$(LOGIN)/data/mariadb" ]; then \
		sudo rm -rf /home/$(LOGIN)/data/mariadb && \
		echo "successfully removed all contents from /home/$(LOGIN)/data/mariadb/"; \
	fi;

	@if grep -q "127.0.0.1 $(DOMAIN_NAME)" /etc/hosts; then \
		sudo sed -i "/127.0.0.1 $(DOMAIN_NAME)/d" /etc/hosts && \
		echo "Removed 127.0.0.1 $(DOMAIN_NAME) from /etc/hosts"; \
	else \
		echo "127.0.0.1 $(DOMAIN_NAME) not found in /etc/hosts to remove." \
		"\nIf you changed DOMAIN_NAME before running fclean, its still there."; \
	fi

re: fclean all

ls:
	sudo docker image ls
	sudo docker ps

env:
	@echo "Creating .env file in ./srcs/.env"
	@echo "# GENERAL" > $(ENV_FILE)
	@echo "DOMAIN_NAME=auzochuk.42.fr" >> $(ENV_FILE)
	@echo "\n" >> $(ENV_FILE)
	@echo "# DATA BASES" >> $(ENV_FILE)
	@echo "WP_DATABASE_NAME=wordpress" >> $(ENV_FILE)
	@echo "WP_DATABASE_HOST=mariadb" >> $(ENV_FILE)
	@echo "\n" >> $(ENV_FILE)
	@echo "# MARIADB DATABASE" >> $(ENV_FILE)
	@echo "DB_ROOT_PASSWORD=default_type" >> $(ENV_FILE)
	@echo "DB_NAME=wordpress" >> $(ENV_FILE)
	@echo "DB_PASS=default" >> $(ENV_FILE)
	@echo "DB_USER=default" >> $(ENV_FILE)
	@echo "DB_USER_PASSWORD=default" >> $(ENV_FILE)
	@echo "\n" >> $(ENV_FILE)
	@echo "# WORDPRESS ADMIN" >> $(ENV_FILE)
	@echo "WP_ADMIN=guzzy" >> $(ENV_FILE)
	@echo "WP_ADMIN_PASSWORD=guzzy123" >> $(ENV_FILE)
	@echo "WP_ADMIN_EMAIL=guzzy@gmail.com" >> $(ENV_FILE)
	@echo "\n" >> $(ENV_FILE)
	@echo "# WORDPRESS USER" >> $(ENV_FILE)
	@echo "WP_USER=bob" >> $(ENV_FILE)
	@echo "WP_USER_PASSWORD=bob123" >> $(ENV_FILE)
	@echo "WP_USER_EMAIL=bob@gmail.com" >> $(ENV_FILE)
	@echo ".env file created successfully! Remember to set the variables..."

.PHONY: all, clean, fclean, re, ls
