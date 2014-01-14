# Imba

[![Build Status](https://travis-ci.org/DonSchado/imba.png?branch=master)](https://travis-ci.org/DonSchado/imba)
[![Code Climate](https://codeclimate.com/github/DonSchado/imba.png)](https://codeclimate.com/github/DonSchado/imba)

## Todo:

- [x] build a mess and refactor later :)
- [x] init .imba-store
- [x] persistence datastore
- [x] sync: get current directory list (movie names)
- [x] ask for updating movie
- [x] rename directory
- [x] cleanup movie titles, remove crap like (I)

- [ ] refactor to use active_record instead of datastore for movies
- [ ] fix utf-8 issues
- [ ] rescue ".imba does not exist (PStore::Error)"
- [ ] place names in queue w/o .imba-meta
- [ ] pop movie and search imdb
- [ ] get first item
- [ ] place .imba-meta file with id, title, genre, rating, year
- [ ] write .imba-meta into imba-store
- [ ] list movies by rating | genre | etc
- [ ] print imba-store
- [ ] maybe document code with yard
- [ ] decouple movie (objectify representation)
- [ ] colorize output
- [ ] play movie # on ATV


## Installation

    $ gem install imba

    $ imba --init


## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
