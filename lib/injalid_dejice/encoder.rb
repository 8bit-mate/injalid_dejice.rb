# frozen_string_literal: true

module InjalidDejice
  #
  # Encodes a UTF-8 string to the KOI-7 encoding.
  #
  class Encoder
    OUTPUT_ENCODING = "US-ASCII"

    def initialize(forced_latin: [], unknown_char_rep: DEF_UNKNOWN_CHAR_REP)
      @forced_latin = forced_latin
      @unknown_char_rep = unknown_char_rep
    end

    #
    # Encode 'input_string' to the KOI-7 encoding.
    #
    # @param [String] input_string
    #   A UTF-8 string.
    #
    # @return [String]
    #   An ASCII string, KOI-7-compatible.
    #
    def call(input_string)
      non_latin_indexes = LocaleResolver.new(input_string, @forced_latin).call

      result = if non_latin_indexes.empty?
                 # No non-Latin characters were found, so no futher action needed.
                 input_string.dup
               else
                 _insert_shift_chars(
                   _handle_replacements(input_string),
                   non_latin_indexes
                 )
               end

      result.force_encoding(OUTPUT_ENCODING)
    end

    private

    #
    # Replace all non-Latin characters in the 'input_string'.
    #
    # @param [String] input_string
    #
    # @return [String] modified_string
    #
    def _handle_replacements(input_string)
      encoding_options = {
        invalid: :replace,
        fallback: lambda { |char|
          CYR_TO_LAT_DICT.fetch(char, @unknown_char_rep)
        }
      }

      input_string.encode(Encoding.find("US-ASCII"), **encoding_options)
    end

    #
    # Insert SO & SI control characters to the string.
    #
    # @param [String] input_string
    # @param [Array<Array<Integer>>] non_latin_indexes
    #
    # @return [String] input_string
    #   Modified string.
    #
    def _insert_shift_chars(input_string, non_latin_indexes)
      i = 0 # Counter of insertions.

      non_latin_indexes.each do |start_idx, end_idx|
        # Add a Cyrillic code page marker (SO) at the beginning of the Cyrillic sub-string.
        # + 2 * i since each i-th Cyrillic sub-string gets wrapped with two chars (SO + SI),
        # so all indexes get shifted.
        input_string.insert(start_idx + 2 * i, CYR_CHAR)

        # Add a Latin code page marker (SI) at the end of the Cyrillic sub-string.
        # + (end_idx + 2) since #insert method inserts a sub-string *before* the character at
        # the given index, so +1 to insert it *after*. Another +1 as we've just insert SO
        # character, so all indexes were shifted.
        input_string.insert((end_idx + 2) + 2 * i, LATIN_CHAR)
        i += 1
      end

      input_string
    end
  end
end
