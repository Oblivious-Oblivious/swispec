class Stack {
    var S: [Int?];
    var N: Int;

    init(_ max_n: Int) {
        self.S = Array(repeating: nil, count: max_n);
        self.N = 0;
    }

    func is_empty() -> Bool {
        return N == 0;
    }

    func push(_ item: Int?) {
        S[N] = item;
        N += 1;
    }

    func pop() -> Int? {
        if N > 0 {
            N -= 1;
            let item = self.S[N];
            S[N] = nil;
            return item;
        }
        else {
            return nil;
        }
    }
}
