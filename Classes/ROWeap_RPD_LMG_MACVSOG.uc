//=============================================================================
// ROWeap_RPD_LMG
//=============================================================================
// RPD bipod mounted light machine gun
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
// Modified for MACVSOG Mutator by Sgt. Capwell [29ID]
//=============================================================================
class ROWeap_RPD_LMG_MACVSOG extends ROMGWeapon
	abstract;

var				Array<name>				Bullets;

var 			name 					BipodFoldControlLeftName;
var 			SkelControlSingleBone	BipodFoldControlLeft;

var 			name 					BipodFoldControlRightName;
var 			SkelControlSingleBone	BipodFoldControlRight;

// Show correct ammo
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	if( BipodFoldControlLeftName != '' )
	{
		BipodFoldControlLeft = SkelControlSingleBone( SkeletalMeshComponent(Mesh).FindSkelControl(BipodFoldControlLeftName) );
		BipodFoldControlLeft.SetSkelControlStrength( 0.0f , 0.0f );
	}

	if( BipodFoldControlRightName != '' )
	{
		BipodFoldControlRight = SkelControlSingleBone( SkeletalMeshComponent(Mesh).FindSkelControl(BipodFoldControlRightName) );
		BipodFoldControlRight.SetSkelControlStrength( 0.0f , 0.0f );
	}

	super.PostInitAnimTree(SkelComp);
}

// override for special hinge stuff
simulated function InstantFoldBipod()
{
	if( BipodFoldControlLeft != none )
	{
		BipodFoldControlLeft.SetSkelControlStrength( 1.0f , 0.0f );
	}

	if( BipodFoldControlRight != none )
	{
		BipodFoldControlRight.SetSkelControlStrength( 1.0f , 0.0f );
	}
}

// override for special hinge stuff
simulated function InstantExtendBipod()
{
	if(BipodFoldControlLeft != none)
	{
		BipodFoldControlLeft.SetSkelControlStrength( 0.0f, 0.0f );
	}

	if(BipodFoldControlRight != none)
	{
		BipodFoldControlRight.SetSkelControlStrength( 0.0f, 0.0f );
	}
}

/** RPD can lean out from cover even with a bipod */
simulated function bool CanLeanOutOfCover(const out CoverSlot CurrentSlot)
{
	return !CurrentSlot.bCanPopUp;
}

// /**
//  * Handle the sight index setting being updated
//  */
// simulated function SightIndexUpdated()
// {
// 	if( SightRotController != none )
// 	{
// 		SightRotController.BoneRotation.Pitch = SightRanges[SightRangeIndex].SightPitch * -1;
// 	}
// 	if( SightSlideController != none )
// 	{
// 		SightSlideController.BoneTranslation.Z = SightRanges[SightRangeIndex].SightSlideOffset;
// 	}
// 	IronSightPosition.Z=SightRanges[SightRangeIndex].SightPositionOffset;
// 	PlayerViewOffset.Z=SightRanges[SightRangeIndex].SightPositionOffset;
// }

simulated exec function SwitchFireMode()
{
	ROMGOperation();
}

simulated function FireAmmunition()
{
	Super.FireAmmunition();

	// Hide a bullet from the ammo belt every time we fire a round
	if ( WorldInfo.NetMode != NM_DedicatedServer && AmmoBeltMesh != None && AmmoCount < Bullets.length )
	{
		AmmoBeltMesh.HideBoneByName(Bullets[AmmoCount], PBO_None);
	}
}

/**
 * Unhide entire ammo clip. Usually called via AnimNotify_Script in the reload animations
 */
simulated function UnHideBulletsNotify()
{
	local int i;

	if( WorldInfo.NetMode != NM_DedicatedServer && PlayerController(Instigator.Controller) != none )
	{
		for( i=0; i<Bullets.Length; i++ )
		{
			AmmoBeltMesh.UnHideBoneByName(Bullets[i]);
		}
	}
}

// Reset the visible ammo belt and ensure that the correct number of rounds are being displayed
simulated function PlayWeaponEquip()
{
	Super.PlayWeaponEquip();

	RefreshVisibleBullets();
}

simulated function SetFOV(float NewFOV)
{
	super.SetFOV(NewFOV);

	if(AmmoBeltMesh != none)
	{
		AmmoBeltMesh.SetFOV(NewFOV);
	}
}

// Reset the bullet belt and recalculate which should be visible and which should not
simulated function RefreshVisibleBullets()
{
	local int i;

	if( AmmoBeltMesh != none && AmmoBeltAttachTime != WorldInfo.TimeSeconds )
	{
		// We don't know where we're up to, so start over
		UnHideBulletsNotify();

		// Hide the bullets up to the current ammo count
		for( i=(Bullets.Length-1); i>0; i-- )
		{
			if( i + 1 > AmmoCount )
			{
				AmmoBeltMesh.HideBoneByName(Bullets[i], PBO_None);
			}
			else
			{
				break;
			}
		}
	}
}

simulated state Reloading
{
	simulated function CancelWeaponAction(optional bool bAnimate, optional bool bReplicateToServer)
	{
		super.CancelWeaponAction(bAnimate, bReplicateToServer);
		RefreshVisibleBullets();
	}
}

defaultproperties
{
	WeaponContentClass(0)="ROGameContent.ROWeap_RPD_LMG_Content"

	AmmoContentClassStart=1
	// class below here are available only through selecting alternative ammo loadouts
	WeaponContentClass(1)="ROGameContent.ROWeap_RPD_LMG_200rd"

	RoleSelectionImage(0)=Texture2D'VN_UI_Textures.WeaponTex.VN_Weap_RPD_LMG_Drum'
	RoleSelectionImage(1)=Texture2D'VN_UI_Textures.WeaponTex.VN_Weap_RPD_LMG_Belt'

	WeaponClassType=ROWCT_LMG
	TeamIndex=`AXIS_TEAM_INDEX

	Category=ROIC_Primary
	Weight=7.4 //kg
	//RoleEncumbranceModifier=0.5
	InvIndex=`ROII_RPD_LMG
	InventoryWeight=3

	PlayerIronSightFOV=60.0

	// MAIN FIREMODE
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'RPDBullet'
	FireInterval(0)=+0.086	// ~700rpm
	DelayedRecoilTime(0)=0.0
	Spread(0)=0.000972 // 3.5 MOA

	// ALT FIREMODE
	FiringStatesArray(ALTERNATE_FIREMODE)=none
	WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
	WeaponProjectiles(ALTERNATE_FIREMODE)=none
	bLoopHighROFSounds(ALTERNATE_FIREMODE)=false
	FireInterval(ALTERNATE_FIREMODE)=+0.075
	DelayedRecoilTime(ALTERNATE_FIREMODE)=0.01
	Spread(ALTERNATE_FIREMODE)=0.000972 // 3.5 MOA

	AltFireModeType=ROAFT_ExtendBipod

	PreFireTraceLength=2500 //50 Meters

	//ShoulderedSpreadMod=3.0//6.0
	//HippedSpreadMod=5.0//10.0

	// AI
	MinBurstAmount=3
	MaxBurstAmount=30
	//BurstWaitTime=0.5

	// Recoil
	maxRecoilPitch=200//220//120//300
	minRecoilPitch=200//200//70//250
	maxRecoilYaw=100//110//100
	minRecoilYaw=-45 //-50
	maxDeployedRecoilPitch=40//70
	minDeployedRecoilPitch=40//70
	maxDeployedRecoilYaw=40
	minDeployedRecoilYaw=-40
	minDeployedRecoilYawAbsolute=15
	RecoilRate=0.08 //0.086 //0.07
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=1500
	RecoilMinPitchLimit=64785
	RecoilISMaxYawLimit=500
	RecoilISMinYawLimit=65035
	RecoilISMaxPitchLimit=350
	RecoilISMinPitchLimit=65035
   	RecoilBlendOutRatio=0.65
   	//PostureHippedRecoilModifer=3
   	//PostureShoulderRecoilModifer=2
   	RecoilViewRotationScale=0.45

	// InstantHitDamage(0)=123
	// InstantHitDamage(1)=123
	InstantHitDamage(0)=86
	InstantHitDamage(1)=86

	InstantHitDamageTypes(0)=class'RODmgType_RPDBullet'
	InstantHitDamageTypes(1)=class'RODmgType_RPDBullet'

	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_Rifles_round'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

	// Shell eject FX
	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_VC_RPD'

	bHasIronSights=true;

	//Equip and putdown
	WeaponPutDownAnim=RPD_putaway
	WeaponEquipAnim=RPD_pullout
	WeaponDownAnim=RPD_Down
	WeaponUpAnim=RPD_Up

	// Fire Anims
	//Hip fire
	WeaponFireAnim(0)=RPD_shoulder_shoot
	WeaponFireAnim(1)=RPD_shoulder_shoot
	WeaponFireLastAnim=RPD_shoulder_shootLAST
	//Shouldered fire
	WeaponFireShoulderedAnim(0)=RPD_shoulder_shoot
	WeaponFireShoulderedAnim(1)=RPD_shoulder_shoot
	WeaponFireLastShoulderedAnim=RPD_shoulder_shootLAST
	//Fire using iron sights
	WeaponFireSightedAnim(0)=RPD_iron_shoot
	WeaponFireSightedAnim(1)=RPD_iron_shoot
	WeaponFireLastSightedAnim=RPD_iron_shootLAST
	//Fire using bipod
	WeaponFireDeployedAnim(0)=RPD_deploy_shoot
	WeaponFireDeployedAnim(1)=RPD_deploy_shoot
	WeaponFireLastDeployedAnim=RPD_deploy_shootLAST

	// Idle Anims
	//Hip Idle
	WeaponIdleAnims(0)=RPD_shoulder_idle
	WeaponIdleAnims(1)=RPD_shoulder_idle
	// Shouldered idle
	WeaponIdleShoulderedAnims(0)=RPD_shoulder_idle
	WeaponIdleShoulderedAnims(1)=RPD_shoulder_idle
	//Sighted Idle
	WeaponIdleSightedAnims(0)=RPD_iron_idle
	WeaponIdleSightedAnims(1)=RPD_iron_idle
	//Bipod Idle
	WeaponIdleDeployedAnims(0)=RPD_deploy_idle
	WeaponIdleDeployedAnims(1)=RPD_deploy_idle

	// Prone Crawl
	WeaponCrawlingAnims(0)=RPD_CrawlF
	WeaponCrawlStartAnim=RPD_Crawl_into
	WeaponCrawlEndAnim=RPD_Crawl_out
	// Deployed Prone Crawl
	RedeployCrawlingAnims(0)=RPD_Deployed_CrawlF

	//Reloading
	WeaponReloadEmptyMagAnim=RPD_reloadempty_crouch
	WeaponReloadNonEmptyMagAnim=RPD_reloadhalf_crouch
	WeaponRestReloadEmptyMagAnim=RPD_reloadempty_rest
	WeaponRestReloadNonEmptyMagAnim=RPD_reloadhalf_rest
	DeployReloadEmptyMagAnim=RPD_deploy_reloadempty
	DeployReloadHalfMagAnim=RPD_deploy_reloadhalf
	// Ammo check
	WeaponAmmoCheckAnim=RPD_ammocheck_crouch
	WeaponRestAmmoCheckAnim=RPD_ammocheck_rest
	DeployAmmoCheckAnim=RPD_deploy_ammocheck

	// Sprinting
	WeaponSprintStartAnim=RPD_sprint_into
	WeaponSprintLoopAnim=RPD_Sprint
	WeaponSprintEndAnim=RPD_sprint_out
	Weapon1HSprintStartAnim=RPD_1H_sprint_into
	Weapon1HSprintLoopAnim=RPD_1H_Sprint
	Weapon1HSprintEndAnim=RPD_1H_sprint_out

	// Mantling
	WeaponMantleOverAnim=RPD_Mantle

	// Cover/Blind Fire Anims
	WeaponRestAnim=RPD_rest_idle
	WeaponEquipRestAnim=RPD_pullout_rest
	WeaponPutDownRestAnim=RPD_putaway_rest
	WeaponIdleToRestAnim=RPD_shoulderTOrest
	WeaponRestToIdleAnim=RPD_restTOshoulder

	// Enemy Spotting
	WeaponSpotEnemyAnim=RPD_SpotEnemy
	WeaponSpotEnemySightedAnim=RPD_SpotEnemy_ironsight
	WeaponSpotEnemyDeployedAnim=RPD_SpotEnemy_Deployed

	ReloadMagazinEmptyCameraAnim=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_reloadempty'

	EquipTime=+1.0//1.50

	bDebugWeapon = false

	ISFocusDepth=41

	// Ammo
	AmmoClass=class'ROAmmo_762x39_RPDDrum'
	MaxAmmoCount=100
	bUsesMagazines=true
	InitialNumPrimaryMags=6
	NumMagsToResupply=1
	MaxNumPrimaryMags=8
	bPlusOneLoading=false
	bCanReloadNonEmptyMag=true
	PenetrationDepth=15
	MaxPenetrationTests=3
	MaxNumPenetrations=2
	// Tracers
	TracerClass=class'RPDBulletTracer'
	TracerFrequency=5

	// 200 round belt version
	AltAmmoLoadouts(0)=(WeaponContentClassIndex=1)

	PlayerViewOffset=(X=3.5,Y=5.0,Z=-1.75)
	ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910) //(Pitch=1200,Yaw=-900,Roll=1500)//

	ShoulderedPosition=(X=2.5,Y=3.0,Z=-1.25)
	//ShoulderRotation=(Pitch=-300,Yaw=500,Roll=1500)
	IronSightPosition=(X=-3,Y=0,Z=0)

	ZoomInTime=0.5//0.65
	ZoomOutTime=0.35//0.6

	//LagStrengthIronSights=1.0//1.4
	//LagStrengthWalk=0.73//0.9
	LagLimit=2

	bUsesFreeAim=true

	// Free Aim variables
	FreeAimHipfireOffsetX=45

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	CollisionCheckLength=51.85

	// Lots of extra sway for ironsighting
	SwayScale=1.6//2
	DeployedSwayScale=0.1

	PitchControlName=PitchControl
	BipodZCheckDist=25.0
	bHasBipod=true
	bCanBlindFire=true
	DeployAnimName=RPD_shoulderTOdeploy
	UnDeployAnimName=RPD_deployTOshoulder
	RestDeployAnimName=RPD_restTOdeploy
	RestUnDeployAnimName=RPD_deployTOrest
	DeployToShuffleAnimName=RPD_Deploy_TO_Shuffle
	ShuffleIdleAnimName=RPD_Shuffle_idle
	ShuffleToDeployAnimName=RPD_Shuffle_TO_Deploy
	RedeployProneTurnAnimName=RPD_prone_turn_TO_Deploy
	UnDeployProneTurnAnimName=RPD_prone_Deploy_TO_turn
	ProneTurningIdleAnimName=RPD_prone_Deploy_turn_idle
	BipodPivotBoneName=Bipod_hinge_pitch//MG_Frontend
	BipodOffset=(X=48.0)

	// 19.5 Z offset to ground from 0,0,0

	FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
	FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'

	SightSlideControlName=Sight_Slide
	SightRotControlName=Sight_Rotation

	SightRanges[0]=(SightRange=100,SightPitch=-90,SightSlideOffset=0.1,SightPositionOffset=0.04)
	SightRanges[1]=(SightRange=200,SightPitch=-100,SightSlideOffset=0.2,SightPositionOffset=0.04)
	SightRanges[2]=(SightRange=300,SightPitch=0,SightSlideOffset=0.4,SightPositionOffset=0.0)
	SightRanges[3]=(SightRange=400,SightPitch=200,SightSlideOffset=0.8,SightPositionOffset=-0.075)
	SightRanges[4]=(SightRange=500,SightPitch=600,SightSlideOffset=1.3,SightPositionOffset=-0.25)
	SightRanges[5]=(SightRange=600,SightPitch=900,SightSlideOffset=1.5,SightPositionOffset=-0.34)
	SightRanges[6]=(SightRange=700,SightPitch=1250,SightSlideOffset=1.7,SightPositionOffset=-0.47)
	// All ranges below here have not been dialed in, and are just estimates
	SightRanges[7]=(SightRange=800,SightPitch=1500,SightSlideOffset=1.75,SightPositionOffset=-0.56)
	SightRanges[8]=(SightRange=900,SightPitch=1800,SightSlideOffset=1.85,SightPositionOffset=-0.67)
	SightRanges[9]=(SightRange=1000,SightPitch=2250,SightSlideOffset=1.9,SightPositionOffset=-0.83)

	ROBarrelClass=class'ROMGBarrelRPD'
  	bTrackBarrelHeat=true
  	BarrelHeatBone=barrel
  	//BarrelChangeAnim=MG34_BarrelChange
  	BarrelChangeAnim=none
  	InitialBarrels=1

	SuppressionPower=25 //10

	Bullets(0)=BELT_BONE_01

	Bullets(1)=BELT_BONE_02
	Bullets(2)=BELT_BONE_03
	Bullets(3)=BELT_BONE_04
	Bullets(4)=BELT_BONE_05
	Bullets(5)=BELT_BONE_06
	Bullets(6)=BELT_BONE_07
	Bullets(7)=BELT_BONE_08
	Bullets(8)=BELT_BONE_09
	Bullets(9)=BELT_BONE_10
	Bullets(10)=BELT_BONE_11
	Bullets(11)=BELT_BONE_12
	Bullets(12)=BELT_BONE_13

	//SwayOffsetMod=1500.f
	RecoilModWhenEmpty=1.25f
	RecoilOffsetModY = 1500.f
	RecoilOffsetModZ = 1500.f
 	RecoilOffsetModZDeployed = 1900.f

 	BipodFoldControlLeftName=BipodFold_RPD_L
 	BipodFoldControlRightName=BipodFold_RPD_R

 	WeaponExtendBipodAnim=RPD_Bipod_Open
	WeaponFoldBipodAnim=RPD_Bipod_Close

	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Loop_3P', FirstPersonCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Loop')

	bLoopingFireSnd(DEFAULT_FIREMODE)=true
	WeaponFireLoopEndSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Tail_3P', FirstPersonCue=AkEvent'WW_WEP_RPD.Play_WEP_RPD_Tail')
	bLoopHighROFSounds(DEFAULT_FIREMODE)=true

	PerformReloadPct=0.73
}

