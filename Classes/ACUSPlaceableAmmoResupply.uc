// The resupply area a placed US ammo crate makes. It spawns the MutExtras crate (which every explosive can destroy)
// instead of the base game one.
class ACUSPlaceableAmmoResupply extends ROUSPlaceableAmmoResupply;

DefaultProperties
{
	PhysicalAmmoCrateClass=class'ACUSPlaceableAmmoResupplyCrate'
}
