// DAY 1

// mongo book

db.towns.insert({
name: "New York",
population: 22000000,
last_census: ISODate("2009-07-31"),
famous_for: ["statue for liberty", "food"],
mayor: {
  name: "Michael Bloomberg",
  party: "I"
}
});

// show collections

db.towns.find();

db.help();

db.towns.help();

db.towns.insert;

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

insertCity("Portland", 582000, '2007-20-09', ["beer", "food"], {name: "Sam Adams", party: "D"});

db.towns.find({"_id":ObjectId("595b3d35165f21d2b9515943")});

db.towns.find({"_id":ObjectId("595b3d35165f21d2b9515943")}, {name : 1});

db.towns.find({"_id":ObjectId("595b3d35165f21d2b9515943")}, {name : 0});

db.towns.find({ name : /^P/, population : { $gt : 10000 }},{ name : 1, population : 1 });

var population_range = {};
population_range['$lt'] = 1000000;
population_range['$gt'] = 10000;
db.towns.find({ name : /^P/, population : population_range},{ name : 1});

db.towns.find({ last_census : { $lte : ISODate('2008-31-01') } },{ _id : 0, name : 1});

db.towns.find({ famous_for : 'food' },{ _id : 0, name : 1, famous_for : 1});

db.towns.find({ famous_for : /statue/ },{ _id : 0, name : 1, famous_for : 1});

db.towns.find({ famous_for : { $all : ['food', 'beer'] }},{ _id : 0, name : 1, famous_for : 1});

db.towns.find({ famous_for : { $nin : ['food', 'beer'] }},{ _id : 0, name : 1, famous_for : 1});

db.towns.find({ 'mayor.party' : 'I' },{ _id : 0, name : 1, mayor : 1});

db.countries.insert({
 _id : "us",
 name : "United States",
 exports : {
     foods : [
         { name : "bacon", tasty : true },
         { name : "burgers" }
     ]
 }
});

db.countries.insert({
    _id : "ca",
    name : "Canada",
    exports : {
        foods : [
            { name : "bacon", tasty : false },
            { name : "syrup", tasty : true }
        ]
    }
});

db.countries.insert({
    _id : "mx",
    name : "Mexico",
    exports : {
        foods : [
            { name : "salsa", tasty : true, condiment : true }
        ]
    }
});

print( db.countries.count() );

db.countries.find(
    { 'exports.foods.name' : 'bacon', 'exports.foods.tasty' : true },
    { _id : 0, name : 1}
);

db.countries.find(
    { 'exports.foods' : {
      $elemMatch : {
        name : 'bacon',
        tasty : true
      }
    }},
    { _id : 0, name : 1}
);

db.countries.find(
    { 'exports.foods' : {
        $elemMatch : {
            tasty : true,
            condiment : { $exists : true }
        }
    }},
    { _id : 0, name : 1}
);

db.countries.find(
    { _id : "mx", name : "United States" },
    {_id : 1}
);

db.countries.find(
    {
        $or : [
            { _id : "mx" },
            { name : "United States" }
        ]
    },
    {_id : 1}
);