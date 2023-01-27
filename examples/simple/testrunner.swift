import Cocoa;

@main
class testrunner {
    static func main() {
        var s = Spec([
            cDataLib(),
            second(),
        ]);
        s.run_spec_suite(type: "all");
    }
}
