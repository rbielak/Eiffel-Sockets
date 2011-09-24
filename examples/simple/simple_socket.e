indexing

	description: "Simple example of socket communications"
	date: "10/27/98"
	author: "Richard Bielak"

class SIMPLE_SOCKET

inherit

	ARGUMENTS

creation

	make

feature

	port: INTEGER is 2001

	server_socket: SERVER_SOCKET

	client_socket: CLIENT_SOCKET

	make is
			-- run one copy as server one as client. Client asks for 
			-- a file, server sends it
		do
			if argument_count = 0 then
				print ("Usage: -{client|server} fname%N")
			elseif argument (1).is_equal ("-client") then
				client
			else
				server
			end
		end

	client is
			-- client: connect to server then ask for file
		do
			print ("Creating a client socket%N")
			!!client_socket.make_inet_stream
			print ("%N Created!!%N")
			client_socket.set_host_name ("localhost")
			client_socket.set_port (port)
			-- try and connect
			client_socket.connect
			if client_socket.is_connected then
				print ("Connect worked!!%N")
				print ("Sending to socket%N")
				client_socket.put_string (argument (2))
				print ("Reading from socket: %N")
				from
					client_socket.read_string				
				until 
					client_socket.end_of_file
				loop
					print (client_socket.last_string)
					print ("%N")
					client_socket.read_string
				end
				print ("==== finished%N")
				client_socket.close 
			else
				print ("Connect failed!!%N")
			end
			print ("Client done%N")
		end

	server is
			-- server: wait for connection, then send file
		do
			print ("Creating a server socket.%N")
			!!server_socket.make_inet_stream
			server_socket.set_port (port)
			server_socket.prepare_to_listen
			server_socket.accept_connections
			-- read from the socket that was created by accept_connections
			read_from_socket (server_socket.last_accepted)
			server_socket.close
			print ("Server done%N")
		end

	read_from_socket (s: SOCKET) is
		local
			f: PLAIN_TEXT_FILE
		do
			s.read_string
			print ("== Sending file: ")
			print (s.last_string)
			print ("%N")
			!!f.make_open_read (s.last_string)
			from
				f.read_line
			until 
				f.end_of_file
			loop
				if f.last_string.count = 0 then
					s.put_string ("%N")
				else
					s.put_string (f.last_string)
				end
				f.read_line
			end

			s.close
		end


end

