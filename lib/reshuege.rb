# coding: utf-8
require "./lib/parsing/parsing"
# require 'uri'
# require 'rubygems'

class Reshuege < Parsing
  def get
    page = get_url
    page = select_text_exercise(page)
    page = clean_html_text_exercise(page)
    page
  end

  def select_text_exercise(page)
    page.css('div.prob_maindiv div.pbody')
  end

  def clean_html_text_exercise(page)
    page.map do |exercise|
      exercise.css('span').remove
      exercise.text.strip
    end
  end
end
