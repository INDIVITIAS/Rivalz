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
ICON_INSTALL="▶️"
ICON_UPDATE="🔄"
ICON_WALLET="🔑"
ICON_STORAGE="💰"
ICON_INFO="📄"
ICON_FIX="🛠️"
ICON_DELETE="🗑️"
ICON_EXIT="❌"
CHECKMARK="✅"
ERROR="❌"
PROGRESS="⏳"
INSTALL="🛠️"
STOP="⏹️"
RESTART="🔄"
LOGS="📄"
EXIT="🚪"
INFO="ℹ️"

# Функции для рисования границ
draw_top_border() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${RESET}"
}

draw_middle_border() {
    echo -e "${CYAN}╠══════════════════════════════════════════════════════════════════════╣${RESET}"
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

# Установка Docker и Docker Compose
install_docker() {
    echo -e "${INSTALL} Установка Docker и Docker Compose...${RESET}"
    sudo apt update && sudo apt upgrade -y
    if ! command -v docker &> /dev/null; then
        sudo apt install docker.io -y
        sudo systemctl start docker
        sudo systemctl enable docker
    fi
    if ! command -v docker-compose &> /dev/null; then
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
    echo -e "${CHECKMARK} Docker и Docker Compose успешно установлены.${RESET}"
}

# Установка ноды Rivalz
install_node() {
    echo -e "${INSTALL} Установка ноды Rivalz...${RESET}"
    install_docker

    # Запрос данных для конфигурации
    echo -e "${INFO} Пожалуйста, укажите следующие данные для конфигурации:${RESET}"
    read -p "Введите ваш WALLET_ADDRESS: " WALLET_ADDRESS
    read -p "Введите количество CPU_CORES: " CPU_CORES
    read -p "Введите объем RAM (например, 4G): " RAM
    read -p "Введите размер диска DISK_SIZE (например, 10G): " DISK_SIZE

    # Проверка на существование файла .env
    if [ -f .env ]; then
        echo -e "${ERROR} Файл .env уже существует. Для перезаписи удалите старый файл.${RESET}"
        exit 1
    fi

    # Создание файла .env
    cat > .env <<EOL
WALLET_ADDRESS=${WALLET_ADDRESS}
CPU_CORES=${CPU_CORES}
RAM=${RAM}
DISK_SIZE=${DISK_SIZE}
EOL

    echo -e "${CHECKMARK} Файл .env создан с указанной конфигурацией.${RESET}"

    # Проверка на наличие файла docker-compose.yml
    if [ ! -f docker-compose.yml ]; then
        echo -e "${ERROR} Файл docker-compose.yml не найден. Убедитесь, что он находится в текущей директории.${RESET}"
        exit 1
    fi

    # Сборка и запуск контейнеров
    docker-compose up -d --build
    echo -e "${CHECKMARK} Нода Rivalz установлена и запущена.${RESET}"
    read -p "Нажмите Enter, чтобы вернуться в главное меню..."
}

# Остановка ноды Rivalz
stop_node() {
    echo -e "${STOP} Остановка ноды Rivalz...${RESET}"
    docker-compose down
    echo -e "${CHECKMARK} Нода Rivalz остановлена.${RESET}"
    read -p "Нажмите Enter, чтобы вернуться в главное меню..."
}

# Перезапуск ноды Rivalz
restart_node() {
    echo -e "${RESTART} Перезапуск ноды Rivalz...${RESET}"
    docker-compose down
    docker-compose up -d
    echo -e "${CHECKMARK} Нода Rivalz успешно перезапущена.${RESET}"
    read -p "Нажмите Enter, чтобы вернуться в главное меню..."
}

# Просмотр логов ноды Rivalz
view_logs() {
    echo -e "${LOGS} Просмотр последних 30 логов ноды Rivalz...${RESET}"
    docker-compose logs --tail 30
    read -p "Нажмите Enter, чтобы вернуться в главное меню..."
}

# Просмотр ID ноды и данных .env
display_id_env() {
    echo -e "${INFO} Отображение ID ноды и данных конфигурации...${RESET}"
    echo -e "${GREEN}ℹ️  ID ноды:${RESET}"
    cat /etc/machine-id
    echo -e "${GREEN}\nℹ️  Конфигурация .env:${RESET}"
    if [ -f .env ]; then
        cat .env
    else
        echo -e "${ERROR} Файл .env не найден.${RESET}"
    fi
    read -p "Нажмите Enter, чтобы вернуться в главное меню..."
}

# Главное меню
show_menu() {
    draw_top_border
    echo -e "    ${YELLOW}Выберите действие:${RESET}"
    draw_middle_border
    echo -e "    ${CYAN}1.${RESET} ${ICON_INSTALL} Установить ноду Rivalz"
    echo -e "    ${CYAN}2.${RESET} ${ICON_INFO} Просмотреть ID ноды и конфигурацию"
    echo -e "    ${CYAN}3.${RESET} ${ICON_STOP} Остановить ноду Rivalz"
    echo -e "    ${CYAN}4.${RESET} ${ICON_RESTART} Перезапустить ноду Rivalz"
    echo -e "    ${CYAN}5.${RESET} ${ICON_LOGS} Просмотреть логи ноды Rivalz"
    echo -e "    ${CYAN}6.${RESET} ${ICON_EXIT} Выйти"
    draw_bottom_border
    echo -ne "${YELLOW}Введите ваш выбор [1-6]: ${RESET}"
}

# Главный цикл
while true; do
    show_menu
    read choice
    case $choice in
        1) install_node ;;
        2) display_id_env ;;
        3) stop_node ;;
        4) restart_node ;;
        5) view_logs ;;
        6) break ;;
        *) echo -e "${ERROR} Неверный выбор, попробуйте снова.${RESET}" ;;
    esac
done
