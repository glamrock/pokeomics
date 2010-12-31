# Model defining an individual Pokemon. Not to be confused with
# Pokedex::Pokemon, which defines a whole species.
class Pokemon < ActiveRecord::Base
  set_table_name 'pokemon_individuals'

  validates :species_id, :presence => true
  validates :nature_id, :presence => true

  belongs_to :species, :class_name => "Pokedex::Pokemon"
  belongs_to :nature, :class_name => "Pokedex::Nature"

  belongs_to :user
end
