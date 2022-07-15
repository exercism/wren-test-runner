import "wren-testie/testie" for Testie as TestieOrig, Expect
import "./json_reporter" for JSONReporter


class Testie is TestieOrig {
    construct new(name, fn) {
        self = super(name, fn)
        self.reporter = JSONReporter
        return self
    }
    static test(name, fn) {
        var tests = Testie.new(name, fn)
        tests.run()
    }
}

