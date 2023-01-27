import Cocoa;

@main
class testrunner {
    static func main() {
        let s = Spec([
            PrimeFactorsSpec(),
        ]);
        s.run_spec_suite(type: "all");
    }
}
