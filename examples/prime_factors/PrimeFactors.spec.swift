import Cocoa;

class PrimeFactorsSpec: SpecModule {
    var o: FactorsClass = FactorsClass();

    override func spec_code() {
        describe("Find prime factors of integer", {
            before_each({
                self.o = FactorsClass();
            });

            it("finds the factors of 1", {
                let f1 = self.o.factors_of(1);
                assert_that(f1.count).equals_to(0);
            });

            it("finds the factors of 2", {
                let f2 = self.o.factors_of(2);
                assert_that(f2[0]).equals_to(2);
            });

            it("finds the factors of 3", {
                let f3 = self.o.factors_of(3);
                assert_that(f3[0]).equals_to(3);
            });

            it("finds the factors of 4", {
                let f4 = self.o.factors_of(4);

                assert_that(f4[0]).is(2);
                assert_that(f4[1]).is(2);
            });

            it("find test factor of 2*2*3*3*5*7*11*11*13", {
                let f = self.o.factors_of(2*2*3*3*5*7*11*11*13);
                let expected = [2,2,3,3,5,7,11,11,13];
                assert_that(f).equals_to(expected);
            });
        });
    }
}
