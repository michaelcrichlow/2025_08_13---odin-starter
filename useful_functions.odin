package test

import "core:fmt"
import "core:mem"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:math"
import p_list "python_list_functions"
import p_str "python_string_functions"

len_runes  :: strings.rune_count
clear_slice :: slice.zero
// rune_slice :: strings.substring


// copy_dynamic_array :: slice.clone_to_dynamic


set :: proc {
    set_slice,
    set_string,
}

// Creates a hashset from the slice passed to it 
set_slice :: proc(array: []$T, allocator := context.allocator) -> map[T]struct {} {
	my_map := make(map[T]struct {}, allocator = allocator)
	for val in array {
		my_map[val] = {}
	}
	return my_map
}

// uses `context.temp_allocator`
set_string :: proc(s: string) -> map[rune]struct {} {
    my_map := make(map[rune]struct{}, context.temp_allocator)
    for val in s {
        my_map[val] = {}
    }
    return my_map
}





//                    o8o                           o8o      .                                 .o8       oooo              .o o.   
//                    `"'                           `"'    .o8                                "888       `888             .8' `8.  
// ooo. .oo.  .oo.   oooo  ooo. .oo.               oooo  .o888oo  .ooooo.  oooo d8b  .oooo.    888oooo.   888   .ooooo.  .8'   `8. 
// `888P"Y88bP"Y88b  `888  `888P"Y88b              `888    888   d88' `88b `888""8P `P  )88b   d88' `88b  888  d88' `88b 88     88 
//  888   888   888   888   888   888               888    888   888ooo888  888      .oP"888   888   888  888  888ooo888 88     88 
//  888   888   888   888   888   888               888    888 . 888    .o  888     d8(  888   888   888  888  888    .o `8.   .8' 
// o888o o888o o888o o888o o888o o888o ooooooooooo o888o   "888" `Y8bod8P' d888b    `Y888""8o  `Y8bod8P' o888o `Y8bod8P'  `8. .8'  
//                                                                                                                         `" "'  

min_iterable :: proc {
	min_iterable_generic,
	min_iterable_string_ascii,
}

// Given an iterable, it return the minimum value in it
min_iterable_generic :: proc(array: []$T) -> T {
	min := array[0]
	for val in array {
		if val < min {
			min = val
		}
	}
	return min
}

/*
 * Finds the minimum ASCII character (rune) in a given string.
 * Each character in the string is compared by its Unicode code point value,
 * and the character with the lowest value is returned.
 * If the string is empty, the function will return rune(255).
 *
 * @param s: The input string consisting of ASCII characters.
 * @return: The rune corresponding to the minimum character in the string.
 *
 * Note: Prefer the procedure group `min_iterable`.
 *
 * Example usage:
 *
 * min_iterable_string_ascii("apple") // returns 'a'
 * Explanation: Among 'a', 'p', 'p', 'l', 'e', the lowest ASCII value is 'a' (97).
 *
 * min_iterable_string_ascii("!@987") // returns '!'
 * Explanation: '!' = 33, '@' = 64, '9' = 57, '8' = 56, '7' = 55.
 * The minimum code point is '!' (33).
 *
 * min_iterable_string_ascii("ABCxyz") // returns 'A'
 * Explanation: 'A' = 65, 'B' = 66, 'C' = 67, 'x' = 120, 'y' = 121, 'z' = 122.
 * The minimum code point is 'A' (65).
 */
min_iterable_string_ascii :: proc(s: string) -> rune {
	_min := rune(255)
	for val in s {
		if val < _min {
			_min = val
		}
	}
	return _min
}	

max_iterable :: proc {
	max_iterable_generic,
	max_iterable_string_ascii,
}

// Given an iterable, it return the maximum value in it
max_iterable_generic :: proc(array: []$T) -> T {
	max := array[0]
	for val in array {
		if val > max {
			max = val
		}
	}
	return max
}

/*
 * Finds the maximum ASCII character (rune) in a given string.
 * Each character in the string is compared by its Unicode code point value,
 * and the character with the highest value is returned.
 * If the string is empty, the function returns rune(0).
 *
 * @param s: The input string consisting of ASCII characters.
 * @return: The rune corresponding to the maximum character in the string.
 *
 * Note: Prefer the procedure group `max_iterable`.
 *
 * Example usage:
 *
 * max_iterable_string_ascii("apple") // returns 'p'
 * Explanation: Among 'a', 'p', 'p', 'l', 'e', the highest ASCII value is 'p'.
 *
 * max_iterable_string_ascii("!@987") // returns '@'
 * Explanation: '!' = 33, '@' = 64, '9' = 57, '8' = 56, '7' = 55.
 * The maximum code point is '@' (64).
 *
 * max_iterable_string_ascii("ABCxyz") // returns 'z'
 * Explanation: 'A' = 65, 'B' = 66, 'C' = 67, 'x' = 120, 'y' = 121, 'z' = 122.
 * The maximum code point is 'z' (122).
 */
max_iterable_string_ascii :: proc(s: string) -> rune {
	_max := rune(0)
	for val in s {
		if val > _max {
			_max = val
		}
	}
	return _max
}


average_iterable :: proc{
    average_iterable_int,
	average_iterable_f64,
}


/*
 * Computes the arithmetic mean of a slice of integers.
 * Converts the total sum and length to f64 to ensure floating-point division.
 * Returns 0.0 if the slice is empty to avoid division by zero.
 *
 * @param l: The slice of integers to average.
 *
 * @return: The average value as an f64. If the slice is empty, returns 0.0.
 */
average_iterable_int :: proc(l: []int) -> f64 {
    if len(l) == 0 { return 0 }
    
    _total := f64(sum_iterable(l))

    return _total / f64(len(l))
}


average_iterable_f64 :: proc(l: []f64) -> f64 {
    if len(l) == 0 { return 0 }
    
    _total := sum_iterable(l)

    return _total / f64(len(l))
}


map_min_value :: proc{
    map_min_value_int,
    map_min_value_f64,
}

map_max_value :: proc{
    map_max_value_int,
    map_max_value_f64,
}

map_min_and_max_values :: proc{
    map_min_and_max_values_int,
    map_min_and_max_values_f64,
}

map_min_value_int :: proc(m: map[$K]int) -> int {
    if len(m) == 0 { return 0 }
    
	min := INT_MAX
	for key, val in m {
		if val < min {
			min = val
		}
	}
	return min
}

map_min_value_f64 :: proc(m: map[$K]f64) -> f64 {
    if len(m) == 0 { return 0.0 }
    
	min := math.F64_MAX
	for key, val in m {
		if val < min {
			min = val
		}
	}
	return min
}

map_max_value_int :: proc(m: map[$K]int) -> int {
    if len(m) == 0 { return 0 }
    
	max := INT_MIN
	for key, val in m {
		if val > max {
			max = val
		}
	}
	return max
}

map_max_value_f64 :: proc(m: map[$K]f64) -> f64 {
    if len(m) == 0 { return 0.0 }
    
	max := math.F64_MIN
	for key, val in m {
		if val > max {
			max = val
		}
	}
	return max
}

map_min_and_max_values_int :: proc(m: map[$K]int) -> (int, int) {
    if len(m) == 0 {
        return 0, 0
    }

    min := INT_MAX
    max := INT_MIN

    for key, val in m {
        if val < min {
            min = val
        }
        if val > max {
            max = val
        }
    }

    return min, max
}

map_min_and_max_values_f64 :: proc(m: map[$K]f64) -> (f64, f64) {
    if len(m) == 0 {
        return 0.0, 0.0
    }

    min := math.F64_MAX
    max := math.F64_MIN

    for key, val in m {
        if val < min {
            min = val
        }
        if val > max {
            max = val
        }
    }

    return min, max
}


/*
 * Counts how many times a specific value appears in a map.
 *
 * @param m: A map with arbitrary key type `$K` and value type `$V`.
 * @param test_value: The value to compare against each entry in the map.
 * @return: An integer representing how many times `test_value` appears in the map.
 *
 * Example usage:
 *
 * map_count(map[string]int{"a": 1, "b": 2, "c": 1}, 1) // returns 2
 * Explanation: The value `1` appears for keys "a" and "c"
 *
 * map_count(map[string]int{"x": 5, "y": 6}, 3) // returns 0
 * Explanation: The value `3` does not appear in the map
 */
map_count_value :: proc(m: map[$K]$V, test_value: V) -> int {
    count := 0
    for key, val in m {
        if val == test_value {
            count += 1
        }
    }
    return count
}

//                                 .                   .o8    .o o.   
//                               .o8                  "888   .8' `8.  
//  .oooo.o  .ooooo.  oooo d8b .o888oo  .ooooo.   .oooo888  .8'   `8. 
// d88(  "8 d88' `88b `888""8P   888   d88' `88b d88' `888  88     88 
// `"Y88b.  888   888  888       888   888ooo888 888   888  88     88 
// o.  )88b 888   888  888       888 . 888    .o 888   888  `8.   .8' 
// 8""888P' `Y8bod8P' d888b      "888" `Y8bod8P' `Y8bod88P"  `8. .8'  
//                                                            `" "'   


// overloaded function sorted()
sorted :: proc {
	sorted_string_to_dynamic_array,
	sorted_slice_to_dynamic_array,
	sorted_slice_of_slice_of_ints,
}

/*
Returns the runes of a string in a dynamic array, sorted

*Allocates Using Provided Allocator*

Inputs:
- s: The input string
- reverse: bool dictating ascending or descending order
- allocator: (default: context.allocator)


Returns:
- an array (the runes of the string) in ascending or descending order

Example:

	import "core:fmt"
	import "core:slice"
	print :: fmt.println


	val := sorted("alopscentedrt")
	val_2 := sorted("alopscentedrt", reverse = true)
	defer delete(val) (or free_all(centext.temp_allocator) when no longer needed)
	defer delete(val_2)
	
	print(val)
	print(val_2)

Output:

	[a, c, d, e, e, l, n, o, p, r, s, t, t]
	[t, t, s, r, p, o, n, l, e, e, d, c, a]

*/
sorted_string_to_dynamic_array :: proc(s: string, reverse := false, allocator := context.allocator) -> [dynamic]rune {
	local_array := make([dynamic]rune, allocator)
	
	for val in s {
		append(&local_array, val)
	}

	if reverse == false {
		slice.sort(local_array[:])
	} else if reverse == true {
		slice.reverse_sort(local_array[:])
	}

	return local_array
}


/*
Returns the slice in an array, sorted

*Allocates Using Provided Allocator*

Inputs:
- l: The input slice
- reverse: bool dictating ascending or descending order
- allocator: (default: context.allocator)


Returns:
- an array (containing the values of the slice) in ascending or descending order

Example:

	import "core:fmt"
	import "core:slice"
	print :: fmt.println


	a := [dynamic]int{1, 11, 2}
	defer delete(a)

	val := sorted(a[:], reverse = true, allocator = context.temp_allocator)
	print(val)

	b := [?]f32{1, 60, 23, 4, 18}
	val_2 := sorted(b[:], allocator = context.temp_allocator)
	print(val_2)

	free_all(context.temp_allocator)

Output:

	[11, 2, 1]
	[1, 4, 18, 23, 60]

*/
sorted_slice_to_dynamic_array :: proc(l: []$T, reverse := false, allocator := context.allocator) -> [dynamic]T {
	local_array := slice.clone_to_dynamic(l[:], allocator)
	
	if reverse == false {
		slice.sort(local_array[:])
	} else if reverse == true {
		slice.reverse_sort(local_array[:])
	}

	return local_array
}


/*
sorted_slice_of_slice_of_ints creates a new, sorted slice from an existing
slice of slices. It does not modify the original.

Parameters:
- l: The input slice of slices of integers.
- index_used_to_sort: The index within each inner slice to use for comparison.
- reverse: If true, sorts in descending order; otherwise, sorts in ascending order.
- allocator: The memory allocator to use for creating the new slice. Defaults to
  the temporary allocator, which is useful for short-lived results.
*/
sorted_slice_of_slice_of_ints :: proc(l: [][]int, reverse := false, allocator := context.temp_allocator) -> [][]int {
	// 1. Create a copy of the original slice so we don't modify it.
	// The new slice is created using the provided allocator.
	result := slice.clone(l, allocator)

	// 2. Sort the new slice using `slice.sort_by()` and `reverse`
	// The [1] means it uses the second element to sort.
    if reverse {
        slice.sort_by(result[:], proc(a, b: []int) -> bool {return a[1] > b[1]})
    }   else {
        slice.sort_by(result[:], proc(a, b: []int) -> bool {return a[1] < b[1]})
    }
    
	// 3. Return the newly allocated and sorted slice.
	return result
}


//              .              .o o.   
//            .o8             .8' `8.  
//  .oooo.o .o888oo oooo d8b .8'   `8. 
// d88(  "8   888   `888""8P 88     88 
// `"Y88b.    888    888     88     88 
// o.  )88b   888 .  888     `8.   .8' 
// 8""888P'   "888" d888b     `8. .8'  
//                             `" "'   


// overloaded function
str :: proc {
	str_int_to_string,
	str_float_to_string,
	str_string_to_string,
	str_u8_to_string,
	str_rune_to_string,
    str_slice_of_runes_to_string,
}


/*
Converets the passed integer to a string

- Allocates Using `context.temp_allocator`
*/
str_int_to_string :: proc(n: int, allocator := context.temp_allocator) -> string {
	b := strings.builder_make(allocator)
	strings.write_int(&b, n)
	final_string := strings.to_string(b)

	return final_string
}

/*
Converets the passed f64 to a string

- Allocates Using `context.temp_allocator`
*/
str_float_to_string :: proc(n: f64, allocator := context.temp_allocator) -> string {
	b := strings.builder_make(allocator)
	strings.write_f64(&b, n, 'g')
	final_string := strings.to_string(b)

	return final_string
}

/*
Converets the passed string to a string (on the heap)

- Allocates Using `context.temp_allocator`
*/
str_string_to_string :: proc(s: string, allocator := context.temp_allocator) -> string {
	b := strings.builder_make(allocator)
	strings.write_string(&b, s)
	final_string := strings.to_string(b)

	return final_string
}

/*
Converets the passed u8 to a string

- Allocates Using `context.temp_allocator`
*/
str_u8_to_string :: proc(num: u8, allocator := context.temp_allocator) -> string {
	num_as_rune := rune(num)
	
	b := strings.builder_make(allocator)
	strings.write_rune(&b, num_as_rune)
	final_string := strings.to_string(b)

	return final_string
}


/*
Converets the passed u8 to a string

- Allocates Using `context.temp_allocator`
*/
str_rune_to_string :: proc(r: rune, allocator := context.temp_allocator) -> string {
	b := strings.builder_make(allocator)
	strings.write_rune(&b, r)
	final_string := strings.to_string(b)

	return final_string
}


/*
Converets the passed slice of runes to a string

- Allocates Using `context.temp_allocator`
*/
str_slice_of_runes_to_string :: proc(l: []rune, allocator := context.temp_allocator) -> string {
    b: strings.Builder
    strings.builder_init(&b, 0, len(l), allocator)
    // code goes here -------------------------------------
    for val in l {
        strings.write_rune(&b, val)
    }
    // ----------------------------------------------------
    final_string := strings.to_string(b)
    
    return final_string
}


/*
Concatenates two strings and returns the result

Odin version of: `string1 + string2`

*Allocates Using Provided Allocator*

Inputs:
- s1: string
- s2: string
- allocator: (default: context.allocator)


Returns:
- final_string -> The result of concatenating s1 and s2

Example:

	import "core:fmt"
	import "core:strings"
	print :: fmt.println


	string_01 := "Hello "
	string_02 := "World!"
	final_string := concatenate_two_strings(string_01, string_02, context.temp_allocator)
	print(final_string)

	free_all(context.temp_allocator)

Output:
	
Hello World!
*/
concatenate_two_strings :: proc(s1, s2: string, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {

	b: strings.Builder
	strings.builder_init(&b, 0, len(s1) + len(s2), allocator) or_return // err is of type mem.Allocator_Error
	// code goes here
	strings.write_string(&b, s1)
	strings.write_string(&b, s2)
	final_string = strings.to_string(b)
	
	return final_string, nil
}


/*
Removes the specified rune from the given string

*Allocates Using Provided Allocator*

Inputs:
- s: string
- rune_to_remove: rune
- allocator: (default: context.allocator)


Returns:
- final_string -> The result of removing the rune

Example:

	import "core:fmt"
	import "core:strings"
	print :: fmt.println

    test_string := "I love cheese"
    test_string = remove_rune(test_string, 'e', context.temp_allocator)
    print(test_string)

	free_all(context.temp_allocator)

Output:
	
I lov chs
*/
remove_rune :: proc(s: string, rune_to_remove: rune, allocator := context.allocator) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	
	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return // err is of type mem.Allocator_Error
	// code goes here
	for val in s {
		if val != rune_to_remove {
			strings.write_rune(&b, val)
		}
	}
	final_string = strings.to_string(b)
	
	return final_string, nil
}

/*
Replaces all occurances of `rune_to_replace` from the given string with `new_rune`
-- OR --
Replaces `rune_to_replace` `count` times with `new_rune`.
If `count` = -1 (default), all occurances will be replaced with `new_rune`.

*Allocates Using Provided Allocator*

Inputs:
- s: string
- rune_to_replace: rune
- new_rune : rune
- count : int
- allocator: (default: context.allocator)


Returns:
- final_string -> The result of replacing the rune

Example:

	import "core:fmt"
	import "core:strings"
	print :: fmt.println

	test_string := "I love cheese"
	test_string_00 := replace_rune(test_string, 'e', 'a', allocator = context.temp_allocator)
	test_string_01 := replace_rune(test_string, 'e', 'a', 2, allocator = context.temp_allocator)
	test_string_02 := replace_rune(test_string, 'e', 'a', -1, allocator = context.temp_allocator)
	print(test_string_00)
	print(test_string_01)
	print(test_string_02)

	free_all(context.temp_allocator)

Output:
	
	I lova chaasa
	I lova chaese
	I lova chaasa
*/
replace_rune :: proc(s: string, rune_to_replace: rune, new_rune: rune, count := -1, allocator := context.allocator) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	local_count := 0
	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return // err is of type mem.Allocator_Error
	
	for val in s {
		if val != rune_to_replace {
			strings.write_rune(&b, val)
		} else if val == rune_to_replace && count == -1 {
			strings.write_rune(&b, new_rune)
		} else if val == rune_to_replace && count != -1 {
			if local_count < count {
				strings.write_rune(&b, new_rune)
				local_count += 1
			} else {
				strings.write_rune(&b, val)
			}
		}
	}
	final_string = strings.to_string(b)

	return final_string, nil
}


//  o8o                  .                                                .     .o o.   
//  `"'                .o8                                              .o8    .8' `8.  
// oooo  ooo. .oo.   .o888oo              .ooooo.   .oooo.    .oooo.o .o888oo .8'   `8. 
// `888  `888P"Y88b    888               d88' `"Y8 `P  )88b  d88(  "8   888   88     88 
//  888   888   888    888               888        .oP"888  `"Y88b.    888   88     88 
//  888   888   888    888 .             888   .o8 d8(  888  o.  )88b   888 . `8.   .8' 
// o888o o888o o888o   "888" ooooooooooo `Y8bod8P' `Y888""8o 8""888P'   "888"  `8. .8'  
//                                                                              `" "'   


int_cast :: proc {
	int_cast_rune_to_int,
	int_cast_string_to_int,
	int_cast_float_to_int,
}

int_cast_rune_to_int :: proc(r: rune) -> (int, bool) #optional_ok {
	if r == '0' do return 0, true
	else if r == '1' do return 1, true
	else if r == '2' do return 2, true
	else if r == '3' do return 3, true
	else if r == '4' do return 4, true
	else if r == '5' do return 5, true
	else if r == '6' do return 6, true
	else if r == '7' do return 7, true
	else if r == '8' do return 8, true
	else if r == '9' do return 9, true
	else do return -1, false
}

int_cast_string_to_int :: proc(s: string) -> (int, bool) #optional_ok {
	val, ok := strconv.parse_int(s)
	return val, ok
}

int_cast_float_to_int :: proc(f: f64) -> int {
	return int(f)
}

float_cast :: f64_cast

f64_cast :: proc {
	float_cast_string_to_f64,
}

float_cast_string_to_f64 :: proc(s: string) -> (f64, bool) {
	val, _, ok := strconv.parse_f64_prefix(s)
	return val, ok
}

// oooo   o8o               .     .o o.   
// `888   `"'             .o8    .8' `8.  
//  888  oooo   .oooo.o .o888oo .8'   `8. 
//  888  `888  d88(  "8   888   88     88 
//  888   888  `"Y88b.    888   88     88 
//  888   888  o.  )88b   888 . `8.   .8' 
// o888o o888o 8""888P'   "888"  `8. .8'  
//                                `" "'   


list :: proc {
	list_string_to_list,
	list_set_to_list,
}

list_string_to_list :: proc(s: string, allocator := context.allocator) -> [dynamic]rune {
	local_array := make([dynamic]rune, allocator)

	for val in s {
		append(&local_array, val)
	}

	return local_array
}

list_set_to_list :: proc(m: map[$T]struct {}, allocator := context.allocator) -> [dynamic]T {
	local_array := make([dynamic]T, allocator)

	for val in m {
		append(&local_array, val)
	}

	return local_array
}

// keys and values are the same type
dict_find_lowest_value_and_return_key :: proc(m: map[$T]T) -> T {
	lowest_value: T
	lowest_key: T
	first_pass := true
	for key, value in m {
		if first_pass {
			lowest_key = key
			lowest_value = value
			first_pass = false
		} else {
			if value < lowest_value {
				lowest_key = key
				lowest_value = value
			}
		}
	}
	return lowest_key
}


// keys and values are the same type
dict_find_highest_value_and_return_key :: proc(m: map[$T]T) -> T {
	highest_value: T
	highest_key: T
	first_pass := true
	for key, value in m {
		if first_pass {
			highest_key = key
			highest_value = value
			first_pass = false
		} else {
			if value > highest_value {
				highest_key = key
				highest_value = value
			}
		}
	}
	return highest_key
}

// key and value are different types
dict_find_lowest_value_and_return_key_02 :: proc(m: map[$K]$V) -> K {
	lowest_value: T
	lowest_key: K
	first_pass := true
	for key, value in m {
		if first_pass {
			lowest_key = key
			lowest_value = value
			first_pass = false
		} else {
			if value < lowest_value {
				lowest_key = key
				lowest_value = value
			}
		}
	}
	return lowest_key
}

// key and value are different types
dict_find_highest_value_and_return_key_02 :: proc(m: map[$K]$V) -> K {
	highest_value: V
	highest_key: K
	first_pass := true
	for key, value in m {
		if first_pass {
			highest_key = key
			highest_value = value
			first_pass = false
		} else {
			if value > highest_value {
				highest_key = key
				highest_value = value
			}
		}
	}
	return highest_key
}

//                                                     o8o      .                                 .o8       oooo            
//                                                     `"'    .o8                                "888       `888            
//  .oooo.o oooo  oooo  ooo. .oo.  .oo.               oooo  .o888oo  .ooooo.  oooo d8b  .oooo.    888oooo.   888   .ooooo.  
// d88(  "8 `888  `888  `888P"Y88bP"Y88b              `888    888   d88' `88b `888""8P `P  )88b   d88' `88b  888  d88' `88b 
// `"Y88b.   888   888   888   888   888               888    888   888ooo888  888      .oP"888   888   888  888  888ooo888 
// o.  )88b  888   888   888   888   888               888    888 . 888    .o  888     d8(  888   888   888  888  888    .o 
// 8""888P'  `V88V"V8P' o888o o888o o888o ooooooooooo o888o   "888" `Y8bod8P' d888b    `Y888""8o  `Y8bod8P' o888o `Y8bod8P' 


sum_iterable :: proc(l: []$T) -> T {
	total: T
	for val in l {
		total += val
	}
	return total
}

sum :: math.sum

//                                     .o8                            .     .o o.   
//                                    "888                          .o8    .8' `8.  
// oo.ooooo.  oooo d8b  .ooooo.   .oooo888  oooo  oooo   .ooooo.  .o888oo .8'   `8. 
//  888' `88b `888""8P d88' `88b d88' `888  `888  `888  d88' `"Y8   888   88     88 
//  888   888  888     888   888 888   888   888   888  888         888   88     88 
//  888   888  888     888   888 888   888   888   888  888   .o8   888 . `8.   .8' 
//  888bod8P' d888b    `Y8bod8P' `Y8bod88P"  `V88V"V8P' `Y8bod8P'   "888"  `8. .8'  
//  888                                                                     `" "'   
// o888o                                                                            


product :: proc {
	product_int,
	product_f64,
}


product_int :: proc(l: []int) -> int {
	total := 1
	for val in l {
		total *= val
	}

	return total
}

product_f64 :: proc(l: []f64) -> f64 {
	total: f64 = 1
	for val in l {
		total *= val
	}

	return total
}


//          oooo   o8o                               
//          `888   `"'                               
//  .oooo.o  888  oooo   .ooooo.   .ooooo.   .oooo.o 
// d88(  "8  888  `888  d88' `"Y8 d88' `88b d88(  "8 
// `"Y88b.   888   888  888       888ooo888 `"Y88b.  
// o.  )88b  888   888  888   .o8 888    .o o.  )88b 
// 8""888P' o888o o888o `Y8bod8P' `Y8bod8P' 8""888P' 

slice_compare :: proc {
	slice_compare_int,
}

// Returns `true` if both slices are the same, `false` otherwise.
slice_compare_int :: proc(s1, s2: []int) -> bool {
	// guard clause
    if len(s1) != len(s2) {
		return false
	}

	for val, i in s1 {
		if val != s2[i] {
			return false
		}
	}

	return true
}


//                                         .o o.   
//                                        .8' `8.  
// oo.ooooo.   .ooooo.  oooo oooo    ooo .8'   `8. 
//  888' `88b d88' `88b  `88. `88.  .8'  88     88 
//  888   888 888   888   `88..]88..8'   88     88 
//  888   888 888   888    `888'`888'    `8.   .8' 
//  888bod8P' `Y8bod8P'     `8'  `8'      `8. .8'  
//  888                                    `" "'   
// o888o                                           


// Returns the result of raising `base` to the power `power`.
pow :: math.pow


// int_pow computes the result of raising an integer base to an integer exponent.
//
// Parameters:
//   - base: The integer base value.
//   - exp:  The non-negative integer exponent.
//
// Returns:
//   The result of base raised to the power of exp (i.e., base^exp).
//
// Notes:
//   - This function uses a simple iterative approach.
//   - It assumes exp ≥ 0; negative exponents are not supported.
//   - For exp = 0, the result is always 1 (even if base is 0).
//
// Example:
//   - int_pow(2, 3) -> 8
//   - int_pow(5, 0) -> 1
int_pow :: proc(base: int, exp: int) -> int {
    if exp < 0 {
		print("\n>>>>")
        print("ERROR from `int_pow`: `exp` cannot be negative. Current value is:", exp)
        print(">>>>\n")
        panic("Negative `exp` detected.")
	}
	
	total := 1
    for _ in 0 ..< exp {
        total *= base
    }
    return total
}


//  o8o                        o8o                  .                                             .o o.   
//  `"'                        `"'                .o8                                            .8' `8.  
// oooo   .oooo.o             oooo  ooo. .oo.   .o888oo  .ooooo.   .oooooooo  .ooooo.  oooo d8b .8'   `8. 
// `888  d88(  "8             `888  `888P"Y88b    888   d88' `88b 888' `88b  d88' `88b `888""8P 88     88 
//  888  `"Y88b.               888   888   888    888   888ooo888 888   888  888ooo888  888     88     88 
//  888  o.  )88b              888   888   888    888 . 888    .o `88bod8P'  888    .o  888     `8.   .8' 
// o888o 8""888P' ooooooooooo o888o o888o o888o   "888" `Y8bod8P' `8oooooo.  `Y8bod8P' d888b     `8. .8'  
//                                                                d"     YD                       `" "'   
//                                                                "Y88888P'                               


// Returns `true` if the passed float has no decimal component. `false` otherwise.
is_integer :: proc(f: f64) -> bool {
	return f == math.floor(f)
}


/*
Returns the birary representation of a int as a string

*Allocates Using Temp Allocator*

Input:
- n: The input int

Returns:
- the binary representation of the integer as a string

Example:
```
	import "core:fmt"
	print :: fmt.println

	number := 13
	number_b := bin(13)
	print(number_b)  1101 

	free_all(context.temp_allocator)
```
Output:
```
	1101
```
*/
bin :: proc(n: int) -> string {
	number_b := fmt.tprintf("%b", n)
	return number_b
}


bin2 :: bin_negative_nums_as_twos_compliment


bin_negative_nums_as_twos_compliment :: proc(n: int, bits: u8, separate_bytes := false, use_underscores := true) -> (string, bool) #optional_ok {
	if bits != 8 && bits != 16 && bits != 32 && bits != 64 {
		print("bits:", bits, " --> must be 8, 16, 32 or 64")
		return "", false
	}
	
	// Calculate signed range
    min_val := -(1 << (bits - 1))
    max_val := (1 << (bits - 1)) - 1

    // Check if number is within range
    if n < min_val || n > max_val {
        print(n, "does not fit into", bits, "bits (remember a bit has to be reserved for the sign).")
		return "", false
    }

    // Convert to unsigned representation using two's complement
    u := u128(n) & ((1 << bits) - 1)

    // Build binary string with underscores every 4 bits
    b: strings.Builder
    strings.builder_init(&b, 0, int(bits + bits / 4), context.temp_allocator)

	for i in 0 ..< bits {
		bit := (u >> (bits - 1 - i)) & 1
		strings.write_string(&b, "1" if bit == 1 else "0")

		// Insert underscore after every 4 bits, except at the end of a byte
		if use_underscores {
			if separate_bytes {
				if (i + 1) % 4 == 0 && (i + 1) % 8 != 0 && i + 1 < bits  {
					strings.write_string(&b, "_")
				}
			} else {
				if (i + 1) % 4 == 0 && i + 1 < bits {
					strings.write_string(&b, "_")
				}
			}
		}
		
		// Insert 4 spaces after every full byte, except at the end
		if separate_bytes && (i + 1) % 8 == 0 && i + 1 < bits {
			strings.write_string(&b, "    ")
		}
	}

    final_string := strings.to_string(b)
    
	return final_string, true
}




//     .                                      .o o.   
//   .o8                                     .8' `8.  
// .o888oo oooo    ooo oo.ooooo.   .ooooo.  .8'   `8. 
//   888    `88.  .8'   888' `88b d88' `88b 88     88 
//   888     `88..8'    888   888 888ooo888 88     88 
//   888 .    `888'     888   888 888    .o `8.   .8' 
//   "888"     .8'      888bod8P' `Y8bod8P'  `8. .8'  
//         .o..P'       888                   `" "'   
//         `Y8P'       o888o                          



// returns `typeid_of(type_of(n))`
type :: proc(n: $T) -> typeid {
	return typeid_of(type_of(n))
}


//  .oooooo.                                         .                      
// d8P'  `Y8b                                      .o8                      
// 888           .ooooo.  oooo  oooo  ooo. .oo.   .o888oo  .ooooo.  oooo d8b 
// 888          d88' `88b `888  `888  `888P"Y88b    888   d88' `88b `888""8P 
// 888          888   888  888   888   888   888    888   888ooo888  888     
// `88b    ooo  888   888  888   888   888   888    888 . 888    .o  888     
//  `Y8bood8P'  `Y8bod8P'  `V88V"V8P' o888o o888o   "888" `Y8bod8P' d888b    


Counter :: proc {
	Counter_slice_of_ints,
	Counter_string,
    Counter_slice_of_strings,
}


// Given a slice of integers, returns a hashmap of integers mapped to how many times that integer appears
// - allocates with `context.temp_allocator`
// - Counter([1, 1, 2, 3]) -> map[1=2, 2=1, 3=1]
Counter_slice_of_ints :: proc(nums: []int) -> map[int]int {
    local_dict := make(map[int]int, context.temp_allocator)
    for val in nums {
		local_dict[val] += 1
    }

    return local_dict
}

// Given a string, returns a hashmap of runes mapped to how many times the rune appears
// - allocates with `context.temp_allocator`
// - Counter("cabcbc") -> map[b=2, c=3, a=1]
Counter_string :: proc(s: string) -> map[rune]int {
    local_dict := make(map[rune]int, context.temp_allocator)
    for val in s {
		local_dict[val] += 1
    }

    return local_dict
}


// Given a slice of strings, returns a hashmap of strings mapped to how many times the string appears
// - allocates with `context.temp_allocator`
// - Counter("I love cheese") -> map[I=1, love=1, cheese=1]
Counter_slice_of_strings :: proc(s: []string) -> map[string]int {
    local_dict := make(map[string]int, context.temp_allocator)
    for val in s {
		local_dict[val] += 1
    }

    return local_dict
}

//                          .                                                                               .                 .    o8o                                 
//                        .o8                                                                             .o8               .o8    `"'                                 
//  .oooooooo  .ooooo.  .o888oo             oo.ooooo.   .ooooo.  oooo d8b ooo. .oo.  .oo.   oooo  oooo  .o888oo  .oooo.   .o888oo oooo   .ooooo.  ooo. .oo.    .oooo.o 
// 888' `88b  d88' `88b   888                888' `88b d88' `88b `888""8P `888P"Y88bP"Y88b  `888  `888    888   `P  )88b    888   `888  d88' `88b `888P"Y88b  d88(  "8 
// 888   888  888ooo888   888                888   888 888ooo888  888      888   888   888   888   888    888    .oP"888    888    888  888   888  888   888  `"Y88b.  
// `88bod8P'  888    .o   888 .              888   888 888    .o  888      888   888   888   888   888    888 . d8(  888    888 .  888  888   888  888   888  o.  )88b 
// `8oooooo.  `Y8bod8P'   "888" ooooooooooo  888bod8P' `Y8bod8P' d888b    o888o o888o o888o  `V88V"V8P'   "888" `Y888""8o   "888" o888o `Y8bod8P' o888o o888o 8""888P' 
// d"     YD                                 888                                                                                                                       
// "Y88888P'                                o888o
//


get_permutations :: proc(s: string) -> []string {
    // base case
    if len(s) == 1 {
        base_case := make([dynamic]string, context.temp_allocator)
        append(&base_case, s)
        return base_case[:]
    }

    // recursive case
    permutations := make([dynamic]string, context.temp_allocator)
    head := s[0]
    tail := s[1:]  
    tail_permutations := get_permutations(tail)  

    // two for loops
    for val in tail_permutations {
        for i in 0 ..< len(val) + 1 {
            perm := combine_three_strings(val[:i], str(head), val[i:])
			//perm := fmt.tprint(val[:i], str(head), val[i:], sep="")
            append(&permutations, perm)
        }
    }

    p_list.sort(permutations[:])
    return permutations[:]
}


// Combines three(3) strings
// - Uses `context.temp_allocator`
combine_three_strings :: proc(s1, s2, s3: string) -> string {
    b: strings.Builder
    strings.builder_init(&b, 0, len(s1) + len(s2) + len(s3), context.temp_allocator)
    // code goes here -------------------------------------
    strings.write_string(&b, s1)
    strings.write_string(&b, s2)
    strings.write_string(&b, s3)
    // ----------------------------------------------------
    final_string := strings.to_string(b)
    
    return final_string
}


// Strings stuff

// Returns if two strings are equal. Works with slice notation as well (which is nice)
// - Odin version of: `string1 == string2`
two_strings_are_equal :: proc(s1, s2: string) -> bool {
    if len(s1) != len(s2) { return false }

    for i in 0 ..< len(s1) {
        if s1[i] != s2[i] { return false }
    }
    return true
}

strings_compare :: two_strings_are_equal


// Concatenates the various number of strings passed to it
// - allocates with `context.temp_allocator`
// - Odin version of: `string1 + string2 + ...`
concatenate_strings :: proc(strs: ..string, sep := "") -> string {
    total_length := 0
    for val in strs {
        total_length += (len(val) + len(sep))
    }
    
    b: strings.Builder
    strings.builder_init(&b, 0, total_length, context.temp_allocator)
    // code goes here -------------------------------------
    for i in 0 ..< len(strs) {
        strings.write_string(&b, strs[i])
        if i != len(strs) - 1 {
            strings.write_string(&b, sep)
        }
    }
    // ----------------------------------------------------
    final_string := strings.to_string(b)
    
    return final_string
}

// Concatenates the various number of strings passed to it
// - allocates with `context.temp_allocator`
// - Odin version of: `c + a + t + ...`
concatenate_runes :: proc(runes: ..rune) -> string {    
    b: strings.Builder
    strings.builder_init(&b, 0, len(runes), context.temp_allocator)
    // code goes here -------------------------------------
    for i in 0 ..< len(runes) {
        strings.write_rune(&b, runes[i])
    }
    // ----------------------------------------------------
    final_string := strings.to_string(b)
    
    return final_string
}


// Replicates the Python functionality of being able to multiply a string by an int
// - Python: "boy" * 3 -> "boyboyboy"
// - Odin: string_times_int("boy", 3) -> "boyboyboy"
string_times_int :: proc(s: string, n: int, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	b: strings.Builder
	strings.builder_init(&b, 0, len(s) * n, allocator) or_return // err is of type mem.Allocator_Error
	// code goes here -------------------------------------
	for _ in 0 ..< n {
		strings.write_string(&b, s)
	}
	// ----------------------------------------------------
	final_string = strings.to_string(b)
	
	return final_string, nil
}


/*
Converts a list of integers into a formatted string representation.

This function takes a list of integers and transforms it into a string format, 
preserving the order of elements. The resulting string can be used as a 
unique identifier in hashmaps or for serialization purposes.

*Allocates using `context.temp_allocator`*

*Use `free_all(context.temp_allocator)` when convenient to free memory.*

Inputs:
- vals: []int (A list of integers)

Returns:
- result: string (The string representation of the list)

Example:
```
    nums := []int{1, 2, 3}
    str_repr := tuple(nums)

    fmt.println(str_repr) // Output: "[1, 2, 3]"

    free_all(context.temp_allocator)    <-- don't forget to do this after use!
```
Returns:
```
    "[1, 2, 3]"
```
*/
tuple :: proc(vals: []int) -> string {
    return fmt.tprintf("%v", vals) // Convert list to string
}


/*
Converts a formatted string representation of a tuple into a list of integers.

This function extracts integer values from a string formatted like a tuple (e.g., "[1, 1]") 
and returns them as a proper list of integers.

*Allocates using `context.temp_allocator`*

*Use `free_all(context.temp_allocator)` when convenient to free memory.*

Inputs:
- s: string (A string representing a list of integers in tuple format)

Returns:
- result: []int (A list of extracted integer values)

Example:
```
    str_repr := "[1, 2, 3]"
    num_list := tuple_to_list(str_repr)

    fmt.println(num_list) // Output: {1, 2, 3}

    free_all(context.temp_allocator)    <-- don't forget to do this after use!
```
Returns:
```
    {1, 2, 3}
```
*/
tuple_to_list :: proc(s: string) -> []int {
    // Remove brackets and split by comma
    trimmed, _ := strings.replace(s, "[", "", -1, context.temp_allocator)
    _trimmed, _ := strings.replace(trimmed, "]", "", -1, context.temp_allocator)
    parts := strings.split(_trimmed, ",", context.temp_allocator)
    
    // trim whitespace
    for &val in parts {
        val = p_str.strip(val)
    }
    
    // Convert string parts into integers
    result := make([]int, len(parts), context.temp_allocator)
    for i in 0 ..< len(parts) {
        result[i], _ = strconv.parse_int(parts[i])
    }

    return result

}

// Determines whether a given integer `n` is a prime number.
//
// Parameters:
//   - n: The integer to test for primality.
//
// Returns:
//   - true if `n` is a prime number (i.e., greater than 1 and divisible only by 1 and itself).
//   - false otherwise.
//
// Description:
//   This function checks whether the input integer `n` is a prime number.
//   It first rules out values less than 2, which are not prime by definition.
//   Then, it iterates from 2 up to the square root of `n`, checking for any divisors.
//   If any number in that range divides `n` evenly, the function returns false.
//   Otherwise, it returns true, indicating that `n` is prime.
//
// Example:
//   - is_prime(7) -> true
//   - is_prime(10) -> false
is_prime :: proc(n: int) -> bool {
    if n < 2 { return false }
    for val in 2 ..< int(sqrt(f64(n)) + 1) {
        if n % val == 0 {
            return false
        }
    }
    return true
}

/*
 * A generic procedure that mimics Python's id() function.
 * It accepts a pointer to any value and returns its memory address.
 *
 * @param data: A pointer to any variable (`^$T`).
 * @return: A `rawptr` representing the variable's memory address.
 */
id :: proc(data: ^$T) -> rawptr {
	return rawptr(data)
}


/*
 * A utility procedure that mimics Python-style string slicing using rune indices.
 * It returns a substring of the input string from `rune_start` (inclusive) to `rune_end` (exclusive),
 * based on rune positions rather than byte offsets, ensuring correct handling of UTF-8 encoded characters.
 *
 * Does not allocate memory. Returns a substring of the original string `s`.
 *
 * If `rune_end` is omitted, it defaults to `INT_MAX`, effectively slicing to the end of the string.
 * If the indices are invalid (negative, out of bounds, or reversed), an empty string is returned.
 *
 * @param s: The input string to slice.
 * @param rune_start: The starting rune index (inclusive).
 * @param rune_end: The ending rune index (exclusive). Defaults to `INT_MAX`.
 * @return: A substring of `s` spanning the specified rune range.
 *
 * +---------------------+-------------------------------+
 * |      Python         |            Odin               |
 * +---------------------+-------------------------------+
 * | "hello"[2:5]        | rune_slice("hello", 2, 5)     |
 * | "world"[0:3]        | rune_slice("world", 0, 3)     |
 * | "héllö"[1:4]        | rune_slice("héllö", 1, 4)     |
 * | "abc"[2:]           | rune_slice("abc", 2)          |
 * | "小猫咪"[0:2]        | rune_slice("小猫咪", 0, 2)    |
 * +---------------------+-------------------------------+
 *
 */
rune_slice :: proc(s: string, rune_start: int, rune_end: int = INT_MAX) -> string {
	if rune_start < 0 || rune_end < 0 || rune_end < rune_start {
		return ""
	}

    N := len_runes(s)

    _rune_start := rune_start
    if _rune_start > N {
        _rune_start = N
    }

    _rune_end := rune_end
    if _rune_end > N {
        _rune_end = N
    }

    if _rune_start == N && _rune_end == N { return "" }

	return my_internal_substring(s, _rune_start, _rune_end)
}

@(private = "file")
my_internal_substring :: proc(s: string, rune_start: int, rune_end: int) -> (sub: string) {
	sub = s
	ok  := true

	rune_i := 0

	if rune_start > 0 {
		ok = false
		for _, i in sub {
			if rune_start == rune_i {
				ok = true
				sub = sub[i:]
				break
			}
			rune_i += 1
		}
		if !ok { return "" }
	}

	if rune_end >= rune_start {
		ok = false
		for _, i in sub {
			if rune_end == rune_i {
				ok = true
				sub = sub[:i]
				break
			}
			rune_i += 1
		}

		if rune_end == rune_i {
			ok = true
		}

        if !ok { return "" }
	}

	return sub
}


/*
 * Converts an integer value into its hexadecimal string representation.
 * The result includes a "0x" prefix and uses uppercase hexadecimal digits ('A'–'F').
 * Negative values are prefixed with a minus sign ("-0x...").
 * Zero is handled as a special case and returns "0x0".
 *
 * Internally, the function works by repeatedly extracting 4-bit chunks (nibbles)
 * from the unsigned representation of the input value, mapping each nibble to
 * its corresponding hexadecimal digit, and then reversing the collected digits
 * to produce the correct order.
 *
 * Allocates using `context.temp_allocator`.
 *
 * @param n: The integer to convert into a hexadecimal string.
 * @return: A string containing the hexadecimal representation of the input integer.
 *
 * Example usage:
 *
 * hex(10)        // returns "0xA"
 * Explanation: decimal 10 is hexadecimal A.
 *
 * hex(255)       // returns "0xFF"
 * Explanation: decimal 255 is hexadecimal FF.
 *
 * hex(1114111)   // returns "0x10FFFF"
 * Explanation: decimal 1114111 is hexadecimal 10FFFF.
 *
 * hex(-4096)     // returns "-0x1000"
 * Explanation: negative values are prefixed with "-".
 *
 * hex(0)         // returns "0x0"
 * Explanation: zero is a special case.
 */
hex :: proc(n: int) -> string {
    a := context.temp_allocator

    // Special case for zero
    if n == 0 {
        return "0x0"
    }

    // Handle sign
    negative := n < 0
    value := n
    if negative {
        value = -value
    }

    // Work in unsigned to simplify bit ops
    u := cast(u64)(value)

    // Lowercase hex digits
    digits := [16]u8 {
        '0','1','2','3','4','5','6','7',
        '8','9','A','B','C','D','E','F',
    }

    // Build result using temp allocator
    // Worst-case length: "-" + "0x" + up to 16 hex digits for 64-bit
    // 16 hex digits + 1 '-' if negative + 1 '0' + 1 'x' (for the beginning) --> 16 + 1 + 1 + 1 --> 19
    buf := make([dynamic]u8, 0, 19, a)      // that's why the capity is 19 here
    if negative {
        append(&buf, '-')
    }
        append(&buf, '0', 'x')

    // Collect hex digits in reverse
    tmp := make([dynamic]u8, 0, 16, a)
    for (u > 0) {
        d := cast(int)(u & 0xF)
        append(&tmp, digits[d])
        u >>= 4
    }

    // Append reversed to get correct order
    for i := len(tmp) - 1; i >= 0; i -= 1 {
        append(&buf, tmp[i])
    }

    return string(buf[:])
}


/*
 * Converts a single Unicode character (rune) into its integer code point.
 * This mimics Python's `ord()` function, returning the numeric value
 * associated with the given character. `ord` is short for `ordinal`
 *
 * @param r: The input rune (Unicode character).
 * @return: The integer code point corresponding to the rune.
 *
 * Example usage:
 *
 * ord('A') // returns 65
 * Explanation: 'A' has Unicode code point U+0041, which is 65 in decimal.
 *
 * ord('😀') // returns 128512
 * Explanation: '😀' has Unicode code point U+1F600, which is 128512 in decimal.
 */
ord :: proc(r: rune) -> int {
    return int(r)
}


/*
 * Converts an integer code point into its corresponding Unicode character (rune).
 * This mimics Python's `chr()` function, returning the character associated
 * with the given numeric value.
 *
 * @param n: The integer code point to convert.
 * @return: The rune (Unicode character) corresponding to the code point.
 *
 * Example usage:
 *
 * chr(65) // returns 'A'
 * Explanation: Unicode code point 65 corresponds to the character 'A'.
 *
 * chr(128512) // returns '😀'
 * Explanation: Unicode code point 128512 corresponds to the emoji '😀'.
 *
 * Notes on invalid inputs:
 * - Passing a negative integer or a value greater than the maximum valid Unicode code point (U+10FFFF)
 *   will still produce a rune in Odin, but it may not correspond to a valid character.
 * - Such values can render as replacement glyphs (�) or appear as undefined symbols depending on the font
 *   and terminal environment.
 * - It is recommended to validate inputs before calling `chr` if you need guaranteed valid Unicode output.
 */
chr :: proc(n: int) -> rune {
    return rune(n)
}


/*
 * Computes the n‑th Fibonacci number using Binet's formula.
 * The Fibonacci sequence is defined as F(0) = 0, F(1) = 1, and
 * F(n) = F(n‑1) + F(n‑2) for n > 1. This implementation uses
 * the closed‑form expression involving powers of (1 ± √5)/2,
 * avoiding iterative loops or recursion.
 *
 * Internally, the function calculates:
 *   F(n) = ( ( (1 + √5)^n ) - ( (1 - √5)^n ) ) / ( 2^n * √5 )
 * and casts the result to an integer.
 *
 * @param n: The index of the Fibonacci number to compute (n ≥ 0).
 * @return: The n‑th Fibonacci number as an integer.
 *
 * Example usage:
 *
 * nth_fibonacci_number(0) // returns 0
 * Explanation: Base case of the sequence.
 *
 * nth_fibonacci_number(1) // returns 1
 * Explanation: Base case of the sequence.
 *
 * nth_fibonacci_number(10) // returns 55
 * Explanation: The 10th Fibonacci number is 55.
 */
nth_fibonacci_number :: proc(n: int) -> int {
    f5 := f64(5)
    sqrt_of_5 := math.sqrt(f5)
    return int_cast((pow(1.0 + sqrt_of_5, f64(n)) - pow(1.0 - sqrt_of_5, f64(n))) / (pow(2.0, f64(n)) * sqrt_of_5))
}

/*
 * Produces a new string by selecting characters from the input string according to
 * start, stop, and step parameters. Negative indices are translated relative to the
 * end of the string (e.g. -1 refers to the last character, -2 to the second-to-last
 * character and so on). `start_` is included and `stop_` is not. i.e.: (start_, stop_]. 
 * Think "Up to, but not including, the `stop_` index."
 *
 * Returns an empty string if the computed range yields no characters.
 *
 * Allocates using `context.temp_allocator`
 *
 * @param s:       The input string to slice.
 * @param start_:  The starting index (default 0). Negative values count from the end.
 * @param stop_:   The stopping index (default INT_MAX, treated as the string length).
 *                 Negative values count from the end.
 * @param step_:   The step size (default 1). Must not be zero. Positive values iterate
 *                 forward, negative values iterate backward.
 * @param allocator: The allocator used to build the new string.
 *
 * @return: A newly allocated string containing the selected characters.
 *
 * Example usage:
 *
 * string_slice("Hello, World!", 0, 5, 1) // returns "Hello"
 * Explanation: Characters from index 0 up to (but not including) 5.
 *
 * string_slice("Hello, World!", -6, INT_MAX, 1) // returns "World!"
 * Explanation: Start at index -6 (translated to 7) through the end.
 *
 * string_slice("Hello, World!", 0, INT_MAX, 2) // returns "Hlo ol!"
 * Explanation: Every second character from start to end.
 *
 * string_slice("Hello, World!", 0, INT_MAX, -1) // returns "!dlroW ,olleH"
 * Explanation: Reverse the entire string.
 *
 * string_slice("Hello, World!", step_=-1) // returns "!dlroW ,olleH"
 * Explanation: If you omit the `start_` and `stop_` parameters, they default to 
 *              the beginning and end of the string, respectively. Here, just `step_`
 *              is used. Just like the example above, it reverses the entire string.              
 *
 * string_slice("abcdef", 2, 5, 1) // returns "cde"
 * Explanation: Characters at indices 2, 3 and 4.
 *
 * string_slice("abcdef", -4, INT_MAX, 1) // returns "cdef"
 * Explanation: Characters from index -4 (translated to 2) to the end of the string is "cdef".
 *
 * string_slice("abcdef", -4, INT_MAX, -1) // returns "fedc"
 * Explanation: Characters from index -4 (translated to 2) to the end of the string -- reversed -- is "fedc".
 */
string_slice :: proc(s: string, start_ := 0, stop_ := INT_MAX, step_ := 1, allocator := context.temp_allocator) -> string {
    n := len(s)
    _start := start_
    _stop  := stop_

    // Translate negative indices like Python
    if _start < 0 {
        _start += n
    }
    if _stop == INT_MAX { // default "no stop" means end
        _stop = n
    } else if _stop < 0 {
        _stop += n
    }

    // Clamp to bounds
    _start = clamp(_start, 0, n)
    _stop  = clamp(_stop,  0, n)

    // make sure `step_` is not zero
    if step_ == 0 {
        panic("step cannot be zero")
    }


    // make a string builder to fill with the correct characters
    b: strings.Builder
    strings.builder_init(&b, 0, len(s), allocator)

    if step_ > 0 {
        for i := _start; i < _stop; i += step_ {
            strings.write_rune(&b, rune(s[i]))
        }
    } else {
        for i := _stop - 1; i > _start - 1; i += step_ {
            strings.write_rune(&b, rune(s[i]))
        }
    }
    final_string := strings.to_string(b)
    
    return final_string
}
