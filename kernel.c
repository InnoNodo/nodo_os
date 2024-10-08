void kernel_main(void) {
    char *video_memory = (char*) 0xb8000;

    // Очистка экрана
    for (int i = 0; i < 80 * 25; i++) {
        video_memory[i * 2] = ' ';    // Символ пробела
        video_memory[i * 2 + 1] = 0x07; // Цвет (белый на черном)
    }

    // Вывод сообщения
    video_memory[0] = 'H';
    video_memory[1] = 0x07; // Цвет (белый на черном)
    video_memory[2] = 'i';
    video_memory[3] = 0x07; // Цвет (белый на черном)
}
