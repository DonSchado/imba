# Imba

[![Build Status](https://travis-ci.org/DonSchado/imba.png?branch=master)](https://travis-ci.org/DonSchado/imba)
[![Code Climate](https://codeclimate.com/github/DonSchado/imba.png)](https://codeclimate.com/github/DonSchado/imba)

At the moment this project is pretty chaotic and far from done.
I want to practice some refactorings and code rearrangements in a save playground :)


## Todo:

- [x] build a mess and refactor later :)
- [ ] ask for updating movie
- [ ] get/send different name when false match
- [ ] underscore all the symbols (like genre)
- [ ] cli/opt parser exitcodes?
- [ ] objectify cli code
- [ ] catch errors in cli
- [ ] what's up with folders which were deleted but are still in the db?
- [ ] add tags to handle genres?
- [ ] fix utf-8 issues
- [ ] list movies by rating | genre | etc
- [ ] maybe document code with yard
- [ ] some logging would be nice
- [ ] decouple movie (objectify representation)


## Impression

![example](/screens/example.png)


## Installation

    $ gem install imba

inside the movie folders directory:

    $ imba --init

    $ imba --synch

    $ imba --list

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
