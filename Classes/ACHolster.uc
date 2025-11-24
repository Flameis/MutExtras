class ACHolster extends ROItem_BinocularsUS_Content;

var bool bSaluting;

simulated function PreBeginPlay()
{
	ROPawn(Instigator).ArmsMesh.AnimSets.AddItem(AnimSet'MutExtrasTBPkg.Anims.Salute1st');

	SetTimer(1, true, 'CheckIdle');

	super.PreBeginPlay();
}

// Play First and Third Person Animations When Fired
simulated function BeginFire(Byte FireModeNum)
{
	ROPawn(Instigator).ArmsMesh.PlayAnim('Salute1st', 2/* ROPawn(Instigator).ArmsMesh.GetAnimLength('29thArms1st') */, false, false);

	Instigator.Controller.ConsoleCommand("MUTATE SALUTE");

	if (WorldInfo.NetMode == NM_Standalone)
		ACPawn(Instigator).Salute();

	bSaluting = true;
	SetTimer(2, false, 'StopSaluting');
	//super.beginfire(FireModeNum);
}

simulated state Active
{
	// Overridden so nothing happens
	simulated exec function IronSights()
	{
		ROPawn(Instigator).ArmsMesh.PlayAnim('Salute1st', 2/* ROPawn(Instigator).ArmsMesh.GetAnimLength('29thArms1st') */, false, false);

		Instigator.Controller.ConsoleCommand("MUTATE SALUTE");

		if (WorldInfo.NetMode == NM_Standalone)
			ACPawn(Instigator).Salute();

		bSaluting = true;
		SetTimer(2, false, 'StopSaluting');
		//super.IronSights();
	}
}

// Overridden so nothing happens
simulated exec function IronSights()
{
	ROPawn(Instigator).ArmsMesh.PlayAnim('Salute1st', 2/* ROPawn(Instigator).ArmsMesh.GetAnimLength('29thArms1st') */, false, false);

	Instigator.Controller.ConsoleCommand("MUTATE SALUTE");

	if (WorldInfo.NetMode == NM_Standalone)
		ACPawn(Instigator).Salute();

	bSaluting = true;
	SetTimer(2, false, 'StopSaluting');
	//super.IronSights();
}

// Delete Holster from inventory
simulated function DeleteHolster()	
{
	local Inventory Inv;
	Inv = Pawn(Owner).FindInventoryType(class'ACHolster');
	if(Inv != None)
		Inv.Destroy();
}

simulated function StopSaluting()
{
	bSaluting = false;
}

simulated function CheckIdle()
{
	if (!bSaluting && !Instigator.bIsSprinting && !Instigator.bIsProning && IsInState('Active'))
	{
    	ROPawn(Instigator).ArmsMesh.PlayAnim('Idle', 1, true, false);
	}
}

defaultproperties
{
    Begin Object Name=FirstPersonMesh
		DepthPriorityGroup=SDPG_Foreground
		AnimSets(0)=AnimSet'WP_VN_USA_Binoculars.Anim.WP_US_BinocsHands'
		SkeletalMesh=none
		PhysicsAsset=None
		// AnimSets(1)=AnimSet'MutExtrasTBPkg.Anims.Salute1st'
		//SkeletalMesh=SkeletalMesh'CHR_VN_1stP_Hands_Master.Mesh.VN_1stP_US_Long_Mesh'
		//SkeletalMesh=SkeletalMesh'WP_VN_USA_Binoculars.Mesh.US_Binocs'
		// AnimTreeTemplate=AnimTree'MutExtrasTBPkg.Anims.SaluteTree1st'
		//AnimTreeTemplate=AnimSet'MutExtrasTBPkg.Anims.SaluteTree'
		Scale=1.0
		FOV=70
	End Object

	WeaponContentClass(0)="MutExtras.ACHolster"

	WeaponClassType=ROWCT_HandGun
	Category=ROIC_Secondary
	InvIndex=200
	Weight=0 //0.4 // kg

    MaxNumPrimaryMags=30
    InitialNumPrimaryMags=30
	bUsingSights=true
    bCanThrow=false
    bUsesFreeAim=false
    SwayScale=0
    InventoryGroup=29
    AttachmentClass=Class'ACHolsterAttachment'

	//ArmsAnimSet=AnimSet'MutExtrasTBPkg.Anims.Salute1st'
	WeaponIdleAnims(0)=Idle
	WeaponIdleAnims(1)=Idle
    //WeaponFireAnim(0)=29thArms1st
	//WeaponFireLastAnim=29thArms1st
}