indexing

	description: "Simple server. Sends files to clients"
	date: "10/28/98"
	author: "Copyright (c) 1998 - Richard Bielak"

class SERVER

creation

	make

feature

	select_set: SELECT_SET
			-- set of sockets that we are handling

	server_port: INTEGER is 2001
			-- port on which we are listening

	server_socket: SERVER_SOCKET
			-- the socket that we use to listen for connections

	server_socket_handler: SERVER_SOCKET_HANDLER
			-- routines within this object will handle I/O on the 
			-- server socket

	make is
			-- main line of the server
		do
			-- create a server socket
			!!server_socket.make_inet_stream
			server_socket.set_port (server_port)
			server_socket.prepare_to_listen
			-- now create a set of sockets for select
			!!select_set.make
			-- create a handler for the server socket
			!!server_socket_handler.make (server_socket)
			select_set.add_socket_io_handler (server_socket_handler)
			print ("Server is ready. Listening on port: ")
			print (server_port)
			print ("%N")
			select_set.handle_socket_io
			print ("Server finished. Exiting...%N")
		end

end
