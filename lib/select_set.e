indexing

	description: "A set of sockets with associated I/O handlers. When %
                 %a socket is ready for I/O it's handle will be called."
	date: "10/12/1998"
	author: "Copyright 1998 - Richard Bielak"

class SELECT_SET

inherit
	
	SOCKET_EXTERNALS

creation

	make

feature

	make is
		do
			-- create empty arrays to start
			!!fd.make (0, -1)
			!!handlers.make (0, -1)
			!!ready.make (0, -1)
			count := 0
			-- time_out := -1
			time_out_seconds := 0
			time_out_micro_seconds := 0
		end

	handle_socket_io is
			-- wait for a socket to become ready and invoke 
			-- appropriate handler. This call completes when there
			-- no more handlers to watch. Handlers can remove 
			-- themselves from the set when their sockets are closed
		local
			done: BOOLEAN
			i: INTEGER
			status: INTEGER
		do
			from
			until (last_status = -1) or count = 0
			loop
				poll_socket_io
--				status := do_select
--				-- TODO: Should raise exception if get "-1"
--				if status = -1 then
--					print ("*** Select failed!!! %N")
--					done := True
--				elseif status = 0 then
--					-- we timed out, just issue the select again???
--				else
--					-- select completed with some sockets ready 
--					-- invoke the handlers
--					from i := 0
--					until i >= ready.count 
--					loop
--						if ready.item (i) > 0 then
--							handlers.item (i).action
--						end
--						i := i + 1
--					end
--				end
			end
		end

	poll_socket_io is
			-- wait for a socket to become ready and invoke 
			-- appropriate handler. This call completes when there
			-- no more handlers to watch. Handlers can remove 
			-- themselves from the set when their sockets are closed
		local
			i: INTEGER
		do
			last_status := do_select
			-- TODO: Should raise exception if get "-1"
			if last_status = -1 then
			elseif last_status = 0 then
			else
				-- select completed with some sockets ready 
				-- invoke the handlers
				from i := 0
				until i >= ready.count 
				loop
					if ready.item (i) > 0 then
						handlers.item (i).action
					end
					i := i + 1
				end
			end
		end

	last_status: INTEGER
			-- status of last call

	add_socket_io_handler (h: SOCKET_IO_HANDLER) is
		require
			handler_valid: (h /= Void) and then (h.the_socket /= Void)

		do
			h.set_select_set (Current)
			handlers.force (h, count)
			fd.force (h.the_socket.fd, count)
			ready.force (0, count)
			count := count + 1
		ensure
			count = old count + 1
		end

	remove_socket_io_handler (h: SOCKET_IO_HANDLER) is
		require
			handler_valid: h /= Void
		local
			found: BOOLEAN
			i: INTEGER
		do
			-- find the index of the handler
			from i := 0
			until (i >= count) or found
			loop
				found :=  h = handlers.item (i)
				if not found then
					i := i + 1
				end
			end
			if found then
				-- just move last entry into the removed spot
				-- decrease "count"
				if i < count then
					fd.put (fd.item (count-1) , i)
					handlers.put (handlers.item (count-1) , i)
				end
				count := count - 1
			end
		end

	count: INTEGER
			-- number of sockets in the set

feature -- timeouts

	time_out_seconds: INTEGER
			-- time out for select operation (initially -1)

	time_out_micro_seconds: INTEGER

	set_time_out (a_time_out_seconds, a_time_out_micro_seconds: INTEGER) is
		require
			a_time_out_seconds >= 0
			a_time_out_micro_seconds >= 0
		do
			time_out_seconds := a_time_out_seconds
			time_out_micro_seconds := a_time_out_micro_seconds
		end

	set_time_out_never is
			-- select will block forever
		do
			time_out_seconds := -1
		end

feature {NONE}

	fd: ARRAY [INTEGER]
			-- file descriptors

	handlers: ARRAY [SOCKET_IO_HANDLER]
			-- corresponding handlers

	ready: ARRAY [INTEGER]
			-- flags showing which sockets are ready after a select 

	do_select: INTEGER is
			-- perform a select to find sockets that are ready
		do
			-- this code fills in the "ready" array
			Result := c_select ($(fd.area), $(ready.area), count, 
								time_out_seconds, time_out_micro_seconds)
		end

invariant

	consistent_tables: (fd.count = handlers.count)

end

