  #!/bin/bash

CONTAINER_NAME="microservice"
IMAGE_NAME="microservice"
HOST_PORT=8080
APP_DIR="/opt/microservice"
DOCKERFILE_PATH="$APP_DIR/Dockerfile"

# Работает ли Docker?
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Ошибка: Docker не установлен в системе."
        exit 1
    fi

    if ! docker info &> /dev/null; then
        echo "Docker-демон не запущен. Пытаемся запустить..."
        sudo systemctl start docker
    fi
}

check_docker

# Запущен ли контейнер?
if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Контейнер $CONTAINER_NAME уже запущен."
    exit 0
fi

# Существует ли контейнер?
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Найден остановленный контейнер $CONTAINER_NAME. Запускаем..."
    docker start $CONTAINER_NAME
    exit $?
fi

# Существует ли образ?
if ! docker image inspect $IMAGE_NAME &> /dev/null; then
    echo "Образ $IMAGE_NAME не найден. Собираем из Dockerfile..."
    if [ ! -f "$DOCKERFILE_PATH" ]; then
        echo "Ошибка: Dockerfile не найден по пути $DOCKERFILE_PATH"
        exit 1
    fi
    docker build -t $IMAGE_NAME -f $DOCKERFILE_PATH $APP_DIR || exit 1
fi

# docker run
echo "Запускаем новый контейнер $CONTAINER_NAME..."
docker run -d \
    --name $CONTAINER_NAME \
    -p $HOST_PORT:8080 \
    -v $APP_DIR:/app \
    --restart unless-stopped \
    $IMAGE_NAME

# Проверка запуска
if [ $? -eq 0 ]; then
    echo "Контейнер $CONTAINER_NAME успешно запущен."
else
    echo "Ошибка при запуске контейнера $CONTAINER_NAME."
    exit 1
fi
