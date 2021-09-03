import "wren-testie/testie" for Testie, Expect
import "./nested-objects" for Lists, Maps

Testie.test("Appropriate testie version") { |do, skip|

  do.test("nested lists") {
    Expect.value(Lists.nested).toEqual( [1, [2, [3, 4]]] )
  }
  do.test("nested maps") {
    Expect.value(Maps.nested).toEqual( {"A": {"B": {"C":"D"}}} )
  }
}
