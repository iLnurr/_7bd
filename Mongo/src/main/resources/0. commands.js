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

db.towns.update(
    { _id : ObjectId("595b3d35165f21d2b9515943") },
    { $set : { state : "OR" } }
);

db.towns.findOne({"_id":ObjectId("595b3d35165f21d2b9515943")});

db.towns.update(
    { _id : ObjectId("595b3d35165f21d2b9515943") },
    { $inc : { population : 1000 } }
);

db.towns.update(
    { _id : ObjectId("595b3d35165f21d2b9515943") },
    { $set : { country : { $ref : "countries", $id : "us" } } }
);

var portland = db.towns.findOne({"_id":ObjectId("595b3d35165f21d2b9515943")});
db.countries.findOne({ _id : portland.country.$id });
db[ portland.country.$ref ].findOne({ _id : portland.country.$id });

var bad_bacon = {
    'exports.foods' : {
        $elemMatch : {
            name : 'bacon',
            tasty : false
        }
    }
};
db.countries.find( bad_bacon );
db.countries.remove( bad_bacon );
db.countries.count();

db.towns.find( function () {
    return this.population > 6000 && this.population < 600000;
} );
db.towns.find( "this.population > 6000 && this.population < 600000;");
db.towns.find( {
    $where : "this.population > 6000 && this.population < 600000;",
    famous_for : /groundhog/
} );

//DZ 1
db.towns.find({ name : { $regex : /^new/, $options:"$i" } });

//DAY 2

function populatePhones(area,start,stop) {
    for(var i=start; i < stop; i++) {
        var country = 1 + ((Math.random() * 8) << 0);
        var num = (country * 1e10) + (area * 1e7) + i;
        db.phones.insert({
            _id: num,
            components: {
                country: country,
                area: area,
                prefix: (i * 1e-4) << 0,
                number: i
            },
            display: "+" + country + " " + area + "-" + i
        });
    }
}

populatePhones( 800, 5550000, 5650000 );

db.phones.find().limit(2);

db.phones.getIndexes();
db.phones.find({display: "+1 800-5650001"}).explain("executionStats");  //54 millis
db.phones.ensureIndex({display : 1}, {unique : true, dropDups : true});
db.phones.find({display: "+1 800-5650001"}).explain("executionStats");  //2 millis after indexing

db.setProfilingLevel(2);
db.phones.find({ display : "+1 800-5650001" });
db.system.profile.find();

db.phones.ensureIndex({ "components.area" : 1}, { background : 1 });
db.phones.getIndexes();


db.phones.count({'components.number' : {$gt : 5599999} });

populatePhones(855, 5550000, 5650000);

db.phones.distinct('components.number', {'components.number' : { $lt : 5550005 } });

db.phones.group({
    initial : { count : 0 },
    reduce : function(phone, output) { output.count++; },
    cond : { 'components.number' : { $gt : 5599999 } },
    key : { 'components.area' : true }
});

db.phones.group({
    initial : { count : 0 },
    reduce : function(phone, output) { output.count++; },
    cond : { 'components.number' : { $gt : 5599999 } }
});

db.phones.group({
    initial : { prefixes : {} },
    reduce : function(phone, output) {
        output.prefixes[phone.components.prefix] = 1;
    },
    finalize : function (out) {
        var ary = [];
        for (var p in out.prefixes) { ary.push( parseInt( p ) ); }
        out.prefixes = ary;
    }
})[0].prefixes;

update_area = function() {
    db.phones.find().forEach(
        function(phone) {
            phone.components.area++;
            phone.display = "+"+
                phone.components.country+" "+
                phone.components.area+"-"+
                phone.components.number;
            db.phone.update({ _id : phone._id }, phone, false);
        }
    )
};
db.eval(update_area);

// use admin
db.runCommand("top");


// use book
db.listCommands();
db.runCommand({ "count" : "phones"  });
db.phones.count
db.phones.find().count
db.runCommand


db.system.js.save({
    _id : 'getLast',
    value : function (collection) {
        return collection.find({}).sort({'_id':1}).limit(1)[0]
    }
});
db.eval('getLast(db.phones)');
db.loadServerScripts();
getLast(db.phones);


distinctDigits = function(phone){
    var
        number = phone.components.number + '',
        seen = [],
        result = [],
        i = number.length;
    while(i--) {
        seen[+number[i]] = 1;
    }
    for (i=0; i<10; i++) {
        if (seen[i]) {
            result[result.length] = i;
        }
    }
    return result;
};
db.system.js.save({_id: 'distinctDigits', value: distinctDigits});

db.eval("distinctDigits(db.phones.findOne({ 'components.number' : 5551213 }))");

map = function() {
    var digits = distinctDigits(this);
    emit({digits : digits, country : this.components.country}, {count : 1});
};

reduce = function(key, values) {
    var total = 0;
    for(var i=0; i<values.length; i++) {
        total += values[i].count;
    }
    return { count : total };
};

results = db.runCommand({
    mapReduce: 'phones',
    map :map,
    reduce : reduce,
    out : 'phones.report'
});
db.phones.report.find({'_id.country':8});
it;

//DAY 3
//mongo localhost:27011
rs.initiate({
    _id : 'book',
    members: [
        {_id: 1, host: 'localhost:27011'},
        {_id: 2, host: 'localhost:27012'},
        {_id: 3, host: 'localhost:27013'}
    ]
})
rs.status();

db.echo.insert({say: 'HELLO'});

//CTRL-C in mongo console
//CTRL-C in mongo1 server terminal

//mongo localhost:27012
rs.status();

//CTRL-C in mongo console
//mongo localhost:27013
rs.status();
db.isMaster();
db.echo.insert({say: 'is this thing on?'}); //MESSAGE: WriteResult({ "writeError" : { "code" : 10107, "errmsg" : "not master" } })




