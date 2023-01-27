NAME = Stack

CC = swiftc
OPT =
VERSION =

FLAGS =
WARNINGS =
LIBS =
SWISPEC = ../../export/SwiSpec.swift

INPUT = $(NAME).swift $(NAME)Spec.swift testrunner.swift
OUTPUT = $(NAME)

all: compiler

compiler:
	cd ../../ && ./compile
	$(CC) $(OPT) $(VERSION) $(FLAGS) $(WANRINGS) $(LIBS) -o $(OUTPUT) $(SWISPEC) $(INPUT)
	./$(NAME)

clean:
	$(RM) -r $(OUTPUT)
