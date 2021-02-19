(import aiosql sqlite3 os googlemaps)

(defn get-prop [res property]
 (setv addr (. res ["address_components"])) 
 (. (first (filter (fn[x] (in property (. x ["types"]))) addr))
    ["long_name"])) 


(defclass Runner []
 (defn __init__[self gmaps-key]
  (setv 
    self.gmaps (googlemaps.Client :key gmaps-key)  
    self.ops (aiosql.from-path "db_ops.sql" "sqlite3")  ; sql commands
    is-file (os.path.isfile "cache.sqlite")   ; is there already a sqlite file?
    self.conn (sqlite3.connect "cache.sqlite"));if there's no sqlite file
                                               ;the driver creates an empty one                                                
  (unless is-file (self.ops.setup self.conn))) ;if this was the case, setup the schema

 (defn store-query [self query fmt neighborhood city latitude longitude]
  (self.ops.store-query self.conn :query query :fmt fmt 
                                  :neighborhood neighborhood :city city
                                  :latitude latitude :longitude longitude) 
  (self.conn.commit))
 
 (defn get-query-cache [self query]
  (self.ops.get-query-cache self.conn :query query)) ; retorna None se não encontrado
 
 (defn query-gmaps [self query]
  (setv 
   res (first (self.gmaps.geocode query))
   latitude  (. res ["geometry"] ["location"] ["lat"])
   longitude (. res ["geometry"] ["location"] ["lng"])
   fmt       (. res ["formatted_address"])
   neighborhood    (get-prop res "sublocality")
   city      (get-prop res "administrative_area_level_2"))

  (self.store_query query fmt neighborhood city latitude longitude)
  [neighborhood latitude longitude])           
 
 (defn query [self query]
  (setv cached (self.get-query-cache query))
  (if cached cached
             (self.query-gmaps query))))             


