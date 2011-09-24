indexing

	description: "Root class of the Emu http server"
	date: "10/30/98"
	author: " Copyright (c) 1998, Richard Bielak"

class EMU_HTTPD

inherit
	
	ARGUMENTS
	
	SHARED_DOCUMENT_ROOT

creation

	make

feature

	port: INTEGER
			-- port the server listens on

	document_root: STRING
			-- base path for server documents

	make is
			-- start the server: we expect two arguments: port on 
			-- which to listen and a documents directory. All 
			-- requests for files will be server relative to this directory
		do
			if argument_count < 2 then
				print ("Usage: emu_httpd <port-number> <doc-root>%N")
			else
				-- TODO: improve this code - add error checks
				port := argument (1).to_integer
				document_root := argument (2)
				document_root_cell.put (document_root)
				print ("Emu port: ")
				print (port)
				print (" Doc root: ")
				print (document_root)
				print ("%N")
				init_server
				serve
			end
		rescue
			-- handle kill signals and some such
		end

feature {NONE}

	server_socket: SERVER_SOCKET
			-- socket for accepting of new connections

	server_socket_handler: SERVER_SOCKET_HANDLER
			-- handler for incoming connections

	selector: SELECT_SET
			-- dispatches I/O to all active sockets 

	init_server is
			-- set up the server
		require
			valid_port: port > 0
		do
			-- prepare the socket
			!!server_socket.make_inet_stream
			server_socket.set_port (port)
			server_socket.prepare_to_listen
			-- prepare the selector
			!!selector.make
			!!server_socket_handler.make (server_socket)
			selector.add_socket_io_handler (server_socket_handler)
		end

	serve is
			-- this routine never exists
		do
			selector.handle_socket_io
		end

end
