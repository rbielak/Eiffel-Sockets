indexing

	description: "Socket that accepts connections"
	date: "10/10/98"
	author: "Copyright 1998 - Richard Bielak"

class SERVER_SOCKET

inherit

	SOCKET
		rename
			is_connected as listening
		end

creation

	make_inet_stream

feature -- prepare for listening

	port: INTEGER
			-- port to listen to

	set_port (new_port: INTEGER) is
			-- set the port
		require
			valid_port: new_port /= 0
			not_listening: not listening
		do
			port := new_port
		ensure
			port = new_port
		end

	prepare_to_listen is
			-- prepare the socket for listening for connections
		require
			port_set: port /= 0
			not_listening: not listening
		do
			-- bind 
			if c_bind (fd, port) = 0 then
				-- listen
				if c_listen (fd, 5) = 0 then
					listening := True
				end
			end
		ensure
			listening: listening
		end

feature  -- accepting

	accept_connections is
			-- accept incoming connections
		require
			listening: listening
		local
			sock: INTEGER
		do
			last_accepted := Void
			sock := c_accept (fd);
			if sock >= 0 then
				!!last_accepted.make_from_fd (sock)
				-- TODO: should also copy socket type etc from 
				-- current socket
			end
		ensure
			listening implies last_accepted /= Void
		end

	last_accepted: SOCKET
			-- socket last accepted

invariant
	
	port_consistent: listening implies port /= 0

end
