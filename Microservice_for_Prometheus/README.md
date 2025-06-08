# Развертывание микросервиса с помощью Ansible и Vagrant

- Этот Python-микросервиис собирает Prometheus метрики, определяет тип хоста, на котором запущен микросервис
- ВМ AlmaLinux9 можно создать с помощью Vagrant
- Файл main.py вместе с requirmets.txt доставляются на виртуальную машину с помощью Ansible, собирается в Docker-контейнер и запускается
- Есть возможность запустить контейнер прямо из ВМ с скриптом start_microservice.sh при наличии Dockerfile, main.py и requirements.txt

- Для раскатки этого сервиса используется Ansible и Vagrant

- Гипервизор 2-го типа: virt-manager (libvirt)

- ОС для ВМ - AlmaLinux 9

## Струкутра проекта

```
.
├── vagrant/
│   └── Vagrantfile
└── ansible/
    ├── ansible.cfg
    ├── inventory.ini
    ├── playbook.yml
    └── roles/
        └── microservice/
            ├── files/
            │   ├── Dockerfile
            │   ├── main.py
            │   ├── requirements.txt
            │   └── start_microservice.sh
            └── tasks/
                ├── docker-setup.yml
                └── main.yml
```

## Используемый стек

- Fedora 41
- QEMU/KVM virtualization
- virt-manager
- Vagrant
- Ansible
- Docker
- Python

## Шаги развертывания

### 1. Настройка ВМ с помощью Vagrant

1. Устновка virt-manager:
  
   ```
   sudo apt install virt-manager qemu-kvm libvirt-daemon-system libvirt-clients
   ```
   
2. Установка Vagrant:

   Если возникают проблемы с установкой Vagrant (плагинов или боксов) используйте VPN, например AdGuardVPN с бесплатной версией - https://adguardaccount.net
  
   ```
   sudo apt install vagrant
   ```
   
3. Установка libvirt плагина для Vagrant:
  
   ```
   vagrant plugin install vagrant-libvirt
   ```
   
4. Установка AlmaLinux 9 box:
  
   ```
   vagrant box add generic/alma9
   ```
   
5. Запуск ВМ:
  
   ```
   cd vagrant
   vagrant up --provider=libvirt
   ```
   
### 2. Использование Ansible

1. Установка Ansible:
  
   ```
   sudo apt install ansible
   ```
   
2. Генерация SSH ключа:
  
   ```
   ssh-keygen
   ```
   
3. Copy SSH key to the VM (password is "password"):
  
   ```
   ssh-copy-id stm@<VM_IP>
   ```

Пароль по умолчанию:_password_, он может быть изменен в Vagranfile
   
4. Запуск Ansible playbook:
  
   ```
   cd ansible
   ansible-playbook playbook.yml -K
   ```

После запуска ввести пароль _password_. Он указывается в Vagranfile
   

### 3. Проверка метрик

1. Подключение к ВМ:
  
   ```
   ssh stm@<VM_IP>
   ```
   
2. Метрики с микросервиса:
  
   ```
   curl http://localhost:8080
   ```
   
