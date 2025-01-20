CFLAGS=-Wall -Wextra -g
.PHONY:run clean

build: source/5jars.cpp source/account.cpp
	g++ $(CFLAGS) source/5jars.cpp source/account.cpp source/user.cpp -o login.exe
run: login.exe
	./login.exe
# figure out a way to insert arguments
clean:
	rm -f 5jars
