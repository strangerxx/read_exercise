require 'spec_helper'

require './config/config'
Dir['./lib/*.rb'].each {|file| require file}

describe 'Exercise' do
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
  end

  describe 'first exercise' do
    before(:each) do
      normal_words = 'длина ребро правильный тетраэдр abcd равный 1. найти угол между прямая dm и cl, где m — середина ребро bc, l — середина ребро ab.'
      @exercise = Exercise.new(NormalExercise.find(1).content)
    end

    it 'split "," "." "—" and word' do
      # expect(@exercise.normal_words[6]).to eq('1')
      # expect(@exercise.normal_words[7]).to eq('.')
      #
      # expect(@exercise.normal_words[14]).to eq('cl')
      # expect(@exercise.normal_words[15]).to eq(',')
      #
      # expect(@exercise.normal_words[18]).to eq('—')
      #
      # expect(@exercise.normal_words[21]).to eq('bc')
      # expect(@exercise.normal_words[22]).to eq(',')
      #
      # expect(@exercise.normal_words[23]).to eq('—')
      #
      # expect(@exercise.normal_words[26]).to eq('ab')
      # expect(@exercise.normal_words[27]).to eq('.')
    end
  end
end
