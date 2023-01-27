import Cocoa;

extension String {
    func red() -> String { return "\u{001B}[1;31m\(self)\u{001B}[0m"; }
    func green() -> String { return "\u{001B}[38;5;78m\(self)\u{001B}[0m"; }
    func yellow() -> String { return "\u{001B}[38;5;11m\(self)\u{001B}[0m"; }
    func gray() -> String { return "\u{001B}[38;5;244m\(self)\u{001B}[0m"; }
    func cyan() -> String { return "\u{001B}[1;36m\(self)\u{001B}[0m"; }
    func magenta() -> String { return "\u{001B}[38;5;207m\(self)\u{001B}[0m"; }
    func module_color() -> String { return "\u{001B}[48;5;89m\u{001B}[38;5;11m\(self)\u{001B}[0m"; }
}
