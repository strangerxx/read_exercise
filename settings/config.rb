# coding: utf-8
require 'rubygems'
require 'active_record'

require "./lib/db/exercise"

ActiveRecord::Base.establish_connection(
        :adapter => "mysql2",
        :host => "localhost",
        :username => "root",
        :password => "180489",
        :database => "read_exercise",
        :encoding => "utf8",
        socket: '/opt/lampp/var/mysql/mysql.sock')
