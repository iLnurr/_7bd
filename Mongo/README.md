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

