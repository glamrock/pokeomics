task :recalc_synergies => :environment do
  Pokedex::Pokemon.recalc_synergy
end
