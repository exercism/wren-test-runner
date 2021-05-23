class TwoFer {
  static twoFer() {
    return "One for you, one for me."
  }
  static twoFer(name) {
    // buggy
    return "One for [name], one for me."
  }
}
