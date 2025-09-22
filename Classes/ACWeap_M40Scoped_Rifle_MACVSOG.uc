
//=============================================================================
// ROWeap_M40Scoped_Rifle
//=============================================================================
// M40 Scoped Bolt Action Rifle.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Nate Steger @ Antimatter Games LTD
// Modified for MACVSOG Mutator by Sgt. Capwell [29ID]
//=============================================================================
class ACWeap_M40Scoped_Rifle_MACVSOG extends ROSniperWeaponAdvanced
	abstract;

/**
 * Sets SceneCapture component to use new magnification
 * @Override to updated tombstone position
 */
simulated function ScopePowerIndexUpdated()
{
	super.ScopePowerIndexUpdated();
	ScopeLenseMIC.SetScalarParameterValue('v_position', ScopePowerArray[ScopePowerIndex].ReticleZOffset);
}

defaultproperties
{
	WeaponContentClass(0)="ROGameContent.ROWeap_M40Scoped_Rifle_Content"
	//WeaponContentClass(1)="ROGameContent.ROWeap_M40Scoped_Rifle_Level2"
	//WeaponContentClass(2)="ROGameContent.ROWeap_M40Scoped_Rifle_Level3"

	RoleSelectionImage(0)=Texture2D'VN_UI_Textures.WeaponTex.US_Weap_M40_SniperRifle'
//	RoleSelectionImage(1)=Texture2D'RS_UI_Textures_Three.WeaponRenders.USA_M1903A4_UPGD1'
//	RoleSelectionImage(2)=Texture2D'RS_UI_Textures_Three.WeaponRenders.USA_M1903A4_UPGD1'

	WeaponClassType=ROWCT_ScopedRifle
	TeamIndex=`ALLIES_TEAM_INDEX

	// Smaller collision buffer so scope doesn't get shoved back in our eyes
	FrontCollisionBufferDist=0.5

	// 2D scene capture
	Begin Object Name=ROSceneCapture2DDPGComponent0
	   TextureTarget=TextureRenderTarget2D'WP_Ger_Kar98k_Rifle.Materials.Kar98Lense'
	   FieldOfView=15 // "3.0X" = 32.5(our real world FOV determinant)/3
	End Object

	Category=ROIC_Primary 		//ROIC_Primary
	Weight=6.57
	InvIndex=`ROII_M40_SniperRifle
	InventoryWeight=7

	PlayerIronSightFOV=45.0//32.5f

	PreFireTraceLength=2500 //50 Meters

	// MAIN FIREMODE
	FiringStatesArray(0)=WeaponSingleFiring
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'M40Bullet'
	FireInterval(0)=1.1//+1.25
	DelayedRecoilTime(0)=0.01
	Spread(0)=0.000208 // approximately 0.75 MOA

	// ALT FIREMODE
	FiringStatesArray(ALTERNATE_FIREMODE)=WeaponManualSingleFiring
	WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
	WeaponProjectiles(ALTERNATE_FIREMODE)=class'M40Bullet'
	FireInterval(ALTERNATE_FIREMODE)=1.1//+1.25
	DelayedRecoilTime(ALTERNATE_FIREMODE)=0.01
	Spread(1)=0.000208 // approximately 0.75 MOA

	//ShoulderedSpreadMod=3.0//6.0
	//HippedSpreadMod=5.0//10.0

	// AI
	MinBurstAmount=1
	MaxBurstAmount=1
	//BurstWaitTime=1.5
	//AILongDistanceScale=1.25f
	//AIMediumDistanceScale=0.5f
	//AISpreadScale=200.0
	//AISpreadNoSeeScale=2.0
	//AISpreadNMEStillScale=0.5
	//AISpreadNMESprintScale=1.5

   	// Recoil
	maxRecoilPitch=810//860
	minRecoilPitch=810
	maxRecoilYaw=315
	minRecoilYaw=-315
	RecoilRate=0.07//0.1
	minRecoilYawAbsolute=100
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=2000
	RecoilMinPitchLimit=63535
	RecoilISMaxYawLimit=500
	RecoilISMinYawLimit=65035
	RecoilISMaxPitchLimit=1500
	RecoilISMinPitchLimit=64035
	RecoilViewRotationScale=0.75

	// InstantHitDamage(0)=115
	// InstantHitDamage(1)=115
	InstantHitDamage(0)=154
	InstantHitDamage(1)=154

	InstantHitDamageTypes(0)=class'RODmgType_M40Bullet'
	InstantHitDamageTypes(1)=class'RODmgType_M40Bullet'

	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_Rifles_round'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

	// Shell eject FX
	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_US_M40'

	bHasIronSights=true;
	bHasManualBolting=true;
	bAmmoCheckDoesBolting=true

	//Equip and putdown
	WeaponPutDownAnim=M40_Putaway
	WeaponEquipAnim=M40_Pullout
	WeaponDownAnim=M40_Down
	WeaponUpAnim=M40_Up

	// Fire Anims
	//Hip fire
   	WeaponFireAnim(0)=M40_Sniper_Hip_Bolt
	WeaponFireAnim(1)=M40_Sniper_Hip_Bolt
	WeaponFireLastAnim=M40_ShootLAST
	//Shouldered fire
	WeaponFireShoulderedAnim(0)=M40_Sniper_Hip_Bolt
	WeaponFireShoulderedAnim(1)=M40_Sniper_Hip_Bolt
	WeaponFireLastShoulderedAnim=M40_ShootLAST
	//Fire using iron sights
   	WeaponFireSightedAnim(0)=M40_Sniper_Iron_Bolt
	WeaponFireSightedAnim(1)=M40_Sniper_Iron_Bolt
	WeaponFireLastSightedAnim=M40_Sniper_Iron_ShootLAST
	//Fire through scope
	WeaponFireScopedAnim(0)=M40_Sniper_Scope_Bolt
	WeaponFireScopedAnim(1)=M40_Sniper_Scope_Bolt
	WeaponFireLastScopedAnim=M40_Sniper_Scope_ShootLAST
	//Manual bolting
	WeaponManualBoltAnim=M40_Sniper_Manual_Bolt
	WeaponManualBoltRestAnim=M40_Sniper_Iron_Manual_Bolt_rest
	WeaponManualBoltScopedAnim=M40_Sniper_Scope_Manual_Bolt

	// Idle Anims
	// Hip Idle
   	WeaponIdleAnims(0)=M40_Shoulder_Idle
	WeaponIdleAnims(1)=M40_Shoulder_Idle
	// Shouldered idle
	WeaponIdleShoulderedAnims(0)=M40_Shoulder_Idle
	WeaponIdleShoulderedAnims(1)=M40_Shoulder_Idle
	// Sighted Idle
	WeaponIdleSightedAnims(0)=M40_Sniper_Idle
	WeaponIdleSightedAnims(1)=M40_Sniper_Idle

	// Prone Crawl
	WeaponCrawlingAnims(0)=M40_CrawlF
	WeaponCrawlStartAnim=M40_Crawl_into
	WeaponCrawlEndAnim=M40_Crawl_out

	//Reloading
	WeaponReloadStripperAnim=M40_Reload
	WeaponReloadSingleBulletAnim=M40_single_Insert
	WeaponReloadEmptySingleBulletAnim=M40_single_Insert_empty
	WeaponOpenBoltAnim=M40_single_open
	WeaponOpenBoltEmptyAnim=M40_single_open_empty
	WeaponCloseBoltAnim=M40_single_close
	WeaponRestReloadStripperAnim=M40_Reload_rest
	WeaponRestReloadSingleBulletAnim=M40_single_Insert_rest
	WeaponRestReloadEmptySingleBulletAnim=M40_single_Insert_empty_rest
	WeaponRestOpenBoltAnim=M40_single_open_rest
	WeaponRestOpenBoltEmptyAnim=M40_single_open_empty_rest
	WeaponRestCloseBoltAnim=M40_single_close_rest
	// Ammo check
	WeaponAmmoCheckAnim=M40_ammocheck
	WeaponRestAmmoCheckAnim=M40_Ammocheck_rest

	// Sprinting
	WeaponSprintStartAnim=M40_sprint_into
	WeaponSprintLoopAnim=M40_Sprint
	WeaponSprintEndAnim=M40_sprint_out
	Weapon1HSprintStartAnim=M40_Sniper_1H_sprint_into
	Weapon1HSprintLoopAnim=M40_Sniper_1H_Sprint
	Weapon1HSprintEndAnim=M40_Sniper_1H_sprint_out

	// Mantling
	WeaponMantleOverAnim=M40_Mantle

	// Cover/Blind Fire Anims
	WeaponRestAnim=M40_rest_idle
	WeaponEquipRestAnim=M40_pullout_rest
	WeaponPutDownRestAnim=M40_putaway_rest
	WeaponBlindFireRightAnim=M40_BF_Right_Shoot
	WeaponBlindFireLeftAnim=M40_BF_Left_Shoot
	WeaponBlindFireUpAnim=M40_BF_up_Shoot
	WeaponIdleToRestAnim=M40_idleTOrest
	WeaponRestToIdleAnim=M40_restTOidle
	WeaponRestToBlindFireRightAnim=M40_restTOBF_Right
	WeaponRestToBlindFireLeftAnim=M40_restTOBF_Left
	WeaponRestToBlindFireUpAnim=M40_restTOBF_up
	WeaponBlindFireRightToRestAnim=M40_BF_Right_TOrest
	WeaponBlindFireLeftToRestAnim=M40_BF_Left_TOrest
	WeaponBlindFireUpToRestAnim=M40_BF_up_TOrest
	WeaponBFLeftToUpTransAnim=M40_BFleft_toBFup
	WeaponBFRightToUpTransAnim=M40_BFright_toBFup
	WeaponBFUpToLeftTransAnim=M40_BFup_toBFleft
	WeaponBFUpToRightTransAnim=M40_BFup_toBFright
	// Blind Fire ready
	WeaponBF_Rest2LeftReady=M40_restTO_L_ready
	WeaponBF_LeftReady2LeftFire=M40_L_readyTOBF_L
	WeaponBF_LeftFire2LeftReady=M40_BF_LTO_L_ready
	WeaponBF_LeftReady2Rest=M40_L_readyTOrest
	WeaponBF_Rest2RightReady=M40_restTO_R_ready
	WeaponBF_RightReady2RightFire=M40_R_readyTOBF_R
	WeaponBF_RightFire2RightReady=M40_BF_RTO_R_ready
	WeaponBF_RightReady2Rest=M40_R_readyTOrest
	WeaponBF_Rest2UpReady=M40_restTO_Up_ready
	WeaponBF_UpReady2UpFire=M40_Up_readyTOBF_Up
	WeaponBF_UpFire2UpReady=M40_BF_UpTO_Up_ready
	WeaponBF_UpReady2Rest=M40_Up_readyTOrest
	WeaponBF_LeftReady2Up=M40_L_ready_toUp_ready
	WeaponBF_LeftReady2Right=M40_L_ready_toR_ready
	WeaponBF_UpReady2Left=M40_Up_ready_toL_ready
	WeaponBF_UpReady2Right=M40_Up_ready_toR_ready
	WeaponBF_RightReady2Up=M40_R_ready_toUp_ready
	WeaponBF_RightReady2Left=M40_R_ready_toL_ready
	WeaponBF_LeftReady2Idle=M40_L_readyTOidle
	WeaponBF_RightReady2Idle=M40_R_readyTOidle
	WeaponBF_UpReady2Idle=M40_Up_readyTOidle
	WeaponBF_Idle2UpReady=M40_idleTO_Up_ready
	WeaponBF_Idle2LeftReady=M40_idleTO_L_ready
	WeaponBF_Idle2RightReady=M40_idleTO_R_ready

	// Enemy Spotting
	WeaponSpotEnemyAnim=M40_SpotEnemy
	WeaponSpotEnemySightedAnim=M40_SpotEnemy_ironsight

	// Melee anims
	WeaponMeleeAnims(0)=M40_Bash
	WeaponMeleeHardAnim=M40_BashHard
	MeleePullbackAnim=M40_Pullback
	MeleeHoldAnim=M40_Pullback_Hold

	EquipTime=+0.66//0.75

	bDebugWeapon = false

	BoltControllerNames[0]=BoltSlide_M40

	ISFocusDepth=30

	//Ammo
	MaxAmmoCount=5
	AmmoClass=class'ROAmmo_762x51_M40Stripper'
	bUsesMagazines=false
	InitialNumPrimaryMags=18//12
	bLosesRoundOnReload=true
	bPlusOneLoading=false
	bCanReloadNonEmptyMag=false//true
	bCanLoadStripperClip=false//true
	bCanLoadSingleBullet=true
	StripperClipBulletCount=5
	PenetrationDepth=23.5
	MaxPenetrationTests=3
	MaxNumPenetrations=2
	PerformReloadPct=0.60f

	PlayerViewOffset=(X=4.5,Y=4.5,Z=-2.5)//(X=-1,Y=4,Z=-2)
	ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
	//ShoulderedTime=0.35
	ShoulderedPosition=(X=3.5,Y=2,Z=-1.75)
	// ShoulderedPosition=(X=3,Y=3.5,Z=-1.0)
	//ShoulderRotation=(Pitch=-300,Yaw=500,Roll=1500)

	bUsesFreeAim=true

	//Free Aim variables
	FreeAimHipfireOffsetX=45

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=30,RightAmplitude=50,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.200)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	CollisionCheckLength=55.85

	FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_KAR98_Shoot'
	FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_KAR98_Shoot'

	bHasScopePosition=true
	IronSightPosition=(X=-4.0,Y=1,Z=-2.5)

	ScopePosition=(X=-3.5,Y=0.1,Z=-0.64)

	// This data is converted from YARDS to METERS (it's what the scope uses!)
	// Rounding all come-ups to the nearest 1/2 MOA

	ScopeSightRanges[0]=(SightRange=90,SightPositionOffset=-0.01) // the Redfield 3x9 has MOA adjustment. Setting this so the tombstone is properly offset in ClientWeaponSet
	ZeroOffsetMOAArray[0]=-5.0

	ScopeSightRanges[1]=(SightRange=185,SightPositionOffset=-0.01)
	ZeroOffsetMOAArray[1]=-7.0	// -5.7 inches @ 200yd

	ScopeSightRanges[2]=(SightRange=275,SightPositionOffset=-0.01)
	ZeroOffsetMOAArray[2]=-10	// -19.7 inches @ 300yd

	ScopeSightRanges[3]=(SightRange=365,SightPositionOffset=-0.01)
	ZeroOffsetMOAArray[3]=-15	// -43.7 inches @ 400yd

	ScopeSightRanges[4]=(SightRange=455,SightPositionOffset=-0.01)
	ZeroOffsetMOAArray[4]=-19.5	// -79.4 inches @ 500yd

	ScopeSightRanges[5]=(SightRange=550,SightPositionOffset=-0.01)
	ZeroOffsetMOAArray[5]=-24	// -129.1 inches @ 600yd

	// ScopeSightRanges[6]=(SightRange=640,SightPositionOffset=0)
	// ZeroOffsetMOAArray[6]=-30	// -195.6 inches @ 700yd

	// ScopeSightRanges[7]=(SightRange=732,SightPositionOffset=0)
	// ZeroOffsetMOAArray[7]=-37	// -282.5 inches @ 800yd

	// ScopeSightRanges[8]=(SightRange=823,SightPositionOffset=0)
	// ZeroOffsetMOAArray[8]=-46	// -393.6 inches @ 900yd

	// ScopeSightRanges[9]=(SightRange=914,SightPositionOffset=0)
	// ZeroOffsetMOAArray[9]=-55	// -533.2 inches @ 1000yd

	ScopePowerArray[0]=(Power=3.0,ReticleZOffset= 0.015)
	ScopePowerArray[1]=(Power=4.0,ReticleZOffset=-0.12)
	ScopePowerArray[2]=(Power=5.0,ReticleZOffset=-0.18)
	ScopePowerArray[3]=(Power=6.0,ReticleZOffset=-0.225)
	ScopePowerArray[4]=(Power=7.0,ReticleZOffset=-0.26)
	ScopePowerArray[5]=(Power=8.0,ReticleZOffset=-0.295)
	ScopePowerArray[6]=(Power=9.0,ReticleZOffset=-0.335)

	SuppressionPower=20

	bUsesSightPictureAdjustment=true

	bForceUseComeUps=true

	MOAOffsetAtZero=-8.5 // 300 yards
	AdjustMOAIncrement=0.5 // 1/2 MOA ticks
	MinMOAAdjustment= -28.0 //
	MaxMOAAdjustment= +28.0

	SceneCaptureFOVScale=1.4

	WindageCorrection=0

	ZoomInTime=0.3//0.45
	ZoomOutTime=0.25//0.4

	SwayScale=0.7//1.2

	WeaponFireSnd(DEFAULT_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M40.Play_WEP_M40_Fire_Single_3P',FirstPersonCue=AkEvent'WW_WEP_M40.Play_WEP_M40_Fire_Single')
	WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M40.Play_WEP_M40_Fire_Single_3P',FirstPersonCue=AkEvent'WW_WEP_M40.Play_WEP_M40_Fire_Single')
}
