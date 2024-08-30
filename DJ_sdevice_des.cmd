####################################################
############ Current - Voltage Curve  ##############
####################################################


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
	{name="fp" Voltage=0.0}
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
	
}

CurrentPlot { 
  eIonIntegral (Maximum (Semiconductor)) 
  hIonIntegral (Maximum (Semiconductor))
  ElectricField ((.7 0) (.93 0) (2.6 0) (5. 0) (8. 0) (.93, 17) (2.6 17) (5 17) (8 17))
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
	ComputeIonizationIntegrals
	BreakAtIonizationIntegral (1 .95)
	#NoAutomaticCircuitContact

  	BreakCriteria {
	   Current (Contact = "Anode" maxval = 1e-8 minval = -1e-8)
	}


}

Solve {
	NewCurrentPrefix="Bias_"
	Coupled (Iterations=50) {Poisson}
	Coupled (Iterations=15) {Hole Poisson}
	Coupled (Iterations=15) {Electron Hole Poisson}
	
	QuasiStationary (
		BreakCriteria {Current(Contact = "Anode" Absval = 1e-8) }
		InitialStep = 1e-6
		MaxStep = 0.01
		MinStep = 1e-9
		Goal {Name="Anode" Voltage=-50}
		Plot {Range = (0 1) Intervals=5}
		) {
#	Save(FilePrefix="VBD_n@node@")
	Coupled {Hole Electron Poisson}
	Plot (
		FilePrefix="IV_" 
#		Time=(0.01; 0.05; 0.1; 0.5)
		Time=(0.5)
		NoOverwrite
		)
	
	}
}
