class Exercise
  #normal_words - массив с нормализированными словами текста упражнения
  #index_figure - номер слова в normal_words,  обозначающий название фигуры
  #index_features_figure - массив индексов в normal_words, обозначающий характеристики фигуры
  attr_reader :normal_words, :index_figure, :index_features_figure

  def initialize(text)
    @normal_words = text
  end

  #Определение фигуры
  def define_figure_from_normal_words(a_figures)
    @index_figure = nil
    a_figures.each do |figure|
      break if @index_figure = @normal_words.index(figure)
    end
    unless @index_figure
      raise "don't define figure"
    end
  end

  #Определение характеристик фигуры
  def define_features_and_figure_from_normal_words(a_feature_figures, a_figures)
    define_figure_from_normal_words(a_figures) unless @index_figure

    @index_features_figure = Array.new
    (@index_figure-1).downto(0).each do |index|
      if a_feature_figures.index(@normal_words[index])
        @index_features_figure.push index
      else
        break
      end
    end
  end
end
