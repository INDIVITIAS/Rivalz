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
CHECKMARK="✅"
ICON_ERROR="❌"
ICON_PROGRESS="⏳"
ICON_UPDATE="🔄"

# Функция для рисования границ
draw_top_border() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${RESET}"
}

draw_bottom_border() {
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${RESET}"
}

# Логотип и информация
display_ascii() {
    echo -e "${CYAN}   ____   _  __   ___    ____ _   __   ____ ______   ____   ___    ____${RESET}"
    echo -e "${CYAN}  /  _/  / |/ /  / _ \\  /  _/| | / /  /  _//_  __/  /  _/  / _ |  / __/${RESET}"
    echo -e "${CYAN} _/ /   /    /  / // / _/ /  | |/ /  _/ /   / /    _/ /   / __ | _\\ \\  ${RESET}"
    echo -e "${CYAN}/___/  /_/|_/  /____/ /___/  |___/  /___/  /_/    /___/  /_/ |_|/___/  ${RESET}"
    echo -e ""
    echo -e "${YELLOW}Подписывайтесь на Telegram: https://t.me/CryptalikBTC${RESET}"
    echo -e "${YELLOW}Подписывайтесь на YouTube: https://www.youtube.com/@Cryptalik${RESET}"
    echo -e "${YELLOW}Здесь про аирдропы и ноды: https://t.me/indivitias${RESET}"
    echo -e "${YELLOW}Купи мне крипто бутылочку... кефира 😏${RESET} ${MAGENTA} 👉  https://bit.ly/4eBbfIr  👈 ${MAGENTA}"
    echo -e ""
}

# Функция для обновления ноды
update_node() {
    echo -e "${ICON_UPDATE} Обновление ноды Rivalz...${RESET}"

    # Переход в директорию Rivalz
    if [ ! -d "Rivalz" ]; then
        echo -e "${ICON_ERROR} Директория Rivalz не найдена. Убедитесь, что нода установлена в директории Rivalz.${RESET}"
        exit 1
    fi
    cd Rivalz

    # Остановка текущего контейнера
    echo -e "${ICON_PROGRESS} Остановка текущего контейнера...${RESET}"
    docker-compose down || echo -e "${ICON_ERROR} Не удалось остановить контейнер. Возможно, он уже остановлен.${RESET}"

    # Обновление rivalz-node-cli
    echo -e "${ICON_PROGRESS} Обновление rivalz-node-cli до версии 3.0.1...${RESET}"
    docker run --rm -v $(pwd):/app -w /app node:18 npm i -g rivalz-node-cli@3.0.1

    # Запуск команды change-hardware-config
    echo -e "${ICON_PROGRESS} Настройка конфигурации оборудования...${RESET}"
    rivalz-node-cli change-hardware-config

    # Перезапуск ноды
    echo -e "${ICON_PROGRESS} Перезапуск ноды...${RESET}"
    docker-compose up -d

    echo -e "${CHECKMARK} Нода Rivalz успешно обновлена.${RESET}"
    echo -e "${GREEN}Теперь вы можете использовать старый скрипт для управления нодой.${RESET}"
}

# Основной код
draw_top_border
display_ascii
update_node
draw_bottom_border
