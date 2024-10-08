bits 16
org 0x7C00

start:
    ; Очищаем сегменты, настраиваем начальные параметры
    cli                 ; Отключаем прерывания
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      ; Стек, чтобы было где работать

    ; Загружаем ядро (читаем сектор с диска)
    mov bx, 0x1000      ; Адрес в памяти, куда загрузим ядро (0x1000 = 64KB)
    call load_kernel

    ; Переходим в защищённый режим
    call enter_protected_mode

    ; Переход к ядру
    jmp 0x08:0x1000     ; Переходим на адрес ядра 0x1000

; Загрузка ядра с диска в память (чтение 1 сектора)
load_kernel:
    mov ah, 0x02        ; Функция BIOS для чтения с диска
    mov al, 1           ; Читаем 1 сектор
    mov ch, 0           ; Трек 0
    mov cl, 2           ; Начинаем со 2-го сектора (1-й сектор — загрузчик)
    mov dh, 0           ; Головка 0
    mov dl, 0x80        ; Первый жесткий диск
    int 0x13            ; Вызов BIOS для чтения
    jc load_kernel      ; Если ошибка, повторяем попытку
    ret

; Переход в защищённый режим
enter_protected_mode:
    ; Включаем A20
    in al, 0x64
    or al, 0x02
    out 0x64, al
.wait_a20:
    in al, 0x64
    test al, 0x02
    jnz .wait_a20

    ; Устанавливаем GDT (глобальную дескрипторную таблицу)
    lgdt [gdt_descriptor]

    ; Включаем защищённый режим
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; Теперь мы в защищённом режиме
    ret

gdt_start:
    ; Нулевой дескриптор
    dq 0x0000000000000000

    ; Кодовый сегмент
    dw 0xFFFF           ; limit 15:0
    dw 0x0000           ; base 15:0
    db 0x00             ; base 23:16
    db 10011010b        ; flags: present, ring 0, code segment
    db 11001111b        ; flags: 4KB granularity, 32-bit
    db 0x00             ; base 31:24

    ; Дескриптор данных
    dw 0xFFFF           ; limit 15:0
    dw 0x0000           ; base 15:0
    db 0x00             ; base 23:16
    db 10010010b        ; flags: present, ring 0, data segment
    db 11001111b        ; flags: 4KB granularity, 32-bit
    db 0x00             ; base 31:24

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

times 510 - ($ - $$) db 0
dw 0xAA55
