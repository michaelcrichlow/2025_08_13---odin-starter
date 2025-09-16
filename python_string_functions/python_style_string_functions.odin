package python_string_functions

import "base:runtime"
import "core:fmt"
import "core:mem"
import "core:slice"
import "core:strings"
import "core:unicode"

print :: fmt.println
I64_MAX :: 9_223_372_036_854_775_807
INT_MAX :: I64_MAX

/*
Coming from Python, I found myself missing Python's String Methods. So, I decided to build them myself - both as a way
of creating a library that will be useful in the future, and also as a way to learn more about Odin. In fact, many of the 
functions I made I later found out that they were already in the core library! Which is great (since I can both call the
functions when I need them and learn a better "more complete" version of building Odin code). Nice! Now, when I use them
I can approach them from a place of actually understanding how they work (which is always the goal).

So, what's here is a combination of my work and calling out to functions in the standard library (including some of the 
comments!) I found this entire excercise helpful, so this is posted with the idea that hopefully it will be helpful to 
others as well. Cheers and happy coding! :)
- Mike C (February 17, 2025)

Added `rotate_left` and `rotate_right`
- Mike C (February 28, 2025)

Added `strip_punctuation`
- Mike C (March 03, 2025)
*/



// odinfmt: disable


/*
Capitalizes the first character of the given string. Lowercases everything else.

*Allocates Using Provided Allocator*

Inputs:
- s: string
- allocator: (default: context.allocator)
- loc: #caller_location (useful for debugging)


Returns:
- final_string: The result of capitalizing the first character and lowercasing everything else.
- err: An optional allocator error if one occured, `nil` otherwise

Example:

	import "base:runtime"
	import "core:fmt"
	import "core:strings"
	import "core:unicode"
	print :: fmt.println

	test := capitalize("mIchAel")
	test2 := capitalize("this is a test.")
	defer delete(test)
	defer delete(test2)

	print(test)
	print(test2)

Output:
	
	Michael
	This is a test.
*/
capitalize :: proc(s: string, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: runtime.Allocator_Error) #optional_allocator_error {
	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return // err is of type mem.Allocator_Error
	for i in 0 ..< len(s) {
		if i == 0 {
			val := unicode.to_upper(rune(s[i]))
			strings.write_rune(&b, val)
		} else {
			val := unicode.to_lower(rune(s[i]))
			strings.write_rune(&b, val)
		}
	}
	final_string = strings.to_string(b)

	return final_string, nil
}

// `casefold()` and `lower()` are not strictly the same, but for my purposes I made them synonymous. `casefold()` just calls `lower()`
casefold :: lower


/*
Centers the input string within a field of specified length by adding pad string on both sides, if its length is less than the target length.

*Allocates Using Provided Allocator*

Inputs:
- str: The input string
- length: The desired length of the centered string, in runes
- pad: The string used for padding on both sides
- allocator: (default is context.allocator)

Returns:
- res: A new string centered within a field of the specified length
- err: An optional allocator error if one occured, `nil` otherwise
*/
center :: strings.center_justify

// Returns the number of runes in a string.
count :: proc(s: string, test_rune: rune) -> int {
	total := 0
	for val in s {
		if val == test_rune {
			total += 1
		}
	}
	return total
}


// Returns the number of times 'test_rune' appears in a string before reaching a space character `' '`.
// If no space character `' '` is present, returns the number of times 'test_rune' appears in the entire string.
count_until_space :: proc(s: string, test_rune: rune) -> int {
	_index_of_space := index(s, " ")
	_s : string
	if _index_of_space != -1 {		// means ' ' is in the string
		_s = s[:_index_of_space]
	} else {						// otherwise use the entire string (since ' ' is not in it)
		_s = s
	}
	
	total := 0
	for val in _s {
		if val == test_rune {
			total += 1
		}
	}
	return total
}

/*

*Disabled Function*

Python's `encode()` is used to convert a string from one encoding to another (e.g., from Unicode to UTF-8, Latin-1, etc.).
Odin's strings are always UTF-8 encoded.  This is a fundamental design decision in Odin.  Therefore, there's no need for
an `encode()` function to change the encoding of a string because it's already UTF-8. This function currently does nothing
but is here for completeness.
*/
encode :: proc() {}


/*
Determines if a string `s` ends with a given `suffix`

Inputs:
- s: The string to check for the `suffix`
- suffix: The suffix to look for

Returns:
- result: `true` if the string `s` ends with the `suffix`, otherwise `false`

Example:

	import "core:fmt"
	import "core:strings"

	has_suffix_example :: proc() {
		fmt.println(strings.has_suffix("todo.txt", ".txt"))
		fmt.println(strings.has_suffix("todo.doc", ".txt"))
		fmt.println(strings.has_suffix("todo.doc.txt", ".txt"))
	}

Output:

	true
	false
	true

*/
endswith :: strings.ends_with


/*
Expands the input string by replacing tab characters with spaces to align to a specified tab size

*Allocates Using Provided Allocator*

Inputs:
- s: The input string
- tab_size: The number of spaces to use for each tab character
- allocator: (default is context.allocator)

Returns:
- res: A new string with tab characters expanded to the specified tab size
- err: An optional allocator error if one occured, `nil` otherwise

WARNING: Panics if tab_size <= 0

Example:

	import "core:fmt"
	import "core:strings"

	expand_tabs_example :: proc() {
		text := "abc1\tabc2\tabc3"
		fmt.println(strings.expand_tabs(text, 4))
	}

Output:

	abc1    abc2    abc3

*/
expandtabs :: strings.expand_tabs


/*
The `find()` method in Python is almost the same as the `index()` method, the only difference is that the `index()` method 
raises an exception if the value is not found. Here, in Odin, both `find()` and `index()` call the same function -> `strings.index()`,
which returns -1 if the substring is not found.  
*/
find :: strings.index


/*
Return a formatted version of s, using substitutions from `args`.
The substitutions are identified by braces ('{' and '}').

*Allocates using context.temp_allocator* 

*Use `free_all(context.temp_allocator)` when convinient to free memory.*

Inputs:
- s: string
- args: map[string]f64


Returns:
- result: string (The result of replacing the formatted sections with values from the map.)

Example:

	import p_str "python_string_functions"
	print :: fmt.println

	txt := "There are {dogs} dogs, {cats} cats and {food} plates of food left."
	
	txt_map := make(map[string]f64)
	txt_map["dogs"] = 8
	txt_map["cats"] = 12
	txt_map["food"] = 3.5
	defer delete(txt_map)			<-- don't forget to do this!

	val_01 := p_str.format(txt, txt_map) 
	print(val_01)

	free_all(context.temp_allocator)  	<-- don't forget to do this after use!

Output:

There are 8 dogs, 12 cats and 3.5 plates of food left.
*/
format :: proc(s: string, args: map[string]f64) -> string {
	l := contains_curly_brace_pattern(s)
	result := s
	ok: bool

	for val in l {
		if val[1:len(val) - 1] in args {
			new_val := args[val[1:len(val) - 1]]
			replacement := str(new_val, context.temp_allocator)
			result, ok = strings.replace_all(result, val, replacement, context.temp_allocator)
		}
	}

	return result
}


// `format()` and `format_map()` are not strictly the same, but for my purposes I made them synonymous. `format_map()` just calls `format()`
format_map :: format

// Returns the first index of the specified substring, -1 if the substring is not present.
index :: strings.index


// Returns true if the rune passed to it is a letter or a number.
// False otherwise.
isalnum :: proc {
	is_alnum_rune,
	is_alnum_u8,
}


// Returns true if the rune passed to it is a letter or a number.
// False otherwise.
@(private = "file")
is_alnum_rune :: proc(r: rune) -> bool {
	rune_as_int := int(r)
	if rune_as_int >= 48 && rune_as_int < 58 { 	// numbers
		return true
	}
	if rune_as_int >= 65 && rune_as_int < 91 { 	// uppercase letters
		return true
	}
	if rune_as_int >= 97 && rune_as_int < 123 { // lowercase letters
		return true
	}
	return false
}


// Returns true if the rune passed to it is a letter or a number.
// False otherwise.
@(private = "file")
is_alnum_u8 :: proc(r: u8) -> bool {
	if r >= 48 && r < 58 { 	// numbers
		return true
	}
	if r >= 65 && r < 91 { 	// uppercase letters
		return true
	}
	if r >= 97 && r < 123 { // lowercase letters
		return true
	}
	return false
}


// Returns true if `r` is a letter. False otherwise.
isalpha :: unicode.is_alpha


// Returns true if `r` is an ascii character (0 to 127). False otherwise. 
isascii :: proc{
	isascii_rune,
	isascii_u8,
}

@(private = "file")
isascii_rune :: proc(r: rune) -> bool {
	rune_as_int := int(r)
	if rune_as_int >= 0 && rune_as_int < 128 { 	// 128 ascii characters
		return true
	}
	return false
}

@(private = "file")
isascii_u8 :: proc(r: u8) -> bool {
	if r >= 0 && r < 128 { 	// 128 ascii characters
		return true
	}
	return false
}

// Returns True if `r` is a digit (0 to 9). False otherwise.
isdecimal :: unicode.is_digit

// - I treat isdecimal() and isdigit() the same, though in Python they are slightly different.
// - Here they both call unicode.is_digit()
// - Returns True if `r` is a digit (0 to 9). False otherwise.
isdigit :: unicode.is_digit


/*
- Returns true if the string is a valid identifier, false otherwise.
- A string is considered a valid identifier if it only contains alphanumeric letters (a-z) and (0-9), 
or underscores (_). 
- A valid identifier cannot start with a number, or contain any spaces.
- It also cannot be a reserved word. 
*/
isidentifier :: proc(s: string, l :[]string = reserved_words) -> bool {
	if len(s) == 0 {
		return false
	}
	if unicode.is_number(rune(s[0])) {
		return false
	}
	for val in s {
		if unicode.is_space(val) {
			return false
		}
	}
	// make sure the values are only alphanumeric or underscores(_)
	if len(s) == 1 {
		for val in s {
			if unicode.is_alpha(val) || val == '_' {/*do nothing*/}
			else {
				return false
			}
		}
	} else if len(s) > 1 {
		for val in s[1:] {
			if unicode.is_alpha(val) || unicode.is_number(val) || val == '_' {/*do nothing*/}
			else {
				return false
			}
		}
	}
	// make sure it's not a reserved word
	for val in l {
		if val == s {
			return false
		}
	}
	return true
}

// Returns true if `r` is a lowercase letter. False otherwise.
islower :: unicode.is_lower

// Returns true if `r` is a digit (0 to 9). False otherwise.
isnumeric :: unicode.is_digit


/*
The functionality of this procedure has been greatly reduced compared to its Python equivalent.
isprintable_ascii() would be a better name for this function as it stands.
This only returns `true` if the rune is an ascii character between 31 and 127 `31 < rune < 127`, `false` otherwise.
Checking for the Unicode Categories: CC, CF, CS, CO and CN are absent in this implimentation.
*/
isprintable :: proc(r: rune) -> bool {
	rune_as_int := int(r)
	if isascii(r) {
		if rune_as_int > 31 && rune_as_int < 127 {
			return true
		} else {
			return false
		}
	}
	return false
}

// Returns true if `r` is a whitespace character. False otherwise.
isspace :: unicode.is_space


/*
*Allocates Using Provided Allocator*

Returns `true` if all words in a text start with a upper case letter, 
AND the rest of the word are lower case letters, otherwise `false`.

Symbols and numbers are ignored.
*/
istitle :: proc(s: string, allocator := context.allocator) -> (res: bool, err: mem.Allocator_Error) #optional_allocator_error {
	list_of_strings := strings.split(s, " ", allocator) or_return
	for val in list_of_strings {
		if !first_letter_is_capitalized_and_everything_else_is_lowercase(val) {
			return false, nil
		}
	}
	return true, nil
}

isupper :: unicode.is_upper

join :: strings.join

/*
*Allocates Using Provided Allocator*

Takes a slice of runes and returns those runes as a string: ['a', 'b', 'c'] -> "abc"
*/
join_runes :: proc(l: []rune, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
    b: strings.Builder
    strings.builder_init(&b, 0, len(l), allocator) or_return // err is of type mem.Allocator_Error
    // code goes here
    for val in l {
        strings.write_rune(&b, val)
    }
    final_string = strings.to_string(b)
    
    return final_string, nil
}

ljust :: strings.left_justify


// Returns a copy of the string converted to lowercase.
// - *Allocates Using Provided Allocator*
// - "ApPLe" -> "apple"
lower :: proc(s: string, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return // err is of type mem.Allocator_Error
	// code goes here -------------------------------------
	for val in s {
        lowercase_val := unicode.to_lower(val)
        strings.write_rune(&b, lowercase_val)
    }
    // ----------------------------------------------------
	final_string = strings.to_string(b)
	
	return final_string, nil
}

/*
Return a copy of the string with leading whitespace removed.

If rune is given, removes rune instead.
 - "    balls" -> "balls"
 - "0000balls" -> "balls"
*/
lstrip :: proc(s: string, rune_to_remove: rune = ' ', allocator := context.allocator) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return // err is of type mem.Allocator_Error
	// code goes here -------------------------------------
	found_start := false
	for val in s {
		if val != rune_to_remove && found_start == false { found_start = true }
		if found_start {
			strings.write_rune(&b, val)
		}
	}
	// ----------------------------------------------------
	final_string = strings.to_string(b)
	
	return final_string, nil
}


/*
Return a copy of the string with trailing whitespace removed.

If rune is given, removes rune instead.
 - "balls    " -> "balls"
 - "balls0000" -> "balls"
*/
rstrip :: proc(s: string, rune_to_remove: rune = ' ', allocator := context.allocator) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return // err is of type mem.Allocator_Error
	// code goes here -------------------------------------
	found_start := false
	#reverse for val in s {
		if val != rune_to_remove && found_start == false { found_start = true }
		if found_start {
			strings.write_rune(&b, val)
		}
	}
	// ----------------------------------------------------
	final_string = strings.to_string(b)
	final_string = reverse(final_string, allocator)
	
	return final_string, nil
}

strip :: strings.trim_space

// Returns a map that can be used with the `translate` procedure to replace specified characters.
// Here, `maketrans` essentially acts as a validator for the map that will be used in the
// `translate` function below.
maketrans :: proc(d : map[string]string) -> map[string]string {
	for key, val in d {
		if len(key) != len(val) {
			fmt.println(">>> ERROR: The length of", key, "and", val, "are not the same.")
			panic(">>> maketrans: The length of the keys and values must be the same.")
		}
	}
	return d
}


/*
Splits the input string `str` by the separator `sep` string and returns 3 parts. The values are slices of the original string.

Inputs:
- str: The input string
- sep: The separator string

Returns:
- head: the string before the split
- match: the seperator string
- tail: the string after the split

Example:

	import "core:fmt"
	import "core:strings"

	partition_example :: proc() {
		text := "testing this out"
		head, match, tail := strings.partition(text, " this ") // -> head: "testing", match: " this ", tail: "out"
		fmt.println(head, match, tail)
		head, match, tail = strings.partition(text, "hi") // -> head: "testing t", match: "hi", tail: "s out"
		fmt.println(head, match, tail)
		head, match, tail = strings.partition(text, "xyz")    // -> head: "testing this out", match: "", tail: ""
		fmt.println(head)
		fmt.println(match == "")
		fmt.println(tail == "")
	}

Output:

	testing  this  out
	testing t hi s out
	testing this out
	true
	true

*/
partition :: strings.partition 

removeprefix :: strings.trim_prefix

removesuffix :: strings.trim_suffix

replace :: strings.replace


// Returns a reversed copy of the input string.
// - Supports full Unicode (UTF-8) input.
// - Allocates using the provided allocator (defaults to `context.allocator`).
// - Returns an optional allocator error.
// - Example: "apple" -> "elppa"
reverse :: proc(s: string, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return // err is of type mem.Allocator_Error
	// code goes here -------------------------------------
	#reverse for val in s {
		strings.write_rune(&b, val)
	}
	// ----------------------------------------------------
	final_string = strings.to_string(b)
	
	return final_string, nil
}


// Returns a reversed copy of the input string.
// This version is optimized for performance and assumes ASCII-only input.
// - Uses `context.temp_allocator` for allocation.
// - Faster than `reverse()` but not Unicode-safe.
// - Example: "apple" -> "elppa"
reverse_ascii :: proc(s: string) -> string {
    mutable_string := make([dynamic]u8, len(s), context.temp_allocator)
    copy(mutable_string[:], s)
    slice.reverse(mutable_string[:])

    return string(mutable_string[:])
}

rfind :: strings.last_index

rindex :: strings.last_index

rjust :: strings.right_justify


// Returns a string with the characters rotated one spot to the left: `band -> andb`
// - *Allocates Using Provided Allocator*
rotate_left :: proc(s: string, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	// guard clauses
	if len(s) == 0 || len(s) == 1 {
		return s, nil
	}
	
	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return // err is of type mem.Allocator_Error
	// code goes here
	for val in 1 ..< len(s) {
		strings.write_rune(&b, rune(s[val]))
	}
	strings.write_rune(&b, rune(s[0]))
	final_string = strings.to_string(b)
	
	return final_string, nil
}


// Returns a string with the characters rotated `k` spots to the left:
// - *Allocates Using Provided Allocator*
// - For Example: if `k` = 3 -> 'apple' -> 'pleap'
rotate_left_num :: proc(s: string, k: int = 1, allocator := context.allocator) -> string  {
	res := s
	_k := k
	if k > len(s) { _k = k % len(s) }
	for _ in 0 ..< _k {
		res = rotate_left(res, allocator)
	}
	return res
}


// Returns a string with the characters rotated one spot to the right: `band -> dban`
// - *Allocates Using Provided Allocator*
rotate_right :: proc(s: string, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	// guard clauses
	if len(s) == 0 || len(s) == 1 {
		return s, nil
	}
	
	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return // err is of type mem.Allocator_Error
	strings.write_rune(&b, rune(s[len(s) - 1]))
	// code goes here
	for val in 0 ..< len(s) - 1 {
		strings.write_rune(&b, rune(s[val]))
	}
	final_string = strings.to_string(b)
	
	return final_string, nil
}


// Returns a string with the characters rotated `k` spots to the right:
// - *Allocates Using Provided Allocator*
// - For Example: if `k` = 3 -> 'apple' -> 'pleap'
rotate_right_num :: proc(s: string, k: int = 1, allocator := context.allocator) -> string  {
	res := s
	_k := k
	if k > len(s) { _k = k % len(s) }
	for _ in 0 ..< _k {
		res = rotate_right(res, allocator)
	}
	return res
}


rpartition :: proc(str, sep: string) -> (head, match, tail: string) {
	i := strings.last_index(str, sep)
	if i == -1 {
		head = str
		return
	}

	head = str[:i]
	match = str[i:i+len(sep)]
	tail = str[i+len(sep):]
	return
}

// string.rsplit(separator, maxsplit) 
// In Python rsplit and split are the same except when you use maxsplit. For now, I just treat both as the same.
rsplit :: strings.split

split :: strings.split

splitlines :: strings.split_lines

startswith :: strings.starts_with


// Returns the string made from repeating the rune `r` `n` times.
// - *Allocates Using Provided Allocator*
// - For Example: string_from_repeated_rune('a', 5) -> "aaaaa"
string_from_repeated_rune :: proc(r: rune, n: int, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	b: strings.Builder
	strings.builder_init_len_cap(&b, 0, n, allocator) or_return // err is of type mem.Allocator_Error
	// code goes here
	for _ in 0 ..< n {
		strings.write_rune(&b, r)
	}
	final_string = strings.to_string(b)
	
	return final_string, nil
}


// Removes all characters that are not a letter, a number or a space.
strip_punctuation :: proc(s: string, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return // err is of type mem.Allocator_Error
	// code goes here
	for val in s {
		if isalnum(val) || val == ' ' {
			strings.write_rune(&b, val)
		}
	}
	final_string = strings.to_string(b)
	
	return final_string, nil
}

// Removes all characters that are not a letter or a number.
// - *Allocates Using Provided Allocator*
// - "a man, a plan, a canal: panama" -> "amanaplanacanalpanama"
strip_punctuation_and_spaces :: proc(s: string, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return // err is of type mem.Allocator_Error
	// code goes here
	for val in s {
		if isalnum(val) {
			strings.write_rune(&b, val)
		}
	}
	final_string = strings.to_string(b)
	
	return final_string, nil
}

swapcase :: proc(s: string, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return // err is of type mem.Allocator_Error
	// code goes here
	for val in s {
		if islower(val) {
			strings.write_rune(&b, to_upper_rune(val))
		} else if isupper(val) {
			strings.write_rune(&b, to_lower_rune(val))
		}
	}
	final_string = strings.to_string(b)
	
	return final_string, nil
}

title :: proc(s: string, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	s_as_slice := split(s, " ", allocator) or_return
	for &val in s_as_slice {
		val = capitalize(val, allocator) or_return
	}
	final_string = strings.join(s_as_slice, " ", allocator) or_return
	
	return final_string, nil
}



// The `translate` function in Python is more complex than this one, but this one will suffice for now.
// Returns a string where some specified characters are replaced with the characters described in a map.
translate :: proc(s: string, d: map[string]string, allocator := context.allocator) -> string {
	_s := s
	ok : bool
	for key, val in d {
		_s, ok = strings.replace(_s, key, val, -1, allocator)
	}
	return _s
}

// NOTE: mem.Allocator_Error and runtime.Allocator_Error are the same thing!
// --> (in core:mem/alloc.odin) Allocator_Error :: runtime.Allocator_Error

upper :: proc(s: string, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return // err is of type mem.Allocator_Error
	// code goes here
	for val in s {
        uppercase_val := unicode.to_upper(val)
        strings.write_rune(&b, uppercase_val)
    }
	final_string = strings.to_string(b)
	
	return final_string, nil
}

zfill :: proc(s: string, length: int, allocator := context.allocator, loc := #caller_location) -> (final_string: string, err: runtime.Allocator_Error) #optional_allocator_error {
	num_of_zeroes_to_add := length - len(s)
	if num_of_zeroes_to_add < 0 {num_of_zeroes_to_add = 0}
	max_len := max(len(s), length)

	b: strings.Builder
	strings.builder_init(&b, 0, max_len, allocator) or_return // err is of type mem.Allocator_Error
	// code goes here
	for _ in 0 ..< num_of_zeroes_to_add {
		strings.write_string(&b, "0")
	}
	strings.write_string(&b, s)
	final_string = strings.to_string(b)
	
	return final_string, nil
}


// ------------------------------------------------------------------------------------------------


// oooo                  oooo                                      .o88o.                                       .    o8o                                 
// `888                  `888                                      888 `"                                     .o8    `"'                                 
//  888 .oo.    .ooooo.   888  oo.ooooo.   .ooooo.  oooo d8b      o888oo  oooo  oooo  ooo. .oo.    .ooooo.  .o888oo oooo   .ooooo.  ooo. .oo.    .oooo.o 
//  888P"Y88b  d88' `88b  888   888' `88b d88' `88b `888""8P       888    `888  `888  `888P"Y88b  d88' `"Y8   888   `888  d88' `88b `888P"Y88b  d88(  "8 
//  888   888  888ooo888  888   888   888 888ooo888  888           888     888   888   888   888  888         888    888  888   888  888   888  `"Y88b.  
//  888   888  888    .o  888   888   888 888    .o  888           888     888   888   888   888  888   .o8   888 .  888  888   888  888   888  o.  )88b 
// o888o o888o `Y8bod8P' o888o  888bod8P' `Y8bod8P' d888b         o888o    `V88V"V8P' o888o o888o `Y8bod8P'   "888" o888o `Y8bod8P' o888o o888o 8""888P' 
//                              888                                                                                                                      
//                             o888o                                                                                                                     


// helper function for `format`
@(private = "file")
contains_curly_brace_pattern :: proc(text: string) -> [dynamic]string {
	list_of_strings_in_curly_braces := make([dynamic]string, context.temp_allocator)
	n := len(text)
	valid_match_start := false
	valid_match_end := false

	for i := 0; i < n; i += 1 {
		// check for opening `{`
		if text[i] == '{' {
			j := i + 1
			valid_match_start = true
			// check for closing `}`
			for j < n && text[j] != '}' {
				j += 1
			}
			if text[j] == '}' {
				valid_match_end = true
			}
			// if you found both, append the contents to `list_of_strings_in_curly_braces`
			if valid_match_start && valid_match_end && j < n {
				append(&list_of_strings_in_curly_braces, text[i:j + 1])
			}
		}
	}
	return list_of_strings_in_curly_braces
}


//              .              .o o.   
//            .o8             .8' `8.  
//  .oooo.o .o888oo oooo d8b .8'   `8. 
// d88(  "8   888   `888""8P 88     88 
// `"Y88b.    888    888     88     88 
// o.  )88b   888 .  888     `8.   .8' 
// 8""888P'   "888" d888b     `8. .8'  
//   

// overloaded function
@(private = "file")
str :: proc {
	str_int_to_string,
	str_float_to_string,
	str_string_to_string,
	str_u8_to_string,
}


/*
Converets the passed integer to a string

*Allocates Using Provided Allocator*
*/
@(private = "file")
str_int_to_string :: proc(n: int, allocator := context.allocator) -> string {
	b := strings.builder_make(allocator)
	strings.write_int(&b, n)
	final_string := strings.to_string(b)

	return final_string
}

/*
Converets the passed integer to a string

*Allocates Using Provided Allocator*
*/
@(private = "file")
str_float_to_string :: proc(n: f64, allocator := context.allocator) -> string {
	b := strings.builder_make(allocator)
	strings.write_f64(&b, n, 'g')
	final_string := strings.to_string(b)

	return final_string
}

/*
Converets the passed string to a string (on the heap)

*Allocates Using Provided Allocator*
*/
@(private = "file")
str_string_to_string :: proc(s: string, allocator := context.allocator) -> string {
	b := strings.builder_make(allocator)
	strings.write_string(&b, s)
	final_string := strings.to_string(b)

	return final_string
}

/*
Converets the passed string to a string (on the heap)

*Allocates Using Provided Allocator*
*/
@(private = "file")
str_u8_to_string :: proc(num: u8, allocator := context.allocator) -> string {
	num_as_rune := rune(num)
	
	b := strings.builder_make(allocator)
	strings.write_rune(&b, num_as_rune)
	final_string := strings.to_string(b)

	return final_string
}

// may need to be updated as language progresses
@(private = "file")
reserved_words := []string{
    // keywords
	"alias", "any", "assert", "break", "case",
    "cast", "chan", "complex", "continue", "defer",
    "else", "enum", "false", "fallthrough", "for", "func",
    "if", "import", "in", "interface", "len",
    "load", "matrix", "nil", "or", "package",
    "proc", "quaternion", "return", "rune", "struct",
    "switch", "true", "union", "using", "when",
    "where",
	// compiler directives
    "align", "any_int", "assert", "bounds_check",
    "no_bounds_check", "by_ptr", "c_vararg", "caller_expression",
    "caller_location", "column_major", "row_major", "config",
    "const", "defined", "exists", "file", "directory",
    "line", "procedure", "force_inline", "force_no_inline", "load",
    "load_directory", "load_hash", "location", "max_field_align",
    "no_alias", "no_broadcast", "no_copy", "no_nil", "shared_nil",
    "optional_allocator_error", "optional_ok", "packed", "panic",
    "partial", "raw_union", "reverse", "simd", "soa",
    "sparse", "subtype", "type", "unroll",
	// types
	"bool", "b8", "b16", "b32", "b64",
    "int", "i8", "i16", "i32", "i64", "i128",
    "uint", "u8", "u16", "u32", "u64", "u128", "uintptr",
    "i16le", "i32le", "i64le", "i128le", "u16le", "u32le", "u64le", "u128le",
    "i16be", "i32be", "i64be", "i128be", "u16be", "u32be", "u64be", "u128be",
    "f16", "f32", "f64",
    "f16le", "f32le", "f64le",
    "f16be", "f32be", "f64be",
    "complex32", "complex64", "complex128",
    "quaternion64", "quaternion128", "quaternion256",
    "string", "cstring",
    "rawptr", "typeid",
    "any",
}

@(private = "file")
first_letter_is_capitalized_and_everything_else_is_lowercase :: proc(s: string) -> bool {
	punctuation_marks := []rune{
		'.', ',', ';', ':', '!', '?', '-', // Standard punctuation
		'\'', '"', // Quotation marks
		'(', ')', '[', ']', '{', '}', // Parentheses, brackets, braces
		'/', '\\', // Slash, backslash
		'@', '#', '$', '%', '^', '&', '*', // Symbols
		'_', '=', '+', '<', '>', // Underscore, equals, plus, less/greater than
		'|', // Pipe
		'~', // Tilde
	}
	is_punctuation_mark : bool
	is_number : bool
	
	if len(s) == 0 {
		return false
	}
	if len(s) == 1 {
		if unicode.is_upper(rune(s[0])) {
			return true
		} else {
			return false
		}
	} else if len(s) > 1 {
		if unicode.is_upper(rune(s[0])) {
			for i in 1..< len(s) {
				// check if punctuation mark
				if slice.contains(punctuation_marks, rune(s[i])) {
					is_punctuation_mark = true
				} else {
					is_punctuation_mark = false
				}

				// check if number
				if unicode.is_digit(rune(s[i])) {
					is_number = true
				} else {
					is_number = false
				}
				
				// check if lowercase letter
				if is_punctuation_mark == false && is_number == false {
					if !unicode.is_lower(rune(s[i])) {
						return false
					}
				}
			}
		} else {
			return false
		}
	}
	return true
}

// Returns the uppercase value of the rune `r`
to_upper_rune :: proc(r: rune) -> rune {
	r_as_int := int(r)
	if r_as_int < 97 || r_as_int > 122 {
		print(">>>> ERROR: `to_upper_rune` only works with ascii values `a` to `z`.")
		panic(">>>> ERROR: `to_upper_rune` only works with ascii values `a` to `z`.")
	}
	
	r_as_int -= 32
	return rune(r_as_int)
}

// Returns the lowercase value of the rune `r`
to_lower_rune :: proc(r: rune) -> rune {
	r_as_int := int(r)
	if r_as_int < 65 || r_as_int > 90 {
		print(">>>> ERROR: `to_upper_rune` only works with ascii values `A` to `Z`.")
		panic(">>>> ERROR: `to_upper_rune` only works with ascii values `Z` to `Z`.")
	}
	
	r_as_int += 32
	return rune(r_as_int)
}

// Strips a string to its unique characters, in the same order
strip_to_unique :: proc(s: string, allocator := context.allocator) -> (final_string: string, err: mem.Allocator_Error) #optional_allocator_error {
	local_dict := make(map[rune]struct {}, context.allocator)
	defer delete(local_dict)

	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return // err is of type mem.Allocator_Error
	for val in s {
		if val not_in local_dict {
			local_dict[val] = {}
			strings.write_rune(&b, val)
		}
	}
	final_string = strings.to_string(b)

	return final_string, nil
}


// Given a list of strings, returns the shortest one
// - uses `context.temp_allocator`
@(deprecated = "Use `get_shortest_word()`")
get_shortest_word_00 :: proc(l: []string) -> string {
    Word_With_Length :: struct {
        word: string,
        length: int,
    }

    local_array := make([dynamic]Word_With_Length, context.temp_allocator)
    for val in l {
        append(&local_array, Word_With_Length{val, len(val)})
    }

	// I kept this for this line (although I don't use this function) 
	// since it shows how to do the sort_by() stuff which may come in handy later.
    slice.sort_by(local_array[:], proc(i, j: Word_With_Length) -> bool {return i.length < j.length})

    return local_array[0].word
}


// Given a list of strings, returns the shortest one
get_shortest_word :: proc(l: []string) -> string {
	min_length := INT_MAX
	res := ""
	for val in l {
		if len(val) < min_length {
			min_length = len(val)
			res = val
		}
	}
	return res
}

is_vowel :: proc {
    is_vowel_rune,
    is_vowel_u8,
}


/*
Determines whether a given rune represents a vowel (A, E, I, O, U, a, e, i, o, u).

Inputs:
- r: rune (The character to check)

Returns:
- result: bool (True if the rune is a vowel, False otherwise)

Example:
```
    result_00 := is_vowel('a')
    result_01 := is_vowel('b')

    fmt.println(result_00) // Output: true
    fmt.println(result_01) // Output: false
```
Returns:
```
    true
    false
```
*/
is_vowel_rune :: proc(r: rune) -> bool {
    _r := u8(r)
    vowel_mask := u128(
        1<<'A' | 1<<'E' | 1<<'I' | 1<<'O' | 1<<'U' | 
        1<<'a' | 1<<'e' | 1<<'i' | 1<<'o' | 1<<'u'
    )

    return (vowel_mask & (1<<_r)) != 0
}


is_vowel_u8 :: proc(r: u8) -> bool {
    vowel_mask := u128(
        1<<'A' | 1<<'E' | 1<<'I' | 1<<'O' | 1<<'U' | 
        1<<'a' | 1<<'e' | 1<<'i' | 1<<'o' | 1<<'u'
    )

    return (vowel_mask & (1<<r)) != 0
}


is_consonant :: proc {
	is_consonant_rune,
	is_consonant_u8,
}


/*
Determines whether a given rune represents a consonant (any alphabetic character that is not a vowel).

Inputs:
- r: rune (The character to check)

Returns:
- result: bool (True if the rune is a consonant, False otherwise)

Example:
```
	result_00 := is_consonant_rune('b') 
	result_01 := is_consonant_rune('a') 
	result_02 := is_consonant_rune('1')

	fmt.println(result_00) // Output: true 
	fmt.println(result_01) // Output: false 
	fmt.println(result_02) // Output: false
```
Returns:
```
    true
    false
	false
```
*/
is_consonant_rune :: proc(r: rune) -> bool {
    _r := u8(r)
    is_alpha := (_r >= 'A' && _r <= 'Z') || (_r >= 'a' && _r <= 'z')
    return is_alpha && !is_vowel_rune(r)
}

is_consonant_u8 :: proc(r: u8) -> bool {
    is_alpha := (r >= 'A' && r <= 'Z') || (r >= 'a' && r <= 'z')
    return is_alpha && !is_vowel_u8(r)
}

// odinfmt: enable

