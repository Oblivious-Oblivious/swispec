import Cocoa;

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
