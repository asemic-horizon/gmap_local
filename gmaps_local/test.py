import hy
from gmaps_local import Runner

gmaps_key = "something_here"
r = Runner(gmaps_key)
r.query("Av. Rio Branco 100")