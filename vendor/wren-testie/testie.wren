import "../wren-testie-orig/testie" for Testie as TestieOrig
import "../wren-assert/Assert" for Assert
import "os" for Process
import "io" for File
import "./json" for JSON


class Testie is TestieOrig {
    construct new(name, fn) { super(name, fn) }
    static test(name, fn) {
        var tests = Testie.new(name,fn)
        tests.reporter = JSONReporter
        tests.run()
    }
}

class JSONReporter {
    construct new(name) {
        _file = Process.arguments[0]
        _results = []
        _name = name
        _tests = []
        _fail = _skip = _success = 0
        _section = ""
    }
    start() { }
    skip(name) {
        _skip = _skip + 1
        _tests.add({
            "name": "[skip] %(name)",
            "status": "pass"
        })
    }
    section(name) { _section = name }
    fail(name, error) {
        _fail = _fail + 1
        _tests.add({
            "name": "%(name)",
            "status": "fail",
            "message": "%(error)\n(stacktrace only available for first failing test due to current Wren limitations)"
        })
    }
    success(name) {
        _success = _success + 1
        _tests.add({
            "name": "%(name)",
            "status": "pass",
        })
    }
    done() {
        var out = File.create(_file)
        var status = _fail > 0 ? "fail" : "pass"
        // we can't use JSON.stringify for the whole Map because
        // ordering isn't guaranteed
        out.writeBytes("{ \"version\": 2, \"status\": \"%(status)\", ")
        out.writeBytes("\"tests\": " + JSON.stringify(_tests))
        out.writeBytes("}")
        out.close()
    }
}
