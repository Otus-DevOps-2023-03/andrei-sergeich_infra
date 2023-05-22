#!/bin/bash

# Создал бакет
yc storage bucket create \
    --name andrei-sergeich-infra-bucket \
    --default-storage-class standard

# Команда для создания статического ключа (необходимо сохранить идентификатор key_id и секретный ключ secret, получить значение ключа снова будет невозможно.)
# yc iam access-key create --service-account-name tuz-terraform
