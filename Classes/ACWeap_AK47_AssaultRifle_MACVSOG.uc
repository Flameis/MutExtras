//=============================================================================
// ROWeap_AK47_AssaultRifle
//=============================================================================
// Derivatives of the AK-47 Assault Rifle. Chinese Type 56-1, Type 56 and Russian AKM
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
// Ammo Count modified by Sgt. Capwell [29ID]
//=============================================================================
class ACWeap_AK47_AssaultRifle_MACVSOG extends ROProjectileWeapon
	abstract;

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	// Run this before we call the super
	if(BayonetSkelControlName != '')
	{
		BayonetSkelControl = SkelControlSingleBone( SkeletalMeshComponent(Mesh).FindSkelControl(BayonetSkelControlName) );
		BayonetSkelControl.SetSkelControlStrength( 0.0f , 0.0f );	// default off
	}

	super.PostInitAnimTree(SkelComp);
}

// @TEMP - triple spread for most handheld weapons
simulated function float GetSpreadMod()
{
	return 3 * super.GetSpreadMod();
}

defaultproperties
{
	WeaponContentClass(0)="ROGameContent.ROWeap_AK47_AssaultRifle_Type56"
	WeaponContentClass(1)="ROGameContent.ROWeap_AK47_AssaultRifle_Type56_1"
	WeaponContentClass(2)="ROGameContent.ROWeap_AK47_AssaultRifle_AKM"

	RoleSelectionImage(0)=Texture2D'VN_UI_Textures.WeaponTex.VN_Weap_Type56_Rifle'
	RoleSelectionImage(1)=Texture2D'VN_UI_Textures.WeaponTex.VN_Weap_Type56-1_Rifle'
	RoleSelectionImage(2)=Texture2D'VN_UI_Textures.WeaponTex.VN_Weap_AKM_Rifle'

	WeaponClassType=ROWCT_AssaultRifle
	TeamIndex=`AXIS_TEAM_INDEX

	Category=ROIC_Primary
	Weight=4.03 //KG
	InvIndex=`ROII_Type56_AssaultRifle
	InventoryWeight=6

	PlayerIronSightFOV=45.0 //50.0

	PreFireTraceLength=1250 //25 Meters

	// MAIN FIREMODE
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'Type56Bullet'
	bLoopHighROFSounds(0)=true
	FireInterval(0)=+0.092 // ~650 RPM
	DelayedRecoilTime(0)=0.0
	Spread(0)=0.00125 // ~4.5 MOA

	// ALT FIREMODE
	FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
	WeaponProjectiles(ALTERNATE_FIREMODE)=class'Type56Bullet'
	FireInterval(ALTERNATE_FIREMODE)=+0.092
	DelayedRecoilTime(ALTERNATE_FIREMODE)=0.0
	Spread(ALTERNATE_FIREMODE)=0.00125 // ~4.5 MOA

	AltFireModeType=ROAFT_Bayonet

	//ShoulderedSpreadMod=3.0//6.0
	//HippedSpreadMod=5.0//10.0

	// AI
	MinBurstAmount=1
	MaxBurstAmount=15
	//BurstWaitTime=0.5

	// Recoil
	maxRecoilPitch=250//260 //350
	minRecoilPitch=250//260 //300
	maxRecoilYaw=135//150 //200
	minRecoilYaw=-35//-150 //-200
	RecoilRate=0.092//0.07//0.085
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=900
	RecoilMinPitchLimit=64785
	RecoilISMaxYawLimit=500
	RecoilISMinYawLimit=65035
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65035
   	RecoilBlendOutRatio=0.55//0.75//0.45
   	//PostureHippedRecoilModifer=2.0
   	//PostureShoulderRecoilModifer=1.75

	// InstantHitDamage(0)=123
	// InstantHitDamage(1)=123
	InstantHitDamage(0)=86
	InstantHitDamage(1)=86

	InstantHitDamageTypes(0)=class'RODmgType_Type56Bullet'
	InstantHitDamageTypes(1)=class'RODmgType_Type56Bullet'

	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_Rifles_round'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

	// Shell eject FX
	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_VC_AK47'

	bHasIronSights=true;

	//Equip and putdown
	WeaponPutDownAnim=AK47_putaway
	WeaponEquipAnim=AK47_pullout
	WeaponDownAnim=AK47_Down
	WeaponUpAnim=AK47_Up

	// Fire Anims
	//Hip fire
	WeaponFireAnim(0)=AK47_shoot
	WeaponFireAnim(1)=AK47_shoot
	WeaponFireLastAnim=AK47_shootLAST
	//Shouldered fire
	WeaponFireShoulderedAnim(0)=AK47_shoot
	WeaponFireShoulderedAnim(1)=AK47_shoot
	WeaponFireLastShoulderedAnim=AK47_shootLAST
	//Fire using iron sights
	WeaponFireSightedAnim(0)=AK47_iron_shoot
	WeaponFireSightedAnim(1)=AK47_iron_shoot
	WeaponFireLastSightedAnim=AK47_iron_shootLAST

	// Idle Anims
	//Hip Idle
	WeaponIdleAnims(0)=AK47_shoulder_idle
	WeaponIdleAnims(1)=AK47_shoulder_idle
	// Shouldered idle
	WeaponIdleShoulderedAnims(0)=AK47_shoulder_idle
	WeaponIdleShoulderedAnims(1)=AK47_shoulder_idle
	//Sighted Idle
	WeaponIdleSightedAnims(0)=AK47_iron_idle
	WeaponIdleSightedAnims(1)=AK47_iron_idle

	// Prone Crawl
	WeaponCrawlingAnims(0)=AK47_CrawlF
	WeaponCrawlStartAnim=AK47_Crawl_into
	WeaponCrawlEndAnim=AK47_Crawl_out

	//Reloading
	WeaponReloadEmptyMagAnim=AK47_reloadempty
	WeaponReloadNonEmptyMagAnim=AK47_reloadhalf
	WeaponRestReloadEmptyMagAnim=AK47_reloadempty_rest
	WeaponRestReloadNonEmptyMagAnim=AK47_reloadhalf_rest
	// Ammo check
	WeaponAmmoCheckAnim=AK47_ammocheck
	WeaponRestAmmoCheckAnim=AK47_ammocheck_rest

	// Sprinting
	WeaponSprintStartAnim=AK47_sprint_into
	WeaponSprintLoopAnim=AK47_Sprint
	WeaponSprintEndAnim=AK47_sprint_out
	Weapon1HSprintStartAnim=AK47_1H_sprint_into
	Weapon1HSprintLoopAnim=AK47_1H_Sprint
	Weapon1HSprintEndAnim=AK47_1H_sprint_out

	// Mantling
	WeaponMantleOverAnim=AK47_Mantle
	WeaponSwitchToAltFireModeAnim=AK47_AutoTOsemi
  	WeaponSwitchToDefaultFireModeAnim=AK47_SemiTOauto

	// Cover/Blind Fire Anims
	WeaponRestAnim=AK47_rest_idle
	WeaponEquipRestAnim=AK47_pullout_rest
	WeaponPutDownRestAnim=AK47_putaway_rest
	WeaponBlindFireRightAnim=AK47_BF_Right_Shoot
	WeaponBlindFireLeftAnim=AK47_BF_Left_Shoot
	WeaponBlindFireUpAnim=AK47_BF_up_Shoot
	WeaponIdleToRestAnim=AK47_idleTOrest
	WeaponRestToIdleAnim=AK47_restTOidle
	WeaponRestToBlindFireRightAnim=AK47_restTOBF_Right
	WeaponRestToBlindFireLeftAnim=AK47_restTOBF_Left
	WeaponRestToBlindFireUpAnim=AK47_restTOBF_up
	WeaponBlindFireRightToRestAnim=AK47_BF_Right_TOrest
	WeaponBlindFireLeftToRestAnim=AK47_BF_Left_TOrest
	WeaponBlindFireUpToRestAnim=AK47_BF_up_TOrest
	WeaponBFLeftToUpTransAnim=AK47_BFleft_toBFup
	WeaponBFRightToUpTransAnim=AK47_BFright_toBFup
	WeaponBFUpToLeftTransAnim=AK47_BFup_toBFleft
	WeaponBFUpToRightTransAnim=AK47_BFup_toBFright
	// Blind Fire ready
	WeaponBF_Rest2LeftReady=AK47_restTO_L_ready
	WeaponBF_LeftReady2LeftFire=AK47_L_readyTOBF_L
	WeaponBF_LeftFire2LeftReady=AK47_BF_LTO_L_ready
	WeaponBF_LeftReady2Rest=AK47_L_readyTOrest
	WeaponBF_Rest2RightReady=AK47_restTO_R_ready
	WeaponBF_RightReady2RightFire=AK47_R_readyTOBF_R
	WeaponBF_RightFire2RightReady=AK47_BF_RTO_R_ready
	WeaponBF_RightReady2Rest=AK47_R_readyTOrest
	WeaponBF_Rest2UpReady=AK47_restTO_Up_ready
	WeaponBF_UpReady2UpFire=AK47_Up_readyTOBF_Up
	WeaponBF_UpFire2UpReady=AK47_BF_UpTO_Up_ready
	WeaponBF_UpReady2Rest=AK47_Up_readyTOrest
	WeaponBF_LeftReady2Up=AK47_L_ready_toUp_ready
	WeaponBF_LeftReady2Right=AK47_L_ready_toR_ready
	WeaponBF_UpReady2Left=AK47_Up_ready_toL_ready
	WeaponBF_UpReady2Right=AK47_Up_ready_toR_ready
	WeaponBF_RightReady2Up=AK47_R_ready_toUp_ready
	WeaponBF_RightReady2Left=AK47_R_ready_toL_ready
	WeaponBF_LeftReady2Idle=AK47_L_readyTOidle
	WeaponBF_RightReady2Idle=AK47_R_readyTOidle
	WeaponBF_UpReady2Idle=AK47_Up_readyTOidle
	WeaponBF_Idle2UpReady=AK47_idleTO_Up_ready
	WeaponBF_Idle2LeftReady=AK47_idleTO_L_ready
	WeaponBF_Idle2RightReady=AK47_idleTO_R_ready

	// Enemy Spotting
	WeaponSpotEnemyAnim=AK47_SpotEnemy
	WeaponSpotEnemySightedAnim=AK47_SpotEnemy_ironsight

	// Melee anims
	WeaponMeleeAnims(0)=AK47_Bash
	WeaponBayonetMeleeAnims(0)=AK47_Stab
	WeaponMeleeHardAnim=AK47_BashHard
	WeaponBayonetMeleeHardAnim=AK47_StabHard
	MeleePullbackAnim=AK47_Pullback
	MeleeHoldAnim=AK47_Pullback_Hold

	WeaponAttachBayonetAnim=AK47_Bayonet_Attach
	WeaponDetachBayonetAnim=AK47_Bayonet_Detach

	ReloadMagazinEmptyCameraAnim=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_reloadempty'

	EquipTime=+0.66//1.00

	bDebugWeapon = false

	BoltControllerNames[0]=BoltSlide_AK

	FireModeRotControlName=FireSelect_AK47

	BayonetSkelControlName=Bayonet_AK

	ISFocusDepth=36

	// Ammo
	AmmoClass=class'ROAmmo_762x39_AK47Mag'
	MaxAmmoCount=31
	bUsesMagazines=true
	InitialNumPrimaryMags=7//6
	bPlusOneLoading=true
	bCanReloadNonEmptyMag=true
	PenetrationDepth=15
	MaxPenetrationTests=3
	MaxNumPenetrations=2

	PlayerViewOffset=(X=4.5,Y=4.5,Z=-2)
	ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
	ShoulderedPosition=(X=4.0,Y=2.0,Z=-0.75)
	//ShoulderRotation=(Pitch=-300,Yaw=500,Roll=1500)
	IronSightPosition=(X=-3,Y=0.01,Z=-0.055)

	RestDeployCollisionSize=(X=4,Y=8,Z=12)

	bUsesFreeAim=true

	ZoomInTime=0.3//0.35
	ZoomOutTime=0.2

	// Free Aim variables
	FreeAimHipfireOffsetX=20.7

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	CollisionCheckLength=43.7

	FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_Shoot'
	FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_Shoot'
	ShakeScaleSighted=2.5
	ShakeScaleStandard=1.75

	SightSlideControlName=Sight_Slide
	SightRotControlName=Sight_Rotation

	SightRanges[0]=(SightRange=100,SightPitch=0,SightSlideOffset=0.0,SightPositionOffset=0.0, AddedPitch = -240 )
	SightRanges[1]=(SightRange=200,SightPitch=215,SightSlideOffset=-0.15,SightPositionOffset=-0.10, AddedPitch = -270)
	SightRanges[2]=(SightRange=300,SightPitch=375,SightSlideOffset=0.095,SightPositionOffset=-0.16, AddedPitch = -270)
	SightRanges[3]=(SightRange=400,SightPitch=575,SightSlideOffset=0.35,SightPositionOffset=-0.25, AddedPitch = -270)
	SightRanges[4]=(SightRange=500,SightPitch=800,SightSlideOffset=0.53,SightPositionOffset=-0.35, AddedPitch = -270)
	SightRanges[5]=(SightRange=600,SightPitch=1065,SightSlideOffset=0.73,SightPositionOffset=-0.47, AddedPitch = -270)
	SightRanges[6]=(SightRange=700,SightPitch=1380,SightSlideOffset=0.9,SightPositionOffset=-0.60, AddedPitch = -270)
	SightRanges[7]=(SightRange=800,SightPitch=1725,SightSlideOffset=1.07,SightPositionOffset=-0.74, AddedPitch = -270)

	SuppressionPower=10

	RecoilModBayonetAttached=0.98f

	bHasBayonet=true
	BayonetAttackRange=73.0

	SwayScale=1.05//1.15

	RecoilOffsetModY = 1300.f
	RecoilOffsetModZ = 1150.f

	WeaponBayonetLength = 9.8

	PerformReloadPct=0.81
}

