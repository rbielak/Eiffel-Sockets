/*

  C-code for the ISE version of Socket libs.

  Based on code I wrote years ago and on great examples from the
  book "Linux Application Development" by Johnson and Troan.

  Date: 10/8/98
  Author: Richard Bielak
  Copyright - Richard Bielak, 1998

  Changes: 

  1/6/99 - Window's code by Andreas Leitner (andreas.leitner@teleweb.at)


 */

#include "eif_eiffel.h"
#ifndef _WIN32
#include <sys/socket.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <netdb.h>
#endif

/* Connect client socket to a given port and host */
int c_connect_inet (int sock, const char *host, int port) {
  struct sockaddr_in sv;
  struct hostent *hp;

  sv.sin_family = AF_INET;
  sv.sin_port = htons (port);

  hp = gethostbyname (host);
  if (hp == NULL) 
    return (-1);
  memcpy (&sv.sin_addr, hp->h_addr_list[0], sizeof (sv.sin_addr));
  return (connect (sock, &sv, sizeof(sv)));

}

/* Bind a socket to a port */
int c_bind (int sock, int port) {
  int i;
  struct sockaddr_in sv;

  /* Set socket options to be reused right away */
  i = 1;
  setsockopt (sock, SOL_SOCKET, SO_REUSEADDR, &i, sizeof (i));
  
  sv.sin_family = AF_INET;
  sv.sin_port = htons (port);
  memset (&sv.sin_addr, 0, sizeof (sv.sin_addr));
  return (bind (sock, (struct sockaddr *) &sv, sizeof (sv)));
}

/* Accept connection on a server socket */
int c_accept(int sock) {
  struct sockaddr_in sv;
  size_t sv_len;
  
  return (accept(sock, (struct sockaddr *)&sv, &sv_len));

}

/* Select a socket ready for reading. Returns:    */
/*        0 - if timed out                        */
/*       -1 - if error                            */
/*        N - number of sockets ready             */
int c_select (int fds[], int ready[], int count, int seconds, int micro_seconds) {

  fd_set inset;
  int max_fd = 0;
  int i, result;
  struct timeval tv;

  FD_ZERO (&inset);
  /* Put all the decriptors we were passed in the "inset" */
  /* And figure out the max descriptor value.             */
  for (i=0; i<count; i++)
	{
	  FD_SET (fds[i], &inset);
	  if (max_fd < fds[i])
		max_fd = fds[i];
	}

  if (seconds != -1) {
	  tv.tv_sec = seconds;
	  tv.tv_usec = micro_seconds;
	  result = select (max_fd + 1, &inset, NULL, NULL, &tv);
	}
  else
	  result = select (max_fd + 1, &inset, NULL, NULL, NULL);

  if (result > 0) {
	/* mark fds that are ready */
	for (i=0; i < count; i++) {
	  ready[i] = FD_ISSET (fds[i], &inset);
	}
  }
  return (result);
}

#ifdef _WIN32
int c_get_last_error ()
{
	return WSAGetLastError ();
}
#else

int c_get_last_error ()
{
	return errno; // Hope this works ?!
}
#endif


 
#ifdef _WIN32
int c_init_sockets ()
// Function to initialize the winsock dll for an application
// returns 0 on success -1 on failure
// Note: I simply request 2.2 as version, this is just the 
// version that is requested in the msdn-sample I looked up
// the code. Maybe we could use a version lower ?!
{
	WORD wVersionRequested;
	WSADATA wsaData;
	int err; 
	wVersionRequested = MAKEWORD( 2, 2 ); 
	err = WSAStartup( wVersionRequested, &wsaData );
	if ( err != 0 ) 
	{
	   /* Tell the user that we could not find a usable */
   	/* WinSock DLL.                                  */    
		return -1;
	} 

	/* Confirm that the WinSock DLL supports 2.2.*/
	/* Note that if the DLL supports versions greater    */
	/* than 2.2 in addition to 2.2, it will still return */
	/* 2.2 in wVersion since that is the version we      */
	/* requested.                                        */ 
	if ( LOBYTE( wsaData.wVersion ) != 2 ||
        HIBYTE( wsaData.wVersion ) != 2 ) 
	{
    	/* Tell the user that we could not find a usable */
    	/* WinSock DLL.                                  */    
		WSACleanup( );
    	return -1; 
	} 
	/* The WinSock DLL is acceptable. Proceed. */
	return 0;
}
#else
int c_init_sockets ()
{
	return 0;
}


void closesocket (int fd) {
  close (fd);
}

#endif

/* function reads 'count' bytes from socket 'fd' into 'buf' */
int c_read (int fd, char* buf, int count)
{
	return recv (  fd, buf,	count, 0);
}

/* function writes 'count' bytes to socket 'fd' from 'data' */
int c_write(int fd, char* data, int count)
{
	send (fd, data, count, 0);
}

/* function gets the ip address of the local host */
char* c_get_host_ip ()
{
  char hostname[255];  // hopefully enough
  struct hostent *hp;
  char* ip;
  
  
  if (gethostname(hostname, sizeof (hostname)) == -1)
	return (NULL);
  hp = gethostbyname (hostname);
  
  if (hp == NULL) 
    return NULL;
  
  ip = (char *)malloc (255);
  
  strncpy (ip, (char *)inet_ntoa((struct in_addr *)hp->h_addr), 255);
  return ip;
}

