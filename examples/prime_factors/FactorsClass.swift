import Cocoa;

class FactorsClass {
    func factors_of(_ remainder: Int) -> [Int] {
        var remainder = remainder;
        var factors = [Int]();

        var divisor = 2;

        while remainder > 1 {
            while remainder % divisor == 0 {
                factors.append(divisor);
                remainder /= divisor;
            }
            divisor += 1;
        }

        return factors;
    }
}
