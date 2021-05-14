import "./two-fer" for TwoFer
import "./vendor/wren-testie/testie" for Testie, Assert

Testie.test("TwoFer") { |do, skip|

  do.test("no name given") {
    Assert.equal("One for you, one for me.", TwoFer.twoFer())
  }

  skip.test("a name given") {
    Assert.equal("One for Alice, one for me.", TwoFer.twoFer("Alice"))
  }

  skip.test("another name given") {
    Assert.equal("One for Bob, one for me.", TwoFer.twoFer("Bob"))
  }
}
