indexing

	description: "Table of all http request handlers"
	date: "11/9/98"
	author: "Copyright (c) 1998, Richie Bielak"

class SHARED_HTTP_REQUEST_HANDLERS

feature

	http_request_handlers: DS_HASH_TABLE [HTTP_REQUEST_HANDLER, STRING] is
		local
			a_handler: HTTP_REQUEST_HANDLER
		once
			!!Result.make (5)
			!GET_REQUEST_HANDLER!a_handler
			Result.put (a_handler, "GET")
		end

end
