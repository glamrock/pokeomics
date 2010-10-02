class ExperimentsController < ApplicationController

  def pokeswarm
    @data = {}

    spid = Pokedex::Stat.find_by_name('Speed').id
    @data['baseSpeeds'] = Pokedex::PokemonStat.where(:stat_id => spid).map {|pstat| pstat.base_stat}
    @data['weights'] = Pokedex::Pokemon.gen(4).map {|species| species.weight}
    @data['heights'] = Pokedex::Pokemon.gen(4).map {|species| species.height}
    @data['capRates'] = Pokedex::Pokemon.gen(4).map {|species| species.capture_rate}[0..492]
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
      :appearByCaptureRate => true,
      :order => 'random',
    }
    
    params.each do |key, val|
      if val == 'false'; @settings[key] = false
      elsif val == 'true'; @settings[key] = true
      elsif val.to_i.to_s == val; @settings[key] = val.to_i
      else @settings[key] = val
      end
    end
  end
end
