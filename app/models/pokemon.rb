# Model defining an individual Pokemon. Not to be confused with
# Pokedex::Pokemon, which defines a whole species.
class Pokemon < ActiveRecord::Base
  set_table_name 'pokemon_individuals'

  belongs_to :species, :class_name => "Pokedex::Pokemon"
end
