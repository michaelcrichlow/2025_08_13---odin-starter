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


// Given an iterable, it return the minimum value in it
min_iterable :: proc(array: []$T) -> T {
	min := array[0]
	for val in array {
		if val < min {
			min = val
		}
	}
	return min
}

// Given an iterable, it return the maximum value in it
max_iterable :: proc(array: []$T) -> T {
	max := array[0]
	for val in array {
		if val > max {
			max = val
		}
	}
	return max
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

float_cast :: proc {
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
//   int_pow(2, 3) -> 8
//   int_pow(5, 0) -> 1
int_pow :: proc(base: int, exp: int) -> int {
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
    for val in 2 ..= int(sqrt(f64(n))) {
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
