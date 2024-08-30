####################################################
############ Current - Voltage Curve  ##############
####################################################
#setdep @node|-1@

File {
	Grid	= "@tdr@"
	Current	= "@plot@"
	Plot	= "@tdrdat@"
	current="@plot@"
	Output = "@log@"
}

Electrode {
	{Name="Anode" Voltage=0.0}
	{Name="Cont1" Voltage=0.0}
	{Name="Cont2" Voltage=0.0}
	{Name="Cont3" Voltage=0.0}
	{Name="CL" Voltage=0.0}
	{Name="CR" Voltage=0.0}
}

Physics {
	AreaFactor = 1
	Temperature = 300
	
	Mobility (
	   DopingDependence
	   eHighFieldSaturation
	   hHighFieldSaturation
	   Enormal
	   CarrierCarrierScattering
	)
	Recombination (
	   SRH (
	   	DopingDependence
	   	#TempDependence
	   	#ElectridField
	   	Tunneling(Hurkx)
	   	)	   
           Auger (withGeneration)
	   Avalanche (UniBo Eparallel)
	   Band2Band (Hurkx)
	)
	EffectiveIntrinsicDensity (OldSlotboom)
	HeavyIon (
  		Direction=(1,0)
  		Location=(0,0)
  		Time=@<0.0 + 1e-9>@
  		Length = 10
  		LET_f = 1.281741e-09
  		Wt_hi = .5
  		Gaussian
  		PicoCoulomb
  		)
}

CurrentPlot { 
eLifeTime(Maximum(material="Silicon"))
hLifeTime(Maximum(material="Silicon"))
eAvalanche(Maximum(material="Silicon"))
hAvalanche(Maximum(material="Silicon"))
RadiationGeneration(Maximum(material="Silicon"))
HeavyIonGeneration(Maximum(material="Silicon"))
}

Plot {
	eDensity hDensity
	eCurrent/Vector hCurrent/Vector
	Current/Vector
	Potential
	ElectricField/Vector
	SpaceCharge
	eMobility hMobility
	eVelocity hVelocity
	DopingConcentration
	DonorConcentration AcceptorConcentration
	srhRecombination AugerRecombination
	AvalancheGeneration
	eAvalanche hAvalanche
	TotalRecombination
	eIonIntegral 
	hIonIntegral 
	MeanIonIntegral
}

Math {
	#Cylindrical
	
	Method=Pardiso
	Number_of_threads = 4
	Stacksize=200000000
	
	Extrapolate
	Derivatives
	AvalDerivatives
	RelErrControl
	
	Iterations=15
	Notdamped=60

#	ComputeIonizationIntegrals (WriteAll)
#	ComputeIonizationIntegrals
#	BreakAtIonizationIntegral (1 .95)
	#NoAutomaticCircuitContact

  	BreakCriteria {
	   Current (Contact = "Anode" maxval = 1e-8 minval = -1e-6)
	}


}

Solve {
	NewCurrentPrefix="mipBias_"
	Coupled (Iterations=50) {Poisson}
	Coupled (Iterations=15) {Hole Poisson}
	Coupled (Iterations=15) {Electron Hole Poisson}
	
	QuasiStationary (
		BreakCriteria {Current(Contact = "Anode" Absval = 1e-8) }
		InitialStep = 1e-6
		MaxStep = 0.01
		MinStep = 1e-9
		Goal {Name="Anode" Voltage=@<Vmin + DV>@}
		Plot {Range = (0 1) Intervals=5}
		) 
        {Coupled {Poisson Electron Hole}}
 

#   load(FilePrefix="n2") 
		
   NewCurrent="MIPHI_"    
 	
   Transient (  	
   			initialtime=0 finaltime=@<0.0+5.0e-9>@
  			MaxStep=0.25
   			MinStep=1e-18 InitialStep=1e-10
			Increment=1.6 Decrement=4.0
			TurningPoints(
			(  condition ( Time( range=( 0 @<0.0 + 1e-9 - 5e-11>@ )))   value=1e-10 )		
			(  condition ( Time( @<0.0 + 1e-9 - 5e-11>@) )    value=2e-12 )
			(  condition ( Time( range=( @<0.0 + 1e-9 - 5e-11>@ @<0.0 + 1e-9 + 5e-11>@ )))   value=2e-12 )		
			)
                 )
                  { 
                  Coupled {  Poisson Electron Hole } 
                  Plot(FilePrefix="n@node@_" time=(@<0.0 + 1e-9>@;@<0.0 + 1.02e-9>@;@<0.0 + 1.1e-9>@;@<0.0 + 1.2e-9>@;@<0.0 + 1.5e-9>@) nooverwrite )
}	

}
