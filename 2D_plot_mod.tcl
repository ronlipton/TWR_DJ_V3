#set n130tdr [load_file n130_des.tdr ]
#  set n140tdr [load_file n140_des.tdr ]
set n0tdr [load_file n198_des.tdr ]
set n1tdr [load_file n228_des.tdr ]
set n2tdr [load_file n251_des.tdr ]
set datalst {}
##
lappend datalst $n0tdr
lappend datalst $n1tdr
lappend datalst $n2tdr

#set plot130 [create_plot -dataset $n130tdr]

set plot0 [create_plot -dataset [lindex $datalst 0] ]
set plot1 [create_plot -dataset [lindex $datalst 1] ]
set plot2 [create_plot -dataset [lindex $datalst 2] ]
set pltlst {}
lappend pltlst $plot0
lappend pltlst $plot1
lappend pltlst $plot2

# link_plots {$plot130 $plot148} -id 1
set_region_prop {Aluminum_2.1} -plot $plot0 -geom [lindex $datalst 0] -on
set_region_prop {Aluminum_2.2} -plot $plot0 -geom [lindex $datalst 0] -on
set_region_prop {Aluminum_2.3} -plot $plot0 -geom [lindex $datalst 0] -on
set_region_prop {Aluminum_2.4} -plot $plot0 -geom [lindex $datalst 0] -on
set_region_prop {Aluminum_2.5} -plot $plot0 -geom [lindex $datalst 0] -on
# 0

link_plots $pltlst
# E Field vs Depth
set_field_prop Abs(ElectricField-V) -plot $plot0 -geom [lindex $datalst 0] -show_bands
set mydata0 [create_cutline -dataset [lindex $datalst 0] -type free -points { 0 0 10 0}]
set mydata1 [create_cutline -dataset [lindex $datalst 1] -type free -points { 0 0 10 0}]
set mydata2 [create_cutline -dataset [lindex $datalst 2] -type free -points { 0 0 10 0}]
set plotcut1 [create_plot -dataset [lindex $datalst 0]  -1d]
# 
set c0 [create_curve -axisX X -axisY Abs(ElectricField-V) -dataset $mydata0 -plot $plotcut1 ]
set c1 [create_curve -axisX X -axisY Abs(ElectricField-V) -dataset $mydata1 -plot $plotcut1 ]
set c2 [create_curve -axisX X -axisY Abs(ElectricField-V) -dataset $mydata2 -plot $plotcut1 ]
#
# E Field at gain layer
set mydata0 [create_cutline -dataset [lindex $datalst 0] -type free -points { 2.0 0 2.5 60}]
set mydata1 [create_cutline -dataset [lindex $datalst 1] -type free -points { 2.0 0 2.5 60}]
set mydata2 [create_cutline -dataset [lindex $datalst 2] -type free -points { 2.0 0 2.5 60}]
set plotcut3 [create_plot -dataset [lindex $datalst 0]  -1d]
# 
set c0 [create_curve -axisX Y -axisY Abs(ElectricField-V) -dataset $mydata0 -plot $plotcut3 ]
set c1 [create_curve -axisX Y -axisY Abs(ElectricField-V) -dataset $mydata1 -plot $plotcut3 ]
set c2 [create_curve -axisX Y -axisY Abs(ElectricField-V) -dataset $mydata2 -plot $plotcut3 ]
set_axis_prop -plot $plotcut3 -axis y -type log

# Ionization Intergral near Surface
set_field_prop  ImpactIonization -plot $plot0 -geom [lindex $datalst 0] -show_bands
set II0 [create_cutline -dataset [lindex $datalst 0] -type free -points { 1 0 1 60}]
set II1 [create_cutline -dataset [lindex $datalst 1] -type free -points { 1 0 1 60}]
set II2 [create_cutline -dataset [lindex $datalst 2] -type free -points { 1 0 1 60}]

set plotcut2 [create_plot -dataset [lindex $datalst 0] -1d]
set IIC0 [create_curve -axisX Y -axisY ImpactIonization -dataset $II0 -plot $plotcut2 ]
set IIC1 [create_curve -axisX Y -axisY ImpactIonization -dataset $II1 -plot $plotcut2 ]
set IIC2 [create_curve -axisX Y -axisY ImpactIonization -dataset $II2 -plot $plotcut2 ]

#  
