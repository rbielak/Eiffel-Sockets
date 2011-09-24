indexing

	descriptions: "Constants needed for Socket calls (Linux)"
	author: "Richie Bielak"
	date: "10/1/98"

class SOCKET_CONSTANTS

feature

	-- address family constants
	af_inet: INTEGER is 2
	af_unix: INTEGER is 1

	-- protocol family constants
	pf_unix: INTEGER is 1
	pf_inet: INTEGER is 2

	-- types of sockets
	sock_stream: INTEGER is 1
	sock_dgram: INTEGER is 2
	sock_raw: INTEGER is 3

end
