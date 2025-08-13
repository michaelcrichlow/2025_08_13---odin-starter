package test

import "core:c"
import "core:c/libc"
import "core:math"

I64_MAX :: 9_223_372_036_854_775_807
I64_MIN :: -9_223_372_036_854_775_808

INT_MAX :: I64_MAX
INT_MIN :: I64_MIN

U64_MAX :: 18_446_744_073_709_551_615

// Returns the cube root of f
cbrt :: proc(f: f64) -> f64 {
	return libc.cbrt(c.double(f))
}


sqrt :: proc {
    sqrt_f64,
    sqrt_int,
}

// Returns the square root of f
sqrt_f64 :: proc(f: f64) -> f64 {
	return libc.sqrt(c.double(f))
}

sqrt_int :: proc(n: int) -> f64 {
    return sqrt_f64(f64(n))
}

// rounds to value of f
round :: proc(f: f64) -> f64 {
	return libc.round(c.double(f))
}

divmod :: math.divmod


successive_differences :: proc {
    successive_differences_int,
    successive_differences_string,
}
/*
Computes the successive differences of a list of integers.

Each element in the returned list represents the difference between 
two consecutive elements in the input list.

*Allocates using `context.temp_allocator`*

*Use `free_all(context.temp_allocator)` when convenient to free memory.*

Inputs:
- nums: []int (A list of integers)

Returns:
- result: []int (List containing the differences between consecutive elements)

Example:

    nums := []int{1, 3, 6, 10}
    diffs := successive_differences(nums)

    fmt.println(diffs)

    free_all(context.temp_allocator)    <-- don't forget to do this after use!

Returns:

 - {2, 3, 4}
*/
successive_differences_int :: proc(nums: []int) -> []int {
    // guard clause
    if len(nums) < 2 {
        return []int{} // Return an empty array if there's not enough data
    }
    
    res := make([dynamic]int, context.temp_allocator)
    for i in 0 ..< len(nums) - 1 {
        append(&res, nums[i + 1] - nums[i])
    }
    return res[:]
}


successive_differences_string :: proc(s: string) -> []int {
    // guard clause
    if len(s) < 2 {
        return []int{} // Return an empty array if there's not enough data
    }
    
    local_dict := make(map[rune]int, context.temp_allocator)
    local_dict['a'] = 0;  local_dict['b'] = 1;  local_dict['c'] = 2;  local_dict['d'] = 3;  local_dict['e'] = 4;
    local_dict['f'] = 5;  local_dict['g'] = 6;  local_dict['h'] = 7;  local_dict['i'] = 8;  local_dict['j'] = 9;
    local_dict['k'] = 10; local_dict['l'] = 11; local_dict['m'] = 12; local_dict['n'] = 13; local_dict['o'] = 14;
    local_dict['p'] = 15; local_dict['q'] = 16; local_dict['r'] = 17; local_dict['s'] = 18; local_dict['t'] = 19;
    local_dict['u'] = 20; local_dict['v'] = 21; local_dict['w'] = 22; local_dict['x'] = 23; local_dict['y'] = 24;
    local_dict['z'] = 25;

    res := make([dynamic]int, context.temp_allocator)
    for i in 0 ..< len(s) - 1 {
        append(&res, local_dict[rune(s[i + 1])] - local_dict[rune(s[i])])
    }
    return res[:]
}


// Adds a variaus number of u8s together. It will either:
// - Succeed -  The sum is returned
// - Fail - The proc will panic if the sum is over 255
add_u8_overflow_checked :: proc(l: ..u8) -> u8 {
    total := 0
    for i in 0 ..< len(l) {
        total += int(l[i])
    }

    if total > 255 {
        print("\n>>>>")
        print("ERROR from `add_u8_checked`: Overflow detected.", total, "cannot fit in a u8 (range 0 to 255)")
        print(">>>>\n")
        panic("Overflow detected")
    }

    return u8(total)
}

/*
Removes duplicate elements from a sorted list of integers, in-place.

This function assumes that the input list is already sorted in ascending order.
It overwrites duplicate elements within the original array and returns a slice
of that same array containing only the unique values at the beginning.

Inputs:
- l: []int (A sorted list of integers)

Returns:
- result: []int (A slice of the input containing only unique values)

Example:

    l := []int{1, 1, 2, 2, 3, 4, 4}
    deduped := remove_duplicates_from_sorted_list(l)

    fmt.println(deduped)

Returns:

 - [1, 2, 3, 4]
*/
remove_duplicates_from_sorted_list :: proc(l: []int) -> []int {
    if len(l) <= 1 {
        return l
    }

    write := 1
    for read in 1 ..< len(l) {
        if l[read] != l[write - 1] {
            l[write] = l[read]
            write += 1
        }
        print("l:", l)
    }

    return l[:write]
}