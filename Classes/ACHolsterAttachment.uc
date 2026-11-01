class ACHolsterAttachment extends ROItemAttach_BinocularsUS;

defaultproperties
{
    WeaponClass=class'ACHolster'
    CHR_AnimSet=AnimSet'MutExtrasContent.Anims.Salute'

	ThirdPersonHandsAnim=AttentionIdleAnimV2
	ThirdPersonHandsIronAnim=AttentionIdleAnimV2

    FireAnim=SaluteAnimV2
	FireLastAnim=SaluteAnimV2
	IdleAnim=AttentionIdleAnimV2
	IdleEmptyAnim=AttentionIdleAnimV2

	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=none
		PhysicsAsset=none
		CullDistance=5000
	End Object
}