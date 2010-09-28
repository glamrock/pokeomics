class CreatePokemons < ActiveRecord::Migration
  def self.up
    create_table :pokemons do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :pokemons
  end
end
