import "os" for Process
import "io" for File
import "./json" for JSON
import "mirror" for Mirror

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
    fail(name, fiber) {
        var msg
        _fail = _fail + 1
        if (fiber.error is String) {
            msg = fiber.error
        } else {
            msg = fiber.error.error
        }
        var trace = SimpleStackTrace.new(fiber)
        _tests.add({
            "name": "%(name)",
            "status": "fail",
            "message": "%(msg)\n%(trace)"
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

class SimpleStackTrace {
    construct new(fiber) {
        _trace = Mirror.reflect(fiber).stackTrace
    }
    toString {
        var out = ""
        _trace.frames.each { |f|
            out = out + "at %( f.methodMirror.signature ) (%( f.methodMirror.moduleMirror.name ) line %( f.line ))\n"
        }
        return out.trim()
    }
}