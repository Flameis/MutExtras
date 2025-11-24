//=============================================================================
// ROWeap_M79_GrenadeLauncher
//=============================================================================
// M79 40mm "Thumper" Grenade Launcher
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ACWeap_M79_GrenadeLauncher extends ROWeap_M79_GrenadeLauncher
	  abstract;
	  
defaultproperties
{
	WeaponContentClass(0)="MutExtras.ACWeap_M79_GrenadeLauncher_Content" // HE Only

	AmmoContentClassStart=1
	// Class below here are available only through selecting alternative ammo loadouts
	WeaponContentClass(1)="MutExtras.ACWeap_M79_GrenadeLauncher_Level2" // HE + Buckshot
	WeaponContentClass(2)="MutExtras.ACWeap_M79_GrenadeLauncher_Level3"	// HE + Smoke
	RoleSelectionImage(0)=Texture2D'VN_UI_Textures.WeaponTex.US_Weap_M79_GrenadeLauncher'
	RoleSelectionImage(1)=Texture2D'VN_UI_Textures.WeaponTex.US_Weap_M79_GrenadeLauncher'
	RoleSelectionImage(2)=Texture2D'VN_UI_Textures.WeaponTex.US_Weap_M79_GrenadeLauncher'

	// HE and Buckshot mixture
	AltAmmoLoadouts(0)=(WeaponContentClassIndex=1)
	// HE and Smoke
	AltAmmoLoadouts(1)=(WeaponContentClassIndex=2)

	InitialNumPrimaryMags=13
	MaxNumPrimaryMags=13
	AmmoClass=class'ACAmmo_40x46_M79Grenade'
	
	SightRanges[0]=(SightRange=50,SightPitch=0,SightSlideOffset=0.0,SightPositionOffset=-0.0, AddedPitch=300)
	SightRanges[1]=(SightRange=75,SightPitch=-16384,SightSlideOffset=-0.1,SightPositionOffset=-0.35, AddedPitch=450)
	SightRanges[2]=(SightRange=100,SightPitch=-16384,SightSlideOffset=0.05,SightPositionOffset=-0.75, AddedPitch=450)
	SightRanges[3]=(SightRange=125,SightPitch=-16384,SightSlideOffset=0.27,SightPositionOffset=-1.24, AddedPitch=450)
	SightRanges[4]=(SightRange=150,SightPitch=-16384,SightSlideOffset=0.45,SightPositionOffset=-1.66, AddedPitch=500)
	SightRanges[5]=(SightRange=175,SightPitch=-16384,SightSlideOffset=0.67,SightPositionOffset=-2.2, AddedPitch=500)
	SightRanges[6]=(SightRange=200,SightPitch=-16384,SightSlideOffset=0.9,SightPositionOffset=-2.74, AddedPitch=500)
	SightRanges[7]=(SightRange=225,SightPitch=-16384,SightSlideOffset=1.2,SightPositionOffset=-3.45, AddedPitch=450)
	SightRanges[8]=(SightRange=250,SightPitch=-16384,SightSlideOffset=1.49,SightPositionOffset=-4.15, AddedPitch=450)
	SightRanges[9]=(SightRange=275,SightPitch=-16384,SightSlideOffset=1.83,SightPositionOffset=-4.93, AddedPitch=400)
	SightRanges[10]=(SightRange=300,SightPitch=-16384,SightSlideOffset=2.25,SightPositionOffset=-5.94, AddedPitch=325)
	//SightRanges[11]=(SightRange=325,SightPitch=-16384,SightSlideOffset=2.7,SightPositionOffset=-7.0)
	//SightRanges[12]=(SightRange=350,SightPitch=-16384,SightSlideOffset=3.3,SightPositionOffset=-8.43)
	//SightRanges[13]=(SightRange=375,SightPitch=-16384,SightSlideOffset=4.3,SightPositionOffset=-9.8)

	SuppressionPower=25

	bSyncSightRangeIndex = true
	
	PlayerIronSightFOV=55.0//55.0
}