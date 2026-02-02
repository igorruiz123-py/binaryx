#include "hexa.h"
#include "bin.h"
#include "dec.h"
#include "error_codes.h"

int parse_base(const char *base) {
    if (strcmp(base, "binary") == 0) return 2;
    if (strcmp(base, "decimal") == 0) return 10;
    if (strcmp(base, "hexadecimal") == 0) return 16;
    return -1;
}

int main(int argc, char *argv[]){

    if (argc != 5){
        printf(ERROR_CODE_340);
        exit (EXIT_FAILURE);
    }

    if (strcmp(argv[1], "convert") != 0){
        printf(ERROR_CODE_340);
        exit (EXIT_FAILURE);
    }


    int base_from = parse_base(argv[3]);
    int base_to = parse_base(argv[4]);

    // bin -> dec
    if (base_from == 2 && base_to == 10){

        unsigned long long number = convert_bin_dec(argv[2]);

        printf("output: %llu \n", number);

    }

    // hex -> dec
    else if (base_from == 16 && base_to == 10){

        unsigned long long number = convert_hex_dec(argv[2]);

        printf("output: %llu \n", number);

    }

    // dec -> bin
    else if (base_from == 10 && base_to == 2){

        char *number = convert_dec_bin(argv[2]);

        printf("output: %s \n", number);
    }

    // hex -> bin
    else if (base_from == 16 && base_to == 2){

        char *number = convert_hex_bin(argv[2]);

        printf("output: %s \n", number);
    }

    // dec -> hex
    else if (base_from == 10 && base_to == 16){

        char *number = convert_dec_hex(argv[2]);

        printf("output: %s \n", number);
    }

    // bin -> hex
    else if (base_from == 2 && base_to == 16){

        char *number = convert_bin_hex(argv[2]);

        printf("output: %s \n", number);
    }

    else {
        printf(ERROR_CODE_340);
    }

    return 0;
}