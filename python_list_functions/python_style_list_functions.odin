package python_list_functions

import "core:slice"
import "core:fmt"

print :: fmt.println

// ------------------------------------------------------------------------------------------------

append :: append_elem

clear :: clear_dynamic_array

copy :: slice.clone_to_dynamic

count :: slice.count 


// Extend `array` by appending elements from the iterable `l`.
extend :: proc(array: ^[dynamic]$T, l: []T) {
	for val in l {
		append(array, val)
	}
}


// Return first index of passed value. Returns `-1, false` if the value is not present.
index :: proc(array: []$T, test_val: T, loc := #caller_location) -> (res: int, ok: bool) #optional_ok {
	for val, index in array {
		if val == test_val {
			return index, true
		}
	}
	print(">>>")
    print(">>> ERROR: from `index`: Could not return index. The value " ,test_val ," does not exist in the iterable ", array, " (", loc.procedure, " ",loc.line, ":",  loc.column, ")", sep="")
    print(">>>")
	print("")
	return -1, false
}


// Return last index of passed value. Returns `-1, false` if the value is not present.
index_right :: proc(array: []$T, test_val: T, loc := #caller_location) -> (res: int, ok: bool) #optional_ok {
	#reverse for val, index in array {
		if val == test_val {
			return index, true
		}
	}
	print(">>>")
    print(">>> ERROR: from `index_right`: Could not return index. The value " ,test_val ," does not exist in the iterable ", array, " (", loc.procedure, " ",loc.line, ":",  loc.column, ")", sep="")
    print(">>>")
	print("")
	return -1, false
}


// Inserts the specified value at the specified index.
insert :: proc(array: ^[dynamic]$T, index: int, value: T) {
	local_array := copy(array[:])
	defer delete(local_array)

	// guard line
	if len(array) < index {
		append(array, value)
		return
	}

	clear(array)
	extend(array, local_array[:index])
	append(array, value)
	extend(array, local_array[index:])
}


// Removes the last index from a dynamic array
pop :: proc(l: ^[dynamic]$T, loc := #caller_location) -> T {
    return pop_index(l, len(l) - 1, loc)
}


// Removes the specified index from a dynamic array
pop_index :: proc(l: ^[dynamic]$T, idx: int, loc := #caller_location) -> T {
	if len(l) == 0 {
        print("")
		print(">>>")
        print(">>> ERROR:  from `pop_index`: Cannot perform action. Length of passed array is zero.", " (", loc.procedure, " ",loc.line, ":",  loc.column, ")", sep="")
        print(">>>")
		print("")
        panic("Length of passed array is zero.")
    }
    
    if idx >= len(l) {
        print("")
		print(">>>")
        print(">>> ERROR: from `pop_index`: `idx` out of range. `idx` == ", idx, ". Valid `idx` range is 0 -> ", len(l) - 1, ". (", loc.procedure, " ",loc.line, ":",  loc.column, ")", sep="")
        print(">>>")
		print("")
		panic("`idx` out of range.")
	}
	if idx < 0 {
		print("")
		print(">>>")
        print(">>> ERROR: from `pop_index`: `idx` must be positive. `idx` == ", idx, ". (", loc.procedure, " ",loc.line, ":",  loc.column, ")", sep="")
        print(">>>")
		print("")
        
        panic("idx must be positive.")
	}
	val := l[idx]
	ordered_remove(l, idx)

	return val
}


// Removes the first instance of a value in a dynamic array while maintaining order
// - Success: returns `index of the value removed, true`
// - Failure: returns `-1, false`
remove :: proc(array: ^$D/[dynamic]$T, value: T, loc := #caller_location) -> (res: int, ok: bool) #optional_ok {
	for val, index in array {
		if val == value {
			ordered_remove(array, index)
			return index, true
		}
	}
	print("")
	print(">>>")
    print(">>> ERROR: from `remove`: Could not remove value. The value ", value, " does not exist in the iterable ", array^, ". (", loc.procedure, " ",loc.line, ":",  loc.column, ")", sep="")
    print(">>>")
	print("")

    return -1, false
}

reverse :: slice.reverse

sort :: slice.sort

// ---------------------------------------------------------------------------------------------------

combine :: proc {
    combine_int,
    combine_string,
}


// Combines slices of ints into one
// - *Allocates Using Provided Allocator*
combine_int :: proc(nums: ..[]int, allocator := context.allocator) -> []int {
    local_array := make([dynamic]int, allocator)
    for val in nums {
        for num in val {
            append(&local_array, num)
        }
    }
    return local_array[:]
}


// Combines slices of string into one
// - *Allocates Using Provided Allocator*
combine_string :: proc(_strings: ..[]string, allocator := context.allocator) -> []string {
    local_array := make([dynamic]string, allocator)
    for val in _strings {
        for s in val {
            append(&local_array, s)
        }
    }
    return local_array[:]
}





