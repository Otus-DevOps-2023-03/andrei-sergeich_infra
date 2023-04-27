### ДЗ по модулю Знакомство с облачной инфраструктурой. Yandex.Cloud ###

bastion_IP = 51.250.85.249

someinternalhost_IP = 10.128.0.17

VPN server admin panel: https://51.250.85.249.sslip.io

Для подключения к хосту без внешнего IP в одну команду необходимо использовать bastion как jump хост:
```
ssh -J user@bastion user@someinternalhost
```

Для подключения при помощи команды вида ```ssh someinternalhost``` из локальной консоли рабочего
устройства, чтобы подключение выполнялось по алиасу someinternalhost,
необходимо в файле ```~/.ssh/config``` прописать:

```
# Jump host
Host bastion
  HostName 51.250.85.249
  User user

# Destination host
Host someinternalhost
	HostName 10.128.0.17
	ProxyJump bastion
	User user
```
