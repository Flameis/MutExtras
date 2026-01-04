//=============================================================================
// ACItem_CTFFlag_Content
//=============================================================================
// Content class for CTF Flag with visual meshes
//=============================================================================
// Created for the 29th Infantry Division Realism Unit
//=============================================================================

class ACItem_CTFFlag_Content extends ACItem_CTFFlag;

defaultproperties
{
	// Override carrier beam with actual mesh
	Begin Object Name=CarrierBeamComponent
		StaticMesh=StaticMesh'FX_VN_Materials.Commander.S_ENV_CommanderMark_Beam'
	End Object
	
	// Override beam base with actual mesh
	Begin Object Name=CarrierBeamBaseComponent
		StaticMesh=StaticMesh'FX_VN_Materials.Commander.S_ENV_CommanderMark_Floor'
	End Object
	
	// Override back attachment with flag mesh
	Begin Object Name=BackAttachmentComponent
		SkeletalMesh=SkeletalMesh'ENV_VN_Flags.Meshes.S_VN_Flag_PAVN'
	End Object
	
	// Override first person flag mesh
	Begin Object Name=FlagMesh
		SkeletalMesh=SkeletalMesh'ENV_VN_Flags.Meshes.S_VN_Flag_PAVN'
		AnimSets(0)=AnimSet'WP_VN_USA_Binoculars.Anim.WP_US_BinocsHands'
		Scale=1.0
		DepthPriorityGroup=SDPG_Foreground
		bOwnerNoSee=true
	End Object
	
	// Override pickup mesh with flag mesh
	Begin Object Name=FlagPickupMesh
		SkeletalMesh=SkeletalMesh'ENV_VN_Flags.Meshes.S_VN_Flag_PAVN'
		Scale=1.0
	End Object
}

// SkeletalMesh'WP_VN_3rd_Master.Mesh.DShK_HMG_3rd_Master' 
