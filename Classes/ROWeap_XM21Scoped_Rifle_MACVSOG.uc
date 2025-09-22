//=============================================================================
// ROWeap_XM21Scoped_Rifle
//=============================================================================
// The XM21 Scoped rifle, featuring the AR TEL autoranging scope system.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Austin "dibbler67" Ware for Antimatter Games LTD
// Modified for MACVSOG Mutator by Sgt Capwell [29ID]
//=============================================================================
class ROWeap_XM21Scoped_Rifle_MACVSOG extends ROSniperWeaponAdvanced
	abstract;

var SkelControlSingleBone ZoomDialSkelControl;
var name ZoomDialSkelControlName;

var int ScopeDialInitialRotation;

// Use a zero at 300m
var config bool bUseRealisticZero;

/* Realistic AR TEL values */
var array<float> RealisticZeroOffsetMOAArray;

/** Array that holds the settings for the different ranges this weapon can be set to */
var(Zooming) array<SightRangeInfo> 	RealisticScopeSightRanges;

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);

	if(ZoomDialSkelControlName != '')
	{
		ZoomDialSkelControl = SkelControlSingleBone( SkeletalMeshComponent(Mesh).FindSkelControl(ZoomDialSkelControlName) );
		ZoomDialSkelControl.SetSkelControlStrength( 1.0f , 0.0f );
		ZoomDialSkelControl.BoneRotation.Roll = ScopeDialInitialRotation;
	}
}

/**
 * @Override to set up zero settings
 */
reliable client function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{
	super.ClientWeaponSet(bOptionalSet, bDoNotActivate);

	UpdateZero();
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	if(WorldInfo.NetMode != NM_DedicatedServer)
	{
		UpdateZero();
	}
}

simulated function UpdateZero()
{
	if( default.bUseRealisticZero )
	{
		ScopeSightRanges = default.RealisticScopeSightRanges;
		ZeroOffsetMOAArray = default.RealisticZeroOffsetMOAArray;
	}
	else
	{
		ScopeSightRanges = default.ScopeSightRanges;
		ZeroOffsetMOAArray = default.ZeroOffsetMOAArray;
	}
}

/**
 * Handle the sight index setting being updated.
 * @Override to change view rotation, instead of sight position -Austin
 */
simulated function ScopeSightIndexUpdated()
{
	super.ScopeSightIndexUpdated();

	if(ZoomDialSkelControl != none)
	{
		ZoomDialSkelControl.BoneRotation.Roll = ScopeDialInitialRotation + ScopeSightRangeIndex * 4000;
	}
}

/**
 * Goes to next available magnification.  @Override Zoom is tied to range!
 */
simulated exec function IncreaseScopePower()
{
	if(bUsingScopePosition && bUsingSights && !bZoomingOut )// && !bZoomingIn )
	{
		if( ScopePowerIndex < (ScopePowerArray.length - 1) && !bZoomingIn && !bZoomingIn )
		{
			ScopePowerIndex++;
			ScopeSightRangeIndex = ScopePowerIndex;
			ScopeSightIndexUpdated();
			ScopePowerIndexUpdated();
		}
  	}
}

/**
 * Goes to previous available magnification. @Override Zoom is tied to range!
 */
simulated exec function DecreaseScopePower()
{
	if(bUsingScopePosition && bUsingSights && !bZoomingOut )// && !bZoomingIn )
	{
		if( ScopePowerIndex > 0 && !bZoomingIn )
		{
			ScopePowerIndex--;
			ScopeSightRangeIndex = ScopePowerIndex;
			ScopeSightIndexUpdated();
			ScopePowerIndexUpdated();
		}
	}
}

/**
 * Override Next weapon call.
 * Increment the sight range index
 * @Override Zoom is tied to range!
 */
simulated function bool DoOverrideNextWeapon()
{
  // If we aren't in ironsights increment the sight index
  	if(bUsingScopePosition && bUsingSights && !bZoomingOut )// && !bZoomingIn )
	{
		if( ScopePowerIndex > 0 && !bZoomingIn )
		{
			ScopePowerIndex--;
			ScopeSightRangeIndex = ScopePowerIndex;
			ScopeSightIndexUpdated();
			ScopePowerIndexUpdated();
		}
	  	return true;
  	}

	return super(ROWeapon).DoOverrideNextWeapon();
}



/**
 * Override Previous weapon call.
 * Increment the sight range index
 * @Override Zoom is tied to range!
 */
simulated function bool DoOverridePrevWeapon()
{
   // If we aren't in ironsights increment the sight index
	if(bUsingScopePosition && bUsingSights && !bZoomingOut )// && !bZoomingIn )
	{
		if( ScopePowerIndex < (ScopePowerArray.length - 1) && !bZoomingIn && !bZoomingIn )
		{
			ScopePowerIndex++;
			ScopeSightRangeIndex = ScopePowerIndex;
			ScopeSightIndexUpdated();
			ScopePowerIndexUpdated();
		}
	  	return true;
	}

	return super(ROWeapon).DoOverridePrevWeapon();
}

`ifndef(ShippingPC)
simulated exec function ToggleRealisticZero()
{
	bUseRealisticZero = !bUseRealisticZero;
	SaveConfig();
	UpdateZero();
	`Log("bUseRealisticZero:"@bUseRealisticZero);
}
`endif

defaultproperties
{
	WeaponContentClass(0)="ROGameContent.ROWeap_XM21Scoped_Rifle_Content"
	// WeaponContentClass(1)="ROGameContent.ROWeap_XM21Scoped_Rifle_Level2"
	WeaponContentClass(1)="ROGameContent.ROWeap_XM21Scoped_Rifle_Suppressed"

	RoleSelectionImage(0)=Texture2D'VN_UI_Textures.WeaponTex.US_Weap_XM21_SniperRifle'
	RoleSelectionImage(1)=Texture2D'VN_UI_Textures.WeaponTex.US_Weap_XM21_Suppressed'
	//RoleSelectionImage(1)=MaterialInstanceConstant'UI_Mats.RoleSelectMenu.sov_wp_svt_sniper_UPGRD1_MIC'
	//RoleSelectionImage(2)=MaterialInstanceConstant'UI_Mats.RoleSelectMenu.sov_wp_svt_sniper_UPGRD1_MIC'

	WeaponClassType=ROWCT_ScopedRifle
	TeamIndex=`ALLIES_TEAM_INDEX

	// Smaller collision buffer so scope doesn't get shoved back in our eyes
	FrontCollisionBufferDist=0.5

	// 2D scene capture
	Begin Object Name=ROSceneCapture2DDPGComponent0
	   TextureTarget=TextureRenderTarget2D'WP_Ger_Kar98k_Rifle.Materials.Kar98Lense'
	   FieldOfView=15 // "3.0X" = 45 / 3 = 15.0(FYI: 50 is our "real world" FOV for RS2)
	End Object

	Category=ROIC_Primary

	Weight=5.27 // kg
	InvIndex=`ROII_XM21_SniperRifle

	InventoryWeight=1

	PlayerIronSightFOV=45.0//32.5f

	PreFireTraceLength=2500 //50 Meters

	// MAIN FIREMODE
	FiringStatesArray(0)=WeaponSingleFiring
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'XM21ScopedBullet'
	FireInterval(0)=+0.1
	DelayedRecoilTime(0)=0.01
	Spread(0)= 0.000276 // ~1 MOA

	// ALT FIREMODE
	FiringStatesArray(ALTERNATE_FIREMODE)=none
	WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_None
	WeaponProjectiles(ALTERNATE_FIREMODE)=none
	FireInterval(ALTERNATE_FIREMODE)=+0.1
	DelayedRecoilTime(ALTERNATE_FIREMODE)=0.01
	Spread(ALTERNATE_FIREMODE)= 0.000276 // ~1 MOA

	AltFireModeType=ROAFT_Bayonet

	//ShoulderedSpreadMod=3.0//6.0
	//HippedSpreadMod=5.0//10.0

	// AI
	MinBurstAmount=1
	MaxBurstAmount=1
	//BurstWaitTime=1.0
	//AILongDistanceScale=1.25f
	//AIMediumDistanceScale=0.5f
	//AISpreadScale=200.0
	//AISpreadNoSeeScale=2.0
	//AISpreadNMEStillScale=0.5
	//AISpreadNMESprintScale=1.5

	// Recoil
	maxRecoilPitch=500//550//700
	minRecoilPitch=500
	maxRecoilYaw=100//280  //250
	minRecoilYaw=-100//-280 //200
	minRecoilYawAbsolute=100
	RecoilRate=0.08
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=2000
	RecoilMinPitchLimit=63535
	RecoilISMaxYawLimit=500
	RecoilISMinYawLimit=65035
	RecoilISMaxPitchLimit=1000
	RecoilISMinPitchLimit=64535
   	//PostureHippedRecoilModifer=1.65
   	//PostureShoulderRecoilModifer=1.4
	RecoilViewRotationScale=0.45

	// InstantHitDamage(0)=173
	// InstantHitDamage(1)=173
	InstantHitDamage(0)=160
	InstantHitDamage(1)=160

	InstantHitDamageTypes(0)=class'RODmgType_XM21ScopedBullet'
	InstantHitDamageTypes(1)=class'RODmgType_XM21ScopedBullet'

	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_Rifles_split'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

	// Shell eject FX
	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_USA_M14'

	bHasIronSights=true;
	bHasManualBolting=false;

	//Equip and putdown
	WeaponPutDownAnim=M14_putaway
	WeaponEquipAnim=M14_pullout
	WeaponDownAnim=M14_Down
	WeaponUpAnim=M14_Up

	// Fire Anims
	//Hip fire
	WeaponFireAnim(0)=M14_shoot
	WeaponFireAnim(1)=M14_Shoot
	WeaponFireLastAnim=M14_shootLAST
	//Shouldered fire
	WeaponFireShoulderedAnim(0)=M14_shoot
	WeaponFireShoulderedAnim(1)=M14_Shoot
	WeaponFireLastShoulderedAnim=M14_shootLAST
	//Fire using iron sights
	WeaponFireSightedAnim(0)=M14_Scope_shoot
	WeaponFireSightedAnim(1)=M14_Scope_shoot
	WeaponFireLastSightedAnim=M14_Scope_shootLAST

	// Idle Anims
	//Hip Idle
	WeaponIdleAnims(0)=M14_shoulder_idle
	WeaponIdleAnims(1)=M14_shoulder_idle
	// Shouldered idle
	WeaponIdleShoulderedAnims(0)=M14_shoulder_idle
	WeaponIdleShoulderedAnims(1)=M14_shoulder_idle
	//Sighted Idle
	WeaponIdleSightedAnims(0)=M14_iron_idle
	WeaponIdleSightedAnims(1)=M14_iron_idle

	// Prone Crawl
	WeaponCrawlingAnims(0)=M14_CrawlF
	WeaponCrawlStartAnim=M14_Crawl_into
	WeaponCrawlEndAnim=M14_Crawl_out

	//Reloading
	WeaponReloadEmptyMagAnim=M14_reloadempty
	WeaponReloadNonEmptyMagAnim=M14_reloadhalf
	WeaponReloadStripperAnim=M14_reloadStriper_half
	WeaponRestReloadEmptyMagAnim=M14_reloadempty_rest
	WeaponRestReloadNonEmptyMagAnim=M14_reloadhalf_rest
	WeaponRestReloadStripperAnim=M14_reloadStriper_half_rest
	// Ammo check
	WeaponAmmoCheckAnim=M14_ammocheck
	WeaponRestAmmoCheckAnim=M14_ammocheck_rest

	// Sprinting
	WeaponSprintStartAnim=M14_sprint_into
	WeaponSprintLoopAnim=M14_Sprint
	WeaponSprintEndAnim=M14_sprint_out
	Weapon1HSprintStartAnim=M14_1H_sprint_into
	Weapon1HSprintLoopAnim=M14_1H_Sprint
	Weapon1HSprintEndAnim=M14_1H_sprint_out

	// Mantling
	WeaponMantleOverAnim=M14_Mantle

	// Cover/Blind Fire Anims
	WeaponRestAnim=M14_rest_idle
	WeaponEquipRestAnim=M14_pullout_rest
	WeaponPutDownRestAnim=M14_putaway_rest
	WeaponBlindFireRightAnim=M14_BF_Right_Shoot
	WeaponBlindFireLeftAnim=M14_BF_Left_Shoot
	WeaponBlindFireUpAnim=M14_BF_up_Shoot
	WeaponIdleToRestAnim=M14_idleTOrest
	WeaponRestToIdleAnim=M14_restTOidle
	WeaponRestToBlindFireRightAnim=M14_restTOBF_Right
	WeaponRestToBlindFireLeftAnim=M14_restTOBF_Left
	WeaponRestToBlindFireUpAnim=M14_restTOBF_up
	WeaponBlindFireRightToRestAnim=M14_BF_Right_TOrest
	WeaponBlindFireLeftToRestAnim=M14_BF_Left_TOrest
	WeaponBlindFireUpToRestAnim=M14_BF_up_TOrest
	WeaponBFLeftToUpTransAnim=M14_BFleft_toBFup
	WeaponBFRightToUpTransAnim=M14_BFright_toBFup
	WeaponBFUpToLeftTransAnim=M14_BFup_toBFleft
	WeaponBFUpToRightTransAnim=M14_BFup_toBFright
	// Blind Fire ready
	WeaponBF_Rest2LeftReady=M14_restTO_L_ready
	WeaponBF_LeftReady2LeftFire=M14_L_readyTOBF_L
	WeaponBF_LeftFire2LeftReady=M14_BF_LTO_L_ready
	WeaponBF_LeftReady2Rest=M14_L_readyTOrest
	WeaponBF_Rest2RightReady=M14_restTO_R_ready
	WeaponBF_RightReady2RightFire=M14_R_readyTOBF_R
	WeaponBF_RightFire2RightReady=M14_BF_RTO_R_ready
	WeaponBF_RightReady2Rest=M14_R_readyTOrest
	WeaponBF_Rest2UpReady=M14_restTO_Up_ready
	WeaponBF_UpReady2UpFire=M14_Up_readyTOBF_Up
	WeaponBF_UpFire2UpReady=M14_BF_UpTO_Up_ready
	WeaponBF_UpReady2Rest=M14_Up_readyTOrest
	WeaponBF_LeftReady2Up=M14_L_ready_toUp_ready
	WeaponBF_LeftReady2Right=M14_L_ready_toR_ready
	WeaponBF_UpReady2Left=M14_Up_ready_toL_ready
	WeaponBF_UpReady2Right=M14_Up_ready_toR_ready
	WeaponBF_RightReady2Up=M14_R_ready_toUp_ready
	WeaponBF_RightReady2Left=M14_R_ready_toL_ready
	WeaponBF_LeftReady2Idle=M14_L_readyTOidle
	WeaponBF_RightReady2Idle=M14_R_readyTOidle
	WeaponBF_UpReady2Idle=M14_Up_readyTOidle
	WeaponBF_Idle2UpReady=M14_idleTO_Up_ready
	WeaponBF_Idle2LeftReady=M14_idleTO_L_ready
	WeaponBF_Idle2RightReady=M14_idleTO_R_ready

	// Enemy Spotting
	WeaponSpotEnemyAnim=M14_SpotEnemy
	WeaponSpotEnemySightedAnim=M14_SpotEnemy_ironsight

	// Melee anims
	WeaponMeleeAnims(0)=M14_Bash
	WeaponMeleeHardAnim=M14_BashHard
	WeaponBayonetMeleeAnims(0)=M14_Stab
	WeaponBayonetMeleeHardAnim=M14_StabHard
	MeleePullbackAnim=M14_Pullback
	MeleeHoldAnim=M14_Pullback_Hold

	WeaponAttachBayonetAnim=M14_Bayonet_Attach
	WeaponDetachBayonetAnim=M14_Bayonet_Detach
	BayonetSkelControlName=Bayonet_M14

	EquipTime=+0.8//1.00
	

	bDebugWeapon = false

  	BoltControllerNames[0]=BoltSlide_M14
  	BoltControllerNames[1]=BoltSlide_M14_2

	ISFocusDepth=30

	// Ammo
	MaxAmmoCount=21
	AmmoClass=class'ROAmmo_762x51_M14Mag' //class'ROAmmo_762x51_XM21Mag'
	bUsesMagazines=true
	InitialNumPrimaryMags=6//7
	bLosesRoundOnReload=false
	bPlusOneLoading=true
	bCanReloadNonEmptyMag=true
	bCanLoadStripperClip=false
	bCanLoadSingleBullet=false
	StripperClipBulletCount=5
	PenetrationDepth=17
	MaxPenetrationTests=3
	MaxNumPenetrations=2
	PerformReloadPct=0.82f

	PlayerViewOffset=(X=2.0,Y=4.5,Z=-3.25)
	// PlayerViewOffset=(X=1,Y=4,Z=-2.5)
	ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
	//ShoulderedTime=0.5
	// ShoulderedPosition=(X=3,Y=2,Z=-1.0)
	// ShoulderedPosition=(X=2,Y=2.8,Z=-1.0)
	ShoulderedPosition=(X=1.0,Y=2,Z=-2.75)
	//ShoulderRotation=(Pitch=-300,Yaw=500,Roll=1500)
	IronSightPosition=(X=-3.0,Y=1,Z=-2.5)

	ZoomInTime=0.35//0.38
	ZoomOutTime=0.25//0.32

	// Free Aim variables
	bUsesFreeAim=true
	FreeAimHipfireOffsetX=50

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=30,RightAmplitude=50,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.150)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	CollisionCheckLength=55.9 // (1118 * .1) / 2

	FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_SVT40_Shoot'
	FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_SVT40_Shoot'

	SightSlideControlName=Sight_Slide
	SightRotControlName=Sight_Rotation

	bHasScopePosition=true
	ScopePosition=(X=-5.5,Y=0.0,Z=-1.54)

	SuppressionPower=15

	// 100m zero
	ScopeSightRanges[0]=(SightRange=100,SightPositionOffset=0)
	ZeroOffsetMOAArray[0]=-5.75

	ScopeSightRanges[1]=(SightRange=200,SightPositionOffset=0)
	ZeroOffsetMOAArray[1]=-9

	ScopeSightRanges[2]=(SightRange=300,SightPositionOffset=0)
	ZeroOffsetMOAArray[2]=-13

	ScopeSightRanges[3]=(SightRange=400,SightPositionOffset=0)
	ZeroOffsetMOAArray[3]=-16.5

	ScopeSightRanges[4]=(SightRange=500,SightPositionOffset=0)
	ZeroOffsetMOAArray[4]=-21.5

	ScopeSightRanges[5]=(SightRange=600,SightPositionOffset=0)
	ZeroOffsetMOAArray[5]=-28.00

	ScopeSightRanges[6]=(SightRange=700,SightPositionOffset=0)
	ZeroOffsetMOAArray[6]=-35.00

	// Realistic zero (300 yards). Round is 5 inches high at 100m
	RealisticScopeSightRanges[0]=(SightRange=300,SightPositionOffset=0)
	RealisticZeroOffsetMOAArray[0]=-13	// 300m zero

	RealisticScopeSightRanges[1]=(SightRange=400,SightPositionOffset=0)
	RealisticZeroOffsetMOAArray[1]=-17.0

	RealisticScopeSightRanges[2]=(SightRange=500,SightPositionOffset=0)
	RealisticZeroOffsetMOAArray[2]=-22

	RealisticScopeSightRanges[3]=(SightRange=600,SightPositionOffset=0)
	RealisticZeroOffsetMOAArray[3]=-28

	RealisticScopeSightRanges[4]=(SightRange=700,SightPositionOffset=0)
	RealisticZeroOffsetMOAArray[4]=-35

	RealisticScopeSightRanges[5]=(SightRange=800,SightPositionOffset=0)
	RealisticZeroOffsetMOAArray[5]=-42

	RealisticScopeSightRanges[6]=(SightRange=900,SightPositionOffset=0)
	RealisticZeroOffsetMOAArray[6]=-51

	ScopePowerArray[0]=(Power=3.0)
	ScopePowerArray[1]=(Power=4.0)
	ScopePowerArray[2]=(Power=5.0)
	ScopePowerArray[3]=(Power=6.0)
	ScopePowerArray[4]=(Power=7.0)
	ScopePowerArray[5]=(Power=8.0)
	ScopePowerArray[6]=(Power=9.0)

	bUsesSightPictureAdjustment=true
	bForceUseComeUps=true

	FocusedDOFDistance=2.25

	SceneCaptureFOVScale=1.24

	WindageCorrection = 0

	EyeReliefPitchCorrection = 250
	EyeReliefPitchCorrectionIronSights = 250

	ZoomDialSkelControlName=ZoomDial_XM21

	ScopeDialInitialRotation = -11000

	SwayScale=0.9//1.29

	bHasBayonet=true
	BayonetAttackRange=84.0
	WeaponBayonetLength = 8.2
	RecoilModBayonetAttached=0.95f
}
