require 'spec_helper'

require './config/config'
Dir['./lib/*.rb'].each {|file| require file}

describe 'Exercise' do
  before(:all) do
    figures = Figure.all
    @name_figures = figures.map { |figure| figure['name'] }

    feature_figures = FeatureFigure.all
    @name_feature_figures = feature_figures.map { |feature_figure| feature_figure['name'] }
  end

  describe '#split_special_character!' do
    context 'char is ,' do
      it 'and it is last in string' do
        exercise = Exercise.new('cl,')
        expect(exercise.normal_words[0]).to eq('cl')
        expect(exercise.normal_words[1]).to eq(',')
      end

      it 'and it isn`t last in string' do
        exercise = Exercise.new('cl,b')
        expect(exercise.normal_words[0]).to eq('cl')
        expect(exercise.normal_words[1]).to eq(',')
        expect(exercise.normal_words[2]).to eq('b')
      end

      it 'and it is first in string' do
        exercise = Exercise.new(',cl')
        expect(exercise.normal_words[0]).to eq(',')
        expect(exercise.normal_words[1]).to eq('cl')
      end
    end

    context 'char is .' do
      it 'and it is last in string' do
        exercise = Exercise.new('cl.')
        expect(exercise.normal_words[0]).to eq('cl')
        expect(exercise.normal_words[1]).to eq('.')
      end

      it 'and it isn`t last in string' do
        exercise = Exercise.new('cl.b')
        expect(exercise.normal_words[0]).to eq('cl')
        expect(exercise.normal_words[1]).to eq('.')
        expect(exercise.normal_words[2]).to eq('b')
      end

      it 'and it is first in string' do
        exercise = Exercise.new('.cl')
        expect(exercise.normal_words[0]).to eq('.')
        expect(exercise.normal_words[1]).to eq('cl')
      end
    end

    context 'char is —' do
      it 'and it is last in string' do
        exercise = Exercise.new('cl—')
        expect(exercise.normal_words[0]).to eq('cl')
        expect(exercise.normal_words[1]).to eq('—')
      end

      it 'and it isn`t last in string' do
        exercise = Exercise.new('cl—b')
        expect(exercise.normal_words[0]).to eq('cl')
        expect(exercise.normal_words[1]).to eq('—')
        expect(exercise.normal_words[2]).to eq('b')
      end

      it 'and it is first in string' do
        exercise = Exercise.new('—cl')
        expect(exercise.normal_words[0]).to eq('—')
        expect(exercise.normal_words[1]).to eq('cl')
      end
    end

    context 'char is =' do
      it 'and it is last in string' do
        exercise = Exercise.new('cl=')
        expect(exercise.normal_words[0]).to eq('cl')
        expect(exercise.normal_words[1]).to eq('=')
      end

      it 'and it isn`t last in string' do
        exercise = Exercise.new('cl=b')
        expect(exercise.normal_words[0]).to eq('cl')
        expect(exercise.normal_words[1]).to eq('=')
        expect(exercise.normal_words[2]).to eq('b')
      end

      it 'and it is first in string' do
        exercise = Exercise.new('=cl')
        expect(exercise.normal_words[0]).to eq('=')
        expect(exercise.normal_words[1]).to eq('cl')
      end
    end

    context 'char is :' do
      it 'and it is last in string' do
        exercise = Exercise.new('cl:')
        expect(exercise.normal_words[0]).to eq('cl')
        expect(exercise.normal_words[1]).to eq(':')
      end

      it 'and it isn`t last in string' do
        exercise = Exercise.new('cl:b')
        expect(exercise.normal_words[0]).to eq('cl')
        expect(exercise.normal_words[1]).to eq(':')
        expect(exercise.normal_words[2]).to eq('b')
      end

      it 'and it is first in string' do
        exercise = Exercise.new(':cl')
        expect(exercise.normal_words[0]).to eq(':')
        expect(exercise.normal_words[1]).to eq('cl')
      end
    end

    context 'string contain two char' do
      it 'and they stay together c.,l' do
        exercise = Exercise.new('c.,l')
        expect(exercise.normal_words[0]).to eq('c')
        expect(exercise.normal_words[1]).to eq('.')
        expect(exercise.normal_words[2]).to eq(',')
        expect(exercise.normal_words[3]).to eq('l')
      end

      it 'and they don`t stay together c.l,' do
        exercise = Exercise.new('c.l,')
        expect(exercise.normal_words[0]).to eq('c')
        expect(exercise.normal_words[1]).to eq('.')
        expect(exercise.normal_words[2]).to eq('l')
        expect(exercise.normal_words[3]).to eq(',')
      end
    end

    it 'string contain three chars c.l,b—' do
      exercise = Exercise.new('c.l,b—')
      expect(exercise.normal_words[0]).to eq('c')
      expect(exercise.normal_words[1]).to eq('.')
      expect(exercise.normal_words[2]).to eq('l')
      expect(exercise.normal_words[3]).to eq(',')
      expect(exercise.normal_words[4]).to eq('b')
      expect(exercise.normal_words[5]).to eq('—')
    end

    it 'ce:ec1=1:2.' do
      exercise = Exercise.new('ce:ec1=1:2.')
      expect(exercise.normal_words[0]).to eq('ce')
      expect(exercise.normal_words[1]).to eq(':')
      expect(exercise.normal_words[2]).to eq('ec1')
      expect(exercise.normal_words[3]).to eq('=')
      expect(exercise.normal_words[4]).to eq('1')
      expect(exercise.normal_words[5]).to eq(':')
      expect(exercise.normal_words[6]).to eq('2')
      expect(exercise.normal_words[7]).to eq('.')
    end
  end

  describe '1 exercise' do
    before(:each) do
      normal_words = 'длина ребро правильный тетраэдр abcd равный 1. найти угол
      между прямая dm и cl, где m — середина ребро bc, l — середина ребро ab.'
      @exercise = Exercise.new(normal_words)
    end

    it 'split "," "." "—" "=" and word' do
      expect(@exercise.normal_words[6]).to eq('1')
      expect(@exercise.normal_words[7]).to eq('.')

      expect(@exercise.normal_words[14]).to eq('cl')
      expect(@exercise.normal_words[15]).to eq(',')

      expect(@exercise.normal_words[18]).to eq('—')

      expect(@exercise.normal_words[21]).to eq('bc')
      expect(@exercise.normal_words[22]).to eq(',')

      expect(@exercise.normal_words[24]).to eq('—')

      expect(@exercise.normal_words[27]).to eq('ab')
      expect(@exercise.normal_words[28]).to eq('.')

      expect(@exercise.normal_words.length).to eq(29)
    end

    it 'get name figure and feature' do
      @exercise.define_features_and_figure_from_normal_words(@name_feature_figures, @name_figures)
      expect(@exercise.get_name_figure).to eq('тетраэдр')
      expect(@exercise.get_features_figure).to eq(['правильный'])
    end

    it 'get mediana' do
      expect(@exercise.get_medianas[0][:letter]).to eq('m')
      expect(@exercise.get_medianas[0][:edge]).to eq('bc')

      expect(@exercise.get_medianas[1][:letter]).to eq('l')
      expect(@exercise.get_medianas[1][:edge]).to eq('ab')
    end

    it 'get equally' do
      @exercise.define_equallys

      equallys = @exercise.get_equallys
      expect(equallys[0][:name]).to eq('ребро')
      expect(equallys[0][:value]).to eq('1')
      expect(equallys[0][:feature]).to eq(nil)

      expect(equallys[1]).to eq(nil)
    end
  end

  describe '2 exercise' do
    before(:each) do
      normal_words = 'в правильный шестиугольный пирамида sabcdef сторона
      основание который равный 1, а боковой ребро равный 2, найти косинус угол
      между прямая sb и ad.'
      @exercise = Exercise.new(normal_words)
    end

    it 'split "," "." "—" "=" and word' do
      expect(@exercise.normal_words.length).to eq(26)
    end

    it 'get name figure and feature' do
      @exercise.define_features_and_figure_from_normal_words(@name_feature_figures, @name_figures)
      expect(@exercise.get_name_figure).to eq('пирамида')
      expect(@exercise.get_features_figure).to eq(['шестиугольный', 'правильный'])
    end

    it 'get mediana' do
      expect(@exercise.get_medianas).to eq([])
    end

    it 'get equally' do
      @exercise.define_equallys

      expect(@exercise.get_equallys[0][:name]).to eq('сторона')
      expect(@exercise.get_equallys[0][:feature]).to eq('основание')
      expect(@exercise.get_equallys[0][:value]).to eq('1')

      expect(@exercise.get_equallys[1][:name]).to eq('ребро')
      expect(@exercise.get_equallys[1][:feature]).to eq('боковой')
      expect(@exercise.get_equallys[1][:value]).to eq('2')
    end
  end

  describe '3 exercise' do
    before(:each) do
      normal_words = 'сторона правильный треугольный призма abca1b1c1 равный 8.
      высота этот призма равный 6. найти угол между прямая ca1 и ab1.'
      @exercise = Exercise.new(normal_words)
    end

    it 'split "," "." "—" "=" and word' do
      expect(@exercise.normal_words.length).to eq(22)
    end

    it 'get name figure and feature' do
      @exercise.define_features_and_figure_from_normal_words(@name_feature_figures, @name_figures)
      expect(@exercise.get_name_figure).to eq('призма')
      expect(@exercise.get_features_figure).to eq(['треугольный', 'правильный'])
    end

    it 'get equally' do
      @exercise.define_equallys

      expect(@exercise.get_equallys[0][:name]).to eq('сторона')
      expect(@exercise.get_equallys[0][:feature]).to eq(nil)
      expect(@exercise.get_equallys[0][:value]).to eq('8')

      expect(@exercise.get_equallys[1][:name]).to eq('высота')
      expect(@exercise.get_equallys[1][:feature]).to eq(nil)
      expect(@exercise.get_equallys[1][:value]).to eq('6')
    end
  end

  describe '4 exercise' do
    before(:each) do
      normal_words = 'в основание прямая призма abca1b1c1 лежать равнобедренный
      прямоугольный треугольник abc с гипотенуза ab, равный высота призма
      равный 6. найти угол между прямая ac1 и cb1.'
      @exercise = Exercise.new(normal_words)
    end

    it 'split "," "." "—" "=" and word' do
      expect(@exercise.normal_words.length).to eq(28)
    end

    it 'get name figure and feature' do
      @exercise.define_features_and_figure_from_normal_words(@name_feature_figures, @name_figures)
      expect(@exercise.get_name_figure).to eq('призма')
      expect(@exercise.get_features_figure).to eq(['прямая'])
    end

    it 'raise don`t define value for equally' do
      expect { @exercise.define_equallys }.to raise_error(RuntimeError,
                                                         "don`t define value for equally")
    end
  end

  describe '5 exercise' do
    before(:each) do
      normal_words = 'в пирамида dabc прямые, содержимый ребро dc и ab,
      перпендикулярны.а) построить сечение плоскостью, проходить через точка
      e — середина ребро db, и параллельно dc и ab. докажите, что получиться
      сечение являться прямоугольником.б) найти угол между диагональ это
      прямоугольника, если dc = 24, ab =10.'
      @exercise = Exercise.new(normal_words)
    end

    it 'split "," "." "—" "=" and word' do
      expect(@exercise.normal_words.length).to eq(58)
    end

    it 'get name figure and feature' do
      @exercise.define_features_and_figure_from_normal_words(@name_feature_figures, @name_figures)
      expect(@exercise.get_name_figure).to eq('пирамида')
      expect(@exercise.get_features_figure).to eq([])
    end

    it 'get mediana' do
      expect(@exercise.get_medianas[0][:letter]).to eq('e')
      expect(@exercise.get_medianas[0][:edge]).to eq('db')
    end

    it 'parsing equally sign' do
      @exercise.pattern_equally_sign
      equallys = @exercise.get_equallys

      expect(equallys[0][:name]).to eq('dc')
      expect(equallys[0][:value]).to eq('24')

      expect(equallys[1][:name]).to eq('ab')
      expect(equallys[1][:value]).to eq('10')
    end
  end

  describe '6 exercise' do
    before(:each) do
      normal_words = 'точка e — середина ребро cc1 куб abcda1b1c1d1. найти угол
      между прямая be и b1d.'
      @exercise = Exercise.new(normal_words)
    end

    it 'split "," "." "—" "=" and word' do
      expect(@exercise.normal_words.length).to eq(17)
    end

    it 'get name figure and feature' do
      @exercise.define_features_and_figure_from_normal_words(@name_feature_figures, @name_figures)
      expect(@exercise.get_name_figure).to eq('куб')
      expect(@exercise.get_features_figure).to eq([])
    end

    it 'get mediana' do
      expect(@exercise.get_medianas[0][:letter]).to eq('e')
      expect(@exercise.get_medianas[0][:edge]).to eq('cc1')
    end
  end

  describe '7 exercise' do
    before(:each) do
      normal_words = 'точка e— середина ребро cc1 куб abcda1b1c1d1. найти угол
      между прямая be и ad.'
      @exercise = Exercise.new(normal_words)
    end

    it 'split "," "." "—" "=" and word' do
      expect(@exercise.normal_words.length).to eq(17)
    end

    it 'get name figure and feature' do
      @exercise.define_features_and_figure_from_normal_words(@name_feature_figures, @name_figures)
      expect(@exercise.get_name_figure).to eq('куб')
      expect(@exercise.get_features_figure).to eq([])
    end

    it 'get mediana' do
      expect(@exercise.get_medianas[0][:letter]).to eq('e')
      expect(@exercise.get_medianas[0][:edge]).to eq('cc1')
    end
  end

  describe '8 exercise' do
    before(:each) do
      normal_words = 'на ребро cc1 куб abcda1b1c1d1 отметить точка e так, что
      ce:ec1=1:2. найти угол между прямая be и ac1.'
      @exercise = Exercise.new(normal_words)
    end

    it 'split "," "." "—" "=" and word' do
      expect(@exercise.normal_words.length).to eq(27)
    end

    it 'get name figure and feature' do
      @exercise.define_features_and_figure_from_normal_words(@name_feature_figures, @name_figures)
      expect(@exercise.get_name_figure).to eq('куб')
      expect(@exercise.get_features_figure).to eq([])
    end

    it 'parsing equally sign' do
      @exercise.pattern_equally_sign
      equallys = @exercise.get_equallys

      expect(equallys).to eq([])
    end

    it 'define point delimiters' do
      @exercise.define_point_delimiters
      point_delimiters = @exercise.get_point_delimiters

      expect(point_delimiters[0][:name_edge]).to eq('cc1')
      expect(point_delimiters[0][:letter_point]).to eq('e')
      expect(point_delimiters[0][:left]).to eq('1')
      expect(point_delimiters[0][:right]).to eq('2')
    end
  end

  describe '9 exercise' do
    before(:each) do
      normal_words = 'на ребро cc1 куб abcda1b1c1d1 отметить точка e так, что
      ce:ec1=2:1. найти угол между прямая be и ac1.'
      @exercise = Exercise.new(normal_words)
    end

    it 'split "," "." "—" "=" and word' do
      expect(@exercise.normal_words.length).to eq(27)
    end

    it 'get name figure and feature' do
      @exercise.define_features_and_figure_from_normal_words(@name_feature_figures, @name_figures)
      expect(@exercise.get_name_figure).to eq('куб')
      expect(@exercise.get_features_figure).to eq([])
    end

    it 'parsing equally sign' do
      @exercise.pattern_equally_sign
      equallys = @exercise.get_equallys

      expect(equallys).to eq([])
    end

    it 'define point delimiters' do
      @exercise.define_point_delimiters
      point_delimiters = @exercise.get_point_delimiters

      expect(point_delimiters[0][:name_edge]).to eq('cc1')
      expect(point_delimiters[0][:letter_point]).to eq('e')
      expect(point_delimiters[0][:left]).to eq('2')
      expect(point_delimiters[0][:right]).to eq('1')
    end
  end

  describe '10 exercise' do
    before(:each) do
      normal_words = 'боковой ребро правильный треугольный пирамида sabc равно
      6, а косинус угол asb при вершина боков грань равный точка m—середина
      ребро sc. найти косинус угол между прямая bm и sa.'
      @exercise = Exercise.new(normal_words)
    end

    it 'split "," "." "—" "=" and word' do
      expect(@exercise.normal_words.length).to eq(34)
    end

    it 'get name figure and feature' do
      @exercise.define_features_and_figure_from_normal_words(@name_feature_figures, @name_figures)
      expect(@exercise.get_name_figure).to eq('пирамида')
      expect(@exercise.get_features_figure).to eq(['треугольный', 'правильный'])
    end

    it 'get mediana' do
      expect(@exercise.get_medianas[0][:letter]).to eq('m')
      expect(@exercise.get_medianas[0][:edge]).to eq('sc')
    end
  end

  describe '11 exercise' do
    before(:each) do
      normal_words = 'боковой ребро правильный треугольный пирамида sabc равно
      10, а косинус угол asb при вершина боков грань равный точка m—середина
      ребро sc. найти косинус угол между прямая bm и sa.'
      @exercise = Exercise.new(normal_words)
    end

    it 'split "," "." "—" "=" and word' do
      expect(@exercise.normal_words.length).to eq(34)
    end

    it 'get name figure and feature' do
      @exercise.define_features_and_figure_from_normal_words(@name_feature_figures, @name_figures)
      expect(@exercise.get_name_figure).to eq('пирамида')
      expect(@exercise.get_features_figure).to eq(['треугольный', 'правильный'])
    end

    it 'get mediana' do
      expect(@exercise.get_medianas[0][:letter]).to eq('m')
      expect(@exercise.get_medianas[0][:edge]).to eq('sc')
    end

    it 'raise don`t define value for equally' do
      expect { @exercise.define_equallys }.to raise_error(RuntimeError,
                                                         "don`t define value for equally")
    end
  end

  describe '12 exercise' do
    before(:each) do
      normal_words = 'в правильный тетраэдр abcd найти угол между высота
      тетраэдр dh и медиана bm боков грань bcd.'
      @exercise = Exercise.new(normal_words)
    end

    it 'split "," "." "—" "=" and word' do
      expect(@exercise.normal_words.length).to eq(17)
    end

    it 'get name figure and feature' do
      @exercise.define_features_and_figure_from_normal_words(@name_feature_figures, @name_figures)
      expect(@exercise.get_name_figure).to eq('тетраэдр')
      expect(@exercise.get_features_figure).to eq(['правильный'])
    end
  end

  describe '13 exercise' do
    before(:each) do
      normal_words = 'в правильный шестиугольный пирамида sabcdef сторона
      основание который равный 1, а боковой ребро равный 2, найти угол между
      прямая sb и cd.'
      @exercise = Exercise.new(normal_words)
    end

    it 'split "," "." "—" "=" and word' do
      expect(@exercise.normal_words.length).to eq(25)
    end

    it 'get name figure and feature' do
      @exercise.define_features_and_figure_from_normal_words(@name_feature_figures, @name_figures)
      expect(@exercise.get_name_figure).to eq('пирамида')
      expect(@exercise.get_features_figure).to eq(['шестиугольный', 'правильный'])
    end

    it 'get equally' do
      @exercise.define_equallys
      equallys = @exercise.get_equallys

      expect(equallys[0][:name]).to eq('сторона')
      expect(equallys[0][:feature]).to eq('основание')
      expect(equallys[0][:value]).to eq('1')

      expect(equallys[1][:name]).to eq('ребро')
      expect(equallys[1][:feature]).to eq('боковой')
      expect(equallys[1][:value]).to eq('2')
    end
  end

  describe '14 exercise' do
    before(:each) do
      normal_words = 'длина весь ребро правильный четырехугольный пирамида
      pabcd равный между собой. найти угол между прямая ph и bm, если отрезка
      ph— высота дать пирамиды, точка m— середина она боковой ребро ap.'
      @exercise = Exercise.new(normal_words)
      @exercise.define_features_and_figure_from_normal_words(@name_feature_figures, @name_figures)
    end

    it 'split "," "." "—" "=" and word' do
      expect(@exercise.normal_words.length).to eq(36)
    end

    it 'get name figure and feature' do
      expect(@exercise.get_name_figure).to eq('пирамида')
      expect(@exercise.get_features_figure).to eq(['четырехугольный', 'правильный'])
    end

    it 'get mediana' do
      expect(@exercise.get_medianas[0][:letter]).to eq('m')
      expect(@exercise.get_medianas[0][:edge]).to eq('ap')
    end
  end
end
