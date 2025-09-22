//=============================================================================
// ROWeap_M2_Carbine
//=============================================================================
// M2 Carbine
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Ross Martin @ Antimatter Games
//=============================================================================
// Ammo Count modified by Sgt. Capwell [29ID]
//=============================================================================
class ACWeap_M2_Carbine_MACVSOG extends ROProjectileWeapon
	abstract;

// @TEMP - triple spread for most handheld weapons
simulated function float GetSpreadMod()
{
	return 3 * super.GetSpreadMod();
}

defaultproperties
{
	WeaponContentClass(0)="ROGameContent.ROWeap_M2_Carbine_Content"
	RoleSelectionImage(0)=Texture2D'VN_UI_Textures_Three.WeaponTex.ARVN_Weap_M2Carbine'

	WeaponClassType=ROWCT_AssaultRifle
	TeamIndex=`ALLIES_TEAM_INDEX

	Category=ROIC_Primary
	Weight=2.4 // kg
	InvIndex=`ROII_M2_CARBINE
	InventoryWeight=6

	PlayerIronSightFOV=45.0//50.0

	// MAIN FIREMODE
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Custom
	FireInterval(0)=+0.07 // 850rpm
	DelayedRecoilTime(0)=0.01
	WeaponProjectiles(0)=class'M2CarbineBullet'
	Spread(0)=0.00085

	// ALT FIREMODE
	FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
	FireInterval(ALTERNATE_FIREMODE)=+0.1
	DelayedRecoilTime(ALTERNATE_FIREMODE)=0.01
	WeaponProjectiles(ALTERNATE_FIREMODE)=class'M2CarbineBullet'
	Spread(ALTERNATE_FIREMODE)=0.00085

	AltFireModeType=ROAFT_Bayonet

	PreFireTraceLength=2500 //50 Meters

	//ShoulderedSpreadMod=3.0//6.0
	//HippedSpreadMod=5.0//10.0

	// AI
	MinBurstAmount=1
	MaxBurstAmount=15
	//BurstWaitTime=1.0

	// Recoil
	maxRecoilPitch=185//200
	minRecoilPitch=185//200
	maxRecoilYaw=20//70//60//280  //250
	minRecoilYaw=-40//-70//-60//-280 //200
	minRecoilYawAbsolute=50
	RecoilRate=0.07//0.1
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=2000
	RecoilMinPitchLimit=63535
	RecoilISMaxYawLimit=500
	RecoilISMinYawLimit=65035
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65035
	RecoilBlendOutRatio=0.35f//0.5//0.75//0.45
	//RecoilViewRotationScale=0.9f
   	//PostureHippedRecoilModifer=1.65
   	//PostureShoulderRecoilModifer=1.4

   	//RecoilCompensationScale=2.0

	InstantHitDamage(0)=75
	InstantHitDamage(1)=75

	InstantHitDamageTypes(0)=class'RODmgType_M2CarbineBullet'
	InstantHitDamageTypes(1)=class'RODmgType_M2CarbineBullet'

	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_SMG'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

	// Shell eject FX
	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons_Two.ShellEjects.FX_Wep_ShellEject_M1_Carbine'

	bHasIronSights=true;

	//Equip and putdown
	WeaponPutDownAnim=M2Carbine_putaway
	WeaponEquipAnim=M2Carbine_pullout
	WeaponDownAnim=M2Carbine_Down
	WeaponUpAnim=M2Carbine_Up

	// Fire Anims
	//Hip fire
	WeaponFireAnim(0)=M2Carbine_shoot
	WeaponFireAnim(1)=M2Carbine_Shoot
	WeaponFireLastAnim=M2Carbine_shootLAST_long_mag
	//Shouldered fire
	WeaponFireShoulderedAnim(0)=M2Carbine_shoot
	WeaponFireShoulderedAnim(1)=M2Carbine_Shoot
	WeaponFireLastShoulderedAnim=M2Carbine_shootLAST_long_mag
	//Fire using iron sights
	WeaponFireSightedAnim(0)=M2Carbine_iron_shoot
	WeaponFireSightedAnim(1)=M2Carbine_Iron_Shoot
	WeaponFireLastSightedAnim=M2Carbine_iron_shootLAST_long_mag

	// Idle Anims
	//Hip Idle
	WeaponIdleAnims(0)=M2Carbine_shoulder_idle
	WeaponIdleAnims(1)=M2Carbine_shoulder_idle
	// Shouldered idle
	WeaponIdleShoulderedAnims(0)=M2Carbine_shoulder_idle
	WeaponIdleShoulderedAnims(1)=M2Carbine_shoulder_idle
	//Sighted Idle
	WeaponIdleSightedAnims(0)=M2Carbine_iron_idle
	WeaponIdleSightedAnims(1)=M2Carbine_iron_idle

	// Prone Crawl
	WeaponCrawlingAnims(0)=M2Carbine_CrawlF
	WeaponCrawlStartAnim=M2Carbine_Crawl_into
	WeaponCrawlEndAnim=M2Carbine_Crawl_out

	//Reloading
	WeaponReloadEmptyMagAnim=M2Carbine_reloadempty_long_mag
	WeaponReloadNonEmptyMagAnim=M2Carbine_reloadhalf_long_mag
	WeaponReloadStripperAnim=M2Carbine_reloadhalf_long_mag
	WeaponRestReloadEmptyMagAnim=M2Carbine_reloadempty
	WeaponRestReloadNonEmptyMagAnim=M2Carbine_reloadhalf
	WeaponRestReloadStripperAnim=M2Carbine_reloadhalf
	// Ammo check
	WeaponAmmoCheckAnim=M2Carbine_ammocheck
	WeaponRestAmmoCheckAnim=M2Carbine_ammocheck

	// Sprinting
	WeaponSprintStartAnim=M2Carbine_sprint_into
	WeaponSprintLoopAnim=M2Carbine_Sprint
	WeaponSprintEndAnim=M2Carbine_sprint_out
	Weapon1HSprintStartAnim=M2Carbine_1H_sprint_into
	Weapon1HSprintLoopAnim=M2Carbine_1H_Sprint
	Weapon1HSprintEndAnim=M2Carbine_1H_sprint_out

	// Mantling
	WeaponMantleOverAnim=M2Carbine_Mantle

	WeaponSpotEnemyAnim=M2Carbine_Spotting
	WeaponSpotEnemySightedAnim=M2Carbine_Spotting_ironsight

	// Cover/Blind Fire Anims
	WeaponRestAnim=M2Carbine_shoulder_idle
	WeaponEquipRestAnim=M2Carbine_pullout
	WeaponPutDownRestAnim=M2Carbine_putaway
	WeaponBlindFireRightAnim=M2Carbine_shoulder_idle
	WeaponBlindFireLeftAnim=M2Carbine_shoulder_idle
	WeaponBlindFireUpAnim=M2Carbine_shoulder_idle
	WeaponIdleToRestAnim=M2Carbine_shoulder_idle
	WeaponRestToIdleAnim=M2Carbine_shoulder_idle
	WeaponRestToBlindFireRightAnim=MM2Carbine_shoulder_idle
	WeaponRestToBlindFireLeftAnim=M2Carbine_shoulder_idle
	WeaponRestToBlindFireUpAnim=M2Carbine_shoulder_idle
	WeaponBlindFireRightToRestAnim=M2Carbine_shoulder_idle
	WeaponBlindFireLeftToRestAnim=M2Carbine_shoulder_idle
	WeaponBlindFireUpToRestAnim=M2Carbine_shoulder_idle
	WeaponBFLeftToUpTransAnim=M2Carbine_shoulder_idle
	WeaponBFRightToUpTransAnim=M2Carbine_shoulder_idle
	WeaponBFUpToLeftTransAnim=M2Carbine_shoulder_idle
	WeaponBFUpToRightTransAnim=M2Carbine_shoulder_idle
	// Blind Fire ready
	WeaponBF_Rest2LeftReady=M2Carbine_shoulder_idle
	WeaponBF_LeftReady2LeftFire=M2Carbine_shoulder_idle
	WeaponBF_LeftFire2LeftReady=M2Carbine_shoulder_idle
	WeaponBF_LeftReady2Rest=M2Carbine_shoulder_idle
	WeaponBF_Rest2RightReady=M2Carbine_shoulder_idle
	WeaponBF_RightReady2RightFire=M2Carbine_shoulder_idle
	WeaponBF_RightFire2RightReady=M2Carbine_shoulder_idle
	WeaponBF_RightReady2Rest=M2Carbine_shoulder_idle
	WeaponBF_Rest2UpReady=M2Carbine_shoulder_idle
	WeaponBF_UpReady2UpFire=M2Carbine_shoulder_idle
	WeaponBF_UpFire2UpReady=M2Carbine_shoulder_idle
	WeaponBF_UpReady2Rest=M2Carbine_shoulder_idle
	WeaponBF_LeftReady2Up=M2Carbine_shoulder_idle
	WeaponBF_LeftReady2Right=M2Carbine_shoulder_idle
	WeaponBF_UpReady2Left=M2Carbine_shoulder_idle
	WeaponBF_UpReady2Right=M2Carbine_shoulder_idle
	WeaponBF_RightReady2Up=M2Carbine_shoulder_idle
	WeaponBF_RightReady2Left=M2Carbine_shoulder_idle
	WeaponBF_LeftReady2Idle=M2Carbine_shoulder_idle
	WeaponBF_RightReady2Idle=M2Carbine_shoulder_idle
	WeaponBF_UpReady2Idle=M2Carbine_shoulder_idle
	WeaponBF_Idle2UpReady=M2Carbine_shoulder_idle
	WeaponBF_Idle2LeftReady=M2Carbine_shoulder_idle
	WeaponBF_Idle2RightReady=M2Carbine_shoulder_idle

	// Melee anims
	WeaponMeleeAnims(0)=M2Carbine_Bash
	WeaponMeleeHardAnim=M2Carbine_BashHard
	WeaponBayonetMeleeAnims(0)=M2Carbine_Stab
	WeaponBayonetMeleeHardAnim=M2Carbine_StabHard
	MeleePullbackAnim=M2Carbine_Pullback
	MeleeHoldAnim=M2Carbine_Pullback_Hold

	WeaponAttachBayonetAnim=M2Carbine_Bayonet_Attach
	WeaponDetachBayonetAnim=M2Carbine_Bayonet_Detach

	WeaponSwitchToAltFireModeAnim=M2Carbine_AutoTOsemi
  	WeaponSwitchToDefaultFireModeAnim=M2Carbine_SemiTOauto

	EquipTime=+0.66//0.8//1.00

	bDebugWeapon = false

  	BoltControllerNames[0]=BoltSlide_Carbine
  	BoltControllerNames[1]=BoltSlide_Carbine_2
  	BoltControllerNames[2]=Bullets_Carbine
  	FireModeRotControlName=FireSelect_M2Carbine
  	BayonetSkelControlName=Bayonet_M2Carbine

	ISFocusDepth=31

	// Ammo
	AmmoClass=class'ROAmmo_762x33_M2CarbineMag'
	MaxAmmoCount=31
	bUsesMagazines=true
	InitialNumPrimaryMags=7//6
	bLosesRoundOnReload=false
	bPlusOneLoading=true
	bCanReloadNonEmptyMag=true
	bCanLoadStripperClip=false
	bCanLoadSingleBullet=false
	PenetrationDepth=12
	MaxPenetrationTests=3
	MaxNumPenetrations=2
	PerformReloadPct=0.67f


	PlayerViewOffset=(X=7.5,Y=4.5,Z=-2.0)//(X=-0.5,Y=3.5,Z=-3)
	ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
	//ShoulderedTime=0.5
	ShoulderedPosition=(X=6.5,Y=2,Z=-1.5)//(X=0,Y=2,Z=-1.5)
	//ShoulderRotation=(Pitch=-300,Yaw=500,Roll=1500)
	IronSightPosition=(X=0.65f,Y=-0.0035f,Z=0.f)

	RestDeployCollisionSize=(X=4,Y=6,Z=13)

	ZoomInTime=0.3//3//0.32
	ZoomOutTime=0.25//0.3

	// Free Aim variables
	bUsesFreeAim=true
	FreeAimHipfireOffsetX=45

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=30,RightAmplitude=50,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.150)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	CollisionCheckLength=45.0

	FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
	FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
	ShakeScaleSighted=1.5
	ShakeScaleStandard=1.5

	SightSlideControlName=Sight_Slide


	// 100 - 300 yards
	SightRanges[0]=(SightRange=90,SightPitch=0,SightSlideOffset=0.0,SightPositionOffset=0.01, AddedPitch=30)
	SightRanges[1]=(SightRange=180,SightPitch=0,SightSlideOffset=-0.34,SightPositionOffset=-0.0575, AddedPitch=25)
	SightRanges[2]=(SightRange=230,SightPitch=0,SightSlideOffset=-0.67,SightPositionOffset=-0.125, AddedPitch=31)
	SightRanges[3]=(SightRange=270,SightPitch=0,SightSlideOffset=-1.0,SightPositionOffset=-0.19, AddedPitch=25)

	SuppressionPower=10//5

	//SwayOffsetMod=1800.f
	RecoilOffsetModY=2000.f//900.f//1800.f
	RecoilOffsetModZ=1400.f//1200.f//900.f//1800.f
	RecoilModWhenEmpty=1.1f
	RecoilModBayonetAttached=0.95f

	bHasBayonet=true
	BayonetAttackRange=78.0

	SwayScale=1.0//1.05//1.29

	WeaponBayonetLength = 8

	LagLimit=0.33
}

