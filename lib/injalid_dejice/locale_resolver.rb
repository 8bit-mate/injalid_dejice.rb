# frozen_string_literal: true

module InjalidDejice
  #
  # Finds start and end indexes of a non-Latin sub-string.
  #
  class LocaleResolver
    #
    # Class init.
    #
    # @param [String] string
    # @param [Array<String>] forced_latin ([])
    #
    def initialize(string, forced_latin = [])
      @string = string
      @forced_latin = forced_latin
    end

    #
    # Return start and end indexes for all so-called "non-Latin" sub-strings of the
    # input string. Numbers and some punctuation characters can be part of both Latin,
    # and non-Latin sub-strings. The "locale" of these characters is defined by the
    # preceding character(s). E.g., in the string "привет-123 hello-456" the "-123 "
    # chunk (note the trailing space) would be considered as a part of the non-Latin
    # sub-string, while the "-456" chunk as a part of the Latin sub-string.
    #
    # Sometimes it is required to forcibly apply the Latin 'locale' to the character.
    # This is needed to avoid some bugs in the legacy software (e.g. MK90 BASIC). For
    # this purpose there's the optional argument 'forced_latin'.
    #
    # @return [Array<Array<Integer>>] non_latin_indexes
    #   Pairs of non-Latin character indexes.
    #   Example: [[2, 5], [9, 14]], i.e. @string has two non-Latin sub-strings.
    #   The first one occupies characters from 2-nd to 5-th, the second one from 9-th
    #   to 14-th. If there's no such sub-string, the @non_latin_indexes is an empty
    #   array.
    #
    def call
      @non_latin_indexes = []
      @start_index = nil

      _handle_subtrings

      _handle_last_substring if @start_index

      @non_latin_indexes
    end

    private

    def _handle_subtrings
      @string.each_char.with_index do |char, idx|
        case _char_kind_of?(char)
        when :shared
          _handle_shared_char(char, idx)
        when :latin
          _handle_latin_char(idx)
        else
          _handle_other_char(idx)
        end
      end
    end

    def _handle_shared_char(char, idx)
      # Force a character to be recognized as a Latin one if it was specified
      # in the '@forced_latin' array.
      _on_end_of_non_latin_substr(idx) if @forced_latin.include?(char) && @start_index
    end

    def _handle_latin_char(idx)
      # If the current character is Latin and '@start_index' is set,
      # it means the Cyrillic substring has ended.
      _on_end_of_non_latin_substr(idx) if @start_index
    end

    def _handle_other_char(idx)
      @start_index = idx if @start_index.nil?
    end

    def _handle_last_substring
      @non_latin_indexes << [@start_index, @string.length - 1]
    end

    def _on_end_of_non_latin_substr(idx)
      @non_latin_indexes << [@start_index, idx - 1]
      @start_index = nil
    end

    #
    # Return character type based on its UTF-8 code.
    #
    # @param [String] char
    #
    # @return [Symbol]
    #
    def _char_kind_of?(char)
      if char.ord < SHARED_CHARS_LIMIT
        :shared
      elsif char.ord >= SHARED_CHARS_LIMIT && char.ord <= ASCII_CHARS_LIMIT
        :latin
      else
        :other
      end
    end
  end
end
