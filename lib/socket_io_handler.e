indexing

	description: "Objects of this type handle sockets that are ready %
                 %for I/O in a SELECT_SET"
	date: "10/12/1998"
	author: "Richie Bielak"

deferred class SOCKET_IO_HANDLER

feature

	the_socket: SOCKET
			-- socket for this handler

	action is
			-- what to do when the socket is ready
		deferred
		end

feature {SELECT_SET}

	select_set: SELECT_SET
			-- set to which this handler belongs

	set_select_set (ss: like select_set) is
		require
			select_set_valid: ss /= Void
			no_set_assigned: select_set = Void
		do
			select_set := ss
		ensure
			ss = select_set
		end

end
