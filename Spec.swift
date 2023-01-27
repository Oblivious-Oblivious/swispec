import Cocoa

extension String {
    func red() -> String { return "\u{001B}[1;31m\(self)\u{001B}[0m"; }
    func green() -> String { return "\u{001B}[38;5;78m\(self)\u{001B}[0m"; }
    func yellow() -> String { return "\u{001B}[38;5;11m\(self)\u{001B}[0m"; }
    func gray() -> String { return "\u{001B}[38;5;244m\(self)\u{001B}[0m"; }
    func cyan() -> String { return "\u{001B}[1;36m\(self)\u{001B}[0m"; }
    func magenta() -> String { return "\u{001B}[38;5;207m\(self)\u{001B}[0m"; }
    func module_color() -> String { return "\u{001B}[48;5;89m\u{001B}[38;5;11m\(self)\u{001B}[0m"; }
}

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

class SimpleTestClass {
    var i: Int;
    var d: Double;
    var s: String;

    init() {
        self.i = -1;
        self.d = 0;
        self.s = "";
    }

    func debug_msg() {
        print("This is called before all tests");
    }

    func teardown_msg() {
        print("This is called after all tests");
    }

    func initializer() {
        self.i = 1;
        self.d = 2.0;
        self.s = "str";
    }

    func destructor() {
        self.i = -1;
        self.d = 0;
        self.s = "";
    }
}

class cDataLib: SpecModule {
    var s: SimpleTestClass = SimpleTestClass();

    override func spec_code() {
        describe("swispec functions", {
            before({
                s.debug_msg();
            });

            before_each({
                self.s.initializer();
            });

            after_each({
                self.s.destructor();
            });

            it("succeeds `assert_that`", {
                assert_that(1).is(1);
            });
            it("fails `assert_that`", {
                assert_that(1).isnot(1);
            });

            it("succeeds testing an int", {
                assert_that(1).equals_to(1);
            });
            it("fails testing an int", {
                assert_that(2).equals_to(3);
            });

            xit("skips that test", {
                assert_that(42).is("the meaning of life");
            });

            it("succeeds testing does_not_equal_to", {
                assert_that(42).does_not_equal_to(41);
            });
            it("fails testing does_not_equal_to", {
                assert_that(42).does_not_equal_to(42);
            });

            it("succeeds is_nil", {
                assert_that(nil).is_nil();
            });
            it("fails is_nil", {
                assert_that(42).is_nil();
            });

            it("succeeds isnot_nil", {
                assert_that(42).isnot_nil();
            });
            it("fails isnot_nil", {
                assert_that(nil).isnot_nil();
            });

            it("succeeds assert_true", {
                assert_that(true).is_true();
            });
            it("fails assert_true", {
                assert_that(false).is_true();
            });

            it("succeeds assert_false", {
                assert_that(false).is_false();
            });
            it("fails assert_false", {
                assert_that(true).is_false();
            });

            it("just fails", {
                fail("This is the fail message");
            });

            after({
                s.teardown_msg();
            });
        });
    }
}

class second: SpecModule {
    override func spec_code() {
        describe("DESC 1", {
            it("before on desc 1", {
                assert_that(42).isnot(69);
            });

            describe("DESC 2", {
                describe("DESC 3", {
                    it("does on 3", {
                        assert_that(3).is(3);
                    });
                });
                it("does on 2", {
                    assert_that(2).is(2);
                });
            });
            it("does on 1", {
                assert_that(1).is(1);
            });
        });

        describe("Array Assertions", {
            let a: [Int] = [1,2,3,4,5];
            let b: [Int] = [7,7,7,7,7];
            let c: [Int] = [1,2,3,4];

            let aa: [Double] = [1.1, 2.2, 3.3, 4.4, 5.5];
            let bb: [Double] = [7.7, 7.7, 7.7, 7.7, 7.7];
            let cc: [Double] = [1.1, 2.2, 3.3, 4.4];

            let aaa: [String] = ["a", "b", "c", "d", "e"];
            let bbb: [String] = ["g", "g", "g", "g", "g"];
            let ccc: [String] = ["a", "b", "c", "d"];

            it("succeeds testing an int array", {
                let my_arr = [1, 2, 3, 4, 5];
                assert_that(my_arr).equals_to(a);
            });
            it("fails testing an int array", {
                assert_that(a).equals_to(b);
                assert_that(b).equals_to(c);
            });

            it("succeeds testing a double array", {
                let my_arr2 = [1.1, 2.2, 3.3, 4.4, 5.5];
                assert_that(my_arr2).equals_to(aa);
            });
            it("fails testing a double array", {
                assert_that(aa).equals_to(bb);
                assert_that(bb).equals_to(cc);
            });

            it("succeeds testing a string array", {
                let my_arr3 = ["a", "b", "c", "d", "e"];
                assert_that(my_arr3).equals_to(aaa);
            });
            it("fails testing a string array", {
                assert_that(aaa).equals_to(bbb);
                assert_that(bbb).equals_to(ccc);
            });
        });
    }
}

var s = Spec([
    cDataLib(),
    second(),
]);
s.run_spec_suite(type: "all");
