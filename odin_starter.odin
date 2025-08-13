package test

import "core:fmt"
import "core:mem"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:math"
import "core:sys/windows"
import "core:time"
import "core:unicode"
import p_str "python_string_functions"
import p_list "python_list_functions"
import p_int "python_int_functions"
import p_float "python_float_functions"
import p_heap "python_heap_functions"
print :: fmt.println
printf :: fmt.printf

DEBUG_MODE :: true

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

    elapsed: time.Duration = time.since(start)
    print("Odin took:", elapsed)


}
