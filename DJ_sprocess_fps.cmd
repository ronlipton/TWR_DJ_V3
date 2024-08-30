# Open the file for reading
set file [open "sp_params.txt" r]

# Read the contents of the file
set file_contents [read $file]

# Close the file
close $file

# Use the contents of the file as commands
eval $file_contents



# modify swb values
 set edboron @EDeepp@
 set edphos  @EDeepn@
 set ddboron @DDeepp@
 set ddphos  @DDeepn@

set ndump 1
set Dname "DTDR_"
# set Dump 1

set dpix [expr 2.*($xwidth)/$npix]
set nwwid [expr ($dpix/2-$dwell)]
set alwid [expr $nwwid-$alovr]
set pc [expr -$xwidth+$dpix/2.]
set dpixac [expr 2.*($xwidth)/$npixac]
set pcac [expr -$xwidth+$dpixac/2.]

# define grid
line x loc=$xlow spacing=.5 tag=sublow
line x loc=$xhigh spacing=.5 tag=subhigh
line y loc=$ylow spacing=.5 tag=subleft
line y loc=$yhigh spacing=.5 tag=subright

# remeshing strategy
grid set.min.normal.size=50<nm> set.normal.growth.ratio.2d=1.2

region Silicon xlo=sublow xhi=subhigh ylo=subleft yhi=subright
init field=Boron concentration=$epiconc

# 3/14/24 Add Epi process - not workinig ....
# pdbSet Silicon Dopant DiffModel Pair

# diffuse temperature= 800<C> time= 60<min> Epi thick= 10<um> epi.doping= {boron=$epiconc}

# Masks
#############
# AC edge implant contacts
set acpdlst {}
# electrode positions
set acpady {}
if {$LGType == 0} {
  set sinl [expr -$xwidth] 
  set sinr [expr  $xwidth]
  mask name=nitride segments = {$sinl $sinr}  negative
  set acoxl [expr -$xwidth-$jtewidth]
  set acoxh [expr $xwidth+$jtewidth]
  mask name=axcon segments =  {$acoxl $acoxh}

for {set npac 1} {$npac <= $npixac} {incr npac} {
    set aclow [expr $pcac - $acpdwid]
    set achigh [expr $pcac + $acpdwid]
    lappend acpady [expr ($aclow+$achigh)/2.]
    lappend acpdlst $aclow
    lappend acpdlst $achigh 
    set pcac [expr $pcac + $dpixac]
    }
    
# added edge al
  lappend acpdlst [expr $ylow]
  lappend acpdlst [expr -$xwidth] 
  lappend acpdlst $xwidth
  lappend acpdlst $yhigh

mask name=acpads segments = $acpdlst negative
}

# pixel masks ------  Test
set plow [expr $pc-$nwwid]
set mlist {}
set jtelst {}
set oxlst {}
set allst {}
set pslst []

for {set np 1} {$np <= $npix} {incr np} {
    set plow [expr $pc-$nwwid]
    set phigh [expr $pc+$nwwid]
    lappend mlist $plow 
    lappend mlist $phigh
    

    if {$np < $npix} {
     set psc [expr $pc + $dpix/2]
     set pslow [expr $psc - $PSWid_2]
     set pshigh [expr $psc + $PSWid_2]
     lappend pslst $pslow
     lappend pslst $pshigh
    }
    
    set jl1 [expr $plow - $jtewidth]
    set jh1 [expr $phigh + $jtewidth]
    lappend jtelst $jl1
    lappend jtelst $plow
    lappend jtelst $phigh
    lappend jtelst $jh1
    
    set olow [expr $pc-$chwid]
    set ohigh [expr $pc+$chwid]
    lappend oxlst $olow
    lappend oxlst $ohigh
    
    set allow [expr $pc - $alwid]
    set alhigh [expr $pc + $alwid]
    lappend allst $allow
    lappend allst $alhigh 
# field plates
    lappend allst [expr $pc - $nwwid - $m2_fpwid_2]
    lappend allst [expr $pc - $nwwid + $m2_fpwid_2]
    lappend allst [expr $pc + $nwwid - $m2_fpwid_2]
    lappend allst [expr $pc + $nwwid + $m2_fpwid_2]    
    
    
    set pc [expr $pc + $dpix]
}
# edge contacts for DC 
lappend mlist $ylow
lappend mlist [expr $ylow+6]
lappend mlist [expr $yhigh-6]
lappend mlist $yhigh

lappend oxlst $ylow
lappend oxlst [expr $ylow+3]
lappend oxlst [expr $yhigh-3]
lappend oxlst $yhigh

lappend allst $ylow
lappend allst [expr $ylow+8]
lappend allst [expr $yhigh-8]
lappend allst $yhigh

# deep implant mask
set djbl [expr -$xwidth-$dtrench+$binset]
set djbh [expr  $xwidth+$dtrench-$binset]
mask name=deepjb segments = {$djbl $djbh}

# Phosphorus
set djpl [expr -$xwidth-$dtrench+$pinset]
set djph [expr  $xwidth+$dtrench-$pinset]
mask name=deepjp segments = {$djpl $djph}

mask name=ntop segments = $mlist
mask name=jte segments = $jtelst
mask name=moxide segments = $oxlst
mask name=pgain segments = $mlist
mask name=Altop segments = $allst negative
mask name=pstop segments = $pslst

AdvancedCalibration
math coord.ucs
# STI process and thermal A not yet included
# Anneal A 

# flip
transform flip

implant Boron energy=$pppenergy dose=$pppconc tilt=$tilt

transform flip
deposit material= {SiO2} type=anisotropic time=1.0 rate= .01

# implant deep junction
if {$Deep == 1} {
 photo mask=deepjb thickness=10
 set ddboron_2 [expr $ddboron/2]
 set ddphos_2 [expr $ddphos/2]
 set mtilt [expr -$tilt]

 implant Boron dose=$ddboron_2 energy=$edboron tilt=$tilt rotation=22
 implant Boron dose=$ddboron_2 energy=$edboron tilt=$mtilt rotation=22
 strip resist
 
 photo mask=deepjp thickness=10 
 implant Phosphorus dose=$ddphos_2 energy=$edphos tilt=$tilt rotation=22
 implant Phosphorus dose=$ddphos_2 energy=$edphos tilt=$mtilt rotation=22
 strip resist
 
  if {$Dump == 1} {
   set TDRname [string cat $Dname $ndump ".tdr"]
   struct tdr=$TDRname
   set ndump [expr $ndump+1]
 }
}

# implant JTE
if { $JTE == 1} {
set mtilt [expr -$tilt]
set jteconc_2 [expr $jteconc/2]
photo mask=jte  thickness=5
implant Phosphorus energy=$jteenergy1 dose=$jteconc_2 tilt=$tilt
implant Phosphorus energy=$jteenergy2 dose=$jteconc_2 tilt=$tilt
implant Phosphorus energy=$jteenergy1 dose=$jteconc_2 tilt=$mtilt
implant Phosphorus energy=$jteenergy2 dose=$jteconc_2 tilt=$mtilt
strip resist
 if {$Dump == 1} {
   set TDRname [string cat $Dname $ndump ".tdr"]
   struct tdr=$TDRname
   set ndump [expr $ndump+1]
 }
}

# implant pstop
if {$SPStop == 1} {
photo mask=pstop  thickness=1
implant Boron energy=$pstopenergy dose=$psconc tilt=$tilt
strip resist
}


# anneal B
struct tdr=pre_anneal
diffuse temp=$Bannltemp time=$Bannltime

# modify per Julie process
if { $glayer == 1} {
# implant p gain layer 
photo mask=pgain thickness=5
set glconc_2 [expr $glconc/2]
implant Boron energy=$glenergy dose=$glconc_2 tilt=$tilt
implant Boron energy=$glenergy dose=$glconc_2 tilt=$mtilt
strip resist
 if {$Dump == 1} {
   set TDRname [string cat $Dname $ndump ".tdr"]
   struct tdr=$TDRname
   set ndump [expr $ndump+1]
 }
}

# implant ac/pixel layer
photo mask=ntop thickness= 1.0
if { $LGType == 0 } {
  implant Phosphorus energy=$acenergy dose=$acconc tilt=$tilt
} else {
  implant Phosphorus energy=$npenergy dose=$npconc tilt=$tilt
}
strip resist

# Anneal C
diffuse time=27<s> temp=850
diffuse time=55<s> temp=1050
diffuse time=39<s> temp=1050
diffuse time=11<s> temp=850
diffuse time=12<s> temp=1050

# Gate formation (needed?)
# Anneal D
diffuse temp=$Dannltemp time=$Dannltime

# Isolation implant and Vth (not needed?)
# Anneal E
diffuse time=7200 temp=750
temp_ramp name=CycleE temperature=600 time=2<s> ramprate=175<C/s>
temp_ramp name=CycleE temperature=950 time=7<s> ramprate=-50<C/s> last
diffuse temp.ramp=CycleE

# sidewall formation
# Anneal F
temp_ramp name=CycleF temperature=600 time=2<s> ramprate=225<C/s>
temp_ramp name=CycleF temperature=1050 time=8<s> ramprate=-56.25<C/s> last
diffuse temp.ramp=CycleF

# Isolation implant 2
# anneal G
diffuse temp=$Gannltemp  time=$Gannltime
struct tdr=Test2

# Remove screening oxide
etch material= {SiO2} anisotropic etchstop= {silicon} time= 1 rate= 0.01

# flip
transform flip

# deposit anode
deposit material= {Aluminum} type=anisotropic time=1.0 rate= {$tmetal}

# flip
transform flip


set mtop [expr -($tdiel + $tmetal)] ; # define metal top for cmp
if {$LGType == 1} {
# deposit SiO2
	deposit material= {SiO2} type=anisotropic time=1.0 rate= {$tox} mask= moxide
# deposit anode
	deposit material= {Aluminum} type=isotropic time=1.0 rate= {2} mask= Altop
} else {
# deposit nitride and pads
	deposit material= {Si3N4} type= anisotropic time=1.0 rate= {$tdiel} mask= nitride
	deposit material= {SiO2} type=anisotropic time=1.0 rate= {$tox} mask= axcon
	deposit material= {Aluminum} type= anisotropic time=1.0 rate= {2} mask= acpads
}

etch type= cmp coord= $mtop material= all
 if {$Dump == 1} {
   set TDRname [string cat $Dname $ndump ".tdr"]
   struct tdr=$TDRname
   set ndump [expr $ndump+1]
 }
# remesh
# remesh
refinebox clear
refinebox clear.interface.mats
refinebox !keep.lines
line clear

pdbSet Grid SnMesh DelaunayType boxmethod
pdbSet Grid Adaptive 1
pdbSet Grid AdaptiveField Refine.Abs.Error 1e37
pdbSet Grid AdaptiveField Refine.Rel.Error 1e10
pdbSet Grid AdaptiveField Refine.Target.Length 10.0

refinebox interface.materials=silicon

refinebox min= {0 $ylow} max= {$xhigh $yhigh} refine.fields= {NetActive} refine.min.edge = {0.05 0.05} refine.max.edge = {1 1}  def.max.asinhdiff= 0.5

grid remesh

set mmid [expr $mtop+$tmetal/2]
if {$LGType == 1} {
 set pc [expr -$xwidth+$dpix/2]
 set cname "Cont"
 for {set np 1} {$np <= $npix} {incr np} {
     append cname $np
     contact name=$cname x=$mmid y=$pc point
     # define field plates
#     if {$Deep == 1} {
         contact name="fp" x=$mmid y=[expr $pc - $nwwid] point add
	 contact name="fp" x=$mmid y=[expr $pc + $nwwid] point add
     set pc [expr $pc +$dpix]
     set cname "Cont"
#       }
     }
 set yloc [expr  $ylow+1]
 contact name= CL x=$mmid y=$yloc point
 set yloc [expr $yhigh-1]
 contact name= CR x=$mmid y=$yloc point

} else {
 set cname "Cont"
 set n1 [expr $npixac-1]
 for {set np1 0} {$np1 <= $n1} {incr np1} {
     set name [string cat $cname $np1]
     puts $name
     set yloc [lindex $acpady $np1]
     contact name=$name x=$mmid y=$yloc point
     }
}

set xc [expr ($thick+$tmetal/2)]
contact name= Anode x=$xc y=0 point

puts "DOE: edboron  @EDeepp@"
puts "DOE: edphos   @EDeepn@"

struct tdr=LGAD_V$version$npix$npixac$LGType$Deep$JTE$glayer
struct tdr=n@node@

exit
