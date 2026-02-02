#include "bin.h"
#include "error_codes.h"

int div_by_2(char *num){

    int carry = 0;

    for (int i = 0; num[i] != '\0'; i++){

        if (num[i] < '0' || num[i] > '9'){
            printf(ERROR_CODE_310);
            exit (EXIT_FAILURE);
        }

        int current = carry * 10 + (num[i] - '0');
        num[i] = (current / 2) + '0';
        carry = current % 2;
    }

    int shift = 0;
    while (num[shift] == '0' && num[shift + 1] != '\0'){
        shift++;
    }

    if (shift > 0){
        memmove(num, num + shift, strlen(num + shift) + 1);
    }

    return carry;
}

char *convert_dec_bin(const char *dec_str){

    // copia porque vamos modificar
    char *num = strdup(dec_str);
    if (!num){
        perror("strdup");
        exit(EXIT_FAILURE);
    }

    size_t capacity = strlen(dec_str) * 4 + 1; // margem segura
    char *bin = malloc(capacity);
    if (!bin){
        perror("malloc");
        exit(EXIT_FAILURE);
    }

    size_t i = 0;

    // enquanto num != "0"
    while (!(num[0] == '0' && num[1] == '\0')){
    int bit = div_by_2(num);

    if (bit == -1){
        free(num);
        free(bin);
        return NULL;
    }

    bin[i++] = bit + '0';
}

    bin[i] = '\0';

    // inverter bits
    for (size_t j = 0; j < i / 2; j++){
        char tmp = bin[j];
        bin[j] = bin[i - j - 1];
        bin[i - j - 1] = tmp;
    }

    free(num);
    return bin;
}

char *convert_hex_bin(const char *hex){

    static const char *map[] = {
        "0000","0001","0010","0011",
        "0100","0101","0110","0111",
        "1000","1001","1010","1011",
        "1100","1101","1110","1111"
    };

    size_t len = strlen(hex);
    char *bin = malloc(len * 4 + 1);

    if (!bin){
        perror("malloc");
        exit(EXIT_FAILURE);
    }

    size_t pos = 0;

    for (size_t i = 0; i < len; i++){
        char c = hex[i];
        int value;

        if (c >= '0' && c <= '9')
            value = c - '0';
        else if (c >= 'A' && c <= 'F')
            value = c - 'A' + 10;
        else if (c >= 'a' && c <= 'f')
            value = c - 'a' + 10;
        else{
            printf(ERROR_CODE_320);
            free(bin);
            exit(EXIT_FAILURE);
        }

        memcpy(bin + pos, map[value], 4);
        pos += 4;
    }

    bin[pos] = '\0';
    return bin;
}

