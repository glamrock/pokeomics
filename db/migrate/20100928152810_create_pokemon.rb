class CreatePokemon < ActiveRecord::Migration
  def self.up
    create_table :pokemon do |t|
      t.belongs_to :species

      t.timestamps
    end
  end

  def self.down
    drop_table :pokemon
  end
end
