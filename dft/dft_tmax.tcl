read_netlist apbuart.vg
read_netlist ../../lib/tech/hcmos8d/simprims/mk180rtsc_typical.v -library
run_build_model apbuart
set_drc apbuart.spf
run_drc
add_faults -all
run_atpg -ndetects 1
report_summaries
write_patterns apbuart.stil -internal -format stil -cycle_count -nopatinfo -parallel 0 -cellnames parallel -replace
