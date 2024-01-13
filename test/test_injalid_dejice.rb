# frozen_string_literal: true

require_relative "test_helper"

class TestInjalidDejice < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::InjalidDejice::VERSION
  end

  def test_encoding_decoding
    str_orig = "Кодировка КОИ-7 совместима с US-ASCII. 7 бит позволяют закодировать 128 символов."

    str_processed = InjalidDejice.koi_to_utf(InjalidDejice.utf_to_koi(str_orig))

    assert_equal str_orig, str_processed
  end

  def test_encoding_decoding_yu_at
    str_orig = "`Ю`Ю`Ю`Ю@ю@ю@ю@ю@ю@"
    str_processed = InjalidDejice.koi_to_utf(InjalidDejice.utf_to_koi(str_orig))

    assert_equal str_orig, str_processed
  end
end
