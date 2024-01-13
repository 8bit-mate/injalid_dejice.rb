# frozen_string_literal: true

module InjalidDejice
  #
  # Decodes an US-ASCII (KOI-7-compatible) string to the UTF-8 encoding.
  #
  class Decoder
    OUTPUT_ENCODING = "UTF-8"

    def initialize(unknown_char_rep: DEF_UNKNOWN_CHAR_REP, strict_mode: false)
      @unknown_char_rep = unknown_char_rep
      @strict_mode = strict_mode
    end

    #
    # Encode US-ANSII (KOI-7-compatible) string to the UTF-8.
    #
    # @param [String] input_string
    #
    # @return [String]
    #
    def call(input_string)
      @result_string = input_string.dup
      @start_idx = nil

      _process_chars(input_string).force_encoding(OUTPUT_ENCODING)
    end

    private

    def _process_chars(input_string)
      input_string.each_char.with_index do |char, idx|
        # Everything above the 0x7F cannot be in the KOI-7, so just get rid of it.
        @result_string[idx] = @unknown_char_rep if char.ord > ASCII_CHARS_LIMIT

        # Found beginning of a Cyr. sub-string.
        @start_idx = idx if char == CYR_CHAR

        # Found beginning of a Latin string, what should indicate the end of the Cyr. string.
        _on_cyr_substr_end(idx) if char == LATIN_CHAR && @start_idx
      end

      _check_unexpected_end if @strict_mode

      # Before the return remove control characters with the regex.
      @result_string.gsub(/[#{LATIN_CHAR}#{CYR_CHAR}]/, "")
    end

    def _on_cyr_substr_end(idx)
      _decode_cyr_substr(idx)
      @start_idx = nil
    end

    #
    # Decode everything between the control characters.
    #
    def _decode_cyr_substr(idx)
      (@start_idx + 1..idx).each do |sub_idx|
        if @result_string[sub_idx].ord >= SHARED_CHARS_LIMIT
          @result_string[sub_idx] = (LAT_TO_CYR_DICT[@result_string[sub_idx]] || DEF_UNKNOWN_CHAR_REP)
        end
      end
    end

    #
    # @raise [ArgumentError]
    #   Found the beginning of the Cyrillic sub-string, but couldn't find the end.
    #
    def _check_unexpected_end
      # Found the beginning of the Cyr. sub-string, but couldn't find the end (the LATIN_CHAR marker),
      # probably that means an unexpected end of the string. Raise an error (only in the strict mode).
      raise ArgumentError, "unexpected end of the string" if @start_idx
    end
  end
end
