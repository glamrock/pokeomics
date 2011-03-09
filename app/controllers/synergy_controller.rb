class SynergyController < ApplicationController
  def index
    species = params[:species]
    subject = Pokedex::Pokemon.find_by_name(species)

    # Build up a hash of synergy ratings for all possible partners
    
    synergies = {}
    Pokedex::Pokemon.all.each do |poke|
      synergies[poke.name] = subject.synergy(poke)
    end

    synergies.sort {|x,y| y[1][:rating] <=> x[1][:rating]}
  end
end
