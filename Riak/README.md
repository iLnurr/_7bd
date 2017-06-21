---------------------
Install Erlang on Debian:
1. sudo apt-get update
2. sudo apt-get install build-essential autoconf libncurses5-dev openssl libssl-dev fop xsltproc unixodbc-dev git
3. wget http://s3.amazonaws.com/downloads.basho.com/erlang/otp_src_R16B02-basho10.tar.gz
4. cd OTP_R16B02_basho10
5. ./otp_build autoconf
6. ./configure && make && sudo make install
7. Confirm Erlang installed to the correct location: which erl
_____________________________________________

Build Riak 2.2.3 from source code:
0. sudo apt-get install build-essential libc6-dev-i386 git libpam0g-dev
1. wget http://s3.amazonaws.com/downloads.basho.com/riak/2.2/2.2.3/riak-2.2.3.tar.gz
2. tar zxvf riak-2.2.3.tar.gz
3. cd riak-2.2.3
4. make rel
5. make devrel

---------------------------------------------

Starting Erlang
1. erl

---------------------------------------------

Starting Riak
1. cd $RIAK
2. /rel/riak/bin/riak start

stop
1. /rel/riak/bin/riak stop
_____________________________________________

Starting servers (configured by command $make devrel)
1. cd $RIAK
2. dev/dev1/bin/riak start
3. dev/dev2/bin/riak start
4. dev/dev3/bin/riak start

Create cluster
1. dev/dev2/bin/riak-admin join -f dev1@127.0.0.1
2. dev/dev3/bin/riak-admin join -f dev2@127.0.0.1
3. dev/dev1/bin/riak-admin join -f dev3@127.0.0.1
4. check stats of created cluster in dev1 node: http://localhost:10018/stats (for dev2 - 10028 port, for dev3 - port 10039 ...)

Stop nodes of server
1. dev/dev1/bin/riak stop
2. dev/dev2/bin/riak stop
3. dev/dev3/bin/riak stop

