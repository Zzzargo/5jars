CFLAGS=-Wall -Wextra -Werror
.PHONY:run clean

run:
	gcc $CFLAGS source/5jars.cpp source/Cont.cpp -o 5jars
	./5jars
clean:
	rm -f 5jars
