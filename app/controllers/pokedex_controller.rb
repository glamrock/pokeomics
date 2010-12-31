class PokedexController < ApplicationController
  def sprite
    headers['Content-Type'] = 'image/gif'
    redirect_to '/images/' + Pokedex::Pokemon.find(params[:species]).icon
  end
end
