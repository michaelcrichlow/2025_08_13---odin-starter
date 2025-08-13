package python_float_functions

import "core:math"
import "core:fmt"
import "core:strconv"


/*
Return integer ratio.

Return a pair of integers, whose ratio is exactly equal to the original float
and with a positive denominator.
*/
as_integer_ratio :: proc(x: f64) -> (i64, i64) {
    if x == 0.0 {
        return 0, 1  // Edge case: 0 is represented as 0/1
    }

    numerator := x
    denominator := 1.0

    for numerator != math.floor(numerator) {  // While there's a decimal part
        numerator *= 2.0
        denominator *= 2.0
    }

    return i64(numerator), i64(denominator)
}

// Returns self, the complex conjugate of any float.
conjugate :: proc(x: f64) -> f64 {
    return x  // The conjugate of a real number is itself
}

// Creates a floating-point number from a hexadecimal string.
// @(deprecated = "Use `fromhex()`.")
// fromhex_deprecated :: proc(s: string) -> (f64, bool) {
//     assert(s[0] == '0' && s[1] == 'h')
//     hex      := s[2:]
//     assert(len(hex) == 16)
//     int, ok  := strconv.parse_u64_of_base(hex, 16)
//     assert(ok)
//     float    := transmute(f64)int
//     return float, true
// }


// Creates a floating-point number from a hexadecimal string.
fromhex :: proc(s: string) -> (value: f64, ok: bool) {
    return strconv.parse_f64(s)
}

/*
Return the hexadecimal representation of a float as a string. 

*Uses `context.temp_allocator`*
*/
hex :: proc(x: f64) -> string {
    return fmt.tprintf("%h", x)
}

// Returns `true` if the passed float has no decimal component. `false` otherwise.
is_integer :: proc(f: f64) -> bool {
	return f == math.floor(f)
}

// The real part of a floating-point number
real :: proc(n: f64) -> f64 {
    return n  // The float itself (since all floats are real numbers)
}

// The imaginary part of a floating-point number
imag :: proc(n: f64) -> f64 {
    return 0.0  // Always 0.0 (because floats have no imaginary part)
}

