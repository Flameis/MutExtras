//=============================================================================
// ROWeapAttach_VietSatchel
//=============================================================================
// Weapon attchment for the Vietnamese Satchel Charge
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Nate Steger @ Antimatter Games LTD
//=============================================================================
class ACWeapAttach_VietSatchel extends ROWeaponAttachmentSatchel;

DefaultProperties
{
	ThirdPersonHandsAnim=Soviet_Satchel_HandPose
	IKProfileName=F1

	// Weapon SkeletalMesh
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'MutExtrasTBPkg.Satchel.Rus_Satchel_3rd_Master'
		PhysicsAsset=PhysicsAsset'MutExtrasTBPkg.Satchel.Sov_Satchel_Physics'
		CullDistance=5000
	End Object

	WeaponClass=class'MutExtras.ACWeap_VietSatchel'
}
