# injalid_dejice.rb

Converts UTF-8 strings to the legacy KOI-7 encoding.

**KOI-7** (Russian: КОИ-7) was a 7-bit character encoding developed in the USSR and based on the US-ASCII encoding. US-ASCII has only 128 code points, which are enough to encode the Latin alphabet (with numbers and most common punctuation marks), but not enough to encode both Latin and Cyrillic alphabets with the full set of characters (uppercase and lowercase).

In order to add Cyrillic alphabet support, but also to remain US-ASCII compatible, KOI-7 designers came up with a “hack”, in which both Cyrillic and Latin characters were encoded with the same code points, while the ASCII control characters 0x0E and 0x0F were adapted to switch between the Cyrillic and the Latin code pages, respectively.

This led to very annoying, yet sometimes funny bugs when an English text was printed (on a screen, a printer, or a teletype), while the codepage was still set to Cyrillic. The «**иНЖАЛИД ДЕЖИЦЕ**» message (pronounced as “injalid dejitze”) is the most notable example of a such case. The message became somewhat of a meme, and also an eponym for improperly coded text that looks like gibberish. In fact, the phrase was an improperly coded error message that simply states: “Invalid device”. Hence the name of the gem.

KOI-7 was widely used on the Soviet PDP-11 clones, notably the DVK systems and the Elektronika MK90 portable computer.

## Installation

Add this line to your application"s Gemfile:

```ruby
gem "injalid_dejice"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install injalid_dejice

## Usage

Ruby doesn't support KOI-7 natively (see ```Encoding.name_list```), but does support 7-bit US-ASCII, a KOI-7 compatible encoding (since KOI-7 was based on the US-ASCII). So the encoder returns result as an US-ASCII string, and the decoder expects an input string to be encoded in US-ASCII, or in any compatible encoding (e.g. UTF-8 with characters in the range of 0x00 - 0x7F).

### Encoding a string from UTF-8 to KOI-7

InjalidDejice.utf_to_koi(string [, keyword arguments])

Arguments:

- string

Keyword arguments:

- :forced_latin ([])

  Characters 0x00 - 0x32 are shared by both Cyrillic and Latin code page (KOI-7 N0 and KOI-7 N1 code pages). A such character's locale is defined by the preceding character(s). But sometimes locale of such a character should be forcibly switched to the Latin, regardless of the preceding character(s). 

  :forced_latin option allows to do that. It specifies characters that will be treated as Latin. I.e. if the Cyrillic locale was set with the SO (0x0E), any character specified in the forced_latin array will forcibly append the SI (0x0F) code before the character.

- :unknown_char_rep ("?")

  A replacement character for the unsupported characters.

Returns:

- String

### Decoding a string from KOI-7 to UTF-8

InjalidDejice.koi_to_utf(string [, keyword arguments])

Arguments:

- string

Keyword arguments:

- :strict mode (false)

   When 'true', if locale was switched to the Cyrillic with an SO (0x0E) character, it should be switched back to the Latin locale with a SI (0x0F) character. If the condition haven't been met an ArgumentError is raised.

- :unknown_char_rep ("?")

  A replacement character for the unsupported characters.

Returns:

- String

### Examples

```ruby
require "injalid_dejice"

# Encode:
str_to_encode = "Пользователи ДВК помнят 'инжалид дежице'!"
InjalidDejice.utf_to_koi(str_to_encode)
# => "\x0EpOLXZOWATELI dwk POMNQT 'INVALID DEVICE'!\x0F"

# Decode:
str_to_decode = "In KOI-7, two control characters can turn 'bhc' into '\x0Ebhc\x0F'!"
InjalidDejice.koi_to_utf(str_to_decode)
# => "In KOI-7, two control characters can turn 'bhc' into 'БХЦ'!"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/8bit-mate/injalid_dejice.rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
