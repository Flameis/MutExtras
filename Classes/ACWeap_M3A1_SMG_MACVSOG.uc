//=============================================================================
// ROWeap_M3A1_SMG
//=============================================================================
// M3A1 "Grease Gun" Sub machine gun
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ACWeap_M3A1_SMG_MACVSOG extends ROProjectileWeapon
	abstract;

// @TEMP - triple spread for most handheld weapons
simulated function float GetSpreadMod()
{
	return 3 * super.GetSpreadMod();
}

defaultproperties
{
	WeaponContentClass(0)="ROGameContent.ROWeap_M3A1_SMG_Content"

	RoleSelectionImage(0)=Texture2D'VN_UI_Textures.WeaponTex.US_Weap_M3A1_SMG'

	WeaponClassType=ROWCT_SMG
	TeamIndex=`ALLIES_TEAM_INDEX

	Category=ROIC_Primary
	Weight=3.61 //KG
	InvIndex=`ROII_M3A1_SMG
	InventoryWeight=3

	PlayerIronSightFOV=55.0

	PreFireTraceLength=1250 //25 Meters

	// MAIN FIREMODE
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'M3A1Bullet'
	FireInterval(0)=+0.13 // 450 RPM
	Spread(0)=0.0043 // 15.48 MOA
	WeaponDryFireSnd=AkEvent'WW_WEP_Shared.Play_WEP_Generic_Dry_Fire'

	// ALT FIREMODE
	FiringStatesArray(ALTERNATE_FIREMODE)=none
	//WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
	WeaponProjectiles(ALTERNATE_FIREMODE)=none
	FireInterval(ALTERNATE_FIREMODE)=+0.13
	Spread(ALTERNATE_FIREMODE)=0.005375 //19.35 MOA // 15.48 MOA


	AltFireModeType=ROAFT_ExtendStock

	//ShoulderedSpreadMod=3.0//6.0
	//HippedSpreadMod=5.0//10.0

	// AI
	MinBurstAmount=1
	MaxBurstAmount=15
	//BurstWaitTime=1.0
	//AISpreadScale=20.0

	// Recoil
	maxRecoilPitch=70//90//200
	minRecoilPitch=70//50//110
	maxRecoilYaw=50//130
	minRecoilYaw=-50//-130
	RecoilRate=0.1
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=750
	RecoilMinPitchLimit=64785
	RecoilISMaxYawLimit=500
	RecoilISMinYawLimit=65035
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65035
   	RecoilBlendOutRatio=1
   	//PostureHippedRecoilModifer=2.0
   	//PostureShoulderRecoilModifer=1.75

	// InstantHitDamage(0)=230
	// InstantHitDamage(1)=230
	InstantHitDamage(0)=106
	InstantHitDamage(1)=106

	InstantHitDamageTypes(0)=class'RODmgType_M3A1Bullet'
	InstantHitDamageTypes(1)=class'RODmgType_M3A1Bullet'

	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_SMG'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

	// Shell eject FX
	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_USA_M3A1'

	ReloadingSmokePSCTemplate=ParticleSystem'FX_VN_Weapons.Emitter.FX_ReloadingSmoke_SMG'

	bHasIronSights=true;

	//Equip and putdown
	WeaponPutDownAnim=M3GG_putaway
	WeaponEquipAnim=M3GG_pullout
	WeaponDownAnim=M3GG_Down
	WeaponUpAnim=M3GG_Up

	// Fire Anims
	//Hip fire
	WeaponFireAnim(0)=M3GG_shoot
	WeaponFireAnim(1)=M3GG_shoot
	WeaponFireLastAnim=M3GG_shootLAST
	//Shouldered fire
	WeaponFireShoulderedAnim(0)=M3GG_shoot
	WeaponFireShoulderedAnim(1)=M3GG_shoot
	WeaponFireLastShoulderedAnim=M3GG_shootLAST
	//Fire using iron sights
	WeaponFireSightedAnim(0)=M3GG_iron_shoot
	WeaponFireSightedAnim(1)=M3GG_iron_shoot
	WeaponFireLastSightedAnim=M3GG_iron_shootLAST

	// Idle Anims
	//Hip Idle
	WeaponIdleAnims(0)=M3GG_shoulder_idle
	WeaponIdleAnims(1)=M3GG_shoulder_idle
	// Shouldered idle
	WeaponIdleShoulderedAnims(0)=M3GG_shoulder_idle
	WeaponIdleShoulderedAnims(1)=M3GG_shoulder_idle
	//Sighted Idle
	WeaponIdleSightedAnims(0)=M3GG_iron_idle
	WeaponIdleSightedAnims(1)=M3GG_iron_idle

	// Prone Crawl
	WeaponCrawlingAnims(0)=M3GG_CrawlF
	WeaponCrawlStartAnim=M3GG_Crawl_into
	WeaponCrawlEndAnim=M3GG_Crawl_out

	//Reloading
	WeaponReloadEmptyMagAnim=M3GG_reloadempty
	WeaponReloadNonEmptyMagAnim=M3GG_reloadhalf
	WeaponRestReloadEmptyMagAnim=M3GG_reloadempty_rest
	WeaponRestReloadNonEmptyMagAnim=M3GG_reloadhalf_rest
	// Ammo check
	WeaponAmmoCheckAnim=M3GG_ammocheck
	WeaponRestAmmoCheckAnim=M3GG_ammocheck_rest

	// Sprinting
	WeaponSprintStartAnim=M3GG_sprint_into
	WeaponSprintLoopAnim=M3GG_Sprint
	WeaponSprintEndAnim=M3GG_sprint_out
	Weapon1HSprintStartAnim=M3GG_1H_sprint_into
	Weapon1HSprintLoopAnim=M3GG_1H_Sprint
	Weapon1HSprintEndAnim=M3GG_1H_sprint_out

	// Mantling
	WeaponMantleOverAnim=M3GG_Mantle

	// Cover/Blind Fire Anims
	WeaponRestAnim=M3GG_rest_idle
	WeaponEquipRestAnim=M3GG_pullout_rest
	WeaponPutDownRestAnim=M3GG_putaway_rest
	WeaponBlindFireRightAnim=M3GG_BF_Right_Shoot
	WeaponBlindFireLeftAnim=M3GG_BF_Left_Shoot
	WeaponBlindFireUpAnim=M3GG_BF_up_Shoot
	WeaponIdleToRestAnim=M3GG_idleTOrest
	WeaponRestToIdleAnim=M3GG_restTOidle
	WeaponRestToBlindFireRightAnim=M3GG_restTOBF_Right
	WeaponRestToBlindFireLeftAnim=M3GG_restTOBF_Left
	WeaponRestToBlindFireUpAnim=M3GG_restTOBF_up
	WeaponBlindFireRightToRestAnim=M3GG_BF_Right_TOrest
	WeaponBlindFireLeftToRestAnim=M3GG_BF_Left_TOrest
	WeaponBlindFireUpToRestAnim=M3GG_BF_up_TOrest
	WeaponBFLeftToUpTransAnim=M3GG_BFleft_toBFup
	WeaponBFRightToUpTransAnim=M3GG_BFright_toBFup
	WeaponBFUpToLeftTransAnim=M3GG_BFup_toBFleft
	WeaponBFUpToRightTransAnim=M3GG_BFup_toBFright
	// Blind Fire ready
	WeaponBF_Rest2LeftReady=M3GG_restTO_L_ready
	WeaponBF_LeftReady2LeftFire=M3GG_L_readyTOBF_L
	WeaponBF_LeftFire2LeftReady=M3GG_BF_LTO_L_ready
	WeaponBF_LeftReady2Rest=M3GG_L_readyTOrest
	WeaponBF_Rest2RightReady=M3GG_restTO_R_ready
	WeaponBF_RightReady2RightFire=M3GG_R_readyTOBF_R
	WeaponBF_RightFire2RightReady=M3GG_BF_RTO_R_ready
	WeaponBF_RightReady2Rest=M3GG_R_readyTOrest
	WeaponBF_Rest2UpReady=M3GG_restTO_Up_ready
	WeaponBF_UpReady2UpFire=M3GG_Up_readyTOBF_Up
	WeaponBF_UpFire2UpReady=M3GG_BF_UpTO_Up_ready
	WeaponBF_UpReady2Rest=M3GG_Up_readyTOrest
	WeaponBF_LeftReady2Up=M3GG_L_ready_toUp_ready
	WeaponBF_LeftReady2Right=M3GG_L_ready_toR_ready
	WeaponBF_UpReady2Left=M3GG_Up_ready_toL_ready
	WeaponBF_UpReady2Right=M3GG_Up_ready_toR_ready
	WeaponBF_RightReady2Up=M3GG_R_ready_toUp_ready
	WeaponBF_RightReady2Left=M3GG_R_ready_toL_ready
	WeaponBF_LeftReady2Idle=M3GG_L_readyTOidle
	WeaponBF_RightReady2Idle=M3GG_R_readyTOidle
	WeaponBF_UpReady2Idle=M3GG_Up_readyTOidle
	WeaponBF_Idle2UpReady=M3GG_idleTO_Up_ready
	WeaponBF_Idle2LeftReady=M3GG_idleTO_L_ready
	WeaponBF_Idle2RightReady=M3GG_idleTO_R_ready

	// Enemy Spotting
	WeaponSpotEnemyAnim=M3GG_SpotEnemy
	WeaponSpotEnemySightedAnim=M3GG_SpotEnemy_ironsight

	// Melee anims
	WeaponMeleeAnims(0)=M3GG_Bash
	WeaponMeleeHardAnim=M3GG_BashHard
	MeleePullbackAnim=M3GG_Pullback
	MeleeHoldAnim=M3GG_Pullback_Hold

	WeaponExtendStockAnim=M3GG_Stock_extend
	WeaponRetractStockAnim=M3GG_Stock_retract

	ReloadMagazinEmptyCameraAnim=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_reloadempty'

	EquipTime=+0.66//0.75

	bDebugWeapon = false

	BoltControllerNames[0]=BoltSlide_M3

	StockSkelControlNames[0]=StockSlide_M3
	bReverseStockControls=true

	ISFocusDepth=15

	SuppressionPower=5

	// Ammo
	AmmoClass=class'ROAmmo_1143x23_M3A1Mag'
	MaxAmmoCount=30
	bUsesMagazines=true
	InitialNumPrimaryMags=7//6
	bPlusOneLoading=false
	bCanReloadNonEmptyMag=true
	PenetrationDepth=13
	MaxPenetrationTests=3
	MaxNumPenetrations=2
	PerformReloadPct=0.70f

	PlayerViewOffset=(X=4.5,Y=4.5,Z=-1.75)
	ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
	//ShoulderedTime=0.5
	ShoulderedPosition=(X=3.5,Y=2,Z=-1.0)
	//ShoulderRotation=(Pitch=-300,Yaw=500,Roll=1500)

	bUsesFreeAim=true

	ZoomInTime=0.25//0.3
	ZoomOutTime=0.25//0.22
	IronSightPosition=(X=2.2,Y=0,Z=0)
	// RetractedStockIronSightPosition=(X=3,Y=1,Z=-1)
	RetractedStockIronSightPosition=(X=5,Y=0.5,Z=-0.1)
	RetractedStockAlignmentScale = 0.3f
	RecoilOffsetModY = 1300.f
	RecoilOffsetModZ = 1100.f
	//SwayOffsetMod = 1200.f

	// Free Aim variables
	FreeAimHipfireOffsetX=35

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	CollisionCheckLength=38.0

	FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_Shoot'
	FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_Shoot'

	SightRanges[0]=(SightRange=100,SightPitch=0,SightPositionOffset=0,AddedPitch=75)

	// bUsingRetractedStock=false

	SwayScale=0.8//1.1

	RetractedStockFrontCollisionBufferDist=6

}

