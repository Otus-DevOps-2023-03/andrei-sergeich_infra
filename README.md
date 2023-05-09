# OTUS HW #

## ДЗ по модулю Модели управления инфраструктурой. Подготовка образов с помощью Packer ##

* Создал сервисный аккаунт, делегировал ему минимально необходимые права (все команды обернул в скрипт).
* Создайте IAM key.
* Создал Packer-шаблон (```ubuntu16.json```), содержащий описание простого образа VM. Для полного деплоя приложения используются скрипты из каталога packer/scripts.
* Создал Packer-шаблон(```immutable.json```), содержащий описание полного образа VM. Шаблон полного образа использует скрипты и ```systemd unit``` из каталога ```packer/files```.
* Параметризировал Packer-шаблон (переменные заполняются в ```packer/variables.json```).
* Создал скрипт ```create-reddit-vm.sh``` в директории ```config-scripts```, который создает VM с помощью Yandex.Cloud CLI.

### Для сборки и проверки простого образа ###

* выполнить команду:

``` bash
packer build -var-file=./variables.json ./ubuntu16.json
```

* создать VM из собранного образа
* установить reddit (```config-scripts/deploy.sh```)
* открыть в браузере <http://external_IP:9292>

### Для сборки и проверки полного образа ###

* выполнить команду:

``` bash
packer build -var-file=./variables.json ./immutable.json
```

* запустить скрипт:

``` bash
bash config-scripts/create-reddit-vm.sh
```

* открыть в браузере <http://external_IP:9292>

---

## ДЗ по модулю Основные сервисы Yandex Cloud ##

``` bash
testapp_IP = 158.160.96.36
testapp_port = 9292
```

Установил и настроил yc CLI для работы с аккаунтом,
создадал хост с помощью CLI,
установил на нем ruby для работы приложения,
установил и запустил MongoDB,
задеплоил тестовое приложение, запустил и проверил его работу.
Все необходимые команды завернул в скрипты.
Создал скрипт для создания инстанса с уже запущенным приложением.

Вариант №1 инициализации инстанса:

1. Выполнить команду:

    ``` bash
    yc compute instance create \
        --name reddit-app \
        --hostname reddit-app \
        --memory=4 \
        --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
        --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
        --metadata serial-port-enable=1 \
        --ssh-key ~/.ssh/id_ed25519.pub
    ```

2. Скопировать на созданную ВМ файлы:
    * ```install_ruby.sh```
    * ```install_mongodb.sh```
    * ```deploy.sh```
    * ```startup.sh```

3. Запустить скрипт ```startup.sh```

Вариант №2 инициализации инстанса (получим инстанс с уже запущенным приложением):

Запустить скрипт ```instance_init.sh```

---

## ДЗ по модулю Знакомство с облачной инфраструктурой. Yandex.Cloud ##

``` bash
bastion_IP = 51.250.85.249
someinternalhost_IP = 10.128.0.17
```

VPN server admin panel: <https://51.250.85.249.sslip.io>

Для подключения к хосту без внешнего IP в одну команду необходимо использовать bastion как jump хост:

``` bash
ssh -J user@bastion user@someinternalhost
```

Для подключения при помощи команды вида ```ssh someinternalhost``` из локальной консоли рабочего
устройства, чтобы подключение выполнялось по алиасу someinternalhost,
необходимо в файле ```~/.ssh/config``` прописать:

``` bash
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
