//=============================================================================
// ROWeap_VietSatchel
//=============================================================================
// "First Person Weapon" for the Vietnamese Satchel Charge
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Nate Steger @ Antimatter Games LTD
//=============================================================================
class ACWeap_VietSatchel extends ROSatchelChargeWeapon
	abstract;

defaultproperties
{
	WeaponContentClass(0)="MutExtras.ACWeap_VietSatchel_Content"
	RoleSelectionImage(0)=Texture'ui_textures.Textures.sov_wp_f1nade'
	InvIndex=INDEX_NONE
	PlayerViewOffset=(X=1,Y=5,Z=-2)
	ShoulderedPosition=(X=3,Y=3.5,Z=-1.0)
	ShoulderRotation=(Pitch=-300,Yaw=500,Roll=1500)
	//RoleEncumbranceModifier=0.25
	FuzeLength=7.0

	WeaponProjectiles(0)=class'ACSatchelChargeProjectile'
	WeaponProjectiles(1)=class'ACSatchelChargeProjectile'
}
