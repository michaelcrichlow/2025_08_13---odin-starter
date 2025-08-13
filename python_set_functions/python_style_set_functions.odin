package python_set_functions


// Returns everything in `set_01` that's not in `set_02` as a []string
// - Allocatates Using Provided Allocator
difference :: proc(set_01, set_02: map[string]struct{}, allocator := context.allocator) -> []string {
    local_array := make([dynamic]string, allocator)
    for val in set_01 {
        if val not_in set_02 {
            append(&local_array, val)
        }
    }
    return local_array[:]
}