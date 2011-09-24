indexing

	description: "Handle I/O on a server sockets"
	date: "10/23/98"
	author: "Copyright (c) 1998 - Richard Bielak"

class SERVER_SOCKET_HANDLER

inherit

	SOCKET_IO_HANDLER
		redefine
			the_socket
		end

creation

	make 

feature

	make (s_socket: SERVER_SOCKET) is
		require
			valid: s_socket /= Void
			ready: s_socket.listening
		do
			the_socket := s_socket
		end

	action is
			-- called when a connection received
		local
			client_socket_handler: CLIENT_SOCKET_HANDLER
		do
			the_socket.accept_connections
			print ("Server received a connection%N")
			-- add the accepted connection to the set with its client 
			-- handler
			if the_socket.last_accepted /= Void then
				!!client_socket_handler.make (the_socket.last_accepted)
				select_set.add_socket_io_handler (client_socket_handler)
			end
			print ("Waiting for another one...%N")
		end
	
	the_socket: SERVER_SOCKET

end
