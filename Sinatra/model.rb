#model.rb
require 'active_record'

ActiveRecord::Base.establish_connection(
	adapter: "mysql",
	encoding: "utf8",
	host: "localhost", 
	username: "root", 
	password: "1", 
	database: "hwq"
)

##Csdn类会自动对应csdns表
class Csdn < ActiveRecord::Base
end

##Tianya类会自动对应tianyas表
class Tianya < ActiveRecord::Base
end

class Info < ActiveRecord::Base
end

class CrcName < ActiveRecord::Base
end