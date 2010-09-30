class ExperimentsController < ApplicationController

  def parade
    @overworlds = Pokedex::Pokemon.gen(4).map { |species| species.overworlds }
  end
end
