//=============================================================================
// ROWeap_M1A1_SMG
//=============================================================================
// M1A1 Thompson Sub machine gun
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// Created by Antimatter games
//=============================================================================
class ACWeap_M1A1_SMG_MACVSOG extends ROProjectileWeapon
	abstract;

// @TEMP - triple spread for most handheld weapons
simulated function float GetSpreadMod()
{
	return 3 * super.GetSpreadMod();
}

function AddKill(Pawn KilledPawn, optional class<DamageType> dmgType)
{
	local int i;

	super.AddKill(KilledPawn, dmgType);

	if( dmgType != none && ROPlayerController(Instigator.Controller) != none)
	{
		for(i = 0; i < InstantHitDamageTypes.Length; i++)
		{
			if(InstantHitDamageTypes[i] == dmgType)
			{
				ROPlayerController(Instigator.Controller).ThompsonKillAchievementHelper();
				break;
			}
		}
	}
}

defaultproperties
{
	WeaponContentClass(0)="ROGameContent.ROWeap_M1A1_SMG_Content"

	RoleSelectionImage(0)=Texture2D'VN_UI_Textures_Three.WeaponTex.ARVN_Weap_ThompsonM1A1'

	WeaponClassType=ROWCT_SMG
	TeamIndex=`ALLIES_TEAM_INDEX

	Category=ROIC_Primary
	Weight=4.9 //KG
	InvIndex=`ROII_M1A1_SMG
	InventoryWeight=3

	PlayerIronSightFOV=55.0

	PreFireTraceLength=1250 //25 Meters

	// MAIN FIREMODE
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'M1A1Bullet'
	bLoopHighROFSounds(0)=true
	FireInterval(0)=+0.08 // 750 RPM
	DelayedRecoilTime(0)=0.0
	Spread(0)=0.0035 // 12.6 MOA
	//WeaponDryFireSnd=AkEvent'WW_WEP_Shared.Play_WEP_Generic_Dry_Fire'

	// ALT FIREMODE
	FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
	WeaponProjectiles(ALTERNATE_FIREMODE)=class'M1A1Bullet'
	FireInterval(ALTERNATE_FIREMODE)=+0.08 // 750 RPM
	DelayedRecoilTime(ALTERNATE_FIREMODE)=0.01
	Spread(ALTERNATE_FIREMODE)=0.0035


	//AltFireModeType=ROAFT_ExtendStock

	//ShoulderedSpreadMod=3.0//6.0
	//HippedSpreadMod=5.0//10.0

	// AI
	MinBurstAmount=1
	MaxBurstAmount=15
	//BurstWaitTime=1.0
	//AISpreadScale=20.0

	// Recoil
	maxRecoilPitch=105//90//200
	minRecoilPitch=105//50//110
	maxRecoilYaw=70//130
	minRecoilYaw=-20//-130
	RecoilRate=0.08
	RecoilMaxYawLimit=500
	RecoilMinYawLimit=65035
	RecoilMaxPitchLimit=750
	RecoilMinPitchLimit=64785
	RecoilISMaxYawLimit=500
	RecoilISMinYawLimit=65035
	RecoilISMaxPitchLimit=500
	RecoilISMinPitchLimit=65035
   	RecoilBlendOutRatio=1
   	PostureHippedRecoilModifer=5.0
   	//PostureShoulderRecoilModifer=1.75

	// InstantHitDamage(0)=230
	// InstantHitDamage(1)=230
	InstantHitDamage(0)=120
	InstantHitDamage(1)=120

	InstantHitDamageTypes(0)=class'RODmgType_M1A1Bullet'
	InstantHitDamageTypes(1)=class'RODmgType_M1A1Bullet'

	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_1stP_SMG'
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'ROGame.RORifleMuzzleFlashLight'

	// Shell eject FX
	ShellEjectSocket=ShellEjectSocket
	ShellEjectPSCTemplate=ParticleSystem'FX_VN_Weapons_Two.ShellEjects.FX_Wep_ShellEject_M1A1'

	ReloadingSmokePSCTemplate=ParticleSystem'FX_VN_Weapons.Emitter.FX_ReloadingSmoke_SMG'

	bHasIronSights=true;

	//Equip and putdown
	WeaponPutDownAnim=Thompson_putaway
	WeaponEquipAnim=Thompson_pullout
	WeaponDownAnim=Thompson_Down
	WeaponUpAnim=Thompson_up

	// Fire Anims
	//Hip fire
	WeaponFireAnim(0)=Thompson_shoot
	WeaponFireAnim(1)=Thompson_shoot
	WeaponFireLastAnim=Thompson_shootLAST
	//Shouldered fire
	WeaponFireShoulderedAnim(0)=Thompson_shoot
	WeaponFireShoulderedAnim(1)=Thompson_shoot
	WeaponFireLastShoulderedAnim=Thompson_shoot
	//Fire using iron sights
	WeaponFireSightedAnim(0)=Thompson_iron_shoot
	WeaponFireSightedAnim(1)=Thompson_iron_shoot
	WeaponFireLastSightedAnim=Thompson_iron_shoot

	// Idle Anims
	//Hip Idle
	WeaponIdleAnims(0)=Thompson_shoulder_idle
	WeaponIdleAnims(1)=Thompson_shoulder_idle
	// Shouldered idle
	WeaponIdleShoulderedAnims(0)=Thompson_shoulder_idle
	WeaponIdleShoulderedAnims(1)=Thompson_shoulder_idle
	//Sighted Idle
	WeaponIdleSightedAnims(0)=Thompson_iron_idle
	WeaponIdleSightedAnims(1)=Thompson_iron_idle

	// Prone Crawl
	WeaponCrawlingAnims(0)=Thompson_CrawlF
	WeaponCrawlStartAnim=Thompson_Crawl_into
	WeaponCrawlEndAnim=Thompson_Crawl_out

	//Reloading
	WeaponReloadEmptyMagAnim=Thompson_reloadhalf_02
	WeaponReloadNonEmptyMagAnim=Thompson_reloadhalf
	WeaponRestReloadEmptyMagAnim=Thompson_reloadhalf_02
	WeaponRestReloadNonEmptyMagAnim=Thompson_reloadhalf
	// Ammo check
	WeaponAmmoCheckAnim=Thompson_ammocheck
	WeaponRestAmmoCheckAnim=Thompson_ammocheck

	// Sprinting
	WeaponSprintStartAnim=Thompson_sprint_into
	WeaponSprintLoopAnim=Thompson_Sprint
	WeaponSprintEndAnim=Thompson_sprint_out
	Weapon1HSprintStartAnim=Thompson_1H_sprint_into
	Weapon1HSprintLoopAnim=Thompson_1H_sprint
	Weapon1HSprintEndAnim=Thompson_1H_sprint_out

	// Mantling
	WeaponMantleOverAnim=Thompson_Mantle

	// Cover/Blind Fire Anims
	WeaponRestAnim=Thompson_shoulder_idle
	WeaponEquipRestAnim=Thompson_shoulder_idle
	WeaponPutDownRestAnim=Thompson_shoulder_idle
	WeaponBlindFireRightAnim=Thompson_shoulder_idle
	WeaponBlindFireLeftAnim=Thompson_shoulder_idle
	WeaponBlindFireUpAnim=Thompson_shoulder_idle
	WeaponIdleToRestAnim=Thompson_shoulder_idle
	WeaponRestToIdleAnim=Thompson_shoulder_idle
	WeaponRestToBlindFireRightAnim=Thompson_shoulder_idle
	WeaponRestToBlindFireLeftAnim=Thompson_shoulder_idle
	WeaponRestToBlindFireUpAnim=Thompson_shoulder_idle
	WeaponBlindFireRightToRestAnim=Thompson_shoulder_idle
	WeaponBlindFireLeftToRestAnim=Thompson_shoulder_idle
	WeaponBlindFireUpToRestAnim=Thompson_shoulder_idle
	WeaponBFLeftToUpTransAnim=Thompson_shoulder_idle
	WeaponBFRightToUpTransAnim=Thompson_shoulder_idle
	WeaponBFUpToLeftTransAnim=Thompson_shoulder_idle
	WeaponBFUpToRightTransAnim=Thompson_shoulder_idle
	// Blind Fire ready
	WeaponBF_Rest2LeftReady=Thompson_shoulder_idle
	WeaponBF_LeftReady2LeftFire=Thompson_shoulder_idle
	WeaponBF_LeftFire2LeftReady=Thompson_shoulder_idle
	WeaponBF_LeftReady2Rest=Thompson_shoulder_idle
	WeaponBF_Rest2RightReady=Thompson_shoulder_idle
	WeaponBF_RightReady2RightFire=Thompson_shoulder_idle
	WeaponBF_RightFire2RightReady=Thompson_shoulder_idle
	WeaponBF_RightReady2Rest=Thompson_shoulder_idle
	WeaponBF_Rest2UpReady=Thompson_shoulder_idle
	WeaponBF_UpReady2UpFire=Thompson_shoulder_idle
	WeaponBF_UpFire2UpReady=Thompson_shoulder_idle
	WeaponBF_UpReady2Rest=Thompson_shoulder_idle
	WeaponBF_LeftReady2Up=Thompson_shoulder_idle
	WeaponBF_LeftReady2Right=Thompson_shoulder_idle
	WeaponBF_UpReady2Left=Thompson_shoulder_idle
	WeaponBF_UpReady2Right=Thompson_shoulder_idle
	WeaponBF_RightReady2Up=Thompson_shoulder_idle
	WeaponBF_RightReady2Left=Thompson_shoulder_idle
	WeaponBF_LeftReady2Idle=Thompson_shoulder_idle
	WeaponBF_RightReady2Idle=Thompson_shoulder_idle
	WeaponBF_UpReady2Idle=Thompson_shoulder_idle
	WeaponBF_Idle2UpReady=Thompson_shoulder_idle
	WeaponBF_Idle2LeftReady=Thompson_shoulder_idle
	WeaponBF_Idle2RightReady=Thompson_shoulder_idle

	// Enemy Spotting
	WeaponSpotEnemyAnim=Thompson_Spotting
	WeaponSpotEnemySightedAnim=Thompson_Spotting_Ironsight

	// Melee anims
	WeaponMeleeAnims(0)=Thompson_Bash
	WeaponMeleeHardAnim=Thompson_BashHard
	MeleePullbackAnim=Thompson_Pullback
	MeleeHoldAnim=Thompson_Pullback_Hold

	WeaponExtendStockAnim=Thompson_shoulder_idle
	WeaponRetractStockAnim=Thompson_shoulder_idle

	WeaponSwitchToAltFireModeAnim=Thompson_AutoTOsemi
  	WeaponSwitchToDefaultFireModeAnim=Thompson_SemiTOauto

	ReloadMagazinEmptyCameraAnim=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_reloadempty'

	EquipTime=+0.66//0.75

	bDebugWeapon = false

	//BoltControllerNames[0]=BoltSlide_M1A1

	FireModeRotControlName=FireSelect_M1A1

	ISFocusDepth=18

	SuppressionPower=5

	// Ammo
	AmmoClass=class'ROAmmo_1143x23_M1A1Mag'
	MaxAmmoCount=30
	bUsesMagazines=true
	InitialNumPrimaryMags=7//6
	bPlusOneLoading=false
	bCanReloadNonEmptyMag=true
	PenetrationDepth=13
	MaxPenetrationTests=3
	MaxNumPenetrations=2
	PerformReloadPct=0.85f

	PlayerViewOffset=(X=2.5,Y=4.5,Z=-2.25)//(X=1,Y=4,Z=-2)
	ZoomInRotation=(Pitch=-910,Yaw=0,Roll=2910)
	//ShoulderedTime=0.5
	ShoulderedPosition=(X=1.5,Y=2,Z=-1.5)//(X=3,Y=2.5,Z=-1.0)
	//ShoulderRotation=(Pitch=-300,Yaw=500,Roll=1500)

	bUsesFreeAim=true

	ZoomInTime=0.4//0.3
	ZoomOutTime=0.4//0.22
	IronSightPosition=(X=-2,Y=0,Z=0.0)
	// RetractedStockIronSightPosition=(X=3,Y=1,Z=-1)
	//RetractedStockIronSightPosition=(X=5,Y=0.5,Z=-0.1)
	//RetractedStockAlignmentScale = 0.3f
	RecoilOffsetModY = 1200.f
	RecoilOffsetModZ = 1200.f
	//SwayOffsetMod = 1200.f

	// Free Aim variables
	FreeAimHipfireOffsetX=35

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	CollisionCheckLength=40.5

	FireCameraAnim[0]=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_Shoot'
	FireCameraAnim[1]=CameraAnim'1stperson_Cameras.Anim.Camera_MP40_Shoot'

	// SightSlideControlName=Sight_Slide
	// SightRotControlName=Sight_Rotation

	SightRanges[0]=(SightRange=50,SightPitch=0,SightSlideOffset=0.0,SightPositionOffset=0.0,AddedPitch=-16)
	SightRanges[1]=(SightRange=150,SightPitch=0,SightSlideOffset=0.0,SightPositionOffset=-0.35,AddedPitch=-55)

	// Values without FreeAim enabled
	//SightRanges[0]=(SightRange=50,SightPitch=0,SightSlideOffset=0.0,SightPositionOffset=0.0,AddedPitch=0)
	//SightRanges[1]=(SightRange=150,SightPitch=0,SightSlideOffset=0.0,SightPositionOffset=-0.35,AddedPitch=-4)

	SwayScale=1.05//1.1
}

