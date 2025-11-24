// ROItem_USPlaceableAmmoCrate
//=============================================================================
// A US version of the placeable Ammo Crate.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Nate Steger @ Antimatter Games LTD
//============================================================================

class ACItem_USAmmoCrate extends ACItem_AmmoCrate;

DefaultProperties
{
	WeaponContentClass(0)="MutExtras.ACItem_USAmmoCrate_Content" 
	
	RoleSelectionImage(0)=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_mg' //TODO: Give me a proper one soon!
	
	AmmoCrateClass=Class'ROGame.ROUSPlaceableAmmoResupply'
    PhysicalAmmoCrateClass=Class'ACUSPlaceableAmmoResupplyCrate'
    ClassConstructorProxy=Class'ROGame.ROUSAmmoCreateConstructorProxy'
}