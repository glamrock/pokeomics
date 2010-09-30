task :pokedex_load do
  sh %(
    sudo aptitude install python-mysqldb python-setuptools
    git clone git://veekun.com/pokedex.git
    cd pokedex
    sudo python setup.py develop
    pokedex load -e mysql://pokeomics@localhost/pokeomics_development
  )
end
