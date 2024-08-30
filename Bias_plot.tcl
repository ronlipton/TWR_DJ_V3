set n0data [load_file Bias_n198_des.plt]
set n1data [load_file Bias_n228_des.plt]
set n2data [load_file Bias_n251_des.plt]
#set n3data [load_file Bias_n251_des.plt]
# gain calculation
create_variable -dataset $n0data -function {1/(1-<MaxSemiconductor eIonIntegral:Bias_n198_des>)} -name gain0
create_variable -dataset $n1data -function {1/(1-<MaxSemiconductor eIonIntegral:Bias_n228_des>)} -name gain1
create_variable -dataset $n2data -function {1/(1-<MaxSemiconductor eIonIntegral:Bias_n251_des>)} -name gain2

set datalst {}
lappend datalst $n0data
lappend datalst $n1data 
lappend datalst $n2data
#lappend datalst $n3data 
#lappend datalst $n0data
set plot_1 [create_plot -1d]
set VI1 [create_curve -axisX {Cathode OuterVoltage} -axisY {Cathode TotalCurrent} -dataset $datalst -plot Plot_1]
set_axis_prop -plot Plot_1 -axis y -type log
set IInt [create_curve -axisX {Cathode OuterVoltage} -axisY2 {MaxSemiconductor eIonIntegral} -dataset $datalst -plot Plot_1]

set plot_2 [create_plot -1d]
set EGain [create_curve -axisX {Cathode OuterVoltage} -axisY {Pos(2.6,0) ElectricField} -dataset $datalst -plot Plot_2]
set EDrift [create_curve -axisX {Cathode OuterVoltage} -axisY {Pos(5,0) ElectricField} -dataset $datalst -plot Plot_2]

# Gain Plots
set plot_3 [create_plot -1d]
set Gain0 [create_curve -axisX {Cathode OuterVoltage} -axisY gain0 -dataset $n0data -plot Plot_3]
set Gain1 [create_curve -axisX {Cathode OuterVoltage} -axisY gain1 -dataset $n1data -plot Plot_3]
set Gain2 [create_curve -axisX {Cathode OuterVoltage} -axisY gain2 -dataset $n2data -plot Plot_3]
