-- DAY 1
--create table with column text
create 'wiki', 'text'

-- insert data to table wiki ('Home' - is row or key, 'text:' - is column, 'Welcome to the wiki!' - is value)
put 'wiki', 'Home', 'text:', 'Welcome to the wiki!'

--read data from table, row or key, column
get 'wiki', 'Home', 'text:'

--перевести табдицу в автономный режим
disable 'wiki'

--изменить таблицу - сохранять все версии значений в столбцах
alter 'wiki', { NAME => 'text', VERSIONS => org.apache.hadoop.hbase.HConstants::ALL_VERSIONS }

--добавим семейство столбцов revision
alter 'wiki', { NAME => 'revision', VERSIONS => org.apache.hadoop.hbase.HConstants::ALL_VERSIONS }

--активировать таблицу после изменений
enable 'wiki'

--with put command we can insert only one row, but because hbase shell - is also ruby interpreter, we can use JRuby script to put multiple rows
import 'org.apache.hadoop.hbase.client.HTable'
import 'org.apache.hadoop.hbase.client.Put'

def jbytes( *args )
  args.map { |arg| arg.to_s.to_java_bytes }
end

table = HTable.new( @hbase.configuration, "wiki" )

p = Put.new( *jbytes( "Home" ) )

p.add( *jbytes( "text", "", "Hello world" ) )
p.add( *jbytes( "revision", "author", "jimbo" ) )
p.add( *jbytes( "revision", "comment", "my first edit" ) )

table.put( p )

--
get 'wiki', 'Home'

--read all data
scan 'wiki'

--DZ 1
--удалить из строки значенияб хранящиеся в указанных столбцах
scan 'wiki'
--удалить из указанной таблицы, строки, столбца, временной метки
delete 'wiki', 'Home', 'text:', 1498713263210

--put_many script
import 'org.apache.hadoop.hbase.client.HTable'
import 'org.apache.hadoop.hbase.client.Put'

def jbytes( *args )
  args.map { |arg| arg.to_s.to_java_bytes }
end

# actual exercise
def put_many( table_name, row, column_values)
  table = HTable.new( @hbase.configuration, table_name )

  p = Put.new( *jbytes( row ))

  column_values.each do |k, v|
    (kf, kn) = k.split(':')
    kn ||= ""
    p.add( *jbytes( kf, kn, v ))
  end

  table.put( p )
end


put_many 'wiki', 'Some title', {
  "text:" => "Some article text",
  "revision:author" => "jschmoe",
  "revision:comment" => "no comment" }

scan 'wiki'

-- DAY 2

disable 'wiki'
alter 'wiki', { NAME=>'text', COMPRESSION=>'GZ', BLOOMFILTER=>'ROW' }
enable 'wiki'

--get zip xml dump from wiki unzip it and transfer to our script
curl https://dumps.wikimedia.org/enwiktionary/latest/enwiktionary-latest-pages-articles.xml.bz2 | bzcat | /home/ubnote/hbase-1.2.6/bin/hbase shell /home/ubnote/IdeaProjects/_7bd/HBase/src/main/resources/import_from_wikipedia.rb

scan 'hbase:meta', { COLUMNS => ['info:server', 'info:regioninfo'] }

describe 'wiki'

create 'links', {
  NAME => 'to', VERSIONS => 1, BLOOMFILTER => 'ROWCOL'
}, {
  NAME => 'from', VERSIONS => 1, BLOOMFILTER => 'ROWCOL'
}

/home/ubnote/hbase-1.2.6/bin/hbase shell /home/ubnote/IdeaProjects/_7bd/HBase/src/main/resources/generate_wiki_links.rb

scan 'links', STARTROW => "Admiral Ackbar", ENDROW => "It's a Trap"

get 'links', 'Star Wars'

count 'wiki', INTERVAL => 100000, CACHE => 10000