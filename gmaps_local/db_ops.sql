--name: setup!
create table location_cache 
  				(loc_id integer primary key, 
  					query text,
  					formatted_address text,
  					neighborhood text,
  					city text,
  					latitude real,
  					longitude real);

--name: store-query!

	insert into 
	  location_cache (query, formatted_address, neighborhood, city, latitude, longitude) 
	  values (:query, :fmt, :neighborhood, :city, :latitude, :longitude);

--name: get-query-cache^

select neighborhood, latitude, longitude from location_cache
     where (query = :query collate nocase)
     	   or (formatted_address = :query);