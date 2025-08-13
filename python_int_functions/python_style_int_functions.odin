package python_int_functions

/*
Return integer ratio.

Return a pair of integers, whose ratio is exactly equal to the original int
and with a positive denominator.
*/
as_integer_ratio :: proc(n: int) -> (int, int) {
    return n, 1  // Always returns (n, 1) for integers
}


// Number of ones in the binary representation of the absolute value of an int.
bit_count :: proc(n: int) -> int {
    _n := n
    count := 0
    for _n > 0 {
        count += _n & 1  // Check if the last bit is 1
        _n >>= 1         // Shift right by 1 bit
    }
    return count
}


// Number of bits necessary to represent self in binary.
bit_length :: proc(n: int) -> int {
    if n == 0 {
        return 1  // Edge case: 0 requires 1 bit
    }

    _n := n
    length := 0
    for _n > 0 {
        length += 1
        _n >>= 1  // Shift right to process the next bit
    }
    return length
}


// Returns self, the complex conjugate of any int.
conjugate :: proc(n: int) -> int {
    return n  // The conjugate of an integer is just itself
}



// Return the integer represented by the given array of bytes.
from_bytes :: proc(bytes: []byte) -> int {
    n := 0

    for i in 0 ..< len(bytes) {
        n = (n << 8) | int(bytes[i])  // Shift left and add byte value
    }

    return n
}


/*
Return an array of bytes representing an integer in __big-endian__ order. 

*Uses `context.temp_allocator`*
*/
to_bytes :: proc(n: int, size: int) -> []byte {
    bytes := make([]byte, size, context.temp_allocator)

    _n := n
    for i in 0 ..< size {
        bytes[size - 1 - i] = byte(_n & 0xFF)  // Extract least significant byte
        _n >>= 8  // Shift right by 8 bits
    }

    return bytes
}


// The real part of a complex number
real :: proc(n: int) -> int {
    return n    // The integer itself (since all integers are real numbers)
}


// The imaginary part of a complex number
imag :: proc(n: int) -> int {
    return 0    // Always 0 (because integers have no imaginary part)
}


// The numerator of a rational number in lowest terms
numerator :: proc(n: int) -> int {
    return n    // The integer itself
}


// The denominator of a rational number in lowest terms
denominator :: proc(n: int) -> int {
    return 1    // Always 1
}

// Returns `true` if all the bits are set in an integer. `false` otherwise.
has_all_bits_set :: proc(n: int) -> bool {
    return n > 0 && (n + 1) & n == 0;
}


