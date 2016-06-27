# coding: utf-8

require './config/config'
Dir['./lib/*.rb'].each {|file| require file}

figures = Figure.all
name_figures = figures.map { |figure| figure['name'] }

feature_figures = FeatureFigure.all
name_feature_figures = feature_figures.map { |feature_figure| feature_figure['name'] }

normal_exercises = NormalExercise.all

array_exercises = Array.new
normal_exercises.each do |n_exercise|
  normal_words = 'на ребро cc1 куб abcda1b1c1d1 отметить точка e так, что
  ce:ec1=1:2. найти угол между прямая be и ac1.'
  test = Exercise.new(normal_words)
  test.define_point_delimiters
  exit

  exercise = Exercise.new(n_exercise['content'])
  exercise.define_features_and_figure_from_normal_words(name_feature_figures, name_figures)
  # p exercise.normal_words if exercise.normal_words.include?(':')

  # p exercise.get_name_figure
  # p exercise.get_features_figure
  # p exercise.get_medianas
  # p exercise.get_equally
  # exit
end
