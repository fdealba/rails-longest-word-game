require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    session[:score].present? ? session[:score] : session[:score] = 0
    @letters = (0..10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @letters = params[:letters]
    @result = ''
    if english? && params[:answer].upcase.split("").all? { |char| params[:answer].upcase.split("").count(char) <= @letters.split.count(char) }
      @result = "Congratulations! #{params[:answer]} is a valid english word!"
      session[:score] += params[:answer].length * params[:answer].length
    elsif english? == false
      @result = "Sorry buy #{params[:answer]} does not seem to be a valid english word..."
    else
      @result = "Sorry but #{params[:answer]} can't be built out of #{@letters}"
    end
  end

  def english?
    url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
    response = open(url).read
    result = JSON.parse(response)
    result['found']
  end
end
