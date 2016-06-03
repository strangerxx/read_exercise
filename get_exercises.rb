# coding: utf-8

require './settings/config'
require './lib/reshuege.rb'

reshuege = Reshuege.new('https://ege.sdamgia.ru/test?theme=168')

exercises = reshuege.get

exercises.each do |exercise|
  exercise = exercise.split(' ').map { |w| w.gsub(/[\u0080-\u00ff]/, '') }.join(' ')
  # p exercise
  RawExercise.find_or_create_by(content: exercise)
  # p test.encode("UTF-8", "Windows-1252")
  # test = test.unpack("U*").map{|c|c.chr rescue '_' }.join
  # test = test.unpack("U*")
  # p test[3].encoding
  # p test.each_char.select{|c| c.bytes.count < 4 }.join('')
  # exit
end
