indexing 
	
	description: "Handler for client connections"
	date: "10/23/98"
	author: "Richard Bielak"

class CLIENT_SOCKET_HANDLER

inherit
	
	SOCKET_IO_HANDLER

creation

	make

feature 

	make (c_socket: SOCKET) is
		require
			valid_socket: c_socket /= Void
			connected: c_socket.is_connected
		do
			the_socket := c_socket
		end

	action is
		do
			if the_socket.is_connected then
				-- read file name from socket and send it to the client
				read_from_socket (the_socket)
				the_socket.close
				select_set.remove_socket_io_handler (Current)
			end
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
			print ("== Finished%N")
		end


end
