import Cocoa;

@main
class testrunner {
    static func main() {
        let s = Spec([
            cDataLib(),
            second(),
        ]);
        s.run_spec_suite(type: "all");
    }
}
