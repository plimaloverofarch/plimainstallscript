#!/bin/bash

# Проверка и установка Gum
if ! command -v gum &> /dev/null; then
    echo "Установка интерфейса Gum..."
    sudo pacman -Sy --noconfirm gum || { 
        echo "❌ Ошибка: Не удалось установить gum. Убедись, что используешь Arch/CachyOS."
        exit 1 
    }
fi

if ! command -v paru &> /dev/null; then
    echo "Установка Paru..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru-install
    cd /tmp/paru-install && makepkg -si --noconfirm && cd ~ && rm -rf /tmp/paru-install
fi

# Главный цикл
while true; do
    clear
    # Отрисовка красивого заголовка
    gum style \
        --foreground 212 --border-foreground 212 --border double \
        --align center --width 50 --margin "1 2" --padding "1 4" \
        "⚡ CACHY MANAGER"

    echo " Выбери действие (используй стрелочки и Enter):"
    
    # Главное меню
    CHOICE=$(gum choose \
        "📦 Установить пакет" \
        "🗑️  Удалить пакет" \
        "🔄 Обновить систему" \
        "🛠️  Скрипты (VPN)" \
        "❌ Выход")

    case $CHOICE in
        "📦 Установить пакет")
            echo -e "\nВведите название пакета:"
            PKG=$(gum input --placeholder "например: btop или visual-studio-code-bin")
            if [ -n "$PKG" ]; then
                clear
                gum style --foreground 99 "Начинаем установку $PKG..."
                paru -S "$PKG"
                gum style --foreground 46 "Готово! Нажми Enter..."
                read
            fi
            ;;
        "🗑️  Удалить пакет")
            echo -e "\nВведите название пакета для удаления:"
            PKG=$(gum input --placeholder "название...")
            if [ -n "$PKG" ]; then
                clear
                gum style --foreground 196 "Удаление $PKG..."
                paru -Rns "$PKG"
                gum style --foreground 46 "Готово! Нажми Enter..."
                read
            fi
            ;;
        "🔄 Обновить систему")
            clear
            gum style --foreground 99 "Поиск обновлений..."
            paru -Syu
            gum style --foreground 46 "Готово! Нажми Enter..."
            read
            ;;
        "🛠️  Скрипты (VPN)")
            clear
            gum style --foreground 212 --border normal --padding "1" "Пользовательские скрипты"
            SCRIPT_CHOICE=$(gum choose "🌐 Настроить VPN" "🧹 Очистить кэш пакетов" "⬅️  Назад")
            
            case $SCRIPT_CHOICE in
                "🌐 Настроить VPN")
                    clear
                    gum style --foreground 99 "Запуск настройки VPN..."
                    # ==========================================
                    # ЗДЕСЬ ПИШИ КОМАНДЫ ДЛЯ VPN
                    # ==========================================
                    echo "Здесь будут выполняться твои команды."
                    gum style --foreground 46 "Готово! Нажми Enter..."
                    read
                    ;;
                "🧹 Очистить кэш пакетов")
                    clear
                    gum style --foreground 99 "Очистка кэша..."
                    paru -Sc --noconfirm
                    gum style --foreground 46 "Готово! Нажми Enter..."
                    read
                    ;;
            esac
            ;;
        "❌ Выход")
            clear
            gum style --foreground 46 "До встречи!"
            exit 0
            ;;
    esac
done