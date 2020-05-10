require 'open-uri'

class GamesController < ApplicationController
  VOWELS = ["A","E","I","O","U","Y"]

  def new
    @letters = VOWELS.sample(5)
    @letters += ('A'..'Z').to_a.sample(5)
    @letters.shuffle!

  end

  def score
    @word = (params[:word] || "").upcase
    letters = params[:letters].split
    by_the_rules= by_the_rules?(@word, letters)
    is_it_english = is_it_english?(@word)
    if(by_the_rules && is_it_english)
      @status = true
    else
      @status = false
    end
  end

  def by_the_rules?(word, letters)
    word = word.chars
    word.each do |letter|
      if !(letters.include? letter)
        return false
      end
    end
    return true
  end

  def is_it_english?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    return JSON.parse(response.read)["found"]
  end
end
