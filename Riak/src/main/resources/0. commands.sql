-- DAY 1

curl http://localhost:10018/ping

curl -I http://localhost:10018/riak/no_bucket/no_key

curl -v -X PUT http://localhost:10018/riak/favs/db -H "Content-Type: text/html" -d "<html><body><h1>My new favorite DB is RIAK</h1></body></html>"

http://localhost:10018/riak/favs/db

curl -X GET http://localhost:10018

curl -v -X PUT http://localhost:10018/riak/animals/ace -H "Content-Type: application/json" -d '{"nickname" : "The Wonder Dog", "breed" : "German Shepherd"}'

curl -v -X PUT http://localhost:10018/riak/animals/polly?returnbody=true -H "Content-Type: application/json" -d '{"nickname" : "Sweet Polly Purebred", "breed" : "Purebred"}'

curl -i -X POST http://localhost:10018/riak/animals -H "Content-Type: application/json" -d '{"nickname" : "Sergeant Stubby", "breed" : "Terrier"}'

curl http://localhost:10018/riak/animals/JOZGkafSrXRS5VZwntcvJRbBCBT

curl -i -X DELETE http://localhost:10018/riak/animals/JOZGkafSrXRS5VZwntcvJRbBCBT

curl http://localhost:10018/riak/animals?keys=true

curl -X PUT http://localhost:10018/riak/cages/1 -H "Content-Type: application/json" -H "Link: </riak/animals/polly>; riaktag=\"contains\"" -d '{"room" : 101}'

curl -i http://localhost:10018/riak/animals/polly

curl -X PUT http://localhost:10018/riak/cages/2 -H "Content-Type: application/json" -H "Link: </riak/animals/ace>; riaktag=\"contains\",</riak/cages/1>; riaktag=\"next_to\"" -d '{"room" : 101}'

curl http://localhost:10018/riak/cages/1/_,_,_

curl http://localhost:10018/riak/cages/2/animals,_,_

curl http://localhost:10018/riak/cages/2/_,next_to,_

curl http://localhost:10018/riak/cages/2/_,next_to,0/animals,_,_

curl http://localhost:10018/riak/cages/2/_,next_to,1/animals,_,_

curl -X PUT http://localhost:10018/riak/photos/polly.jpg -H "Content-Type: image/jpeg" -H "Link: </riak/animals/polly>; riaktag=\"photo\"" --data-binary @polly_image.jpg

http://localhost:10018/riak/photos/polly.jpg

--DZ 1

curl -X PUT http://localhost:10018/riak/animals/polly -H "Content-Type: application/json" -H "Link: </riak/photos/polly>; riaktag=\"photo\"" -d '{"nickname" : "Sweet Polly Purebred", "breed" : "Purebred"}'
-- pdf должен быть в той папке откуда вызывается curl
curl -i -X POST http://localhost:10018/riak/animals -H "Content-Type: application/pdf" --data-binary @book.pdf

http://localhost:10018/riak/animals/Y6tY5AFok2JwqJpgCelyWSywytc

-- DAY 2

http://localhost:10018/riak/rooms

curl -X POST -H "content-type:application/json" http://localhost:8098/mapred --data "{\"inputs\": [[\"rooms\",\"101\"],[\"rooms\",\"102\"], [\"rooms\",\"103\"] ], \"query\": [{\"map\": {\"language\": \"javascript\", \"source\": \"function(v) {/* From the Riak object, pull data and parse it as JSON */ var parsed_data = JSON.parse(v.values[0].data); var data = {}; /* Key capacity number by room style string */ data[parsed_data.style] = parsed_data.capacity; return [data]; }\"} } ] }"

curl -X POST -H "content-type:application/json" http://localhost:8098/mapred --data @-
{
  "inputs":[
    ["rooms","101"],["rooms","102"],["rooms","103"]],
  "query":[
    {"map":{
      "language":"javascript",
      "source":
      "function(v) {
        var parsed_data = JSON.parse(v.values[0].data);
        var data = {};
        var floor = ~~(parseInt(v.key) / 100);
        data[floor] = parsed_data.capacity;
        return [data];
      }"}
  } ]
}

Ctrl-D

--хранимые функции
curl -X PUT -H "content-type:application/json" http://localhost:8098/riak/my_functions/map_capacity --data @-
function(v) {
        var parsed_data = JSON.parse(v.values[0].data);
        var data = {};
        var floor = ~~(parseInt(v.key) / 100);
        data[floor] = parsed_data.capacity;
        return [data];
      }

curl -X POST -H "content-type:application/json" http://localhost:8098/mapred --data @-
{
  "inputs":[
    ["rooms","101"],["rooms","102"],["rooms","103"]
    ],
  "query":[
    {"map":{
      "language":"javascript",
      "bucket" : "my_functions",
      "key" : "map_capacity"
      }}
  ]
}

curl -X POST -H "content-type:application/json" http://localhost:8098/mapred --data @-
{
  "inputs":[
    ["rooms","101"],["rooms","102"],["rooms","103"]
    ],
  "query":[
    {"map":{
      "language":"javascript",
      "name" : "Riak.mapValuesJson"
      }}
  ]
}

--reduce
curl -X POST -H "content-type:application/json" http://localhost:8098/mapred --data @-
{
  "inputs":[
    ["rooms","101"],["rooms","102"],["rooms","103"]],
  "query":[
    {"map":{
      "language":"javascript",
      "bucket" : "my_functions",
      "key" : "map_capacity"
      }},
  {"reduce": {
      "language": "javascript",
      "source":
        "function(v) {
            var totals = {};
            for (var i in v) {
              for(var style in v[i]) {
                if( totals[style] )
                  totals[style] += v[i][style];
                else
                  totals[style] = v[i][style];
              }
            }
            return [totals];
          }"}
  } ]
}