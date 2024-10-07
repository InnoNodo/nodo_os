bits 16
org 0x7C00
start:
    mov ax, 0x0000  ; Устанавливаем сегмент данных в 0
    mov ds, ax
    mov es, ax

    ; Переходим в реальный режим
    jmp $

times 510 - ($ - $$) db 0  ; Заполняем оставшиеся байты нулями
dw 0xAA55  ; Загрузочный сектор (signature)
