// The resupply area a placed US ammo crate makes. It spawns the MutExtras crate (which every explosive can destroy)
// instead of the base game one, and explosives wait between refills (ACExplosiveResupply).
class ACUSPlaceableAmmoResupply extends ROUSPlaceableAmmoResupply;

function ResupplyTimer()
{
	class'ACExplosiveResupply'.static.Get(self).CrateTimer(self);
}

DefaultProperties
{
	PhysicalAmmoCrateClass=class'ACUSPlaceableAmmoResupplyCrate'
}
