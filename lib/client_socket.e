indexing

	description: "Socket that can connect"
	date: "10/3/98"
	author: "Copyright 1998 - Richard Bielak"

class CLIENT_SOCKET

inherit

	SOCKET

creation

	make_inet_stream,
	make_and_connect

feature {NONE} -- creation

	make_and_connect (new_host_name: STRING; new_port: INTEGER) is
			-- create a socket and connect it
		require
			host_valid: new_host_name /= Void
			port_valid: new_port > 0
		do
			-- create the socket first
			make_inet_stream
			-- then connect it
			port := new_port
			host_name := clone (new_host_name)
			connect
		ensure
			port = new_port;
			host_name.is_equal (new_host_name);
			is_connected
		end

feature -- connection

	connect is
			-- connect to remote system
		require
			port_valid: port /= 0
			host_valid: host_name /= Void
			not_connected: not is_connected
		local
			status: INTEGER
		do
			if p_family = pf_inet then
				status := c_connect_inet (fd, $(host_name.to_c), port)
			else
				print ("***Error: socket.connect - not implemented%N")
			end
			is_connected := status = 0
		ensure
			is_connected
		end

feature -- destination 

	port: INTEGER
			-- port to which we're talking

	set_port (new_port: INTEGER) is
			-- change the port
		require
			not_connected: not is_connected
			port_valid: new_port > 0
		do
			port := new_port
		ensure
			port = new_port
		end

	host_name: STRING
			-- host to which we're talking

	set_host_name (new_host_name: STRING) is
		require
			not_connected: not is_connected
			host_valid: new_host_name /= Void
		do
			host_name := clone (new_host_name)
		ensure
			host_name.is_equal (new_host_name)
		end

invariant

	port_consistent: is_connected implies (port /= 0)

end
