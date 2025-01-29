#!/bin/bash

# Определения цветов и форматирования
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

# Иконки для пунктов меню
ICON_UPDATE="🔄"
CHECKMARK="✅"
ICON_ERROR="❌"
ICON_PROGRESS="⏳"

# Функция для обновления ноды
update_node() {
    echo -e "${ICON_PROGRESS} Начинаем обновление ноды Rivalz до версии 3.0.1..."

    # Остановка текущего контейнера
    echo -e "${ICON_PROGRESS} Останавливаем текущий контейнер..."
    docker-compose down

    # Обновление rivalz-node-cli
    echo -e "${ICON_PROGRESS} Обновляем rivalz-node-cli до версии 3.0.1..."
    docker run --rm -v /usr/local/lib/node_modules:/usr/local/lib/node_modules node:18 npm install -g rivalz-node-cli@3.0.1

    if [ $? -eq 0 ]; then
        echo -e "${CHECKMARK} rivalz-node-cli успешно обновлен до версии 3.0.1."
    else
        echo -e "${ICON_ERROR} Ошибка при обновлении rivalz-node-cli."
        exit 1
    fi

    # Пересборка и запуск контейнера
    echo -e "${ICON_PROGRESS} Пересобираем и запускаем контейнер..."
    docker-compose up -d --build

    if [ $? -eq 0 ]; then
        echo -e "${CHECKMARK} Нода Rivalz успешно обновлена и запущена."
    else
        echo -e "${ICON_ERROR} Ошибка при перезапуске контейнера."
        exit 1
    fi

    # Проверка версии
    echo -e "${ICON_PROGRESS} Проверяем версию ноды..."
    docker exec rivalz rivalz --version

    echo -e "${GREEN}Обновление завершено!${RESET}"
}

# Главное меню
show_menu() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}║                        ${YELLOW}Меню обновления ноды Rivalz${CYAN}                        ║${RESET}"
    echo -e "${CYAN}╠══════════════════════════════════════════════════════════════════════╣${RESET}"
    echo -e "${CYAN}║   ${YELLOW}1.${RESET} ${ICON_UPDATE} Обновить ноду Rivalz до версии 3.0.1                        ║${RESET}"
    echo -e "${CYAN}║   ${YELLOW}2.${RESET} Выйти в главное меню                                           ║${RESET}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${RESET}"
    echo -ne "${YELLOW}Введите ваш выбор [1-2]: ${RESET}"
}

# Главный цикл
while true; do
    show_menu
    read choice
    case $choice in
        1) update_node ;;
        2) break ;;
        *) echo -e "${ICON_ERROR} Неверный выбор, попробуйте снова.${RESET}" ;;
    esac
done
