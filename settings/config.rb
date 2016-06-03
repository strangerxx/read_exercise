# coding: utf-8
require 'rubygems'
require 'active_record'

Dir['./lib/db/*.rb'].each {|file| require file}

ActiveRecord::Base.establish_connection(
        :adapter => "mysql2",
        :host => "localhost",
        :username => "root",
        :password => "180489",
        :database => "read_exercise",
        :encoding => "utf8mb4",
        socket: '/opt/lampp/var/mysql/mysql.sock')
