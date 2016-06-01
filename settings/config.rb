# coding: utf-8
require 'rubygems'
require 'active_record'

require "./lib/db/exercise"

require 'active_record/connection_adapters/abstract_mysql_adapter'

module ActiveRecord
  module ConnectionAdapters
    class AbstractMysqlAdapter
      NATIVE_DATABASE_TYPES[:string] = { :name => "varchar", :limit => 191 }
    end
  end
end

ActiveRecord::Base.establish_connection(
        :adapter => "mysql2",
        :host => "localhost",
        :username => "root",
        :password => "180489",
        :database => "read_exercise",
        :encoding => "utf8mb4",
        socket: '/opt/lampp/var/mysql/mysql.sock')

# ActiveRecord::Base.connection.execute("ALTER TABLE read_exercise MODIFY content TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;")
