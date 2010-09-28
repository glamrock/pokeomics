class PokemonController < ApplicationController
  def new
    @pokemon = Pokemon.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @pokemon = Pokemon.new(params[:pokemon])

    respond_to do |format|
      if @pokemon.save
        format.html { redirect_to @pokemon, :notice => "#{@pokemon.species.name} saved successfully!" }
      else
        format.html { render :action => "new" }
      end
    end
  end
end
