CC := gcc
CFLAGS := $(shell pkg-config --cflags hidapi-hidraw appindicator3-0.1 gtk+-3.0) -Wall -Wextra -Werror -O2
LDFLAGS := $(shell pkg-config --libs hidapi-hidraw appindicator3-0.1 gtk+-3.0)

SRC := k380-fnlock.c
TARGET := bin/k380-fnlock

$(shell mkdir -p bin)

.PHONY: all check-deps clean

all: check-deps $(TARGET)

check-deps:
	@pkg-config --exists hidapi-hidraw || { echo "Missing dependency: hidapi-hidraw"; exit 1; }
	@pkg-config --exists appindicator3-0.1 || { echo "Missing dependency: appindicator3-0.1"; exit 1; }
	@pkg-config --exists gtk+-3.0 || { echo "Missing dependency: gtk+-3.0"; exit 1; }

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET) $(LDFLAGS)

clean:
	rm -f $(TARGET)