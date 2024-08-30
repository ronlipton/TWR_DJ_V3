#setdep @node|-1@
load_file Bias_n@node|DJ_sdevice@_des.plt -name IVplot
set Vanode [get_variable_data "Anode OuterVoltage" -dataset IVplot ]
set Ianode [get_variable_data "Anode TotalCurrent" -dataset IVplot ]
ext::ExtractExtremum out= Vmin name= "out" y= $Vanode x= $Ianode extremum= "min"
set VExt [expr $Vmin + 5]
ext::ExtractValue out= Imin name= "out" y= $Ianode x= $Vanode xo= $VExt
exit 0
