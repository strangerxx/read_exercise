# coding: utf-8

require './settings/config'
require './lib/reshuege.rb'

reshuege = Reshuege.new('https://ege.sdamgia.ru/test?theme=168')

exercises = reshuege.get

exercises.each do |exercise|
  Exercise.find_or_create_by(content: exercise)
end
