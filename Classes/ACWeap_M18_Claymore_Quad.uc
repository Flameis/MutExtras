//-----------------------------------------------------------
// Modified projectile that is allowed to have 4 at a time
// Edited for the 29th by Reimer, Tested and Published by Scovel
//-----------------------------------------------------------
class ACWeap_M18_Claymore_Quad extends ROWeap_M18_Claymore;

DefaultProperties
{
	InitialNumPrimaryMags=4
	MaxAmmoCount=4
	WeaponContentClass(0)="MutExtras.ACWeap_M18_Claymore_Quad_Content"
	PlantedChargeClass=class'ACM18ClaymoreMine'

	WeaponProjectiles(0)=class'ACM18ClaymoreMine'
}
