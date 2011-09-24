--
-- Changed: 1/6/99
--     Integrated Andreas Leitner's changes to make portable between 
--     Linux and Windows.

indexing

	description: "Access to socket calls for ISE Eiffel"
	author: "Richie Bielak"
	date: "10/1/1998"

class SOCKET_EXTERNALS

feature {NONE} -- external calls

	c_socket (domain, type, protocol: INTEGER): INTEGER is
		external "C [macro <eiffel_sockets.h>] (EIF_INTEGER,EIF_INTEGER,EIF_INTEGER): EIF_INTEGER"
		alias "socket"
		end

	c_close (fd: INTEGER): INTEGER is
		external "C [macro <eiffel_sockets.h>] (EIF_INTEGER): EIF_INTEGER"
		alias "closesocket"
		end

	c_connect_inet (fd: INTEGER; host: POINTER; port: INTEGER): INTEGER is
			-- connect network socket
		external "C"
		end

	c_bind (fd: INTEGER; port: INTEGER): INTEGER is
		external "C"
		end

	c_listen (fd: INTEGER; backlog: INTEGER): INTEGER is
		external "C [macro <eiffel_sockets.h>] (EIF_INTEGER, EIF_INTEGER): EIF_INTEGER"
		alias "listen"
		end

	c_accept (fd: INTEGER): INTEGER is
		external "C"
		end

	read (fd: INTEGER; data: POINTER; count: INTEGER): INTEGER is
		external "C"
		alias "c_read"
		end

	write(fd: INTEGER; data: POINTER; count: INTEGER): INTEGER is
		external "C"
		alias "c_write"
		end

	c_select (fds: POINTER; ready_fds: POINTER; count: INTEGER; 
			  seconds: INTEGER; micro_seconds: INTEGER): INTEGER is
			-- timeout is in seconds. -1 for no timeout.
		external "C"
		end
	
	get_last_error: INTEGER is
			-- gets the last error code for a failed socket feature
		external "C"
		alias "c_get_last_error"
		end

	c_init_sockets : INTEGER is
			-- initializes the winsocket dll for the application 
			-- (only needed on windows platforms)
		external "C"
		end

	c_get_host_ip: POINTER is
		external "C"
		end


end
