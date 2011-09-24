indexing

	description: "Mapping of file extensions to content types that %
                 %have to be put in http response headers"
	date: "11/10/98"
	author: "Copyright (c) 1998, Richie Bielak"

class URI_CONTENTS_TYPES

creation

	make


feature

	content_types: DS_HASH_TABLE [STRING, STRING]

	extension (uri: STRING): STRING is
			-- extract extendion from a URI
		local
			i: INTEGER
		do
			-- going from the end find the position of the "."
			from
				i := uri.count
			until
				i = 0 or else uri.item (i) = '.'
			loop
				i := i - 1
			end
			Result := uri.substring (i+1, uri.count)
		end

feature {NONE}

	make is
		do
			!!content_types.make (30)
			content_types.put ("text/html", "html")
			content_types.put ("text/html", "htm")
			content_types.put ("image/gif", "gif")
			content_types.put ("image/jpeg", "jpeg")
			content_types.put ("image/jpeg", "jpg")
		end

end
