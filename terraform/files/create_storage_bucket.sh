#!/bin/bash

# Создал бакет
yc storage bucket create \
    --name andrei-sergeich-infra-bucket \
    --default-storage-class standard

# Команда для создания статического ключа (необходимо сохранить идентификатор key_id и секретный ключ secret, получить значение ключа снова будет невозможно.)
# key_id и секретный ключ secret необходимо положить в файл с кредами (s3_credentials_example) в параметры aws_access_key_id и aws_secret_access_key соответственно
# yc iam access-key create --service-account-name tuz-terraform
