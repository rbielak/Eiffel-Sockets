indexing

	description: "Constants needed for http"
	date: "11/9/98"
	author: "Copyright (c) 1998, Richie Bielak"

class HTTP_CONSTANTS

feature

	http_version: STRING is "HTTP/1.0"
	crlf: STRING is "%/13/%/10/"

feature -- error codes

	ok: STRING is "200"
	not_found: STRING is "404"
	server_error: STRING is "500"
	not_implemented: STRING is "501"

	-- messages
	ok_message: STRING is "OK"
	not_found_message: STRING is "URI not found"
	not_implemented_message: STRING is "Not Implemented"

feature -- content types

	text_html: STRING is "text/html"

end
