class PokemonController < ApplicationController
  before_filter :require_userish

  before_filter :get_pokemon, :except => ['list']
  before_filter :check_ownership, :except => ['list', 'show', 'data']

  def require_userish
    @current_user = User.first
  end

  def get_pokemon
    @poke = Pokemon.find(params[:id])
  end

  def check_ownership
    if @poke.user != @current_user
      render :text => "Access Denied"
    end
  end

  def list
    
  end

  def show
    @poke = Pokemon.find(params[:id])
  end

  def data
    @poke = Pokemon.find(params[:id])
    render :json => @poke
  end

  def create
    poke = Pokemon.new(params.only('species_id', 'nature_id', 'gender'));
    poke.user = @current_user
    poke.save

    poke.update_statdata(params['statdata'].values)

    render :text => "^_^"
  end

  def update
    poke.update_attributes(params.only('species_id', 'nature_id', 'gender'))

    poke.update_statdata(params['statdata'].values)

    render :text => "^_^"
  end

  def destroy

    render :text => "^_^"
  end
end
