# OTUS HW

## ДЗ по модулю "Устройство Gitlab CI. Построение процесса непрерывной интеграции"

* Описал создание облачной инфраструктуры с помощью ***Terraform***
* Описал установку ***Docker*** на инстанс с помощью ***Ansible***
* Описал установку ***GitLab*** на инстанс с помощью ```docker compose```
* Добавил в проект ```reddit```
* Добавил в проект тесты
* Добавил окружения ```dev```, ```stage```. ```production``` в пайплайн

Для сборки:

* перейти в каталог **gitlab-ci**, выполнить команды:

    ``` bash
    terraform init
    terraform apply
    ansible-playbook install_docker.yml
    ansible-playbook install_gitlab.yml
    ```

* чтобы получить пароль для входа, нужно подключиться к инстансу по ```ssh``` и выполнить:

    ``` bash
    docker exec -it gitlab_web_1 bash
    cat /etc/gitlab/initial_root_password | grep Password:
    ```

Для проверки:

* открыть в браузере <http://IP_адрес_созданной_VM>

---

## ДЗ по модулю "Локальная разработка Ansible ролей с Vagrant. Тестирование конфигурации"

* Описал создание локальной инфраструктуры с помощью ***Vagrant***
* Добавил плейбук для установки ```python``` на целевых хостах
* Доработал роли ```app``` и ```db```
* Параметризировал конфигурацию роли ```app``` в части использования пользователя,
чтобы дать возможность использовать роль для иного пользователя (имя пользователя
определено в ```roles/app/defaults/main.yml```, а при использовании Vagrant передается
в блоке ```provision``` в ```Vagrantfile```)
* Дополнил конфигурацию Vagrant для корректной работы проксирования приложения
с помощью nginx

  Для сборки (поднятие локальной инфраструктуры):

  * перейти в каталог **ansible**, выполнить команду:

      ``` bash
      vagrant up
      ```

  Для проверки:

  * открыть в браузере <http://10.10.10.20:80>

* Реализовал тестирование роли ```db``` с помощью ***Molecule*** и ***Testinfra***
* Написал тест к роли ```db``` (с помощью модуля Testinfra) для проверки того,
что БД слушает по нужному порту (27017)

  Для сборки (создание ВМ и запуск тестов):

  * перейти в каталог **ansible/roles/db**, выполнить команду:

      ``` bash
      molecule create
      molecule converge
      molecule verify
      ```

* Изменил плэйбуки для провижининга ```Packer```'а, плейбуки теперь используют роли ```app``` и ```db```

  Для сборки ```Packer```-образов:

  * нужно добавить в ```Packer```-шаблоны (```{app,db}.json```), содержащие описание образов VM, в раздел ```provisioners``` строку

      ``` json
      "use_proxy": "false"
      ```

     > Убрал ее из-за того, что тесты не знают такой параметр

  * выполнить сборку образов:

      ``` bash
      packer build -var-file=packer/variables.json packer/app.json
      packer build -var-file=packer/variables.json packer/db.json
      ```

* Вынес роль ```db``` в отдельный репозиторий, реализовал подключение роли через
requirements.yml обоих окружений

  Для добавления роли:

  * перейти в каталог **ansible**, выполнить команду:

      ``` bash
      ansible-galaxy install -r environments/stage/requirements.yml
      ```

---

## ДЗ по модулю "Ansible роли, управление настройками нескольких окружений и best practices"

* Перенес созданные впрошлых ДЗ плейбуки в раздельные роли
* Описал два окружения (окружение по-умолчанию - **stage**)
* Подключил коммьюнити роль nginx
* Использовал Ansible Vault для окружений

Динамический inventory генерируется ```Terraform```'ом.

Для сборки:

* перейти в каталог **terraform/stage** или **terraform/prod**, выполнить команды:

    ``` bash
    terraform init
    terraform apply
    ```

* в файле ```environments/{stage,prod}/group_vars/app``` заполнить значение переменной ```db_host```, подставив IP-адрес VM с базой данных (внутренний или внешний)
* в каталоге **ansible** запустить плэйбук командой:

    > Для настройки окружения **stage**

    ``` bash
    ansible-playbook playbooks/site.yml
    ```

    > Для настройки окружения **prod**

    ``` bash
    ansible-playbook -i environments/prod/inventory playbooks/site.yml
    ```

Для проверки:

* ``` bash
  terraform output
  ```

* ```external_ip_address_app``` - адрес VM с приложением из вывода output переменной
* открыть в браузере <http://external_ip_address_app:9292>

---

## ДЗ по модулю "Продолжение знакомства с Ansible: templates, handlers, dynamic inventory, vault, tags"

В процессе выполнения реализовал несколько сценариев:

* Один playbook, один сценарий
* Один плейбук, несколько сценариев
* Несколько плейбуков

Так же создал теги, хэндлеры, шаблоны файлов, реализовал провижининг ```Packer```'а с помощью ```Ansible```.

Для сборки ```Packer```-образов:

* нужно добавить в ```Packer```-шаблоны (```{app,db}.json```), содержащие описание образов VM, в раздел ```provisioners``` строку

    ``` json
    "use_proxy": "false"
    ```

   > Убрал ее из-за того, что тесты не знают такой параметр

* выполнить сборку образов:

    ``` bash
    packer build -var-file=packer/variables.json packer/app.json
    packer build -var-file=packer/variables.json packer/db.json
    ```

Для выполнения данного ДЗ отключил провижининг в ```Terraform```. В окружении **stage** используются образы, созданные ```Packer```'ом с провижинингом ```Ansible```. Динамический inventory генерируется ```Terraform```'ом.

Для сборки:

* перейти в каталог **terraform/stage** или **terraform/prod**, выполнить команды:

    ``` bash
    terraform init
    terraform apply
    ```

* в плэйбуке ```ansible/app.yml``` заполнить значение переменной ```db_host```, подставив IP-адрес VM с базой данных (внутренний или внешний)
* запустить плэйбук командой:

    ``` bash
    ansible-playbook site.yml
    ```

Для проверки:

* ``` bash
  terraform output
  ```

* ```external_ip_address_app``` - адрес VM с приложением из вывода output переменной
* открыть в браузере <http://external_ip_address_app:9292>

---

## ДЗ по модулю "Управление конфигурацией. Знакомство с Ansible"

* Установлен и сконфигурирован ansible:
  * создан ansible.cfg
  * файлы inventory разных форматов
* Написан плейбук, клонирующий репозиторий

  > Выполните ansible  app -m command -a 'rm -rf ~/reddit' и проверьте еще раз выполнение плейбука. Что изменилось и почему?

  Команда удалит директорию и вложенные файлы репозитория приложения. После запуска плэйбука репозиторий будет снова клонирован и ansible сообщит об успешном изменении.

* Динамический ```inventory.json``` создается с помощью ресурса terraform во время разворачивания инфраструктуры (ресурс описан в файлах ```terrafom/{stage,prod}/main.tf```, шаблон - ```terrafom/{stage,prod}/ansible_inventory_json.tpl```)

Для сборки перейти в каталог **stage** или **prod**, выполнить команды:

``` bash
terraform init
terraform apply
```

Для проверки в том же каталоге, где была произведена сборка, выполнить команду:

``` bash
ansible all -m ping
```

---

## ДЗ по модулю "Принципы организации инфраструктурного кода и работа над инфраструктурой в команде на примере Terraform"

* Создание ресурсов разнесено по модулям:
  * виртуальная сеть
  * база данных
  * приложение
* Создал окружения **stage** и **prod** на основе модулей
* Создал удаленный бекенд (скрипт ```terraform/files/create_storage_bucket```)
* Креды от бакета положил в файл ```s3_credentials```
* Настроил хранение стейт файла в удаленном бекенде
* Добавил необходимые provisioner в модули для деплоя и работы приложения, включая проброс IP адреса базы

Для сборки перейти в каталог **stage** или **prod**, выполнить команды:

``` bash
terraform init
terraform apply
```

Для проверки:

* ``` bash
  terraform output
  ```

* ```external_ip_address_app``` - адрес VM с приложением из вывода output переменной
* открыть в браузере <http://external_ip_address_app:9292>

---

## ДЗ по модулю "Знакомство с Terraform"

* Создал сервисный аккаунт, делегировал ему минимально необходимые права (все команды обернул в скрипт).
* Описал ресурс для создания инстанса VM в YC из base-образа, созданного в предыдущем ДЗ.
* Реализовал вывод переменных (IP адрес инстанса) в консоль (```outputs.tf```).
* Добавил провижинеры, скрипт, unit-файл для деплоя последней версии приложения на созданную VM.
* Создал конфигурационные файлы ```variables.tf```, ```terraform.tfvars```, ```terraform.tfvars.example```, в которых определил входные переменные
* Описал ресурс для создания HTTP балансировщика, направляющего трафик на наше развернутое приложение на инстансе reddit-app (файл ```lb.tf```). Добавил в output переменные адрес балансировщика.
* Добавил в код еще один terraform ресурс для нового инстанса приложения reddit-app2, добавил его в балансировщик, при остановке на одном из инстансов приложения (```systemctl stop puma```),приложение продолжает быть доступным по адресу балансировщика. Добавил в output переменные адрес второго инстанса.

  Основные проблемы данной конфигурации:
  * дублирование кода,
  * необходимость правки частей кода, связанных с именами/адресами ресурсов/инстансов, что требует особой внимательности)))

* Реализовал подход с заданием количества инстансов через параметр ресурса count. Переменная count задается в параметрах и по умолчанию равна 1.

Для сборки выполнить команды:

``` bash
terraform init
terraform apply
```

Для проверки:

* ``` bash
  terraform output
  ```

* ```external_ip_address_lb``` - адрес HTTP балансировщика из вывода output переменной
* открыть в браузере <http://external_ip_address_lb>

---

## ДЗ по модулю "Модели управления инфраструктурой. Подготовка образов с помощью Packer"

* Создал сервисный аккаунт, делегировал ему минимально необходимые права (все команды обернул в скрипт).
* Создал IAM key.
* Создал Packer-шаблон (```ubuntu16.json```), содержащий описание простого образа VM. Для полного деплоя приложения используются скрипты из каталога packer/scripts.
* Создал Packer-шаблон(```immutable.json```), содержащий описание полного образа VM. Шаблон полного образа использует скрипты и ```systemd unit``` из каталога ```packer/files```.
* Параметризировал Packer-шаблон (переменные заполняются в ```packer/variables.json```).
* Создал скрипт ```create-reddit-vm.sh``` в директории ```config-scripts```, который создает VM с помощью Yandex.Cloud CLI.

### Для сборки и проверки простого образа

* выполнить команду:

``` bash
packer build -var-file=./variables.json ./ubuntu16.json
```

* создать VM из собранного образа
* установить reddit (```config-scripts/deploy.sh```)
* открыть в браузере <http://external_IP:9292>

### Для сборки и проверки полного образа

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

## ДЗ по модулю "Основные сервисы Yandex Cloud"

``` bash
testapp_IP = 158.160.96.36
testapp_port = 9292
```

* Установил и настроил yc CLI для работы с аккаунтом.
* Создал хост с помощью CLI.
* Установил на нем ruby для работы приложения.
* Установил и запустил MongoDB.
* Задеплоил тестовое приложение, запустил и проверил его работу.
* Все необходимые команды завернул в скрипты.
* Создал скрипт для создания инстанса с уже запущенным приложением.

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

## ДЗ по модулю "Знакомство с облачной инфраструктурой. Yandex.Cloud"

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
