//=============================================================================
// ROWeap_XM21Scoped_Rifle
//=============================================================================
// The XM21 Scoped rifle, featuring the AR TEL autoranging scope system.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Austin "dibbler67" Ware for Antimatter Games LTD
//=============================================================================
class ACWeap_XM21Scoped_Rifle extends ROWeap_XM21Scoped_Rifle
	abstract;

defaultproperties
{
	WeaponContentClass(0)="ROGameContent.ROWeap_XM21Scoped_Rifle_Content"
	// WeaponContentClass(1)="ROGameContent.ROWeap_XM21Scoped_Rifle_Level2"
	WeaponContentClass(1)="MutExtras.ACWeap_XM21Scoped_Rifle_Suppressed"

	RoleSelectionImage(0)=Texture2D'VN_UI_Textures.WeaponTex.US_Weap_XM21_SniperRifle'
	RoleSelectionImage(1)=Texture2D'VN_UI_Textures.WeaponTex.US_Weap_XM21_Suppressed'
	//RoleSelectionImage(1)=MaterialInstanceConstant'UI_Mats.RoleSelectMenu.sov_wp_svt_sniper_UPGRD1_MIC'
	//RoleSelectionImage(2)=MaterialInstanceConstant'UI_Mats.RoleSelectMenu.sov_wp_svt_sniper_UPGRD1_MIC'

}
