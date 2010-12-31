class PokemonStatDatum < ActiveRecord::Migration
  def self.up
    create_table :pokemon_stat_data do |t|
      t.references :pokemon
      t.integer :level
      t.integer :hp
      t.integer :attack
      t.integer :defense
      t.integer :special_attack
      t.integer :special_defense
      t.integer :speed
    end
  end

  def self.down
    drop_table :pokemon_stat_data
  end
end
