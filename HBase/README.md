______________________________
Install hadoop on Ubuntu:
1. wget http://apache-mirror.rbc.ru/pub/apache/hadoop/common/hadoop-2.8.0/hadoop-2.8.0.tar.gz
2. tar xfz hadoop-2.8.0.tar.gz
3. sudo mv hadoop-2.8.0 /usr/local/hadoop
4. sudo nano /usr/local/hadoop/etc/hadoop/hadoop-env.sh
then change to: export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")

Run hadoop
1. /usr/local/hadoop/bin/hadoop

We'll ensure that it is functioning properly by running the example MapReduce
program it ships with. To do so, create a directory called input in our
home directory and copy Hadoop's configuration files into it to use those files as our data.
1. mkdir ~/input
2. cp /usr/local/hadoop/etc/hadoop/*.xml ~/input

Next, we can use the following command to run the MapReduce hadoop-mapreduce-examples program,
a Java archive with several options. We'll invoke its grep program, one of many examples
included in hadoop-mapreduce-examples, followed by the input directory,
input and the output directory grep_example. The MapReduce grep program will count the
matches of a literal word or regular expression. Finally, we'll supply a regular expression to
find occurrences of the word principal within or at the end of a declarative sentence.
The expression is case-sensitive, so we wouldn't find the word if it were capitalized at the beginning of a sentence:
1. /usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.8.0.jar grep ~/input ~/grep_example 'principal[.]*'

Create a user
1. sudo su
2. useradd hadoop
3. passwd hadoop

SSH Setup and Key Generation
SSH setup is required to perform different operations on the cluster such as start, stop, and distributed daemon shell operations. To authenticate different users of Hadoop, it is required to provide public/private key pair for a Hadoop user and share it with different users.
The following commands are used to generate a key value pair using SSH. Copy the public keys form id_rsa.pub to authorized_keys, and provide owner, read and write permissions to authorized_keys file respectively.
0. sudo apt-get install openssh-client openssh-server
1. ssh-keygen -t rsa
2. cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
3. chmod 0600 ~/.ssh/authorized_keys

Verify ssh
1. ssh localhost


Configure
1. nano ~/.bashrc
    export HADOOP_HOME=/usr/local/hadoop
    export HADOOP_MAPRED_HOME=$HADOOP_HOME
    export HADOOP_COMMON_HOME=$HADOOP_HOME
    export HADOOP_HDFS_HOME=$HADOOP_HOME
    export YARN_HOME=$HADOOP_HOME
    export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
    export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
    export HADOOP_INSTALL=$HADOOP_HOME
    export HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib/native"

2. source ~/.bashrc
3. echo $HADOOP_HOME
4. cd $HADOOP_HOME/etc/hadoop
5. sudo nano core-site.xml
        <configuration>
           <property>
              <name>fs.default.name</name>
              <value>hdfs://localhost:9000</value>
           </property>
        </configuration>
6. sudo nano hdfs-site.xml
        <configuration>
           <property>
              <name>dfs.replication</name >
              <value>1</value>
           </property>

           <property>
              <name>dfs.name.dir</name>
              <value>file:///home/hadoop/hadoopinfra/hdfs/namenode</value>
           </property>

           <property>
              <name>dfs.data.dir</name>
              <value>file:///home/hadoop/hadoopinfra/hdfs/datanode</value>
           </property>
        </configuration>
7. sudo nano yarn-site.xml
        <configuration>
           <property>
              <name>yarn.nodemanager.aux-services</name>
              <value>mapreduce_shuffle</value>
           </property>
        </configuration>
8. cp mapred-site.xml.template mapred-site.xml
9. sudo nano mapred-site.xml
        <configuration>
           <property>
              <name>mapreduce.framework.name</name>
              <value>yarn</value>
           </property>
        </configuration>

Set up the namenode using the command “hdfs namenode -format” as follows.
1. cd ~
2. hdfs namenode -format

Verifying Hadoop dfs
1. start-dfs.sh

Verifying Yarn Script
1. start-yarn.sh

Accessing Hadoop on Browser
http://localhost:50070

Verify all Applications of Cluster
The default port number to access all the applications of cluster is 8088. Use the following url to visit this service.
http://localhost:8088/






______________________________
Install HBase on Ubuntu:
1. wget http://apache-mirror.rbc.ru/pub/apache/hbase/stable/hbase-1.2.6-bin.tar.gz
2. tar xfz hbase-1.2.6-bin.tar.gz
3. cd ~
3. cd hbase-1.2.6

Configuring HBase in Standalone Mode
4. gedit conf/hbase-env.sh
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
4. nano conf/hbase-site.xml
    "<configuration>
      <property>
        <name>hbase.rootdir</name>
        <value>file:///home/ubnote/hbase</value>
      </property>
      <property>
        <name>hbase.zookeeper.property.dataDir</name>
        <value>/home/ubnote/zookeeper</value>
      </property>
    </configuration>"

5. start hbase: ./bin/start-hbase.sh
6. connect to shell: ./bin/hbase shell
7. stop hbase: ./bin/stop-hbase.sh
_____________________________

HBase Web Interface

To access the web interface of HBase, type the following url in the browser.

http://localhost:60010

______________________________

DAY 3
Remote connect to HBASE in Amazon ES using Thrift protocol

1. Запуск службы Thrift: ${HBASE_HOME}/bin/hbase-daemon.sh start thrift -b 127.0.0.1
2. В качестве клиентского языка выбран Ruby - нужно установить гем пакет: sudo gem install thrift
3. Check installing of gem thrift: ruby -e "require 'thrift'"
    If nothing is printed - great!

Install thrift
1. sudo apt-get install libboost-dev libboost-test-dev libboost-program-options-dev libboost-system-dev libboost-filesystem-dev libevent-dev automake libtool flex bison pkg-config g++ libssl-dev ant
2. wget http://www.us.apache.org/dist/thrift/0.9.3/thrift-0.9.3.tar.gz
3. tar -xvf thrift-0.9.3.tar.gz
4. cd thrift-0.9.3/
5. ./configure
6. make
7. sudo make install
8. thrift -version

1. git clone https://github.com/apache/hbase.git
2. cp hbase-thrift to ${HBASE_ROOT}


Model generation
1. thrift --gen rb /home/ubnote/hbase-1.2.6/hbase-thrift/src/main/resources/org/apache/hadoop/hbase/thrift/Hbase.thrift

Run client (script)
1. ruby /home/ubnote/IdeaProjects/_7bd/HBase/src/main/resources/thrift-example.rb

Attic
1. Access key from AWS:
2. wget http://archive.apache.org/dist/whirr/whirr-0.8.2/whirr-0.8.2.tar.gz
3. tar -xvf whirr-0.8.2.tar.gz
4. cd whirr-0.8.2
5. ./bin/whirr version
6. mkdir keys
7. ssh-keygen -t rsa -P '' -f keys/id_rsa
9. ./bin/whirr launch-cluster --config hbase.properties