-- DAY 1

mongo book

db.towns.insert({
name: "New York",
population: 22000000,
last_census: ISODate("2009-07-31"),
famous_for: ["statue for liberty", "food"],
mayor: {
  name: "Michael Bloomberg",
  party: "I"
}
})

show collections

db.towns.find()

db.help()

db.towns.help()

db.towns.insert

function insertCity(
  name, population, last_census,
  famous_for, mayor_info
) {
  db.towns.insert({
    name:name,
    population:population,
    last_census: ISODate(last_census),
    famous_for:famous_for,
    mayor : mayor_info
  });
}

insertCity("Portland", 582000, '2007-20-09', ["beer", "food"], {name: "Sam Adams", party: "D"})

db.towns.find({"_id":ObjectId("595b3d35165f21d2b9515943")})
