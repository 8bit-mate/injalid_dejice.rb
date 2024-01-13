# frozen_string_literal: true

require_relative "injalid_dejice/decoder"
require_relative "injalid_dejice/encoder"
require_relative "injalid_dejice/injalid_dejice"
require_relative "injalid_dejice/locale_resolver"
require_relative "injalid_dejice/version"

#
# UTF-8 <-> KOI-7 encoder/decoder.
#
module InjalidDejice
  class Error < StandardError; end

  #
  # Encode 'utf_string' to the KOI-7 encoding.
  #
  # @param [String] utf_string
  #   A UTF-8 string.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Options.
  #
  # @option kwargs [Array<String>] :forced_latin ([])
  #   Force characters to be recognized as Latin ones.
  #
  # @option kwargs [String] :unknown_char_rep (DEF_UNKNOWN_CHAR_REP)
  #   Replacement character for the unsupported characters.
  #
  # @return [String]
  #   An US-ASCII string, KOI-7-compatible.
  #
  def self.utf_to_koi(utf_string, **kwargs)
    Encoder.new(**kwargs).call(utf_string)
  end

  #
  # Decode 'koi_string' from the KOI-7 to the UTF-8.
  #
  # @param [String] koi_string
  #   A KOI-7-compatible string.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Options.
  #
  # @option kwargs [String] :unknown_char_rep (DEF_UNKNOWN_CHAR_REP)
  #   Replacement character for the unsupported characters.
  #
  # @option kwargs [Boolean] :strict_mode (false)
  #   When 'true', an opening SO (0x0E) character should have a closing SI (0x0F)
  #   counterpart, otherwise ArgumentError would be raised. When 'false', an error
  #   won't be raised.
  #
  # @return [String]
  #
  def self.koi_to_utf(koi_string, **kwargs)
    Decoder.new(**kwargs).call(koi_string)
  end
end
