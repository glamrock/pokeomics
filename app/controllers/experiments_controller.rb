class ExperimentsController < ApplicationController

  def pokeswarm
    @data = {}

    spid = Pokedex::Stat.find_by_name('Speed').id
    @data['baseSpeeds'] = Pokedex::PokemonStat.where(:stat_id => spid).map {|pstat| pstat.base_stat}
    @data['weights'] = Pokedex::Pokemon.all.map {|species| species.weight}
    @data['heights'] = Pokedex::Pokemon.all.map {|species| species.height}
    @data['forms'] = {}

    paths = Dir.glob('public/images/overworld/down/*.png')
    paths.each do |path|
      match = path.match(/(\d+)(.+?)?\.png/)
      if match[2]
        @data['forms'][match[1]] ||= []
        @data['forms'][match[1]] << match[1]+match[2]
      end
    end

    @settings = {
      :speedStatBias => true,
      #:speedWeightBias => true,
      #:bobbleWeightBias => true,
      #:bobbleStatBias => true,
      #:sizeHeightBias => true,
      :order => 'random',
    }
  end
end
