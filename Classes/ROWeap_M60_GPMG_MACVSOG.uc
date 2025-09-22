//=============================================================================
// ROWeap_M60
//=============================================================================
// M60 Machine Gun
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Nate Steger @ Antimatter Games LTD
//=============================================================================

class ROWeap_M60_GPMG_MACVSOG extends ROMGWeapon
	abstract;

var				Array<name>				Bullets;

/**
 * Handle the sight index setting being updated
 */
simulated function SightIndexUpdated()
{
	if( SightRotController != none )
	{
		SightRotController.BoneRotation.Pitch = SightRanges[SightRangeIndex].SightPitch;
	}
	if( SightSlideController != none )
	{
		SightSlideController.BoneTranslation.Z = SightRanges[SightRangeIndex].SightSlideOffset;
	}
	IronSightPosition.Z=SightRanges[SightRangeIndex].SightPositionOffset;
	if( bUsingSights )
		PlayerViewOffset.Z=SightRanges[SightRangeIndex].SightPositionOffset;
}

/** M60 can lean out from cover even though it has a bipod */
simulated function bool CanLeanOutOfCover(const out CoverSlot CurrentSlot)
{
	return !CurrentSlot.bCanPopUp;
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
 * Unhide entire ammo clip. Usually called via Script AnimNotify in the reload animations
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

simulated function SetFOV(float NewFOV)
{
	super.SetFOV(NewFOV);

	if(AmmoBeltMesh != none)
	{
		AmmoBeltMesh.SetFOV(NewFOV);
	}
}

// Reset the visible ammo belt and ensure that the correct number of rounds are being displayed
simulated function PlayWeaponEquip()
{
	// RS2PR-5774 - Force our ladder to update it's position based on our saved value. -Nate
	SightIndexUpdated();
	Super.PlayWeaponEquip();

	RefreshVisibleBullets();
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
	WeaponContentClass(0)="ROGameContent.ROWeap_M60_GPMG_Content"

	AmmoContentClassStart=1
	// Class below here are available only through selecting alternative ammo loadouts
	WeaponContentClass(1)="ROGameContent.ROWeap_M60_GPMG_Level2"

	RoleSelectionImage(0)=Texture2D'VN_UI_Textures.WeaponTex.US_Weap_M60_GPMG_Box'
	RoleSelectionImage(1)=Texture2D'VN_UI_Textures.WeaponTex.US_Weap_M60_GPMG_Belt'

	WeaponClassType=ROWCT_LMG
	TeamIndex=`ALLIES_TEAM_INDEX

	Category=ROIC_Primary
	Weight=10.5 //KG
	//RoleEncumbranceModifier=0.6
	InvIndex=`ROII_M60_GPMG
	InventoryWeight=3

	PlayerIronSightFOV=60.0

	// MAIN FIREMODE
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'M60Bullet'
	bLoopHighROFSounds(0)=true
	FireInterval(0)=+0.100 //~600rpm
	DelayedRecoilTime(0)=0.0
	Spread(0)=0.0008 // 3 MOA

	// ALT FIREMODE
	FiringStatesArray(ALTERNATE_FIREMODE)=none
	WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
	WeaponProjectiles(ALTERNATE_FIREMODE)=none
	FireInterval(ALTERNATE_FIREMODE)=+0.1 // 600 RPM
	DelayedRecoilTime(ALTERNATE_FIREMODE)=0.01
	Spread(ALTERNATE_FIREMODE)=0.0008 // 3 MOA

	AltFireModeType=ROAFT_ExtendBipod

	PreFireTraceLength=2500 //50 Meters

	//ShoulderedSpreadMod=3.0//6.0
	//HippedSpreadMod=5.0//10.0

	// AI
	MinBurstAmount=3
	MaxBurstAmount=30
	//BurstWaitTime=0.5

	// Recoil
	maxRecoilPitch=260//180//350
	minRecoilPitch=260//130//300
	maxRecoilYaw=150 //200
	minRecoilYaw=-80 //-200
	maxDeployedRecoilPitch=50//90
	minDeployedRecoilPitch=50//90
	maxDeployedRecoilYaw=50
	minDeployedRecoilYaw=-50
	minDeployedRecoilYawAbsolute=25
	RecoilRate=0.1//0.07
	RecoilMaxYawLimit=1500
	RecoilMinYawLimit=64035
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

	// InstantHitDamage(0)=150
	// InstantHitDamage(1)=150
	InstantHitDamage(0)=120
	InstantHitDamage(1)=120

	InstantHitDamageTypes(0)=class'RODmgType_M60Bullet'
	InstantHitDamageTypes(1)=class'RODmgType_M60Bullet'

	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_Rifles_split'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

	// Shell eject FX
	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_USA_M60'

	bHasIronSights=true;

	//Equip and putdown
	WeaponPutDownAnim=M60_putaway
	WeaponEquipAnim=M60_pullout
	WeaponDownAnim=M60_Down
	WeaponUpAnim=M60_Up

	// Fire Anims
	//Hip fire
	WeaponFireAnim(0)=M60_shoulder_shoot
	WeaponFireAnim(1)=M60_shoulder_shoot
	WeaponFireLastAnim=M60_shoulder_shootLAST
	//Shouldered fire
	WeaponFireShoulderedAnim(0)=M60_shoulder_shoot
	WeaponFireShoulderedAnim(1)=M60_shoulder_shoot
	WeaponFireLastShoulderedAnim=M60_shoulder_shootLAST
	//Fire using iron sights
	WeaponFireSightedAnim(0)=M60_Iron_shoot
	WeaponFireSightedAnim(1)=M60_Iron_shoot
	WeaponFireLastSightedAnim=M60_Iron_shootLAST
	//Fire using bipod
	WeaponFireDeployedAnim(0)=M60_deploy_shoot
	WeaponFireDeployedAnim(1)=M60_deploy_shoot
	WeaponFireLastDeployedAnim=M60_deploy_shootLAST

	// Idle Anims
	//Hip Idle
	WeaponIdleAnims(0)=M60_shoulder_idle
	WeaponIdleAnims(1)=M60_shoulder_idle
	// Shouldered idle
	WeaponIdleShoulderedAnims(0)=M60_shoulder_idle
	WeaponIdleShoulderedAnims(1)=M60_shoulder_idle
	//Sighted Idle
	WeaponIdleSightedAnims(0)=M60_Iron_idle
	WeaponIdleSightedAnims(1)=M60_Iron_idle
	//Bipod Idle
	WeaponIdleDeployedAnims(0)=M60_deploy_idle
	WeaponIdleDeployedAnims(1)=M60_deploy_idle

	// Prone Crawl
	WeaponCrawlingAnims(0)=M60_CrawlF
	WeaponCrawlStartAnim=M60_Crawl_into
	WeaponCrawlEndAnim=M60_Crawl_out
	// Deployed Prone Crawl
	RedeployCrawlingAnims(0)=M60_Deployed_CrawlF

	//Reloading
	WeaponReloadEmptyMagAnim=M60_reloadempty_crouch
	WeaponReloadNonEmptyMagAnim=M60_reloadhalf_crouch
	WeaponRestReloadEmptyMagAnim=M60_reloadempty_rest
	WeaponRestReloadNonEmptyMagAnim=M60_reloadhalf_rest
	DeployReloadEmptyMagAnim=M60_deploy_reloadempty
	DeployReloadHalfMagAnim=M60_deploy_reloadhalf
	// Ammo check
	WeaponAmmoCheckAnim=M60_ammocheck
	WeaponRestAmmoCheckAnim=M60_ammocheck_rest
	DeployAmmoCheckAnim=M60_deploy_ammocheck

	// Sprinting
	WeaponSprintStartAnim=M60_sprint_into
	WeaponSprintLoopAnim=M60_Sprint
	WeaponSprintEndAnim=M60_sprint_out
	Weapon1HSprintStartAnim=M60_1H_sprint_into
	Weapon1HSprintLoopAnim=M60_1H_Sprint
	Weapon1HSprintEndAnim=M60_1H_sprint_out

	// Mantling
	WeaponMantleOverAnim=M60_Mantle

	// Cover/Blind Fire Anims
	WeaponRestAnim=M60_rest_idle
	WeaponEquipRestAnim=M60_pullout_rest
	WeaponPutDownRestAnim=M60_putaway_rest
	WeaponIdleToRestAnim=M60_idleTOrest
	WeaponRestToIdleAnim=M60_restTOidle

	// Enemy Spotting
	WeaponSpotEnemyAnim=M60_SpotEnemy
	WeaponSpotEnemySightedAnim=M60_SpotEnemy_ironsight
	WeaponSpotEnemyDeployedAnim=M60_SpotEnemy_Deployed

	ReloadMagazinEmptyCameraAnim=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_reloadempty'

	EquipTime=+1.00//1.5

	bDebugWeapon = false

	ISFocusDepth=42

	// Ammo
	AmmoClass=class'ROAmmo_762x51_M60Belt_200'
	MaxAmmoCount=200
	bUsesMagazines=true
	InitialNumPrimaryMags=4//3
	NumMagsToResupply=1
	MaxNumPrimaryMags=5//4
	bPlusOneLoading=false
	bCanReloadNonEmptyMag=true
	PenetrationDepth=17
	MaxPenetrationTests=3
	MaxNumPenetrations=2
	// Tracers
	TracerClass=class'M60BulletTracer'
	TracerFrequency=5

	PlayerViewOffset=(X=4.0,Y=5.5,Z=-1.5)
	ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2000)//(Pitch=1400,Yaw=0,Roll=-2900)//(Pitch=-1910,Yaw=0,Roll=-2910)
	ZoomInTime=0.5//0.65
	ZoomOutTime=0.35//0.6

	ShoulderedPosition=(X=3.0,Y=3.0,Z=-0.75)
	//ShoulderRotation=(Pitch=-300,Yaw=500,Roll=1500)
	IronSightPosition=(X=-4,Y=0,Z=0.0)

	bUsesFreeAim=true

	// Free Aim variables
	FreeAimHipfireOffsetX=50

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	CollisionCheckLength=55.25 // 110.5cm

	// More sway for the M60 because it's so darn heavy!
	SwayScale=1.6//2
	CoverRestedSwayScale=0.3f
	DeployedSwayScale=0.1

	//LagStrengthIronSights=0.8//1.4
	//LagStrengthWalk=0.//0.9
	LagLimit=3.0

	PitchControlName=PitchControl
	BipodZCheckDist=25.0
	bHasBipod=true
	bCanBlindFire=true
	DeployAnimName=M60_shoulderTOdeploy
	UnDeployAnimName=M60_deployTOshoulder
	RestDeployAnimName=M60_restTOdeploy
	RestUnDeployAnimName=M60_deployTOrest
	DeployToShuffleAnimName=M60_Deploy_TO_Shuffle
	ShuffleIdleAnimName=M60_Shuffle_idle
	ShuffleToDeployAnimName=M60_Shuffle_TO_Deploy
	RedeployProneTurnAnimName=M60_prone_turn_TO_Deploy
	UnDeployProneTurnAnimName=M60_prone_Deploy_TO_turn
	ProneTurningIdleAnimName=M60_prone_Deploy_turn_idle
	BipodPivotBoneName=MG_Frontend
	BipodOffset=(X=50.0)

	// 19.5 Z offset to ground from 0,0,0

	FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
	FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'

	SightSlideControlName=Sight_Slide
	SightRotControlName=Sight_Rotation

	// Austin: These are dialed in pretty well. <300m should be fine because of the height of the front sight
	SightRanges[0]=(SightRange=300,SightPitch=16384,SightSlideOffset=0.0,SightPositionOffset=-0.09)
	SightRanges[1]=(SightRange=400,SightPitch=16384,SightSlideOffset=0.06,SightPositionOffset=-0.18)
	SightRanges[2]=(SightRange=500,SightPitch=16384,SightSlideOffset=0.1,SightPositionOffset=-0.25)
	SightRanges[3]=(SightRange=600,SightPitch=16384,SightSlideOffset=0.16,SightPositionOffset=-0.35)
	SightRanges[4]=(SightRange=700,SightPitch=16384,SightSlideOffset=0.22,SightPositionOffset=-0.45)

	// All ranges below here have not been dialed in, and are just estimates
	SightRanges[5]=(SightRange=800,SightPitch=16384,SightSlideOffset=0.31,SightPositionOffset=-0.61)
	SightRanges[6]=(SightRange=900,SightPitch=16384,SightSlideOffset=0.39,SightPositionOffset=-0.72)
	SightRanges[7]=(SightRange=1000,SightPitch=16384,SightSlideOffset=0.48,SightPositionOffset=-0.9)
	SightRanges[8]=(SightRange=1100,SightPitch=16384,SightSlideOffset=0.58,SightPositionOffset=-1.05)

	ROBarrelClass=class'ROMGBarrelM60'
  	bTrackBarrelHeat=true
  	BarrelHeatBone=Barrel
  	BarrelChangeAnim=none
  	InitialBarrels=1

	SuppressionPower=25

	Bullets(0)=BELT_BONE_01
	Bullets(1)=BELT_BONE_02
	Bullets(2)=BELT_BONE_03
	Bullets(3)=BELT_BONE_04
	Bullets(4)=BELT_BONE_05
	Bullets(5)=BELT_BONE_06
	Bullets(6)=BELT_BONE_07

	//SwayOffsetMod=700.f
	RecoilModWhenEmpty=1.25f
 	RecoilOffsetModY = 1500.f
 	RecoilOffsetModZ = 1500.f
 	RecoilOffsetModZDeployed = 1600.f

 	BipodSkelControlName=BipodFold_M60

 	WeaponExtendBipodAnim=M60_Bipod_Open
	WeaponFoldBipodAnim=M60_Bipod_Close

	PerformReloadPct=0.78f
}

