import Foundation;

class Spec {
    var modules: [SpecModule];
    var data: SpecData;

    init(_ modules: [SpecModule]) {
        self.modules = modules;
        self.data = SpecData();
    }

    func run_spec_suite(type: String) {
        print("\u{001B}[38;5;95m/######### #########/");
        print("\u{001B}[38;5;95m/##### \u{001B}[38;5;89ms\u{001B}[38;5;90mw\u{001B}[38;5;91mi\u{001B}[38;5;92ms\u{001B}[38;5;93mp\u{001B}[38;5;94me\u{001B}[38;5;95mc\u{001B}[0m \u{001B}[38;5;95m#####/");
        print("/######### #########/\u{001B}[0m");
        print("");

        for m in self.modules {
            self.data.add(m.run(type));
        }
        data.display();
    }
}
