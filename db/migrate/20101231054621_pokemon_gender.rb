class PokemonGender < ActiveRecord::Migration
  def self.up
    change_table :pokemon_individuals do |t|
      t.string :gender, :default => 'female'
    end
  end

  def self.down
    change_table :pokemon_individuals do |t|
      t.remove_column :gender
    end
  end
end
