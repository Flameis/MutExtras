//=============================================================================
// ROWeaponVietSatchel_Content
//=============================================================================
// Content for the Vietnamese Satchel Charge
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Nate Steger @ Antimatter Games LTD
//=============================================================================
class ACWeap_VietSatchel_Content extends ACWeap_VietSatchel;

DefaultProperties
{
	Begin Object Name=FirstPersonMesh
		DepthPriorityGroup=SDPG_Foreground
		SkeletalMesh=SkeletalMesh'MutExtrasTBPkg.Satchel.Sov_Satchel'
		PhysicsAsset=PhysicsAsset'MutExtrasTBPkg.Satchel.Sov_Satchel_Physics'
		AnimSets(0)=AnimSet'MutExtrasTBPkg.Satchel.WP_SatchelHands'
		AnimTreeTemplate=AnimTree'MutExtrasTBPkg.Satchel.Sov_Satchel_Tree'
		Scale=1.0
		FOV=70
	End Object

	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'MutExtrasTBPkg.Satchel.Rus_Satchel_3rd_Master'
		PhysicsAsset=PhysicsAsset'MutExtrasTBPkg.Satchel.Rus_Satchel_3rd_Master_Physics'
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=true//false
		BlockRigidBody=true
		bHasPhysicsAssetInstance=false
		bUpdateKinematicBonesFromAnimation=false
		PhysicsWeight=1.0
		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
		bSkipAllUpdateWhenPhysicsAsleep=TRUE
		bSyncActorLocationToRootRigidBody=true
	End Object

	AttachmentClass=class'MutExtras.ACWeapAttach_VietSatchel'

	ArmsAnimSet=AnimSet'MutExtrasTBPkg.Satchel.WP_SatchelHands'
}
