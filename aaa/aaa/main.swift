
// Make an array because we cannot simply get numeric index of characters from a `String`.
// Because it is supposed to be a UTF-8 stream... (actual encoding is effectively hidden)
let letters = Array("acdegilmnoprstuw".characters)

func hash(s: String) -> Int64 {
    return hash(Array(s.characters))
}
func hash(s: [Character]) -> Int64 {
    var h = Int64(7)
    for ch in s {
        guard let index = letters.indexOf(ch) else { fatalError() }
        h = (h * Int64(37) + Int64(index))
    }
    return h
}

print(hash("leepadg"))














////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Initial Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func reverse_hash(h: Int64) -> [Character] {
    var solution = [Character]()
    var h1 = h
    while h1 >= 37 {
        let lastDigit = h1 - (h1 / 37 * 37)
        let indexInLetters = Int(lastDigit)
        let letter = letters[indexInLetters]
        solution.insert(letter, atIndex: 0)
        h1 = h1 / 37
    }
    precondition(h1 == 7)
    return solution
}

print(reverse_hash(25377615533200))






////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Example Production Style Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

enum ReverseHashError: ErrorType {
    case BadInputData
}
/// Gets original characters from compressed number.
///
/// - Note:
///     Honestly, I am not sure safety of this algorithm for every data.
///     This program is written almost by intuition rather then proofing.
///
func reverseHash(h: Int64) throws -> [Character] {
    // Q: Why did you choose radix `37`...? Any special reason? Or just random?
    let RADIX = Int64(37)
    var stack = [Character]()
    var h1 = h
    while h1 >= RADIX {
        let digit = h1 - (h1 / RADIX * RADIX)
        let index = Int(digit) // By calculation above, `lastDigit` cannot be larger than `RADIX`. No need for boundary check.
        guard index <= letters.count else { throw ReverseHashError.BadInputData }
        let letter = letters[index]
        // First digit is packed in smallest number, and last digit is packed in largest number.
        // So we need to reverse them later to make it in proper order.
        // Anyway we use `append` for amortized O(1) performance without sacrificing readability.
        stack.append(letter)
        h1 = h1 / RADIX
    }
    // Q: For validation purpose? But why `7`..?
    guard h1 != 7 else { throw ReverseHashError.BadInputData }
    // Get ordered properly.
    return Array(stack.reverse())
}
func reportErrorToDevelopers(error: ErrorType) {
    // TODO: Implement this...
}
do {
    print(try reverseHash(25377615533200))
}
catch let error {
    reportErrorToDevelopers(error)
}









////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - A Bit More Functional Style Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func reverse_hash_recursive(h: Int64) -> [Character] {
    if h >= 37 {
        let lastDigit = h - (h / 37 * 37)
        let indexInLetters = Int(lastDigit)
        let letter = letters[indexInLetters]
        return reverse_hash_recursive(h / 37) + [letter]
    }
    else {
        precondition(h == 7)
        return []
    }
}

print(reverse_hash_recursive(25377615533200))

















