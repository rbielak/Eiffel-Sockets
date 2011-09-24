indexing

	description: "Shared extension to contents mapping table"
	date: "11/10/98"
	author: "Copyright (c) 1998, Richie Bielak"
	

class SHARED_URI_CONTENTS_TYPES

feature

	ct_table: URI_CONTENTS_TYPES is
		once
			!!Result.make
		end

end
