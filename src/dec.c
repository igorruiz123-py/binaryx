#include "dec.h"
#include "error_codes.h"

unsigned long long convert_bin_dec(const char *bin){

    unsigned long long decimal = 0;

    for (int i = 0; bin[i] != '\n' && bin[i] != '\0'; i++){

        if (bin[i] != '0' && bin[i] != '1'){
            printf(ERROR_CODE_330);
            exit (EXIT_FAILURE);
        }

        decimal = decimal * 2 + (bin[i] - '0');
    }

    return decimal;
}

unsigned long long convert_hex_dec(const char *hex){

    unsigned long long decimal = 0;
    int value = 0;

    for (int i = 0; hex[i] != '\0' && hex[i] != '\n'; i++){

        if (hex[i] >= '0' && hex[i] <= '9'){
            value = hex[i] - '0';
        }

        else if (hex[i] >= 'A' && hex[i] <= 'F'){
            value = hex[i] - 'A' + 10;
        }

        else if (hex[i] >= 'a' && hex[i] <= 'f'){
            value = hex[i] - 'a' + 10;
        }

        else {
            printf(ERROR_CODE_320);            
            exit(EXIT_FAILURE);
        }

        decimal = decimal * 16 + value;
    }

    return decimal;
}
