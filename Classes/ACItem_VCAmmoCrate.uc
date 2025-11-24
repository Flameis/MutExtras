// ROItem_VCPlaceableAmmoCrate
//=============================================================================
// A VC version of the placeable Ammo Crate.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Nate Steger @ Antimatter Games LTD
//============================================================================

class ACItem_VCAmmoCrate extends ACItem_AmmoCrate;

DefaultProperties
{
	WeaponContentClass(0)="MutExtras.ACItem_VCAmmoCrate_Content"
	
	RoleSelectionImage(0)=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_mg' //TODO: Give me a proper one soon!

	AmmoCrateClass=Class'ROGame.ROVCPlaceableAmmoResupply'
    PhysicalAmmoCrateClass=Class'ACVCPlaceableAmmoResupplyCrate'
    ClassConstructorProxy=Class'ROGame.ROVCAmmoCreateConstructorProxy'
}