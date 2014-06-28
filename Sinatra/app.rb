#app.rb
require 'sinatra'
require File.join(File.dirname(__FILE__),'model')

get "/key" do
  #可以接收请求中的参数
  @key = params[:key]
  #如果参数来为空，说明是查询请求
  unless @key.blank?
    @csdns = Csdn.where("email=? or username=?", @key, @key )
    @tianyas = Tianya.where("email=? or username=?", @key, @key )
  end

  #Sinatra可以渲染erb模板
  erb :test
end

# get "/"接收对根目录的get请求
get "/" do
  sqlstr = "select i.pcap,i.proto,c1.name as app_name,c2.name as rule_name,i.appversion,i.action,i.os,i.browser,count(distinct c1.name) \
            from infos i,app_rule_crc a, crc_names c1, crc_names c2 where i.rule_crc=c2.crc and c2.flag=3 \
            and i.rule_crc=a.rule_crc and a.app_crc=c1.crc and c1.flag=2 group by c1.name order by i.pcap desc"
  @info = Info.find_by_sql(sqlstr)
  erb :index
end
