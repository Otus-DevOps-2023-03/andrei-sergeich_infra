# andrei-sergeich_infra
andrei-sergeich Infra repository

### ДЗ по модулю Знакомство с облачной инфраструктурой. Yandex.Cloud ###
Для подключения к хосту без внешнего IP в одну команду необходимо использовать bastion как jump хост:
```
ssh -J user@bastion user@someinternalhost
```

Для подключения из консоли при помощи команды вида ```ssh someinternalhost``` из локальной консоли рабочего
устройства, чтобы подключение выполнялось по алиасу someinternalhost
необходимо в файле ```~/.ssh/config``` прописать:

```
# Jump host
Host bastion
  HostName 1.2.3.4
  User user

# Destination host
Host someinternalhost
	HostName 10.128.0.17
	ProxyJump bastion
	User user
```
