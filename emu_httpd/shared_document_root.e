indexing

	description: "Shared variable that is set to the path to the %
                 %document root directory";
	date: "11/2/98"
	author: "Copyright (c) 1998, Richie Bielak"

class SHARED_DOCUMENT_ROOT

feature

	document_root_cell: CELL [STRING] is
		once
			!!Result.put (Void)
		end

end
