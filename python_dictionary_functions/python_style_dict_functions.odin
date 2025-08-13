package python_dictionary_functions

import "core:mem"

clear :: clear_map

copy :: proc {
    copy_map_string_int,
    copy_map_int_int,
}

copy_map_string_int :: proc(d: map[string]int, allocator := context.allocator) -> map[string]int {
    local_map := make(map[string]int, allocator)
    for key, val in d {
        local_map[key] = val
    }

    return local_map
}

copy_map_int_int :: proc(d: map[int]int, allocator := context.allocator) -> map[int]int {
    local_map := make(map[int]int, allocator)
    for key, val in d {
        local_map[key] = val
    }

    return local_map
}


fromkeys :: proc {
    fromkeys_string_int,
    fromkeys_int_int,
}

fromkeys_string_int :: proc(l: []string, n: int, allocator := context.allocator) -> map[string]int {
    local_dict := make(map[string]int, allocator)

    for val in l {
        local_dict[val] = n
    }

    return local_dict
}

fromkeys_int_int :: proc(l: []int, n: int, allocator := context.allocator) -> map[int]int {
    local_dict := make(map[int]int, allocator)

    for val in l {
        local_dict[val] = n
    }

    return local_dict
}

get_value_from_key :: proc {
    get_value_string_int,
}


// Returns the value for key if key is in the dictionary, else `default_return_value`.
@(require_results)
get_value_string_int :: proc(dict: map[string]int, test_key: string, default_return_value := 0) -> int {
    if test_key in dict {
        return dict[test_key]
    }
    
    return default_return_value
}