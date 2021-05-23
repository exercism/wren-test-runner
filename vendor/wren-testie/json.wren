class JSON {
//   static parse(string) {
//     return JSONParser.new(string).parse
//   }

  static stringify(object) {
    return JSONStringifier.new(object).toString
  }

//   static tokenize(string) {
//     return JSONScanner.new(string).tokenize
//   }
}

var HEX_CHARS = [
  "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"
]

class JSONStringifier {
  construct new(object) {
    _object = object
  }

  toString { stringify(_object) }
  lpad(s, count, with) {
    while (s.count < count) {
      s = "%(with)%(s)"
    }
    return s
  }
  toHex(byte) {
    var hex = ""
    while (byte > 0) {
      var c = byte % 16
      hex = HEX_CHARS[c] + hex
      byte = byte >> 4
    }
    return hex
  }
  stringify(obj) {
    if (obj is Num || obj is Bool || obj is Null) {
      return obj.toString
    } else if (obj is String) {
      var substrings = []
      // Escape special characters
      for (char in obj) {
        if (char == "\"") {
          substrings.add("\\\"")
        } else if (char == "\\") {
          substrings.add("\\\\")
        } else if (char == "\b") {
          substrings.add("\\b")
        } else if (char == "\f") {
          substrings.add("\\f")
        } else if (char == "\n") {
          substrings.add("\\n")
        } else if (char == "\r") {
          substrings.add("\\r")
        } else if (char == "\t") {
          substrings.add("\\t")
        } else if (char.bytes[0] < 0x1f) {
          var byte = char.bytes[0]
          var hex = lpad(toHex(byte),4, "0")
          substrings.add("\\u" + hex)
        } else {
          substrings.add(char)
        }
      }
      return "\"" + substrings.join("") + "\""

    } else if (obj is List) {
      var substrings = obj.map { |o| stringify(o) }
      return "[" + substrings.join(",") + "]"

    } else if (obj is Map) {
      var substrings = obj.keys.map { |key|
        return stringify(key) + ":" + stringify(obj[key])
      }
      return "{" + substrings.join(",") + "}"
    }
  }
}
