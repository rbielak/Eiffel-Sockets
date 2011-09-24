OBJS = ise_socket.o test_sock.o
LDLIBS = 
CFLAGS = -g -I$(EIFFEL4)/bench/spec/$(PLATFORM)/include
CC = gcc


test_sock: $(OBJS)
	gcc -o test_sock $(OBJS) $(LDLIBS) 
