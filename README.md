# gmaps_local

I use the Google Maps address resolution API quite a lot, and it's become quite expensive.

This is a small package, written in Hy (a Lisp-ish language that compiles to the Python AST) that manages a cache, stored as a SQLite file, of a distillation of the address resolution (`geocode`) queries. It can be used from Python as follows:

```
import hy # this is necessary
from gmaps_local import Runner

gmaps_key = "something_here"
r = Runner(gmaps_key)
r.query("Av. Rio Branco 100")

```

The `Runner` object will:

* Check if a cache already exists; if not, initialize it with the schema documented in the file `gmaps_local/db_ops.sql`.
* Check if the query is already stored in the cache; if it is, it returns an answer from the local cache; if it's not, it queries the Google Maps service
* If Google Maps had to be queried, it will store the simplified results in the cache.

so it really can be dropped in your code in lieu of the naked Google Maps query. 

The cache stores:

- The query itself
- The "formatted address"
- The neighborhood, as defined by the type `sublocality` in the Googlemaps API
- The city, as defined by the type `administrative_area_level_2` in the Googlemaps API
- Latitude and longitude.

If you want, for some reason, to take a look in the database itself, obtain the `sqlite3` package (with `apt install` or something equivalent), type `sqlite3 cache.sqlite` and then

```
.mode column
.headers on
select * from location_cache
```


The code itself is easy to modify if you want to store some further partial result from the Google Maps result using the `gmaps_local.get_prop`function. But here's hoping that it really works as a drop-in for you. 
