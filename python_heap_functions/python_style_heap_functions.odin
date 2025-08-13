package python_heap_functions

import "core:slice"
// import p_list "odin_tests/python_list_functions"

copy :: slice.clone_to_dynamic

/*  
---- EXAMPLE USE CASES ----
main :: proc() {

	when DEBUG_MODE {
		// tracking allocator
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf(
					"=== %v allocations not freed: context.allocator ===\n",
					len(track.allocation_map),
				)
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track.bad_free_array) > 0 {
				fmt.eprintf(
					"=== %v incorrect frees: context.allocator ===\n",
					len(track.bad_free_array),
				)
				for entry in track.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}

		// tracking temp_allocator
		track_temp: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track_temp, context.temp_allocator)
		context.temp_allocator = mem.tracking_allocator(&track_temp)

		defer {
			if len(track_temp.allocation_map) > 0 {
				fmt.eprintf(
					"=== %v allocations not freed: context.temp_allocator ===\n",
					len(track_temp.allocation_map),
				)
				for _, entry in track_temp.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track_temp.bad_free_array) > 0 {
				fmt.eprintf(
					"=== %v incorrect frees: context.temp_allocator ===\n",
					len(track_temp.bad_free_array),
				)
				for entry in track_temp.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track_temp)
		}
	}

    // main work
    print("Hello from Odin!")
    windows.SetConsoleOutputCP(windows.CODEPAGE.UTF8)
    start: time.Time = time.now()

    // code goes here
    // arr := []int{3, 1, 4, 1, 5, 9, 2}
    arr := make([dynamic]int, context.temp_allocator)
    append(&arr, 3, 1, 4, 1, 5, 9, 2)
    heapify(arr[:])
    print(arr)  // Output: [1, 1, 2, 3, 5, 9, 4] (heap order may vary)

    heappush(&arr, 0)
    print(arr)

    heappush(&arr, 10)
    print(arr)
    print("")

    // min_value := heappop(&arr)
    // print(min_value)  // Output: 0 (smallest element)
    N := len(arr)
    for _ in 0 ..< N {
        print(heappop(&arr))
        print(arr)
    }
    // print(nsmallest(arr[:], 2))

    // append(&arr, 2, 5, 10, 2, 0, 1, 7, 2, 8, 8, 12)
    append(&arr, 2, 5, 10, 3, 0, 1, 7, 4, 6, 8, 9)
    print(arr)

    heapify(arr[:])
    print(arr)

    M := len(arr)
    for _ in 0 ..< M {
        print(heappop(&arr))
        print(arr)
    }

    heappush(&arr, 0)
    print(arr)
    heappush(&arr, 1)
    print(arr)
    heappush(&arr, 50)
    print(arr)
    heappush(&arr, 12)
    print(arr)
    heappush(&arr, 7)
    print(arr)
    heappush(&arr, 20)
    print(arr)

    print(heappop(&arr))
    print(arr)
    print(heappop(&arr))
    print(arr)
    print(heappop(&arr))
    print(arr)
    print(heappop(&arr))
    print(arr)
    print(heappop(&arr))
    print(arr)
    print(heappop(&arr))
    print(arr)
    print(heappop(&arr))
    print(arr)

    elapsed: time.Duration = time.since(start)
    print("Odin took:", elapsed)

    free_all(context.temp_allocator)
}
*/ 



heapify :: proc(arr: []int) {
    n := len(arr)

    // Helper function to maintain the heap property
    sift_down :: proc(arr: []int, start: int, end: int) {
        root := start
        for 2 * root + 1 <= end {  // Check if left child exists
            child := 2 * root + 1  // Left child index
            swap := root

            // Check if the left child is smaller than the root
            if arr[swap] > arr[child] {
                swap = child
            }

            // Check if the right child exists and is smaller than the current smallest
            if child + 1 <= end && arr[swap] > arr[child + 1] {
                swap = child + 1
            }

            // If no swaps are necessary, break out
            if swap == root {
                break
            }

            // Perform the swap and move down the heap
            arr[root], arr[swap] = arr[swap], arr[root]
            root = swap
        }
    }

    // Build the heap by sifting down all non-leaf nodes
    for i := n / 2 - 1; i >= 0; i -= 1 {
        sift_down(arr, i, n - 1)
    }
}

heappush :: proc(heap: ^[dynamic]int, value: int) {
    append(heap, value)

    sift_up :: proc(heap: []int, index: int) {
        idx := index
        parent := (idx - 1) / 2
        for idx > 0 && heap[idx] < heap[parent] {
            heap[idx], heap[parent] = heap[parent], heap[idx]
            idx = parent
            parent = (idx - 1) / 2
        }
    }
    sift_up(heap^[:], len(heap) - 1)  // Restore the heap property
}


heappop :: proc(heap: ^[dynamic]int) -> int {
    if len(heap) == 0 {
        return -1  // Return an error value for an empty heap
    }
    
    min_value := heap[0]
    // min_value := pop_front(heap)
    heap[0] = heap[len(heap) - 1]  // Move the last element to the root
    pop(heap)
    
    sift_down :: proc(heap: []int, index: int) {
        idx := index
        for 2 * idx + 1 < len(heap){
            child := 2 * idx + 1
            if child + 1 < len(heap) && heap[child + 1] < heap[child] {
                child += 1
            }
            if heap[idx] <= heap[child] {
                break
            }
            heap[idx], heap[child] = heap[child], heap[idx]
            idx = child
        }
    }
    sift_down(heap^[:], 0)  // Restore the heap property
    return min_value
}


nlargest :: proc(arr: []int, n: int) -> []int {
    _n := n
    if n > len(arr) {
        _n = len(arr)
    }
    local_array := copy(arr, context.temp_allocator)
    slice.reverse_sort(local_array[:])

    return local_array[:_n]  // Return the first n elements
}

nsmallest :: proc(arr: []int, n: int) -> []int {
    _n := n
    if n > len(arr) {
        _n = len(arr)
    }
    local_array := copy(arr, context.temp_allocator)
    slice.sort(local_array[:])

    return local_array[:_n]  // Return the first n elements
}


// --------------------------------------------------------------------------------------------------


