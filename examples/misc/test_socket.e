class TEST_SOCKET

inherit

	ARGUMENTS

creation

	make

feature

	port: INTEGER is 3000
	
	ss: SERVER_SOCKET

	cs: CLIENT_SOCKET

	s_set: SELECT_SET

	make is
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
		do
			print ("Creating a client socket%N")
			!!cs.make_inet_stream
			print ("%N Created!!%N")
			cs.set_host_name ("idoru")
			cs.set_port (port)
			-- try and connec
			cs.connect
			if cs.is_connected then
				print ("Connect worked!!%N")
				print ("Sending to socket%N")
				cs.put_string (argument (2))
				print ("Reading from socket: %N")
				from
					cs.read_string				
				until 
					cs.end_of_file
				loop
					print (cs.last_string)
					print ("%N")
					cs.read_string
				end
				print ("==== finished%N")
				cs.close 
			else
				print ("Connect failed!!%N")
			end
			print ("Client done%N")
		end

	server_ss: SELECT_SET

	server is
		local
			server_handler: SERVER_SOCKET_HANDLER
		do
			print ("Creating a server socket.%N")
			!!ss.make_inet_stream
			ss.set_port (port)
			ss.prepare_to_listen
			
			!!server_ss.make
			!!server_handler.make (ss)
			server_ss.add_socket_io_handler (server_handler)
			
			print ("Server ready to accept connections. %N")
			server_ss.handle_socket_io
--			ss.accept_connections
--			read_from_socket (ss.last_accepted)
--			ss.close
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
		
