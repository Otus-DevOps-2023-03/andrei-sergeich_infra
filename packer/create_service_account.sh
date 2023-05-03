#!/bin/bash

# Создал сервисный аккаунт
SVC_ACCT=cmero-tuz
FOLDER_ID=$(yc config list | grep folder | awk '{print $2}')
yc iam service-account create --name $SVC_ACCT --folder-id $FOLDER_ID

# Выдал права аккаунту
ACCT_ID=$(yc iam service-account get $SVC_ACCT | grep ^id | awk '{print $2}')
yc resource-manager folder add-access-binding --id $FOLDER_ID --role editor --service-account-id $ACCT_ID

# Создал IAM key и экспортировал его в файл
yc iam key create --service-account-id $ACCT_ID --output svc_acct_key.json
