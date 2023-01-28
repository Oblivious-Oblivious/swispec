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
