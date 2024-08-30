create_curve -axisX {Cathode OuterVoltage} -axisY {MaxSemiconductor eIonIntegral} -dataset {Bias_n9_des Bias_n7_des Bias_n5_des} -plot Plot_1
#-> Curve_1 Curve_2 Curve_3
create_curve -axisX {Cathode OuterVoltage} -axisY2 {Cathode TotalCurrent} -dataset {Bias_n9_des Bias_n7_des Bias_n5_des} -plot Plot_1
#-> Curve_4 Curve_5 Curve_6
set_axis_prop -plot Plot_1 -axis y2 -type log
#-> 0
set_curve_prop {Curve_4} -plot Plot_1 -line_width 3
#-> 0
set_curve_prop {Curve_6} -plot Plot_1 -line_width 3
#-> 0
set_curve_prop {Curve_3} -plot Plot_1 -line_width 3
#-> 0
set_curve_prop {Curve_1} -plot Plot_1 -line_width 3
#-> 0
set_curve_prop {Curve_2} -plot Plot_1 -line_width 3
