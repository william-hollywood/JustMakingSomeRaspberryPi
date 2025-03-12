cmake_minimum_required(VERSION 3.13...3.27)

# initialize the SDK based on PICO_SDK_PATH
# note: this must happen before project()
include(pico_sdk_import.cmake)

project(my_project)


# initialize the Raspberry Pi Pico SDK
pico_sdk_init()

# rest of your project

add_executable(blink
    src.c
)

target_compile_definitions(blink PRIVATE
        PICO_TIME_DEFAULT_ALARM_POOL_DISABLED=1
        PICO_NO_FPGA_CHECK=1 # small but may as well
        )
pico_set_printf_implementation(blink none)
pico_set_float_implementation(blink none)
pico_set_double_implementation(blink none)

# Add pico_stdlib library which aggregates commonly used features
target_link_libraries(blink pico_stdlib)

# create map/bin/hex/uf2 file in addition to ELF.
pico_add_extra_outputs(blink)
