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
    end

    belongs_to :generation 
    belongs_to :evolution_chain
    belongs_to :pokemon_color, :foreign_key => 'color_id'
    belongs_to :pokemon_shape
    belongs_to :pokemon_habitat, :foreign_key => 'habitat_id'

    has_many :pokemon_stats

    # Generates a friendly hash of form { "Stat Name" => base_value }
    def base_stats
      bases = {}

      pokemon_stats.each do |pokestat|
        bases[pokestat.stat.name] = pokestat.base_stat
      end

      bases
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

    has_and_belongs_to_many :egg_groups, :join_table => 'pokemon_egg_groups'
    has_and_belongs_to_many :types, :join_table => 'pokemon_types'
  end

  # Join table for Pokemon and Stats
  class PokemonStat < ActiveRecord::Base
    include Pokedata

    belongs_to :pokemon
    belongs_to :stat
  end

  # Defines an individual type of stat, e.g "HP"
  class Stat < ActiveRecord::Base
    include Pokedata

    belongs_to :damage_class
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

  # Defines a Pokemon type
  class Type < ActiveRecord::Base
    include Pokedata

    belongs_to :generation
    belongs_to :damage_class

    has_and_belongs_to_many :pokemon, :join_table => 'pokemon_types'
  end

  # Defines a generation of pokemon games
  class Generation < ActiveRecord::Base
    include Pokedata
  end
  

  class Nature < ActiveRecord::Base
    include Pokedata
  end
end
