//=============================================================================
// ROWeap_XM177E1_Carbine
//=============================================================================
// CAR-15 Commando (XM177E1) Carbine
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2017 Tripwire Interactive LLC
// - Austin "dibbler67" Ware for Antimatter Games
//=============================================================================
// Ammo Count modified by Sgt. Capwell [29ID]
//=============================================================================
class ROWeap_XM177E1_Carbine_MACVSOG extends ROProjectileWeapon
	abstract;

// @TEMP - triple spread for most handheld weapons
simulated function float GetSpreadMod()
{
	return 3 * super.GetSpreadMod();
}

/**
 * Override Next weapon call.
 * Increment the sight range index
 * @Override to allow sight adjustment when this weapon's stock is retracted
 */
simulated function bool DoOverrideNextWeapon()
{
	// If we aren't in ironsights increment the sight index
	if( SightRanges.Length > 0 && bUsingSights && !bZoomingOut /**&& !bUsingRetractedStock*/ )// && !bZoomingIn )
	{
	   if( SightRangeIndex > 0 && !bZoomingIn )
	   {
	       SightRangeIndex--;
		   SightIndexUpdated();
	   }

	   return true;
	}

	return false;
}

/**
 * Override Previous weapon call.
 * Increment the sight range index
 * @Override to allow sight adjustment when this weapon's stock is retracted
 */
simulated function bool DoOverridePrevWeapon()
{
	// If we aren't in ironsights increment the sight index
	if( SightRanges.Length > 0 && bUsingSights && !bZoomingOut /**&& !bUsingRetractedStock*/ )// && !bZoomingIn )
	{
	   if( SightRangeIndex < (SightRanges.Length - 1) && !bZoomingIn )
	   {
	       SightRangeIndex++;
		   SightIndexUpdated();
	   }

	   return true;
	}

	return false;
}

defaultproperties
{
	WeaponContentClass(0)="ROGameContent.ROWeap_XM177E1_Carbine_Content"
	RoleSelectionImage(0)=Texture2D'VN_UI_Textures_Three.WeaponTex.AUS_Weap_XM117'

	WeaponClassType=ROWCT_AssaultRifle
	TeamIndex=`ALLIES_TEAM_INDEX

	AltFireModeType=ROAFT_ExtendStock

	Category=ROIC_Primary
	Weight=2.43 //KG
	InvIndex=`ROII_XM177E1_AssaultRifle
	InventoryWeight=6

	PlayerIronSightFOV=55.0

	PreFireTraceLength=1250 //25 Meters

	// MAIN FIREMODE
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'XM177E1Bullet'
	bLoopHighROFSounds(0)=true
	FireInterval(0)=+0.08 // 750 RPM
	DelayedRecoilTime(0)=0.0
	Spread(0)=0.00084 // ~3.0 MOA

	// ALT FIREMODE
	FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
	WeaponProjectiles(ALTERNATE_FIREMODE)=class'XM177E1Bullet'
	FireInterval(ALTERNATE_FIREMODE)=+0.08
	DelayedRecoilTime(ALTERNATE_FIREMODE)=0.01
	Spread(ALTERNATE_FIREMODE)=0.00084 // ~3.0 MOA

	//AltFireModeType=ROAFT_Bayonet

	//ShoulderedSpreadMod=3.0//6.0
	//HippedSpreadMod=5.0//10.0

	// AI
	MinBurstAmount=1
	MaxBurstAmount=10
	//BurstWaitTime=1.0

	// Recoil
	maxRecoilPitch=210
	minRecoilPitch=210
	maxRecoilYaw=55
	minRecoilYaw=-55
	RecoilRate=0.08//0.075//0.085
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

	// InstantHitDamage(0)=120
	// InstantHitDamage(1)=120
	InstantHitDamage(0)=99//100
	InstantHitDamage(1)=99//100

	InstantHitDamageTypes(0)=class'RODmgType_XM177E1Bullet'
	InstantHitDamageTypes(1)=class'RODmgType_XM177E1Bullet'

	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_Rifles_split'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

	ReloadingSmokePSCTemplate=ParticleSystem'FX_VN_Weapons.Emitter.FX_ReloadingSmoke_Rifle'

	// Shell eject FX
	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_USA_M16'

	bHasIronSights=true;

	//Equip and putdown
	WeaponPutDownAnim=M16_putaway
	WeaponEquipAnim=M16_pullout
	WeaponDownAnim=M16_Down
	WeaponUpAnim=M16_up

	// Fire Anims
	//Hip fire
	WeaponFireAnim(0)=M16_shoot
	WeaponFireAnim(1)=M16_shoot
	WeaponFireLastAnim=M16_shootLAST

	//Shouldered fire
	WeaponFireShoulderedAnim(0)=M16_shoot
	WeaponFireShoulderedAnim(1)=M16_shoot
	WeaponFireLastShoulderedAnim=M16_shootLAST

	//Fire using iron sights
	WeaponFireSightedAnim(0)=M16_iron_shoot
	WeaponFireSightedAnim(1)=M16_iron_shoot
	WeaponFireLastSightedAnim=M16_iron_shootLAST

	// Idle Anims
	//Hip Idle
	WeaponIdleAnims(0)=M16_shoulder_idle
	WeaponIdleAnims(1)=M16_shoulder_idle

	// Shouldered idle
	WeaponIdleShoulderedAnims(0)=M16_shoulder_idle
	WeaponIdleShoulderedAnims(1)=M16_shoulder_idle

	//Sighted Idle
	WeaponIdleSightedAnims(0)=M16_iron_idle
	WeaponIdleSightedAnims(1)=M16_iron_idle

	// Prone Crawl
	WeaponCrawlingAnims(0)=M16_CrawlF
	WeaponCrawlStartAnim=M16_Crawl_into
	WeaponCrawlEndAnim=M16_Crawl_out

	//Reloading
	WeaponReloadEmptyMagAnim=M16_reloadempty
	WeaponReloadNonEmptyMagAnim=M16_reloadhalf
	WeaponRestReloadEmptyMagAnim=M16_reloadempty_rest
	WeaponRestReloadNonEmptyMagAnim=M16_reloadhalf_rest

	// Ammo check
	WeaponAmmoCheckAnim=M16_ammocheck
	WeaponRestAmmoCheckAnim=M16_ammocheck_rest

	// Sprinting
	WeaponSprintStartAnim=M16_sprint_into
	WeaponSprintLoopAnim=M16_Sprint
	WeaponSprintEndAnim=M16_sprint_out

	// One handed sprinting
	Weapon1HSprintStartAnim=M16_1H_sprint_into
	Weapon1HSprintLoopAnim=M16_1H_sprint
	Weapon1HSprintEndAnim=M16_1H_sprint_out

	// Mantling
	WeaponMantleOverAnim=M16_Mantle
 	WeaponSwitchToAltFireModeAnim=M16_AutoTOsemi
  	WeaponSwitchToDefaultFireModeAnim=M16_SemiTOauto
	// Cover/Blind Fire Anims
	WeaponRestAnim=M16_rest_idle
	WeaponEquipRestAnim=M16_pullout_rest
	WeaponPutDownRestAnim=M16_putaway_rest
	WeaponBlindFireRightAnim=M16_BF_Right_Shoot
	WeaponBlindFireLeftAnim=M16_BF_Left_Shoot
	WeaponBlindFireUpAnim=M16_BF_up_Shoot
	WeaponIdleToRestAnim=M16_idleTOrest
	WeaponRestToIdleAnim=M16_restTOidle
	WeaponRestToBlindFireRightAnim=M16_restTOBF_Right
	WeaponRestToBlindFireLeftAnim=M16_restTOBF_Left
	WeaponRestToBlindFireUpAnim=M16_restTOBF_up
	WeaponBlindFireRightToRestAnim=M16_BF_Right_TOrest
	WeaponBlindFireLeftToRestAnim=M16_BF_Left_TOrest
	WeaponBlindFireUpToRestAnim=M16_BF_up_TOrest
	WeaponBFLeftToUpTransAnim=M16_BFleft_toBFup
	WeaponBFRightToUpTransAnim=M16_BFright_toBFup
	WeaponBFUpToLeftTransAnim=M16_BFup_toBFleft
	WeaponBFUpToRightTransAnim=M16_BFup_toBFright
	// Blind Fire ready
	WeaponBF_Rest2LeftReady=M16_restTO_L_ready
	WeaponBF_LeftReady2LeftFire=M16_L_readyTOBF_L
	WeaponBF_LeftFire2LeftReady=M16_BF_LTO_L_ready
	WeaponBF_LeftReady2Rest=M16_L_readyTOrest
	WeaponBF_Rest2RightReady=M16_restTO_R_ready
	WeaponBF_RightReady2RightFire=M16_R_readyTOBF_R
	WeaponBF_RightFire2RightReady=M16_BF_RTO_R_ready
	WeaponBF_RightReady2Rest=M16_R_readyTOrest
	WeaponBF_Rest2UpReady=M16_restTO_Up_ready
	WeaponBF_UpReady2UpFire=M16_Up_readyTOBF_Up
	WeaponBF_UpFire2UpReady=M16_BF_UpTO_Up_ready
	WeaponBF_UpReady2Rest=M16_Up_readyTOrest
	WeaponBF_LeftReady2Up=M16_L_ready_toUp_ready
	WeaponBF_LeftReady2Right=M16_L_ready_toR_ready
	WeaponBF_UpReady2Left=M16_Up_ready_toL_ready
	WeaponBF_UpReady2Right=M16_Up_ready_toR_ready
	WeaponBF_RightReady2Up=M16_R_ready_toUp_ready
	WeaponBF_RightReady2Left=M16_R_ready_toL_ready
	WeaponBF_LeftReady2Idle=M16_L_readyTOidle
	WeaponBF_RightReady2Idle=M16_R_readyTOidle
	WeaponBF_UpReady2Idle=M16_Up_readyTOidle
	WeaponBF_Idle2UpReady=M16_idleTO_Up_ready
	WeaponBF_Idle2LeftReady=M16_idleTO_L_ready
	WeaponBF_Idle2RightReady=M16_idleTO_R_ready

	// Enemy Spotting
	WeaponSpotEnemyAnim=M16_SpotEnemy
	WeaponSpotEnemySightedAnim=M16_SpotEnemy_ironsight

	WeaponExtendStockAnim=M16_Stock_extend
	WeaponRetractStockAnim=M16_Stock_retract


	// Melee anims
	WeaponMeleeAnims(0)=M16_Bash
	WeaponBayonetMeleeAnims(0)=M16_Stab
	WeaponMeleeHardAnim=M16_BashHard
	WeaponBayonetMeleeHardAnim=M16_StabHard
	MeleePullbackAnim=M16_Pullback
	MeleeHoldAnim=M16_Pullback_Hold

	WeaponAttachBayonetAnim=M16_Bayonet_Attach
	WeaponDetachBayonetAnim=M16_Bayonet_Detach

	ReloadMagazinEmptyCameraAnim=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_reloadempty'

	EquipTime=+0.66//0.75
	

	bDebugWeapon = false

	BoltControllerNames[0]=BoltSlide_M16

	FireModeRotControlName=FireSelect_M16

	//BayonetSkelControlName=Attachment

	StockSkelControlNames[0]=StockSlide_XM117

	ISFocusDepth=20

	// Ammo
	AmmoClass=class'ROAmmo_556x45_M16Mag'
	MaxAmmoCount=31
	bUsesMagazines=true
	InitialNumPrimaryMags=7//6
	bPlusOneLoading=true
	bCanReloadNonEmptyMag=true
	PenetrationDepth=10
	MaxPenetrationTests=3
	MaxNumPenetrations=1
	PerformReloadPct=0.75f //0.88f

	//AltAmmoLoadouts(0)=(WeaponContentClassIndex=1)

	PlayerViewOffset=(X=6.5,Y=4.5,Z=-1.25)
	ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
	ShoulderedPosition=(X=5.5,Y=2.0,Z=-0.75)

	IronSightPosition=(X=-2.0,Y=-0.001,Z=0)
	RetractedStockIronSightPosition=(X=-4.5,Y=-0.001,Z=0)
	RetractedStockAlignmentScale = 1f

	RestDeployCollisionSize=(X=4,Y=7,Z=16)

	ZoomInTime=0.25
	ZoomOutTime=0.25

	bUsesFreeAim=true

	// Free Aim variables
	FreeAimHipfireOffsetX=40

	SuppressionPower=10

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	CollisionCheckLength=41.5

	FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_Shoot'
	FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_Shoot'
	ShakeScaleSighted=2.35
	ShakeScaleStandard=1.65

	SightRotControlName=Sight_Rotation

	SightRanges[0]=(SightRange=250,SightPitch=0,SightPositionOffset=-0.03)
	SightRanges[1]=(SightRange=400,SightPitch=16384,SightPositionOffset=0.0, AddedPitch = 40)

	RecoilOffsetModY = 1600.f
	RecoilOffsetModZ = 1600.f

	SwayScale=0.9//1.05

	RecoilScaleRetractedStock=1.0f

	LagLimit=1.0

	RetractedStockFrontCollisionBufferDist = 1
}


