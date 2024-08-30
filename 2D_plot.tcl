set n130tdr [load_file n130_des.tdr ]
set plot130 [create_plot -dataset $n130tdr]
set_field_prop Abs(ElectricField-V) -plot $plot130 -geom n130_des -show_bands
# set_field_prop ImpactIonization 
set mydata130 [create_cutline -dataset $n130tdr -type free -points { 0 0 10 0}]
set plotcut1 [create_plot -dataset $mydata130 -1d]
set c130 [create_curve -axisX X -axisY Abs(ElectricField-V) -dataset $mydata130 -plot $plotcut1]
