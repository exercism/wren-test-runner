import "wren-testie/testie" for Testie as TestieOrig, Expect
import "./json_reporter" for JSONReporter


class Testie is TestieOrig {
    construct new(name, fn) { super(name, fn) }
    static test(name, fn) {
        var tests = Testie.new(name,fn)
        tests.reporter = JSONReporter
        tests.run()
    }
}

