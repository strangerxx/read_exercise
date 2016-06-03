# coding: utf-8

require './settings/config'
Dir['./lib/*.rb'].each {|file| require file}

figures = Figure.all
name_figures = figures.map { |figure| figure['name'] }

feature_figures = FeatureFigure.all
name_feature_figures = feature_figures.map { |feature_figure| feature_figure['name'] }

normal_exercises = NormalExercise.all

array_exercises = Array.new
normal_exercises.each do |n_exercise|
  exercise = Exercise.new(n_exercise['content'].split(' '))

  exercise.define_features_and_figure_from_normal_words(name_feature_figures, name_figures)

  p exercise.index_features_figure
  # exit
end
