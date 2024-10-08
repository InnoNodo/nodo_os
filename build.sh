#!/bin/bash

# Остановка скрипта при ошибках
set -e

# Компиляция ядра
echo "Компиляция ядра..."
gcc -m32 -ffreestanding -c kernel.c -o kernel.o

# Ассемблирование загрузчика
echo "Ассемблирование загрузчика..."
nasm -f bin boot.asm -o boot.bin

## Линковка ядра
#echo "Линковка ядра..."
#i686-elf-ld -Ttext 0x1000 --oformat binary -o kernel.bin kernel.o

# Создание образа ОС
echo "Создание образа ОС..."
cat boot.bin kernel.o > os-image.bin

# Запуск в QEMU
echo "Запуск образа в QEMU..."
qemu-system-i386 -drive format=raw,file=os-image.bin

echo "Сборка завершена!"
