indexing

	description: "An http request handler"
	date: "11/2/98"
	author: "Copyright (c) 1998, Richie Bielak"

deferred class HTTP_REQUEST_HANDLER


feature

	set_uri (new_uri: STRING) is
			-- set new URI
		require
			valid_uri: new_uri /= Void
		do
			request_uri := new_uri
		end

	request_uri: STRING
			-- requested url

	set_data (new_data: STRING) is
			-- set new data
		do
			data := new_data
		end

	data: STRING
			-- the entire request message

	process is
			-- process the request and create an answer
		require
			valid_uri: request_uri /= Void
		deferred
		end

	answer: HTTP_RESPONSE
			-- reply to this request

	reset is
			-- reinit the fields 
		do
			request_uri := Void
			data := Void
			answer := Void
		end

end
