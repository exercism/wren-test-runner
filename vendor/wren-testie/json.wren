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

class JSONStringifier {
  construct new(object) {
    _object = object
  }

  toString { stringify(_object) }

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
