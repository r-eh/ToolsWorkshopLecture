# Set the default C compiler: mpicc
CC := mpicc

# Set the default flags
CFLAGS ?= -std=c17
LDFLAGS ?= -lm
INCLUDE ?= 

TARGET ?= HelloWorld
OBJ_DIR ?= build
APP_DIR ?= bin

SRCS := $(wildcard src/*.c)
OBJS := $(SRCS:%.c=$(OBJ_DIR)/%.o)
DEPE := $(OBJS:.o=.d)

.PHONY: all check clean debug

all: CFLAGS += -O3
all: $(APP_DIR)/$(TARGET)

debug: CFLAGS += -O0 -g -g3 -Wall
debug: $(APP_DIR)/$(TARGET)

$(OBJ_DIR)/%.o: %.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCLUDE) -MMD -MP -c $< -o $@

$(APP_DIR)/$(TARGET): $(OBJS)
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

-include $(DEPE)

check: all
	mpiexec -n 1 --oversubscribe ./$(APP_DIR)/$(TARGET)
	mpiexec -n 4 --oversubscribe ./$(APP_DIR)/$(TARGET)
	mpiexec -n 16 --oversubscribe ./$(APP_DIR)/$(TARGET)

clean:
	-@rm -rf $(APP_DIR) $(OBJ_DIR)