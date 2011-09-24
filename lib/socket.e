--
-- Changes:
--    1/6/99 - integrated Andreas Leitner changes.
--
indexing

	description: "Access to a basic Unix socket"
	date: "9/24/98"
	author: "Copyright 1998 - Richard Bielak"

class SOCKET

inherit

	SOCKET_EXTERNALS
		export {NONE} all
		end;

	SOCKET_CONSTANTS

	MEMORY
		redefine
			dispose
		end

	EXCEPTIONS

creation

	make_inet_stream,
	make_from_fd

feature {NONE} -- creation

	make_inet_stream is
			-- created an unconected socket
		do
			init_sockets
			p_family := pf_inet
			socket_type := sock_stream
			fd := c_socket (pf_inet, sock_stream, 0)
			!!buffer.make (1, 1024)
		ensure
			socket_created: fd > 0
		end


	make_from_fd (new_fd: INTEGER) is
		require
			new_fd_valid: new_fd > 0
		do
			init_sockets
			fd := new_fd
			is_connected := True
			!!buffer.make (1, 1024)
		ensure
			is_connected
		end

feature 

	close is
			-- close this socket
		require
			is_connected
		do
			if c_close (fd) = 0 then
				is_connected := False
				end_of_file := True
			end
		ensure
			not is_connected
		end
				

	is_connected: BOOLEAN
			-- true is the socket is connected

feature -- reading

	end_of_file: BOOLEAN
			-- true when there is nothing more to read

	last_string: STRING
			-- last string read

	read_string is
			-- read at most 'count' bytes from the socket
		require
			connected: is_connected
		local
			sz: INTEGER
		do
			sz := read (fd, $(buffer.area), buffer.count)
			if sz > 0 then
				!!last_string.make (sz)
				last_string.from_c_substring ($(buffer.area), 1, sz)
			elseif sz = 0 then
				last_string := Void
				end_of_file := True
			end

				-- What if sz == -1 ? (resp. SOCKET_ERROR)
		ensure
			-- last_string contains the read data
		end

	last_integer: INTEGER
			-- last integer read

	read_integer is
			-- read an integer from the socket
		require
			connected: is_connected
		do
		ensure
			-- last_integer has the answer
		end

feature -- writing

	put_string (s: STRING) is
			-- write a string
		require
			connected: is_connected
			valid_string: (s /= Void) and then (s.count > 0)
		local
			sz: INTEGER
		do
			sz := write (fd, $(s.to_c), s.count)
		end
					   
	put_integer (n: INTEGER) is
		require
			connected: is_connected
		do
		end

feature -- polling

	wait_for_data (seconds, micro_seconds: INTEGER) is
			-- wait at maximum for 'seconds' seconds + 'micro_seconds' 
			-- for incomming data on this port.
			--
			-- if data is ready before that timelimit the routine returns 
			-- and sets 'data_ready' to 'True'. if the timelimit exceeds without
			-- any incomming data available, the routine returns with 'data_ready'
			-- set to 'False'
		local
			a_fds: ARRAY [INTEGER]
			a_ready: ARRAY [INTEGER]
			select_result: INTEGER
		do
			!! a_fds.make (0, 0)
			a_fds.put (fd, 0)
			!! a_ready.make (0, 0)
			-- this code fills in the "ready" array
			select_result := c_select ($(a_fds.area), $(a_ready), 1, seconds, micro_seconds)
			
			inspect
				select_result
			when -1 then
				data_ready := False  -- issue exception and set an error flag instead ?!
			when 0 then
				data_ready := False
			else
				data_ready := True
			end
		end

	data_ready: BOOLEAN
			-- true if data is available on this socket


feature -- socket info

	host_ip: STRING is
			-- retrieves the IP for the local host
		local
			ip: POINTER
		do
			ip := c_get_host_ip
			if
				ip = Void 
			 then
				raise ("cannot get host ip")
			end
			!! Result.make (0)
			Result.from_c (ip)
			-- TODO: need to free memory of ip !!
		ensure
			Result /= Void
		end

feature {SELECT_SET}

	fd: INTEGER
			-- descriptor for this socket

feature {NONE} -- implementation

	buffer: ARRAY [CHARACTER]
			-- buffer for reading data

	p_family: INTEGER
			-- protocol family

	socket_type: INTEGER 
			-- type of socket

	init_sockets is
			-- this routine intializes the Window's socket libs. It's 
			-- a no-op for Unix.
		local
			value: INTEGER
		once
			value := c_init_sockets
			check
				value = 0
			end
		end

	dispose is
		do
			if is_connected then
				close
			end
		end

invariant

	valid_socket: fd > 0
	buffer_exists: buffer /= Void

end
