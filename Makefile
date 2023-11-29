.PHONY: all build run clean fclean re

all: build

build:
	as -o main.o main.s
	gcc -o game main.o F1_Race.c -lSDL2 -lSDL2_mixer

run:
	./game

clean:
	-rm -f main.o

fclean: clean
	-rm -f game

re: fclean all
