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

  def pokenet_data
    conns = []

    candidates = Pokedex::Pokemon.gen(4).find_all { |poke| poke.can_breed? && poke.previous_evolution.nil? }

    conns = candidates.combination(2)

    conns = conns.
      find_all { |conn| conn[0].can_breed_with?(conn[1]) }.
      map { |conn| [conn[0].id, conn[1].id] }.
      uniq
  end

  def pokenet
    @params = params
  end

  def countdown
  end

  def sunburst
    @totals = {}

    gen = params[:gen] ? params[:gen].to_i : 4

    if params[:id] == 'types'
      @title = "Pokemon by Type"
      Pokedex::Type.all.each do |type|
        @totals[type.name.capitalize] = type.pokemon.find_all { |poke| poke.generation_id <= gen }.length
      end
    elsif params[:id] == 'egg_groups'
      @title = "Pokemon by Egg Group"
      Pokedex::EggGroup.all.each do |group|
        @totals[group.name.capitalize] = group.pokemon.find_all { |poke| poke.generation_id <= gen }.length
      end
    elsif params[:id] == "evo_stages"
      @title = "Pokemon by Evolutionary Stage"
       
    end
  end
end
