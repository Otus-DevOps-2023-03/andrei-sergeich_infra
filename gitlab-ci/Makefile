NAME     = GITLAB-CI


all: infra_create gitlab_install

infra_create:
	@printf "Создание инфраструктуры ${NAME}...\n"
	@terraform plan
	@printf "Нажмите Ctrl + C для отмены...\n"
	@sleep 5
	@terraform apply -auto-approve
	@printf "Ожидание развертывания инфраструктуры ${NAME}...\n"
	@sleep 50

gitlab_install:
	@printf "Установка GitLab ${NAME}...\n"
	@ansible-playbook install_docker.yml
	@ansible-playbook install_gitlab.yml

fclean:
	@printf "Полное уничтожение инфраструктуры ${NAME}...\n"
	@terraform destroy

re:	fclean all

.PHONY: infra_create gitlab_install fclean re
