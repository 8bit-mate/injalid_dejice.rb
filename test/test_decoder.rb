# frozen_string_literal: true

require_relative "test_helper"

class TestInjalidDejice < Minitest::Test
  UNKNOWN_CHAR = "*"

  def test_latin_chars_only
    str = "In Soviet Russia characters control YOU!"
    assert_equal str, InjalidDejice.koi_to_utf(str)
  end

  def test_cyr_chars_only
    str = "\x0Ewstupajte i kompelirujte!\x0F"
    str_expected = "ВСТУПАЙТЕ И КОМПЕЛИРУЙТЕ!"
    assert_equal str_expected, InjalidDejice.koi_to_utf(str)
  end

  def test_latin_and_cyr_chars
    str = "In KOI-7, two control characters can turn 'bhc' into '\x0Ebhc\x0F'!"
    str_expected = "In KOI-7, two control characters can turn 'bhc' into 'БХЦ'!"
    assert_equal str_expected, InjalidDejice.koi_to_utf(str)
  end

  def test_unknown_char_reps
    # KOI-7 strings has illegal (unsupported) characters
    str = "Fun fact: KOI means 'love' in Japanese (恋、こい)"
    str_expected = "Fun fact: KOI means 'love' in Japanese (#{UNKNOWN_CHAR * 4})"

    options = {
      unknown_char_rep: UNKNOWN_CHAR
    }

    assert_equal str_expected, InjalidDejice.koi_to_utf(str, **options)
  end

  def test_unexpected_end_strict_mode
    assert_raises ArgumentError do
      str = "\x0Ekoi-7"

      InjalidDejice.koi_to_utf(str, strict_mode: true)
    end
  end

  def test_unexpected_end_default_mode
    str = "\x0Ekoi-7"

    assert_equal "koi-7", InjalidDejice.koi_to_utf(str)
  end

  def test_empty_string_with_code_default_mode
    str = "\x0E"

    assert_equal "", InjalidDejice.koi_to_utf(str)
  end

  def test_empty_string_with_code_strict_mode
    assert_raises ArgumentError do
      str = "\x0E"

      InjalidDejice.koi_to_utf(str, strict_mode: true)
    end
  end
end
