elaborate -library gaisler apbuart
create_clock -period 10 clk
set_input_delay -clock clk 0 [all_inputs]
set_output_delay -clock clk 0 [all_output]
create_port -direction in testen
create_port -direction in testrst
create_port -direction in testin
create_port -direction out testout

compile_ultra -scan

set_scan_configuration \
    -style multiplexed_flip_flop \
    -clock_mixing mix_edges \
    -lockup_type flip_flop \
    -chain_count 1

set_dft_signal -view existing_dft -type ScanClock -port clk -timing {45 55}
# set_dft_signal -view existing_dft -type Reset -port testrst -active_state 1

set_dft_signal -view spec -type ScanEnable -port testen -active_state 1
set_dft_signal -view spec -type ScanDataIn  -port testin
set_dft_signal -view spec -type ScanDataOut  -port testout

set_scan_path -view spec \
    -scan_data_in testin \
    -scan_data_out testout \
    -scan_master_clock clk  "c_sys"

create_test_protocol
dft_drc -verbose
insert_dft
dft_drc -verbose

change_names -hier -rules verilog
write -f verilog -hier [current_design_name] -output apbuart.vg
write_scan_def -output apbuart.def
set_app_var test_stil_netlist_format verilog
write_test_protocol -output apbuart.spf
