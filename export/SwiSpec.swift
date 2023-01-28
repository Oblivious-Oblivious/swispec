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
import Foundation;

class SpecData {
    var it_counter: Int;
    var xit_counter: Int;
    var positive_it_counter: Int;
    var time_taken: [Double];

    init() {
        self.it_counter = 0;
        self.xit_counter = 0;
        self.positive_it_counter = 0;
        self.time_taken = [Double]();
    }

    func display() {
        print("● \(it_counter + xit_counter) tests".yellow());
        print("✓ \(positive_it_counter) passing".green());
        print("✗ \(it_counter - positive_it_counter) failing".red());
        print("- \(xit_counter) skipped".gray());

        let formatted_time = self.time_taken.reduce(0, +);
        if formatted_time > 1000 {
            print("★ Finished in \(String(format: "%.5f", formatted_time/1000.0)) seconds".cyan());
        }
        else if formatted_time > 60000 {
            print("★ Finished in \(String(format: "%.5f", formatted_time/60000.0)) minutes".cyan());
        }
        else {
            print("★ Finished in \(String(format: "%.5f", formatted_time)) ms".cyan());
        }
    }

    func add(_ data: SpecData) {
        self.it_counter += data.it_counter;
        self.xit_counter += data.xit_counter;
        self.positive_it_counter += data.positive_it_counter;
        self.time_taken += data.time_taken;
    }
}
import Foundation;

class SpecModule {
    var spacing = "";
    var type = "all";

    var it_state = true;
    var failed_it_result = "";

    var current_file = "";
    var current_line = -1;

    var module_data = SpecData();
    var before_each_block: () -> Void = {};
    var after_each_block: () -> Void = {};
    var actual: Any? = nil;

    func spec_code() {}

    func equals(_ actual : Any?, _ expected : Any?) -> Bool {
        guard actual is AnyHashable else { return false };
        guard expected is AnyHashable else { return false };
        return (actual as! AnyHashable) == (expected as! AnyHashable);
    }
    func not_equals(_ actual : Any?, _ expected : Any?) -> Bool {
        return !equals(actual, expected);
    }

    // MARK: - swispec API
    func before(_ block: () -> Void) {
        block();
    }

    func before_each(_ block: @escaping () -> Void) {
        self.before_each_block = block;
    }

    func after(_ block: () -> Void) {
        block();
    }

    func after_each(_ block: @escaping () -> Void) {
        self.after_each_block = block;
    }

    func describe(_ name: String, _ desc: () -> Void) {
        self.spacing += "    ";
        
        print(self.spacing + "`\(name)`".magenta());
        desc();

        self.spacing.removeLast(4);
    }

    func it(_ name: String, _ it: () -> Void) {
        self.spacing += "    ";
        self.before_each_block();

        self.it_state = true;
        self.failed_it_result = "";

        let start_time = Date();
        it();
        let total_time = DateInterval(start: start_time, end: Date());

        self.module_data.time_taken.append(total_time.duration * 1000.0);
        self.module_data.it_counter += 1;

        if self.it_state {
            self.module_data.positive_it_counter += 1;

            if self.type == "all" || self.type == "passing" {
                print(self.spacing + "✓".green() + " it " + name);
            }
        }
        else if self.type == "all" || self.type == "failing" {
            print(self.spacing + "✗".red() + " it " + name);
            print(self.failed_it_result);
        }

        self.after_each_block();
        self.spacing.removeLast(4);
    }

    func xit(_ name: String, _ : () -> Void) {
        self.spacing += "    ";
        self.before_each_block();

        self.module_data.xit_counter += 1;

        if self.type == "all" || self.type == "skipped" {
            print(self.spacing + "- xit \(name) (skipped)".gray());
        }

        self.after_each_block();
        self.spacing.removeLast(4);
    }

    func generic_match(_ matched: Bool, _ error_message: () -> String) {
        if !matched {
            self.it_state = false;
            self.spacing += "    ";
            self.failed_it_result += "\(self.spacing)\(self.current_file):\(self.current_line):\n";
            self.spacing += "    ";
            self.failed_it_result += self.spacing + "|> " + error_message() + "\n";
            self.spacing.removeLast(8);
        }
    }

    func `is`(_ expected: Any?) {
        generic_match(equals(self.actual, expected), { "`\(self.actual!)`".red() + " should be `\(expected!)`" });
    }

    func isnot(_ expected: Any?) {
        generic_match(not_equals(self.actual, expected), { "`\(self.actual!)`".red() + " should not be `\(expected!)`" });
    }

    func equals_to(_ expected: Any?) {
        generic_match(equals(self.actual, expected), { "`\(expected!)` expected but got " + "`\(self.actual!)`".red() });
    }

    func does_not_equal_to(_ expected: Any?) {
        generic_match(not_equals(self.actual, expected), { "`\(expected!)` must be different from " + "`\(self.actual!)`".red() });
    }

    func is_true() {
        let actual_to_bool = "\(self.actual!)";
        generic_match(actual_to_bool == "true", { "`\(actual_to_bool)`".red() + " should be true" });
    }

    func is_false() {
        let actual_to_bool = "\(self.actual!)";
        generic_match(actual_to_bool == "false", { "`\(actual_to_bool)`".red() + " should be false" });
    }

    func is_nil() {
        let actual_to_nil = String(describing: self.actual);
        generic_match(actual_to_nil == "nil", { "`\(self.actual!)`".red() + " should be nil" });
    }

    func isnot_nil() {
        let actual_to_nil = String(describing: self.actual);
        generic_match(actual_to_nil != "nil", { ("`\(actual_to_nil)`".red() + " should not be nil") });
    }

    func assert_that(_ actual: Any?, file: String = #file, line: Int = #line) -> SpecModule {
        self.actual = actual;
        self.current_file = file;
        self.current_line = line;

        return self;
    }

    func fail(_ message: String, file: String = #file, line: Int = #line) {
        self.it_state = false;
        self.spacing += "    ";
        self.failed_it_result += "\(self.spacing)\(file):\(line):\n";
        self.spacing += "    ";
        self.failed_it_result += (self.spacing + "|> " + message.red() + "\n");
        self.spacing.removeLast(8);
    }

    func run(_ type: String) -> SpecData {
        self.module_data = SpecData();
        self.type = type;

        let classname_array = String(describing: self).components(separatedBy: ".");
        print("Module `\(classname_array[classname_array.count - 1])`".module_color());
        spec_code();
        print("");

        return self.module_data;
    }
}
import Foundation;

extension String {
    func red() -> String { return "\u{001B}[1;31m\(self)\u{001B}[0m"; }
    func green() -> String { return "\u{001B}[38;5;78m\(self)\u{001B}[0m"; }
    func yellow() -> String { return "\u{001B}[38;5;11m\(self)\u{001B}[0m"; }
    func gray() -> String { return "\u{001B}[38;5;244m\(self)\u{001B}[0m"; }
    func cyan() -> String { return "\u{001B}[1;36m\(self)\u{001B}[0m"; }
    func magenta() -> String { return "\u{001B}[38;5;207m\(self)\u{001B}[0m"; }
    func module_color() -> String { return "\u{001B}[48;5;89m\u{001B}[38;5;11m\(self)\u{001B}[0m"; }
}
