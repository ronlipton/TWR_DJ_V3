###########################################
# Sentaurus Visual U-2022.12-SP1.
# Tcl log file.
#------------------------------------------
# Date: Mar 23, 2024. 17:43:19.
# Version: 34.2.8021373 (2.8021373)
# Mode: Interactive (GUI).
# Mesa: enabled.
# Hostname: fasic-beast1.fnal.gov.
# Machine: Linux, x86_64, x86_64.
# Kernel: 3.10.0-1160.105.1.el7.x86_64.
###########################################
set nsd @node|sdevice@
# determine sdevice node status
set status @[gproject::GetNodeStatus @node|sdevice@]@
if { $status == "done" } {
 load_file /fasic_home/lipton/synopsys/DB/TWR/svisual_vis.plt
 create_plot -1d
 select_plots {Plot_1}
 #-> Plot_1
 #-> Plot_1
 #-> V6_331100
 create_curve -axisX {Cathode OuterVoltage} -axisY {Cathode TotalCurrent} -dataset {V6_331100} -plot Plot_1
 #-> Curve_1
 set_axis_prop -plot Plot_1 -axis y -type log
 #-> 0
 create_curve -axisX {Cathode OuterVoltage} -axisY2 {MaxSemiconductor eIonIntegral} -dataset {V6_331100} -plot Plot_1
 #-> Curve_2
 set_curve_prop {Curve_2} -plot Plot_1 -label "MaxSemiconductor eIonIntegral(V6_331100)"
 #-> 0
 set IBD [probe_curve {Curve_1} -valueX -125]
 set IIBD [probe_curve {Curve_2} -valueX -125]
}
puts "DOE: IBD $IBD"
puts "DOE: IIINt $IIBD"

exit 0
 
