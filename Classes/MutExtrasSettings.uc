class MutExtrasSettings extends MutatorSettings
	config(MutExtras_Server);

/**
 * @brief Initializes the settings screen for this mutator
 */
function InitMutSettings()
{
	//Bool
	if (self.myMut == None){self.SetIntPropertyByName(name(Repl("bUseDefaultFactions", ".", "_")), int(class'MutExtras'.default.bUseDefaultFactions));}
	else{self.SetIntPropertyByName(name(Repl("bUseDefaultFactions", ".", "_")), int(MutExtras(self.myMut).bUseDefaultFactions));};

	//Enum
	if (self.myMut == None){self.SetIntPropertyByName(name(Repl("MySouthForce (USA = 0, USMC = 1, AUS = 2, ARVN = 3)", ".", "_")), int(class'MutExtras'.default.MySouthForce));}
	else{self.SetIntPropertyByName(name(Repl("MySouthForce (USA = 0, USMC = 1, AUS = 2, ARVN = 3)", ".", "_")), int(MutExtras(self.myMut).MySouthForce));};

	if (self.myMut == None){self.SetIntPropertyByName(name(Repl("MyNorthForce (PAVN = 0, NLF = 1)", ".", "_")), int(class'MutExtras'.default.MyNorthForce));}
	else{self.SetIntPropertyByName(name(Repl("MyNorthForce (PAVN = 0, NLF = 1)", ".", "_")), int(MutExtras(self.myMut).MyNorthForce));};

	//Bool
	if (self.myMut == None){self.SetIntPropertyByName(name(Repl("bAITRoles", ".", "_")), int(class'MutExtras'.default.bAITRoles));}
	else{self.SetIntPropertyByName(name(Repl("bAITRoles", ".", "_")), int(MutExtras(self.myMut).bAITRoles));};

	if (self.myMut == None){self.SetIntPropertyByName(name(Repl("bSmokeForEveryone", ".", "_")), int(class'MutExtras'.default.bSmokeForEveryone));}
	else{self.SetIntPropertyByName(name(Repl("bSmokeForEveryone", ".", "_")), int(MutExtras(self.myMut).bSmokeForEveryone));};

	if (self.myMut == None){self.SetIntPropertyByName(name(Repl("bLightGetGrenade", ".", "_")), int(class'MutExtras'.default.bLightGetGrenade));}
	else{self.SetIntPropertyByName(name(Repl("bLightGetGrenade", ".", "_")), int(MutExtras(self.myMut).bLightGetGrenade));};

	if (self.myMut == None){self.SetIntPropertyByName(name(Repl("bAllAITWeapons", ".", "_")), int(class'MutExtras'.default.bAllAITWeapons));}
	else{self.SetIntPropertyByName(name(Repl("bAllAITWeapons", ".", "_")), int(MutExtras(self.myMut).bAllAITWeapons));};

	// if (self.myMut == None){self.SetIntPropertyByName(name(Repl("bMACVSOGRoles", ".", "_")), int(class'MutExtras'.default.bMACVSOGRoles));}}
	// else{self.SetIntPropertyByName(name(Repl("bMACVSOGRoles", ".", "_")), int(MutExtras(self.myMut).bMACVSOGRoles));};
}

/**
 * @brief Saves the settings for this mutator
 */
function SaveMutSettings()
{
	local ENorthernForces MyNorthForce;
	local ESouthernForces MySouthForce;

	//Bool
	if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("bUseDefaultFactions", ".", "_")), tempValue); class'MutExtras'.default.bUseDefaultFactions = (self.tempValue != 0);}
	else {self.GetIntPropertyByName(name(Repl("bUseDefaultFactions", ".", "_")), tempValue); MutExtras(self.myMut).bUseDefaultFactions  = (self.tempValue != 0);}

	//Enum
	if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("MyNorthForce (PAVN = 0, NLF = 1)", ".", "_")), tempValue);
		if (self.tempValue == 0)
			MyNorthForce = NFOR_NVA;
		else
			MyNorthForce = NFOR_NLF;
		class'MutExtras'.default.MyNorthForce = MyNorthForce;}
	else {self.GetIntPropertyByName(name(Repl("MyNorthForce (PAVN = 0, NLF = 1)", ".", "_")), tempValue);
		if (self.tempValue == 0)
			MyNorthForce = NFOR_NVA;
		else
			MyNorthForce = NFOR_NLF;
		MutExtras(myMut).MyNorthForce = MyNorthForce;}

	if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("MySouthForce (USA = 0, USMC = 1, AUS = 2, ARVN = 3)", ".", "_")), tempValue);
		if (self.tempValue < 4)
			MySouthForce = ESouthernForces(tempValue);
		else
			MySouthForce = SFOR_USarmy;
		class'MutExtras'.default.MySouthForce = MySouthForce;}
	else {self.GetIntPropertyByName(name(Repl("MySouthForce (USA = 0, USMC = 1, AUS = 2, ARVN = 3)", ".", "_")), tempValue); 
		if (self.tempValue < 4)
			MySouthForce = ESouthernForces(tempValue);
		else
			MySouthForce = SFOR_USarmy;
		MutExtras(myMut).MySouthForce = MySouthForce;}

	//Bool
	if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("bAITRoles", ".", "_")), tempValue); class'MutExtras'.default.bAITRoles = (self.tempValue != 0);}
	else {self.GetIntPropertyByName(name(Repl("bAITRoles", ".", "_")), tempValue); MutExtras(self.myMut).bAITRoles  = (self.tempValue != 0);}

	if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("bSmokeForEveryone", ".", "_")), tempValue); class'MutExtras'.default.bSmokeForEveryone = (self.tempValue != 0);}
	else {self.GetIntPropertyByName(name(Repl("bSmokeForEveryone", ".", "_")), tempValue); MutExtras(self.myMut).bSmokeForEveryone  = (self.tempValue != 0);}

	if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("bLightGetGrenade", ".", "_")), tempValue); class'MutExtras'.default.bLightGetGrenade = (self.tempValue != 0);}
	else {self.GetIntPropertyByName(name(Repl("bLightGetGrenade", ".", "_")), tempValue); MutExtras(self.myMut).bLightGetGrenade  = (self.tempValue != 0);}

	if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("bAllAITWeapons", ".", "_")), tempValue); class'MutExtras'.default.bAllAITWeapons = (self.tempValue != 0);}
	else {self.GetIntPropertyByName(name(Repl("bAllAITWeapons", ".", "_")), tempValue); MutExtras(self.myMut).bAllAITWeapons  = (self.tempValue != 0);}

	// if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("bMACVSOGRoles (Not finished)", ".", "_")), tempValue); class'MutExtras'.default.bMACVSOGRoles = (self.tempValue != 0);}
	// else {self.GetIntPropertyByName(name(Repl("bMACVSOGRoles", ".", "_")), tempValue); MutExtras(self.myMut).bMACVSOGRoles  = (self.tempValue != 0);}

	if (self.myMut != None)
		self.myMut.SaveConfig();
	else
		class'MutExtras'.static.StaticSaveConfig();
}


defaultproperties
{
    SettingsGroups(0)=(GroupID="Settings",pMin=1000,pMax=1100,lMin=0,lMax=0)

	Properties.Add((PropertyId=1000,Data=(Type=SDT_Int32,Value1=0)))
	PropertyMappings.Add((Id=1000,Name="bUseDefaultFactions"))

	Properties.Add((PropertyId=1001,Data=(Type=SDT_Int32,Value1=0)))
	PropertyMappings.Add((Id=1001,Name="MyNorthForce (PAVN = 0, NLF = 1)"))
	
	Properties.Add((PropertyId=1002,Data=(Type=SDT_Int32,Value1=0)))
	PropertyMappings.Add((Id=1002,Name="MySouthForce (USA = 0, USMC = 1, AUS = 2, ARVN = 3)"))

	Properties.Add((PropertyId=1003,Data=(Type=SDT_Int32,Value1=0)))
	PropertyMappings.Add((Id=1003,Name="bAITRoles"))

	// Properties.Add((PropertyId=1004,Data=(Type=SDT_Int32,Value1=0)))
	// PropertyMappings.Add((Id=1004,Name="bSmokeForEveryone"))

	// Properties.Add((PropertyId=1005,Data=(Type=SDT_Int32,Value1=0)))
	// PropertyMappings.Add((Id=1005,Name="bLightGetGrenade"))

	// Properties.Add((PropertyId=1006,Data=(Type=SDT_Int32,Value1=0)))
	// PropertyMappings.Add((Id=1006,Name="bAllAITWeapons"))

	// Properties.Add((PropertyId=1004,Data=(Type=SDT_Int32,Value1=0)))
	// PropertyMappings.Add((Id=1004,Name="bMACVSOGRoles"))
}