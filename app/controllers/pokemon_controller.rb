class PokemonController < ApplicationController
  before_filter :require_userish

  def require_userish
    @current_user = User.first
  end

  def create
    pokemon = Pokemon.new({ :species_id => params['species_id'], :nature_id => params['nature_id'] })
    pokemon.user = @current_user
    pokemon.save

    params['statdata'].each do |datum|
      statdatum = PokemonStatDatum.new(datum)
      statdatum.pokemon = pokemon
      statdatum.save
    end
  end
end
