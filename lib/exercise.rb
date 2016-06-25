String.class_eval do
  def get_character(chars)
    found_chars = Array.new
    chars.each do |char|
      found_chars.push char if self.include?(char)
    end
    found_chars
  end

  def partition_with_delete(char)
    words = self.partition(char)
    words.slice!(-1) if words.last.length == 0
    words.slice!(0) if words.first.length == 0
    words
  end

  def split_few_chars(chars)
    # chars = ['.', ',']
    return [self] if chars.empty?
    words = self.partition_with_delete(chars.shift)
    chars.each do |char|
      new_words = Array.new
      words.map! do |word|
        unless word.length == 1 or !word.include?(char)
          word.partition_with_delete(char)
        else
          word
        end
      end
      # words = new_words
    end
    words.flatten
  end
end

class Exercise
  #normal_words - массив с нормализированными словами текста упражнения
  #index_figure - номер слова в normal_words,  обозначающий название фигуры
  #index_features_figure - массив индексов в normal_words, обозначающий характеристики фигуры
  attr_reader :normal_words, :index_figure, :index_features_figure, :medians

  def initialize(text)
    @normal_words = text.split(' ')
    self.split_special_character!
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

  def define_median_from_normal_words()
    pattern_median = 'середина'

    index_medians = search_in_normal_words(pattern_median, 1, false)
    return unless index_medians
    # p index_medians

    @medians = Array.new
    index_medians.each do |index|
      median = define_median_through_index(index)
      @medians.push median
    end
  end

    def split_special_character!(characters = [',', '.', '—'])
      clear_words = Array.new
      @normal_words.each do |word|
        # p word
        found_chars = word.get_character(characters)
        clear_words += word.split_few_chars(found_chars)
        # exit
      end
      @normal_words = clear_words
    end

  protected

    def define_median_through_index(index_median)
      median = Hash.new

      index_letter = index_median-1
      #"e -" or "m -"
      index_letter -= 1 if @normal_words[index_letter] == '—'
      #"e-" or "m-"
      @normal_words[index_letter].slice!(1) if @normal_words[index_letter][1] == '—'
      median[:index_letter] = index_letter

      pattern_edge = 'ребро'
      index_edge = search_in_normal_words(pattern_edge, index_letter)

      name_edge = @normal_words[index_edge+1]
      name_edge.slice!(-1) if name_edge[-1] == ',' or name_edge[-1] == '.'
      median[:name_edge] = name_edge

      median
    end

    def search_in_normal_words(pattern, start_position = 0, one = true)
      indexes = Array.new
      (start_position...@normal_words.length).each do |index|
        if @normal_words[index] == pattern
          if one
            return index
          else
            indexes.push index
          end
        end
      end
      if indexes.empty?
        return nil
      else
        return indexes
      end
    end
end
