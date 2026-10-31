// The resupply area a placed VC ammo crate makes. It spawns the MutExtras crate (which every explosive can destroy)
// instead of the base game one.
class ACVCPlaceableAmmoResupply extends ROVCPlaceableAmmoResupply;

DefaultProperties
{
	PhysicalAmmoCrateClass=class'ACVCPlaceableAmmoResupplyCrate'
}
