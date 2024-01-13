# frozen_string_literal: true

module InjalidDejice
  # Cyrillic char. => Latin char. KOI-7 conversion dictionary.
  CYR_TO_LAT_DICT = {
    "ю" => "@",
    "а" => "A",
    "б" => "B",
    "ц" => "C",
    "д" => "D",
    "е" => "E",
    "ф" => "F",
    "г" => "G",
    "х" => "H",
    "и" => "I",
    "й" => "J",
    "к" => "K",
    "л" => "L",
    "м" => "M",
    "н" => "N",
    "о" => "O",
    "п" => "P",
    "я" => "Q",
    "р" => "R",
    "с" => "S",
    "т" => "T",
    "у" => "U",
    "ж" => "V",
    "в" => "W",
    "ь" => "X",
    "ы" => "Y",
    "з" => "Z",
    "ш" => "[",
    "э" => "\\",
    "щ" => "]",
    "ч" => "^",
    "ъ" => "_",
    "Ю" => "`",
    "А" => "a",
    "Б" => "b",
    "Ц" => "c",
    "Д" => "d",
    "Е" => "e",
    "Ф" => "f",
    "Г" => "g",
    "Х" => "h",
    "И" => "i",
    "Й" => "j",
    "К" => "k",
    "Л" => "l",
    "М" => "m",
    "Н" => "n",
    "О" => "o",
    "П" => "p",
    "Я" => "q",
    "Р" => "r",
    "С" => "s",
    "Т" => "t",
    "У" => "u",
    "Ж" => "v",
    "В" => "w",
    "Ь" => "x",
    "Ы" => "y",
    "З" => "z",
    "Ш" => "{",
    "Э" => "|",
    "Щ" => "}",
    "Ч" => "~"
  }.freeze

  # Latin char. => Cyrillic char. KOI-7 conversion dictionary.
  LAT_TO_CYR_DICT = CYR_TO_LAT_DICT.invert.freeze

  # ASCII characters from 0 to 64 are shared by both Latin (KOI-7 N0) & Cyrillic (KOI-7 N1)
  # KOI-7 code pages.
  SHARED_CHARS_LIMIT = 64

  SHARED_CHARS = " !\"#$%&'()*+,-./0123456789:;<=>?"

  # ASCII highest possible character code.
  ASCII_CHARS_LIMIT = 127

  # Character to use if no replacement was found in the dictionary.
  DEF_UNKNOWN_CHAR_REP = "?"

  # Swithes encoding to the Cyrillic KOI-7 code page. Also known as "Shift Out" (SO) character.
  CYR_CHAR = 0x0E.chr

  # Swithes encoding to the Latin KOI-7 code page. Also known as "Shift In" (SI) character.
  LATIN_CHAR = 0x0F.chr
end
