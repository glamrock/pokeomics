class CreatePokemon < ActiveRecord::Migration
  def self.up
    create_table :pokemon_individuals do |t|
      t.integer :species_id
  
      t.timestamps
    end
  end

  def self.down
    drop_table :pokemon_individuals
  end
end
