//=============================================================================
// ROAmmo_1143x23_M3A1Mag
//=============================================================================
// Ammo properties for the 114.3 x 23mm (.45 ACP) M3A1 Greasegun magazine
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ACAmmo_1143x23_CIWS extends ROAmmunition
    abstract;

defaultproperties
{
    CompatibleWeaponClasses(0)=class'MutExtras.ACWeap_CIWS'

    InitialAmount=1000000
	Weight=0.8
	ClipsPerSlot=3
}
