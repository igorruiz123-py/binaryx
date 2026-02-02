#include "hexa.h"
#include "error_codes.h"



char *convert_dec_hex(const char *dec) {

    if (dec == NULL || *dec == '\0') {
        printf(ERROR_CODE_340);
        exit (EXIT_FAILURE);
    }

    long num = 0;

    for (int i = 0; dec[i] != '\0'; i++) {

        if (dec[i] < '0' || dec[i] > '9') {
            printf(ERROR_CODE_310);
            exit (EXIT_FAILURE);
        }

        num = num * 10 + (dec[i] - '0');
    }

    if (num == 0) {
        char *hex = malloc(2);
        if (!hex) return NULL;
        hex[0] = '0';
        hex[1] = '\0';
        return hex;
    }

    char buffer[65];
    int i = 0;
    static const char hex_map[] = "0123456789ABCDEF";

    while (num > 0) {
        buffer[i++] = hex_map[num % 16];
        num /= 16;
    }

    char *hex = malloc(i + 1);
    if (!hex) return NULL;

    for (int j = 0; j < i; j++) {
        hex[j] = buffer[i - j - 1];
    }

    hex[i] = '\0';
    return hex;
}


char *convert_bin_hex(const char *bin) {

    if (bin == NULL || *bin == '\0') {
        printf("Error: not binary. \n");
        exit (EXIT_FAILURE);
    }

    long num = 0;

    for (int i = 0; bin[i] != '\0'; i++) {

        if (bin[i] != '0' && bin[i] != '1') {
            printf(ERROR_CODE_330);
            exit (EXIT_FAILURE);
        }

        num = num * 2 + (bin[i] - '0');
    }

    if (num == 0) {
        char *hex = malloc(2);
        if (!hex) return NULL;
        hex[0] = '0';
        hex[1] = '\0';
        return hex;
    }

    char buffer[65];
    int i = 0;
    static const char hex_map[] = "0123456789ABCDEF";

    while (num > 0) {
        buffer[i++] = hex_map[num % 16];
        num /= 16;
    }

    char *hex = malloc(i + 1);
    if (!hex) return NULL;

    for (int j = 0; j < i; j++) {
        hex[j] = buffer[i - j - 1];
    }

    hex[i] = '\0';
    return hex;
}