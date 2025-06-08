# Используем официальный образ Python
FROM python:3.9-slim

# Копируем код и зависимости
WORKDIR /app
COPY . .

# Устанавливаем Python-зависимости
RUN pip install -r requirements.txt

# Открываем порт для Prometheus
EXPOSE 8080

# Запускаем приложение
CMD ["python3", "main.py"]
