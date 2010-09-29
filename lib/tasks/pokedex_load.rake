task :pokedex_load do
  sh %(
    git submodule init
    git submodule update
    sudo aptitude install python-mysqldb python-setuptools
    sudo python db/pokedex/setup.py develop
    pokedex load -e mysql://pokeomics@localhost/pokeomics_development
  )
end
