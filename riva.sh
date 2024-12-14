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
ICON_EXIT="\❌"

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

print_telegram_icon() {
    echo -e "          ${MAGENTA}🚀 Подписывайтесь на наш Telegram!${RESET}"
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

# Отображение меню
show_menu() {
    clear
    draw_top_border
    display_ascii
    draw_middle_border
    print_telegram_icon
    echo -e "    ${BLUE}Криптан, подпишись!: ${YELLOW}https://t.me/indivitias${RESET}"
    draw_middle_border

    echo -e "    ${YELLOW}Пожалуйста, выберите опцию:${RESET}"
    echo
    echo -e "    ${CYAN}1.${RESET} ${ICON_INSTALL} Установить ноду Rivalz"
    echo -e "    ${CYAN}2.${RESET} ${ICON_UPDATE} Обновить ноду"
    echo -e "    ${CYAN}3.${RESET} ${ICON_WALLET} Поменять кошелек"
    echo -e "    ${CYAN}4.${RESET} ${ICON_STORAGE} Поменять потребляемое кол-во места диска"
    echo -e "    ${CYAN}5.${RESET} ${ICON_INFO} Информация о ноде"
    echo -e "    ${CYAN}6.${RESET} ${ICON_FIX} Исправить ошибку Running on another..."
    echo -e "    ${CYAN}7.${RESET} ${ICON_DELETE} Удалить ноду"
    echo -e "    ${CYAN}8.${RESET} ${ICON_EXIT} Выйти из скрипта"
    draw_bottom_border
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}║${RESET}              ${YELLOW}Введите свой выбор [1-8]:${RESET}           ${CYAN}║${RESET}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${RESET}"
    read -p " " choice
}

# Основное меню
while true; do
    show_menu
    case $choice in
        1)
            echo "Начинаю установку ноды..."
            echo "Происходит обновление пакетов..."
            if sudo apt update && sudo apt upgrade -y; then
                echo "Обновление пакетов: Успешно"
            else
                echo "Обновление пакетов: Ошибка"
                exit 1
            fi

            echo "Установка screen..."
            if sudo apt-get install screen -y; then
                echo "Установка screen: Успешно"
            else
                echo "Установка screen: Ошибка"
                exit 1
            fi

            echo "Скачиваем Node.Js..."
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
            if sudo apt install -y nodejs; then
                echo "Устанвока Node.Js: Успешно"
            else
                echo "Установка Node.Js: Ошибка"
                exit 1
            fi

            echo "Установка ноды Rivalz..."
            npm i -g rivalz-node-cli

            rivalz run
            ;;
        2)
            npm i -g rivalz-node-cli@2.6.2
            rivalz run
            ;;
        3)
            rivalz change-wallet
            ;;
        4)
            rivalz change-hardware-config
            ;;
        5)
            rivalz info
            ;;
        6)
            echo "Начинаю делать исправление..."
            rm -f /etc/machine-id
            dbus-uuidgen --ensure=/etc/machine-id
            cp /etc/machine-id /var/lib/dbus/machine-id
            echo "Готово!"
            ;;
        7)
            sudo npm uninstall -g rivalz-node-cli
            ;;
        8)
            exit 0
            ;;
        *)
            echo "Неверная пункт. Пожалуйста, выберите правильную цифру в меню."
            ;;
    esac
done
