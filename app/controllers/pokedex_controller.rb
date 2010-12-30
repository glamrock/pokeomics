class PokedexController < ApplicationController
  def sprite
    redirect_to '/images/' + Pokedex::Pokemon.find(params[:species]).icon
  end
end
