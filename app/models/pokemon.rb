# Model defining an individual Pokemon. Not to be confused with
# Pokedex::Pokemon, which defines a whole species.
class Pokemon < ActiveRecord::Base
  set_table_name 'pokemon_individuals'

  validates :species_id, :presence => true
  validates :nature_id, :presence => true

  belongs_to :species, :class_name => "Pokedex::Pokemon"
  belongs_to :nature, :class_name => "Pokedex::Nature"

  belongs_to :user

  has_many :statdata, :class_name => "PokemonStatDatum"

  before_create :correct_values

  def as_json(opts={})
    hash = super(opts)
    hash[:statdata] = statdata
    hash
  end

  # Destroy current statdata and replace with data specified by array of hashes
  def update_statdata(data)
    statdata.destroy_all
    data.each do |datum|
      statdatum = PokemonStatDatum.new(datum)
      statdatum.pokemon = self
      statdatum.save
    end
  end

  def correct_values
    if species.gender_rate == -1
      self.gender = 'neuter'
    elsif species.gender_rate == 0
      self.gender = 'male'
    elsif species.gender_rate == 8
      self.gender = 'female'
    end
  end
end
