#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdio.h>

extern int c_connect_inet (int sock, const char *host, int port);

void main (int argc, char *argv[]) {
  int fd;
  int stat;
  
  fd = socket (PF_INET, SOCK_STREAM, 0);
  printf ("fd = %d \n", fd);
  
  stat = c_connect_inet (fd, "idoru", 23);
  printf ("stat=%d \n");

}
