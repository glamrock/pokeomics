# Contains the many readonly models which provide access to veekun's Pokedex data
module Pokedex

  # Mixin
  module Pokedata
    def readonly?
      true
    end
  end

  # Main Pokemon species model
  class Pokemon < ActiveRecord::Base
    include Pokedata

    class << self
      # Returns all species present in a given generation of games
      def gen(n)
        Pokemon.all.find_all { |species| species.generation_id <= n && species.forme_base_pokemon_id.nil?}
      end

      def synergy_map
      end
    end

    belongs_to :generation 
    belongs_to :evolution_chain
    belongs_to :pokemon_color, :foreign_key => 'color_id'
    belongs_to :pokemon_shape
    belongs_to :pokemon_habitat, :foreign_key => 'habitat_id'

    has_many :pokemon_stats

    has_and_belongs_to_many :egg_groups, :join_table => 'pokemon_egg_groups'
    has_and_belongs_to_many :types, :join_table => 'pokemon_types'
    has_and_belongs_to_many :abilities, :join_table => 'pokemon_abilities'

    # Generates a friendly hash of form { "Stat Name" => base_value }
    def base_stats
      bases = {}

      pokemon_stats.each do |pokestat|
        bases[pokestat.stat.name] = pokestat.base_stat
      end

      bases
    end

    def highest_base_stat
      base_stats.invert[base_stats.values.max]
    end

    # Returns path to the DP party icon for this species
    def icon
      "dp_icons/%.3d.gif" % id
    end

    # Returns hash of HGSS overworld sprite frames paths
    def overworlds
      paths = {} 
      [:down, :up, :left, :right].each do |dir|
        paths[dir] = ["overworld/#{dir}/#{id}.png", "overworld/#{dir}/frame2/#{id}.png"]
      end
      paths
    end 

    def previous_evolution
      evo = Pokedex::Evolution.find_by_to_pokemon_id(id)
      evo.nil? ? nil : evo.from_pokemon
    end

    def can_breed?
      !is_baby && egg_groups.length > 0 && !egg_groups.include?(Pokedex::EggGroup.find_by_name('No Eggs'))
    end

    def can_breed_with?(species)
      return true if id == 132 || species.id == 132
      can_breed? && species.can_breed? && (egg_groups - species.egg_groups).length < egg_groups.length
    end

    def has_ability?(ability_or_name)
      if ability_or_name.is_a? String
        ability = Pokedex::Ability.find_by_name(ability_or_name)
      else
        ability = ability_or_name
      end

      self.abilities.include?(ability)
    end

    ### Type stuff

    # Returns a hash of form { Pokedex::Type => damage_factor }
    def typematches(opts={})
      damage_factors = {}
      types.each do |type|
        Pokedex::TypeEfficacy.where(:target_type_id => type.id).each do |efficacy|
          dtype = efficacy.damage_type
          dfactor = efficacy.damage_factor

          if damage_factors[dtype.name].nil?
            damage_factors[dtype.name] = dfactor
          else
            damage_factors[dtype.name] *= (dfactor/100.0) # Compound effectiveness
          end
        end
      end

      ability = opts[:ability] || self.abilities.first.name

      # Abilities. Absorptions are strings rather than negative values since they are specially handled anyway.
      case ability
        when 'Dry Skin' then 
        when 'Water Absorb' then 
          damage_factors['water'] = 'Absorb'
          damage_factors['fire'] *= 1.25
        when 'Flash Fire' then 
          damage_factors['fire'] = 'Power Up'
        when 'Heatproof' then 
          damage_factors['fire'] *= 0.5
        when 'Levitate' then 
          damage_factors['ground'] = 0.0
        when 'Motor Drive' then 
          damage_factors['electric'] = 'Power Up'
        when 'Thick Fat' then 
          damage_factors['fire'] *= 0.5
          damage_factors['ice'] *= 0.5
        when 'Volt Absorb' then 
          damage_factors['electric'] = 'Absorb'
      end

      damage_factors
    end

    # Calculate synergy score for another Pokemon; i.e how well that Pokemon complements our weaknesses.
    def synergy(poke, opts={})
      rating = 0
      reasons = []

      pokematches = poke.typematches(:ability => opts[:defender_ability])

      self.typematches(:ability => opts[:defended_ability]).each do |type, sfactor|
        pfactor = pokematches[type]

        # Compound resistance scale 
        sscore, pscore = [sfactor, pfactor].map { |fac|
          if fac == 0; 8.0 # Immunity counts as double compound resistance
          elsif fac == 'Absorb'; 12 # Absorption counts as triple compound resistance
          elsif fac == 'Power Up'; 12
          else
            (Math.log2(fac/25)-2)*-2
          end
        }

        #p "#{type} #{sscore} #{pscore}"

        if sscore < 0 && pscore > 0
          change = (sscore-pscore).abs # Bonus for resistance/weakness
        elsif sscore < 0 && pscore < 0
          change = -(sscore+pscore).abs # Penalty for weakness/weakness
        end

        unless change.nil?
          rating += change
          reasons << [type, pfactor] if opts[:include_reasons]
        end
      end

      opts[:include_reasons] ? { rating: rating, reasons: reasons } : rating
    end
  end

  # Defines an individual type of stat, e.g "HP"
  class Stat < ActiveRecord::Base
    include Pokedata

    belongs_to :damage_class
  end

  # Join table for Pokemon and Stats
  class PokemonStat < ActiveRecord::Base
    include Pokedata

    belongs_to :pokemon
    belongs_to :stat
  end

  # Join table for Pokemon and Abilities
  class PokemonAbility < ActiveRecord::Base
    include Pokedata

    belongs_to :pokemon
    belongs_to :ability
  end

  class Ability < ActiveRecord::Base
    include Pokedata

    has_and_belongs_to_many :pokemon, :join_table => 'pokemon_abilities'    
  end

  # Defines a Pokemon egg group
  class EggGroup < ActiveRecord::Base
    include Pokedata

    has_and_belongs_to_many :pokemon, :join_table => 'pokemon_egg_groups'
  end

  # Defines evolutionary transitions between Pokemon and their properties.
  class Evolution < ActiveRecord::Base
    include Pokedata

    set_table_name "pokemon_evolution"

    belongs_to :from_pokemon, :class_name => "Pokedex::Pokemon"
    belongs_to :to_pokemon, :class_name => "Pokedex::Pokemon"
  end

  # Defines a Pokemon evolution chain.
  class EvolutionChain < ActiveRecord::Base
  end

  # Defines a Pokemon type
  class Type < ActiveRecord::Base
    include Pokedata

    belongs_to :generation
    belongs_to :damage_class

    has_and_belongs_to_many :pokemon, :join_table => 'pokemon_types'

    def weaknesses
      Pokedex::TypeEfficacy.where(:target_type_id => self.id, :damage_factor => 200)
    end

    def resistances
      Pokedex::TypeEfficacy.where(:target_type_id => self.id, :damage_factor => 50)
    end

    def immunities
      Pokedex::TypeEfficacy.where(:target_type_id => self.id, :damage_factor => 0)
    end

    def damage_to(type)
      if type.is_a? String
        type = Pokedex::Type.find_by_name(type) || Pokedex::Type.find_by_abbreviation(type)
      end

      Pokedex::TypeEfficacy.where(:damage_type_id => self.id, :target_type_id => type.id).first
    end
  end

  # Defines the efficacy relationships among types
  class TypeEfficacy < ActiveRecord::Base
    set_table_name "type_efficacy"
    belongs_to :damage_type, :class_name => "Pokedex::Type"
    belongs_to :target_type, :class_name => "Pokedex::Type"
  end

  # Defines a generation of pokemon games
  class Generation < ActiveRecord::Base
    include Pokedata
  end
  

  class Nature < ActiveRecord::Base
    include Pokedata
  end
end
