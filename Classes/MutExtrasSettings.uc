class MutExtrasSettings extends MutatorSettings;

/**
 * @brief Initializes the settings screen for this mutator
 */
function InitMutSettings()
{
	//Int

	//Bool
	if (self.myMut == None){self.SetIntPropertyByName(name(Repl("bAITRoles", ".", "_")), int(class'MutExtras'.default.bAITRoles));}
	else{self.SetIntPropertyByName(name(Repl("bAITRoles", ".", "_")), int(MutExtras(self.myMut).bAITRoles));};
}

/**
 * @brief Saves the settings for this mutator
 */
function SaveMutSettings()
{
	//Int

	//Bool
	if (self.myMut == None) {self.GetIntPropertyByName(name(Repl("bAITRoles", ".", "_")), tempValue); class'MutExtras'.default.bAITRoles = (self.tempValue != 0);}
	else {self.GetIntPropertyByName(name(Repl("bAITRoles", ".", "_")), tempValue); MutExtras(self.myMut).bAITRoles  = (self.tempValue != 0);}

	if (self.myMut != None)
		self.myMut.SaveConfig();
	else
		class'MutExtras'.static.StaticSaveConfig();
}


defaultproperties
{
    SettingsGroups(0)=(GroupID="Settings",pMin=1000,pMax=1100,lMin=0,lMax=0)

	Properties.Add((PropertyId=1000,Data=(Type=SDT_Int32,Value1=0)))

	PropertyMappings.Add((Id=1000,Name="bAITRoles"))
}