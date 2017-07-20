---------------------
Install Mongo on Ubuntu:
1. sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
2. echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
3. sudo apt-get update
4. sudo apt-get install -y mongodb-org

_____________________________________
Start mongo service
1. sudo service mongod start
2. sudo service mongod stop
_____________________________________

DAY 3
Create new servers

_____________________________________
Create three replica servers
1. cd Mongo/src/main/resources
2. mkdir ./mongo1 ./mongo2 ./mongo3
3. mongod --replSet book --dbpath ./mongo1 --port 27011 --rest

into new gnome-terminal startup second server
1. cd Mongo/src/main/resources
2. mongod --replSet book --dbpath ./mongo2 --port 27012 --rest

into new gnome-terminal startup third server
1. cd Mongo/src/main/resources
2. mongod --replSet book --dbpath ./mongo3 --port 27013 --rest

into new gnome-terminal start mongo and connect to one of server
1. mongo localhost:27011
2. rs.initiate({
        _id : 'book',
        members: [
            {_id: 1, host: 'localhost:27011'},
            {_id: 2, host: 'localhost:27012'},
            {_id: 3, host: 'localhost:27013'}
        ]
    })
3. rs.status()

