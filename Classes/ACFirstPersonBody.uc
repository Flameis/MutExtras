// The soldier's own body in first person (ACFreeLook): a copy of the pawn's body mesh, seen only by its owner, that takes
// its pose from the pawn's mesh every frame (the game keeps animating that mesh for its owner even while hiding it). The
// head and hands are a separate mesh in the game, so the copy has neither; the upper arms are hidden too, as WW2 does,
// so the first person arms aren't doubled by the sleeves. Like WW2's, it has a near clip plane of its own, so the parts
// right at the camera aren't cut off.
class ACFirstPersonBody extends ROSkeletalMeshComponent;

function CopyFrom(SkeletalMeshComponent Source)
{
    local int i;

    SetSkeletalMesh(Source.SkeletalMesh);
    for (i = 0; i < Source.GetNumElements(); i++)
        SetMaterial(i, Source.GetMaterial(i));
    SetParentAnimComponent(Source);
    SetLightEnvironment(Source.LightEnvironment);
}

// Once attached (bones hidden before that aren't kept), and again after the mesh is swapped
function HideArms()
{
    HideArmBone('CHR_LArmUpper');
    HideArmBone('CHR_RArmUpper');
}

function HideArmBone(name Bone)
{
    if (MatchRefBone(Bone) != INDEX_NONE)
        HideBoneByName(Bone, PBO_None);
}

defaultproperties
{
    bOnlyOwnerSee=true
    CastShadow=false
    bCastDynamicShadow=false
    CollideActors=false
    BlockActors=false
    BlockZeroExtent=false
    BlockNonZeroExtent=false
    BlockRigidBody=false
    bAcceptsDynamicDecals=false
    bUpdateSkelWhenNotRendered=false
    NearClippingPlane=-5.0
}
