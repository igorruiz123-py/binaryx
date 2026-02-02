CC = gcc
CFLAGS = -Ilibs -Wall -Wextra

BIN_DIR = output/bin

SRCS = src/bin.c src/dec.c src/hexa.c src/main.c
OBJS = $(SRCS:src/%.c=$(BIN_DIR)/%.o)

TARGET = $(BIN_DIR)/binaryx

all: $(TARGET)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(TARGET): $(BIN_DIR) $(OBJS)
	$(CC) $(OBJS) -o $@

$(BIN_DIR)/%.o: src/%.c | $(BIN_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(BIN_DIR)/*.o $(TARGET)

.PHONY: all clean

PREFIX = /usr/local

install: $(BIN_DIR)/binaryx
	cp $(BIN_DIR)/binaryx $(PREFIX)/bin/

uninstall:
	rm -f $(PREFIX)/bin/binaryx
