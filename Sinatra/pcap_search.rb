# encoding: utf-8
require 'zlib'
require 'mysql2'

def exec_sql(sqlstr)
  begin
    #@mysql_con.query("SET NAMES utf8")     # 解决查询输出的乱码问题
    res = @mysql_con.query(sqlstr)
  rescue => e
    puts e.inspect
  end
  return res
end

# 根据record_id返回"应用、规则、目录"
def get_pcap_by_record_id(record_id)
  sqlstr = "select p.path,i.pcap,c1.name as rule_name,c2.name as app_name from info i,crc_path p,app_rule_crc a,crc_name c1, crc_name c2 where i.record_id=#{record_id} and i.rule_crc=p.crc and i.rule_crc=a.rule_crc and i.rule_crc=c1.crc and a.app_crc=c2.crc limit 1"
  return exec_sql(sqlstr)
end

# 模糊查找数据表的一个字段
def fuzzy_query_one_key(table, key, content)
  sqlstr = "select record_id from #{table} where #{key} like '%#{content}%'"
  return exec_sql(sqlstr)
end

# 精确查找数据表的一个字段
def exact_query_one_key(table, key, content)
  sqlstr = "select record_id from #{table} where #{key} = '#{content}'"
  return exec_sql(sqlstr)
end

# 查询ip地址字段
def query_ip_address(table, content)
  value = exec_sql("select inet_aton('#{content}')")
  value.each do |item|
    ip_address = item[0]
    sqlstr="select record_id from #{table} where ip = '#{ip_address}'"
    return exec_sql(sqlstr)    
  end
end

proj_dir = File.expand_path("..", File.dirname(__FILE__))

begin
    #@mysql_con = Mysql2.real_connect("127.0.0.1", "root", "1", "hwq", 3306)
    @mysql_con = Mysql2::Client.new(:host=>"127.0.0.1", :username=>"root",:password=>"1",:database=>"hwq", :port=>3306)
rescue => e
  puts e.inspect
end

result = exec_sql("select * from crc_names")
result.each do |row|
  puts row.to_s
end
# record_id = query_ip_address("tcp", "129.129.129.68")
# record_id = query_ip_address("udp", "112.115.181.189")
# record_id = query_ip_address("http", "220.181.90.24")

# record_id = exact_query_one_key("tcp", "port", "12345")
# record_id = exact_query_one_key("udp", "port", "80")
# record_id = exact_query_one_key("http", "port", "80")

# record_id = fuzzy_query_one_key("tcp", "dns", "qq.com")
# record_id = fuzzy_query_one_key("udp", "dns", "gamedl.qq.com")
# record_id = exact_query_one_key("http", "dns", "api.caipiao.163.com")

# record_id = fuzzy_query_one_key("http", "host", "sohu.com")
# record_id = fuzzy_query_one_key("http", "ua", "Android 4.0.4")
# record_id = fuzzy_query_one_key("http", "ct", "application/json")
# record_id = fuzzy_query_one_key("http", "refer", "www.qq.com")

=begin
record_id.each do |row|
  result = get_pcap_by_record_id(row[0])
  result.each do |ret|
    path = ret[0]
    pcap = ret[1]
    rule = ret[2]
    app = ret[3]

    puts "#{path}#{pcap} #{app}/#{rule}"
  end
end
=end