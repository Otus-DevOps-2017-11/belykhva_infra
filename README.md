# Infra project (Stage 1)

## Подключение к внутреннему хосту одной командой через бастион-хост:

```shell
ssh -o ProxyCommand='ssh -W %h:%p appuser@35.195.24.17' appuser@10.132.0.3 
```

## Упрощение жизни, алиасы, вот это всё

### Создание конфигурационного файла для SSH на клиентской машине:

```shell
$ vim ~/.ssh/config

Host bastion
  Hostname 35.195.24.17
  User appuser

Host internal
  Hostname 10.132.0.3
  User appuser
  ProxyCommand ssh bastion -W %h:%p
```

### Подключение к внутреннему хосту одной командой используя алиас:

```shell
$ ssh internal
```

## Конфигурация стенда

Хост **bastion**, внешн. IP: **35.195.24.17**, внутр. IP: **10.132.0.2**.   
Хост **someinternalhost**, внутр. IP: **10.132.0.3**

# Infra project (Stage 2)

## Создание инстанса с помощью утилиты gcloud
Команда запускается из каталога с файлом **startup.sh**.  
Зона назначения была убрана из скрипта намеренно, т.к. значение по-умолчанию берется из настроек gcloud.  

```shell 
gcloud compute instances create reddit-app3 \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --metadata-from-file startup-script=startup.sh \
  --restart-on-failure
```
