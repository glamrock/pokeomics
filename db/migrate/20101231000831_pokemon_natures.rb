class PokemonNatures < ActiveRecord::Migration
  def self.up
    change_table :pokemon_individuals do |t|
      t.references :nature
    end
  end

  def self.down
    change_table :pokemon_individuals do |t|
      t.remove_column :nature_id
    end
  end
end
