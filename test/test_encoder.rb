# frozen_string_literal: true

require_relative "test_helper"

class TestEncoder < Minitest::Test
  UNKNOWN_CHAR = "*"

  def test_empty_string
    assert_equal "", InjalidDejice.utf_to_koi("")
  end

  def test_latin_chars_only
    str = "FooBar"
    assert_equal str, InjalidDejice.utf_to_koi(str)
  end

  def test_latin_chars_and_shared
    str = "FOO, bar, 5 * 10 = 50"
    assert_equal str, InjalidDejice.utf_to_koi(str)
  end

  def test_cyr_chars_only
    str_to_encode = "иНЖАЛИДдЕЖИЦЕ"
    str_expected = "\x0EInvalidDevice\x0F"
    assert_equal str_expected, InjalidDejice.utf_to_koi(str_to_encode)
  end

  def test_cyr_chars_and_shared
    str_to_encode = "иНЖАЛИД дЕЖИЦЕ 123"
    str_expected = "\x0EInvalid Device 123\x0F"
    assert_equal str_expected, InjalidDejice.utf_to_koi(str_to_encode)
  end

  def test_cyr_chars_and_forced_latin
    str_to_encode = "10 PRINT \"Привет, мир!\""
    result_str = InjalidDejice.utf_to_koi(str_to_encode, forced_latin: ["\""])
    str_expected = "10 PRINT \"\x0EpRIWET, MIR!\x0F\""

    assert_equal str_expected, result_str
  end

  def test_unsupported_chars
    str_to_encode = "日本語"
    str_expected = "\x0E#{UNKNOWN_CHAR * 3}\x0F"
    assert_equal str_expected, InjalidDejice.utf_to_koi(str_to_encode, unknown_char_rep: UNKNOWN_CHAR)
  end

  def test_cyr_and_latin_chars_mixed
    str_to_encode = "You say 'иНЖАЛИД дЕЖИЦЕ'!? Yeah, I know about that stuff!"
    str_expected = "You say '\x0EInvalid Device'!? \x0FYeah, I know about that stuff!"
    assert_equal str_expected, InjalidDejice.utf_to_koi(str_to_encode)
  end

  def test_cyr_and_latin_chars_with_unsupported_mixed
    str_to_encode = "Буква 'ё' не поддерживается в КОИ-7! That's sad..."
    str_expected = "\x0EbUKWA '#{UNKNOWN_CHAR}' NE PODDERVIWAETSQ W koi-7! \x0FThat's sad..."
    assert_equal str_expected, InjalidDejice.utf_to_koi(str_to_encode, unknown_char_rep: UNKNOWN_CHAR)
  end
end
