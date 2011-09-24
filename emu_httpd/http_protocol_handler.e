indexing 
	
	description: "Handler for single http  connection"
	date: "11/9/98"
	author: "Copyright (c) 1998, Richard Bielak"

class HTTP_PROTOCOL_HANDLER

inherit
	
	SOCKET_IO_HANDLER

	SHARED_HTTP_REQUEST_HANDLERS

	HTTP_CONSTANTS

creation

	make

feature 
	
	make (c_socket: SOCKET) is
			-- make from a socket that was just connected
		require
			valid_socket: c_socket /= Void
			connected: c_socket.is_connected
		do
			the_socket := c_socket
		end


	action is
			-- this routine is called if there is data ready for 
			-- reading on our socket
		do
			if the_socket.is_connected then
				the_socket.read_string
				if not the_socket.end_of_file then
					debug
						print ("--- Received: %N")
						print (the_socket.last_string)
						print ("%N---------%N")
					end
					-- parse the request line to see
					parse_http_request_line (the_socket.last_string)
					-- Now get the handler for this method
					request_handler := http_request_handlers.item (current_method)
					if request_handler = Void then
						-- not supported method - send error reply
						!!answer.make
						answer.set_status_code (not_implemented)
						answer.set_reason_phrase (not_implemented_message)
						answer.set_reply_text ("Sorry! Not implemented!")
						answer.append_reply_text (crlf)
					else
						request_handler.set_uri (current_uri)
						request_handler.set_data (the_socket.last_string)
						request_handler.process
						answer := request_handler.answer
					end

					if answer /= Void then
						debug
							print ("Sending header: ")
							print (answer.reply_header)
						end
						-- TODO: This should be one I/O
						the_socket.put_string (answer.reply_header)
						if answer.reply_text /= Void then
							the_socket.put_string (answer.reply_text)
						end
					end
				end
				-- close socket after sending reply
				print ("Closing%N")
				the_socket.close
				select_set.remove_socket_io_handler (Current)
			end
		end

feature -- current request handler

	request_handler: HTTP_REQUEST_HANDLER
			-- handler for the request

	answer: HTTP_RESPONSE
			-- answer for the last request

feature -- handle header fields

	current_method: STRING
			-- method in current request (GET/POST, etc)

	current_uri: STRING
			-- uri for this request

	parse_http_request_line (line: STRING) is
		require
			line /= Void
		local
			pos, next_pos: INTEGER
		do
			-- parse (this should be done by a lexer)
			pos := line.index_of (' ', 1)
			current_method := line.substring (1, pos - 1)
			next_pos := line.index_of (' ', pos+1)
			current_uri := line.substring (pos+1, next_pos-1)
		ensure
			not_void_method: current_method /= Void	
		end

end
