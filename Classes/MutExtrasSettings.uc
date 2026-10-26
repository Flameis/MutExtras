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
	if (self.myMut == None){self.SetIntPropertyByName(name(Repl("MySouthForce", ".", "_")), int(class'MutExtras'.default.MySouthForce));}
	else{self.SetIntPropertyByName(name(Repl("MySouthForce", ".", "_")), int(MutExtras(self.myMut).MySouthForce));};

	if (self.myMut == None){self.SetIntPropertyByName(name(Repl("MyNorthForce", ".", "_")), int(class'MutExtras'.default.MyNorthForce));}
	else{self.SetIntPropertyByName(name(Repl("MyNorthForce", ".", "_")), int(MutExtras(self.myMut).MyNorthForce));};

	//Bool
	if (self.myMut == None){self.SetIntPropertyByName(name(Repl("bAITRoles", ".", "_")), int(class'MutExtras'.default.bAITRoles));}
	else{self.SetIntPropertyByName(name(Repl("bAITRoles", ".", "_")), int(MutExtras(self.myMut).bAITRoles));};

	// if (self.myMut == None){self.SetIntPropertyByName(name(Repl("bSmokeForEveryone", ".", "_")), int(class'MutExtras'.default.bSmokeForEveryone));}
	// else{self.SetIntPropertyByName(name(Repl("bSmokeForEveryone", ".", "_")), int(MutExtras(self.myMut).bSmokeForEveryone));};

	// if (self.myMut == None){self.SetIntPropertyByName(name(Repl("bLightGetGrenade", ".", "_")), int(class'MutExtras'.default.bLightGetGrenade));}
	// else{self.SetIntPropertyByName(name(Repl("bLightGetGrenade", ".", "_")), int(MutExtras(self.myMut).bLightGetGrenade));};

	// if (self.myMut == None){self.SetIntPropertyByName(name(Repl("bAllAITWeapons", ".", "_")), int(class'MutExtras'.default.bAllAITWeapons));}
	// else{self.SetIntPropertyByName(name(Repl("bAllAITWeapons", ".", "_")), int(MutExtras(self.myMut).bAllAITWeapons));};

	if (self.myMut == None){self.SetIntPropertyByName(name(Repl("bEnableAmbientSoundFix", ".", "_")), int(class'MutExtras'.default.bEnableAmbientSoundFix));}
	else{self.SetIntPropertyByName(name(Repl("bEnableAmbientSoundFix", ".", "_")), int(MutExtras(self.myMut).bEnableAmbientSoundFix));};

	if (self.myMut == None){self.SetIntPropertyByName(name(Repl("bMACVSOGRoles", ".", "_")), int(class'MutExtras'.default.bMACVSOGRoles));}
	else{self.SetIntPropertyByName(name(Repl("bMACVSOGRoles", ".", "_")), int(MutExtras(self.myMut).bMACVSOGRoles));};

	if (self.myMut == None){self.SetIntPropertyByName(name(Repl("bAllowIntroVO", ".", "_")), int(class'MutExtras'.default.bAllowIntroVO));}
	else{self.SetIntPropertyByName(name(Repl("bAllowIntroVO", ".", "_")), int(MutExtras(self.myMut).bAllowIntroVO));};

	// Shown as "put the gunfire into demos" (on), stored as bDisableDemoGunfire (off), so a missing line means on
	if (self.myMut == None){self.SetIntPropertyByName('bDemoGunfire', int(!class'MutExtras'.default.bDisableDemoGunfire));}
	else{self.SetIntPropertyByName('bDemoGunfire', int(!MutExtras(self.myMut).bDisableDemoGunfire));};

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
	if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("MyNorthForce", ".", "_")), tempValue);
		if (self.tempValue == 0)
			MyNorthForce = NFOR_NVA;
		else
			MyNorthForce = NFOR_NLF;
		class'MutExtras'.default.MyNorthForce = MyNorthForce;}
	else {self.GetIntPropertyByName(name(Repl("MyNorthForce", ".", "_")), tempValue);
		if (self.tempValue == 0)
			MyNorthForce = NFOR_NVA;
		else
			MyNorthForce = NFOR_NLF;
		MutExtras(myMut).MyNorthForce = MyNorthForce;}

	if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("MySouthForce", ".", "_")), tempValue);
		if (self.tempValue < 4)
			MySouthForce = ESouthernForces(tempValue);
		else
			MySouthForce = SFOR_USarmy;
		class'MutExtras'.default.MySouthForce = MySouthForce;}
	else {self.GetIntPropertyByName(name(Repl("MySouthForce", ".", "_")), tempValue); 
		if (self.tempValue < 4)
			MySouthForce = ESouthernForces(tempValue);
		else
			MySouthForce = SFOR_USarmy;
		MutExtras(myMut).MySouthForce = MySouthForce;}

	//Bool
	if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("bAITRoles", ".", "_")), tempValue); class'MutExtras'.default.bAITRoles = (self.tempValue != 0);}
	else {self.GetIntPropertyByName(name(Repl("bAITRoles", ".", "_")), tempValue); MutExtras(self.myMut).bAITRoles  = (self.tempValue != 0);}

	// if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("bSmokeForEveryone", ".", "_")), tempValue); class'MutExtras'.default.bSmokeForEveryone = (self.tempValue != 0);}
	// else {self.GetIntPropertyByName(name(Repl("bSmokeForEveryone", ".", "_")), tempValue); MutExtras(self.myMut).bSmokeForEveryone  = (self.tempValue != 0);}

	// if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("bLightGetGrenade", ".", "_")), tempValue); class'MutExtras'.default.bLightGetGrenade = (self.tempValue != 0);}
	// else {self.GetIntPropertyByName(name(Repl("bLightGetGrenade", ".", "_")), tempValue); MutExtras(self.myMut).bLightGetGrenade  = (self.tempValue != 0);}

	// if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("bAllAITWeapons", ".", "_")), tempValue); class'MutExtras'.default.bAllAITWeapons = (self.tempValue != 0);}
	// else {self.GetIntPropertyByName(name(Repl("bAllAITWeapons", ".", "_")), tempValue); MutExtras(self.myMut).bAllAITWeapons  = (self.tempValue != 0);}

	if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("bEnableAmbientSoundFix", ".", "_")), tempValue); class'MutExtras'.default.bEnableAmbientSoundFix = (self.tempValue != 0);}
	else {self.GetIntPropertyByName(name(Repl("bEnableAmbientSoundFix", ".", "_")), tempValue); MutExtras(self.myMut).bEnableAmbientSoundFix  = (self.tempValue != 0);}

	if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("bMACVSOGRoles", ".", "_")), tempValue); class'MutExtras'.default.bMACVSOGRoles = (self.tempValue != 0);}
	else {self.GetIntPropertyByName(name(Repl("bMACVSOGRoles", ".", "_")), tempValue); MutExtras(self.myMut).bMACVSOGRoles  = (self.tempValue != 0);}

	if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("bAllowIntroVO", ".", "_")), tempValue); class'MutExtras'.default.bAllowIntroVO = (self.tempValue != 0);}
	else {self.GetIntPropertyByName(name(Repl("bAllowIntroVO", ".", "_")), tempValue); MutExtras(self.myMut).bAllowIntroVO  = (self.tempValue != 0);}

	if (self.myMut == None) {self.GetIntPropertyByName('bDemoGunfire', tempValue); class'MutExtras'.default.bDisableDemoGunfire = (self.tempValue == 0);}
	else {self.GetIntPropertyByName('bDemoGunfire', tempValue); MutExtras(self.myMut).bDisableDemoGunfire = (self.tempValue == 0);}

	if (self.myMut != None)
		self.myMut.SaveConfig();
	else
		class'MutExtras'.static.StaticSaveConfig();
}

// The WebAdmin page: one tab per group, a plain label for each setting, and every on/off setting as On / Off
// buttons (a value mapping of 0 and 1). Settings with a few fixed values get them as choices; four or more show
// as a drop-down list. The group names, labels and choice names are localized, so they are in the .int file
// (Localization\INT, section [<this class>]), in the same order as below.
defaultproperties
{
    SettingsGroups.Add((GroupID="Roles",pMin=1000,pMax=1010,lMin=0,lMax=0))
    SettingsGroups.Add((GroupID="Factions",pMin=1010,pMax=1020,lMin=0,lMax=0))
    SettingsGroups.Add((GroupID="Fixes",pMin=1020,pMax=1030,lMin=0,lMax=0))

    // Roles
    Properties.Add((PropertyId=1000,Data=(Type=SDT_Int32,Value1=0)))
    PropertyMappings.Add((Id=1000,Name="bAITRoles",MappingType=PVMT_IdMapped,ValueMappings=((Id=0),(Id=1))))
    Properties.Add((PropertyId=1001,Data=(Type=SDT_Int32,Value1=0)))
    PropertyMappings.Add((Id=1001,Name="bMACVSOGRoles",MappingType=PVMT_IdMapped,ValueMappings=((Id=0),(Id=1))))

    // Factions
    Properties.Add((PropertyId=1010,Data=(Type=SDT_Int32,Value1=0)))
    PropertyMappings.Add((Id=1010,Name="bUseDefaultFactions",MappingType=PVMT_IdMapped,ValueMappings=((Id=0),(Id=1))))
    Properties.Add((PropertyId=1011,Data=(Type=SDT_Int32,Value1=0)))
    PropertyMappings.Add((Id=1011,Name="MyNorthForce",MappingType=PVMT_IdMapped,ValueMappings=((Id=0),(Id=1))))
    Properties.Add((PropertyId=1012,Data=(Type=SDT_Int32,Value1=0)))
    PropertyMappings.Add((Id=1012,Name="MySouthForce",MappingType=PVMT_IdMapped,ValueMappings=((Id=0),(Id=1),(Id=2),(Id=3))))

    // Sound and fixes
    Properties.Add((PropertyId=1020,Data=(Type=SDT_Int32,Value1=0)))
    PropertyMappings.Add((Id=1020,Name="bAllowIntroVO",MappingType=PVMT_IdMapped,ValueMappings=((Id=0),(Id=1))))
    Properties.Add((PropertyId=1021,Data=(Type=SDT_Int32,Value1=0)))
    PropertyMappings.Add((Id=1021,Name="bEnableAmbientSoundFix",MappingType=PVMT_IdMapped,ValueMappings=((Id=0),(Id=1))))
    Properties.Add((PropertyId=1022,Data=(Type=SDT_Int32,Value1=0)))
    PropertyMappings.Add((Id=1022,Name="bDemoGunfire",MappingType=PVMT_IdMapped,ValueMappings=((Id=0),(Id=1))))
}
