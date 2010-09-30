class ExperimentsController < ApplicationController

  def pokeswarm
    @data = {}

    spid = Pokedex::Stat.find_by_name('Speed').id
    @data['baseSpeeds'] = Pokedex::PokemonStat.where(:stat_id => spid).map {|pstat| pstat.base_stat}
    @data['weights'] = Pokedex::Pokemon.all.map {|species| species.weight}
    @data['heights'] = Pokedex::Pokemon.all.map {|species| species.height}

    @settings = {
      :speedStatBias => true,
      :speedWeightBias => false,
      :bobbleWeightBias => true,
      #:sizeHeightBias => true,
      :order => 'random',
    }
  end
end
