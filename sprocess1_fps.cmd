#-----------------------------------
# 2D NPN Vertical Bipolar Transistor
#-----------------------------------

line x location= 4.0<um> spacing= 0.1<um> tag= SubTop
line x location= 5.0<um> spacing= 0.1<um>
line x location= 6.0<um> spacing= 0.7<um> tag= SubBottom
line y location= 0.0<um> spacing= 6.00<um> tag= SubLeft    
line y location= 18.0<um> spacing= 6.00<um>
line y location= 18.5<um> spacing= 0.50<um>
line y location= 30.0<um> spacing= 0.50<um> tag= SubRight   

# Global Mesh settings for automatic meshing in newly generated layers
# --------------------------------------------------------------------


grid set.normal.growth.ratio.2d= 1.1 set.min.normal.size= 50<nm>
mgoals accuracy= 2e-5 

# Define layout masks
# -------------------

# (Note: n-type emitter is also used as contact to collector.)
# Masks are listed in the order they are used.

# Masks for front end processing .....

mask name= Sinker  segments= {-1 22 24 35}       negative
mask name= Base    segments= {-1 1.5 13 35}      negative
mask name= Emitter segments= {-1 2.5 8 22 24 35} negative

# Masks for back end processing .....

mask name= Contact segments= {-1 3.5 7 10 12 22.5 23.5 35} 
mask name= Metal   segments= {-1 2 8 9 13 22 24 35} negative


region Silicon xlo= SubTop xhi= SubBottom ylo= SubLeft yhi= SubRight
init concentration= 1e+15<cm-3> field= Boron 

AdvancedCalibration

# Buried layer
# ------------

deposit material= {Oxide} type= isotropic time= 1 rate= {0.025}
implant Antimony dose= 1.5e15<cm-2> energy= 100<keV> 
etch material= {Oxide} type= anisotropic time= 1 rate= {0.03}

# Epi layer
# ---------

deposit material= {Silicon} type= isotropic time= 1 rate= {4.0} Arsenic concentration= 1e15<cm-3>
diffuse temp= 1100<C> time= 60<min> 

struct tdr= n@node@_vert_npn1

# Show the final profiles
# -----------------------

SetPlxList {BTotal SbTotal AsTotal PTotal}
WritePlx n@node@_Buried.plx y=5.0

# Sinker (beginning of 2D problem)
# --------------------------------

###
refinebox Silicon min= {0 20.0} max= {3.0 26.0} xrefine= {0.25 0.25} yrefine= {0.25 0.25} 
grid remesh
###

deposit material= {Oxide} type= isotropic time= 1 rate= {0.05}
photo mask= Sinker thickness= 1
implant Phosphorus dose= 5e15<cm-2> energy= 200<keV>
strip Photoresist 
diffuse temp= 1100<C> time= 5<hr>

struct tdr= n@node@_vert_npn2

# Base
# ----

# Refine the mesh in the base region before the base implant.

refinebox Silicon min= {0 0.2} max= {1.5 14.4} xrefine= {0.1 0.1 0.2} yrefine= {0.1 0.2 0.1} 
grid remesh

photo mask= Base thickness= 1
implant Boron dose= 1e14<cm-2> energy= 50<keV> 
strip Photoresist
diffuse temp= 1100<C> time= 35<min> 

struct tdr= n@node@_vert_npn3

# Emitter
# -------

# Refine the mesh in the emitter region before the emitter implant.


photo mask= Emitter thickness= 1
implant Arsenic dose= 5e15<cm-2> energy= 55<keV> tilt= 7 rotation= 0 
strip Photoresist
diffuse temp= 1100<C> time= 25<min> 

struct tdr= n@node@_vert_npn4

# Show the final profiles
# -----------------------

SetPlxList {BTotal SbTotal AsTotal PTotal}
WritePlx n@node@_Final.plx  y= 5.0
WritePlx n@node@_Sinker.plx y= 23.0

# Back end
# --------

etch material= {Oxide} type= anisotropic time= 1 rate= {0.055} mask= Contact

# Reset the mgoals params to lower mesh requirements above silicon.

grid set.normal.growth.ratio.2d= 20.0 set.min.normal.size= 300<nm>
mgoals accuracy= 2e-5 

deposit material= {Aluminum} type= isotropic   time= 1 rate= {1.0}
etch    material= {Aluminum} type= anisotropic time=1 rate= {1.1} mask= Metal

struct tdr= n@node@_vert_npn5

exit





