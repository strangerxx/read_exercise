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

  def partition_few_chars(chars)
    # chars = ['.', ',']
    return [self] if chars.empty?
    words = self.partition_with_delete(chars.shift)
    chars.each do |char|
      words.map! do |word|
        if word.length == 1 or !word.include?(char)
          word
        else
          word.partition_with_delete(char)
        end
      end
      words.flatten!
    end
    words
  end

  def is_i?
       /\A[-+]?\d+\z/ === self
  end
end

class Exercise
  #normal_words - массив с нормализированными словами текста упражнения
  #index_figure - номер слова в normal_words,  обозначающий название фигуры
  #index_features_figure - массив индексов в normal_words, обозначающий
  #характеристики фигуры
  attr_reader :normal_words, :index_figure, :index_features_figure, :medians,
    :equallys, :point_delimiters

  def initialize(text)
    @normal_words = text.split(' ')
    self.partition_special_character!

    define_medians
  end

  def get_name_figure
    @normal_words[@index_figure]
  end

  def get_features_figure
    @index_features_figure.map do |index_feature_figure|
      @normal_words[index_feature_figure]
    end
  end

  def get_medianas
    return [] unless @medians
    @medians.map do |median|
      {letter: @normal_words[median[:index_letter]],
       edge: @normal_words[median[:index_edge]]}
    end
  end

  def get_equallys
    return [] unless @equallys
    @equallys.map do |equally|
      {name: @normal_words[equally[:index_name]],
       feature: get_feature_name_equally(equally),
       value: @normal_words[equally[:index_value]]}
    end
  end

  def get_point_delimiters
    return [] unless @point_delimiters
    @point_delimiters.map do |point_delimiter|
      {name_edge: @normal_words[point_delimiter[:index_name_edge]],
       letter_point: @normal_words[point_delimiter[:index_letter_point]],
       left: @normal_words[point_delimiter[:index_left]],
       right: @normal_words[point_delimiter[:index_right]]}
    end
  end

  def get_feature_name_equally(equally)
    if equally[:index_feature]
      @normal_words[equally[:index_feature]]
    else
      nil
    end
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

  def define_medians
    index_medians = search_in_normal_words('середина')
    return unless index_medians

    @medians = Array.new
    index_medians.each do |index|
      median = define_median_through_index(index)
      @medians.push median
    end
  end

  def define_equallys
    index_equally = search_in_normal_words('равный')
    return unless index_equally

    @equallys = Array.new
    prev_index_equally = 0
    index_equally.each do |index|
      equally = define_equally_through_index(index, prev_index_equally)
      @equallys.push equally
      prev_index_equally = index
    end
  end

  def pattern_equally_sign
    index_equally_sign = search_in_normal_words('=')
    return unless index_equally_sign

    @equallys = Array.new
    index_equally_sign.each do |index|
      equally = Hash.new

      index_value = index + 1
      if @normal_words[index_value].is_i?
        index_delimiters = index_value + 1
        next if @normal_words[index_value+1] == ':'
        equally[:index_value] = index_value
      else
        raise 'don`t define value for equally_sign'
      end

      equally[:index_name] = index - 1

      @equallys.push equally
    end
  end

  def define_point_delimiters
    index_point_delimiters = search_in_normal_words(':')
    return unless index_point_delimiters

    @point_delimiters = Array.new
    index_point_delimiters.each_cons(2) do |index|
      point_delimiter = define_point_delimiter_through_index(index[1])
      @point_delimiters.push point_delimiter
    end
  end

  protected

    def partition_special_character!(characters = [',', '.', '—', '=', ':'])
      clear_words = Array.new
      @normal_words.each do |word|
        # p word
        found_chars = word.get_character(characters)
        clear_words += word.partition_few_chars(found_chars)
        # exit
      end
      @normal_words = clear_words
    end

    def define_median_through_index(index_median)
      median = Hash.new

      index_letter = index_median-1
      #"e -" or "m -"
      index_letter -= 1 if @normal_words[index_letter] == '—'
      #"e-" or "m-"
      # @normal_words[index_letter].slice!(1) if @normal_words[index_letter][1] == '—'
      median[:index_letter] = index_letter

      pattern_edge = 'ребро'
      index_edge = search_in_normal_words(pattern_edge, index_letter,
                                          @normal_words.length, true)

      # name_edge = @normal_words[index_edge+1]
      # name_edge.slice!(-1) if name_edge[-1] == ',' or name_edge[-1] == '.'
      median[:index_edge] = index_edge + 1

      median
    end

    def define_equally_through_index(index_equally, prev_index_equally)
      equally = Hash.new

      index_value = index_equally+1
      if @normal_words[index_value].is_i?
        equally[:index_value] = index_value
      else
        raise 'don`t define value for equally'
      end

      pattern_name = ['ребро', 'сторона', 'высота']
      index_name = search_in_normal_words(pattern_name, prev_index_equally, index_equally, true)
      if index_name
        equally[:index_name] = index_name
        index_feature = nil
        if @normal_words[index_name] == 'ребро'
          index_feature = index_name-1 if @normal_words[index_name-1] == 'боковой'
        elsif @normal_words[index_name] == 'сторона'
          index_feature = index_name+1 if @normal_words[index_name+1] == 'основание'
        end
        equally[:index_feature] = index_feature
      else
        raise 'raise don`t definde name for equally'
      end

      equally
    end

    def define_point_delimiter_through_index(index_point_delimiters)
      point_delimiter = Hash.new

      index_edge = search_in_normal_words('ребро', 0,
                                          index_point_delimiters, true)
      point_delimiter[:index_name_edge] = index_edge+1

      index_point = search_in_normal_words('точка', index_edge,
                                          index_point_delimiters, true)
      point_delimiter[:index_letter_point] = index_point+1

      point_delimiter[:index_left] = index_point_delimiters-1
      point_delimiter[:index_right] = index_point_delimiters+1

      point_delimiter
    end

    def search_in_normal_words(pattern, start_position = 0,
                               end_position = @normal_words.length, one = false)
      pattern = [pattern] unless pattern.class == Array
      indexes = Array.new
      (start_position...end_position).each do |index|
        if pattern.include?(@normal_words[index])
          unless one
            indexes.push index
          else
            return index
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
