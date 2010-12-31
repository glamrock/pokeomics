class PokemonUserId < ActiveRecord::Migration
  def self.up
    change_table :pokemon_individuals do |t|
      t.references :user
    end
  end

  def self.down
    change_table :pokemon_individuals do |t|
      t.remove_column :user_id
    end
  end
end
