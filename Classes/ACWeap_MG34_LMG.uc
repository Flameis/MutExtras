class ACWeap_MG34_LMG extends ROWeap_MG34_LMG
    abstract;

DefaultProperties
{
    WeaponContentClass(0)="MutExtras.ACWeap_MG34_LMG_Content"

    bDebugWeapon=False

    AmmoClass=class'ACAmmo_792x57_MG34Belt_200'
    MaxAmmoCount=200
    bUsesMagazines=true
    InitialNumPrimaryMags=1
    NumMagsToResupply=1
    MaxNumPrimaryMags=2

    SightRanges.Empty

    // Dialed in.
    SightRanges[0]=(SightRange=200,SightPitch=16384,SightSlideOffset=0.0,SightPositionOffset=0.0,AddedPitch=-125)

    // Estimated.
    SightRanges[1]=(SightRange=400,SightPitch=16384,SightSlideOffset=0.05,SightPositionOffset=-0.075,AddedPitch=-107)
    SightRanges[2]=(SightRange=500,SightPitch=16384,SightSlideOffset=0.075,SightPositionOffset=-0.12,AddedPitch=-97)
    SightRanges[3]=(SightRange=600,SightPitch=16384,SightSlideOffset=0.11,SightPositionOffset=-0.18,AddedPitch=-85)
    SightRanges[4]=(SightRange=700,SightPitch=16384,SightSlideOffset=0.14,SightPositionOffset=-0.225,AddedPitch=-85)

    // Wrong.
    SightRanges[5]=(SightRange=800,SightPitch=16384,SightSlideOffset=0.16,SightPositionOffset=-0.285,AddedPitch=86)
    SightRanges[6]=(SightRange=900,SightPitch=16384,SightSlideOffset=0.24,SightPositionOffset=-0.4,AddedPitch=96)
    SightRanges[7]=(SightRange=1000,SightPitch=16384,SightSlideOffset=0.3,SightPositionOffset=-0.52,AddedPitch=106)
    SightRanges[8]=(SightRange=1100,SightPitch=16384,SightSlideOffset=0.37,SightPositionOffset=-0.63,AddedPitch=116)
    SightRanges[9]=(SightRange=1200,SightPitch=16384,SightSlideOffset=0.44,SightPositionOffset=-0.75,AddedPitch=127)
    SightRanges[10]=(SightRange=1300,SightPitch=16384,SightSlideOffset=0.51,SightPositionOffset=-0.88,AddedPitch=137)
    SightRanges[11]=(SightRange=1400,SightPitch=16384,SightSlideOffset=0.59,SightPositionOffset=-1.0,AddedPitch=147)
    SightRanges[12]=(SightRange=1500,SightPitch=16384,SightSlideOffset=0.69,SightPositionOffset=-1.19,AddedPitch=157)
    SightRanges[13]=(SightRange=1600,SightPitch=16384,SightSlideOffset=0.79,SightPositionOffset=-1.36,AddedPitch=167)
    SightRanges[14]=(SightRange=1700,SightPitch=16384,SightSlideOffset=0.9,SightPositionOffset=-1.55,AddedPitch=178)
    SightRanges[15]=(SightRange=1800,SightPitch=16384,SightSlideOffset=1.02,SightPositionOffset=-1.75,AddedPitch=188)
    SightRanges[16]=(SightRange=1900,SightPitch=16384,SightSlideOffset=1.15,SightPositionOffset=-1.99,AddedPitch=198)
    SightRanges[17]=(SightRange=2000,SightPitch=16384,SightSlideOffset=1.28,SightPositionOffset=-2.25,AddedPitch=208)

    // MAIN FIREMODE
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'ACBullet_MG34'
	bLoopHighROFSounds(0)=true
	FireInterval(0)=+0.075 // 850rpm
	DelayedRecoilTime(0)=0.0
	Spread(0)=0.0008 // 3 MOA

	// ALT FIREMODE
	FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Custom
	WeaponProjectiles(ALTERNATE_FIREMODE)=class'ACBullet_MG34'
	FireInterval(ALTERNATE_FIREMODE)=+0.075 // 850rpm
	DelayedRecoilTime(ALTERNATE_FIREMODE)=0.0
	Spread(ALTERNATE_FIREMODE)=0.0008 // 3 MOA

	InstantHitDamage(0)=125
	InstantHitDamage(1)=125

	InstantHitDamageTypes(0)=class'ACDmgType_MG34Bullet'
	InstantHitDamageTypes(1)=class'ACDmgType_MG34Bullet'


    maxRecoilPitch=320//180//350
	minRecoilPitch=280//130//300
	maxRecoilYaw=80 //200
	minRecoilYaw=-80 //-200
	maxDeployedRecoilPitch=120//200
	minDeployedRecoilPitch=80//200
	maxDeployedRecoilYaw=20
	minDeployedRecoilYaw=-20
	minDeployedRecoilYawAbsolute=25
	RecoilRate=0.2
	RecoilMaxYawLimit=1500
	RecoilMinYawLimit=64035
	RecoilMaxPitchLimit=1500
	RecoilMinPitchLimit=64785
	RecoilISMaxYawLimit=500
	RecoilISMinYawLimit=65035
	RecoilISMaxPitchLimit=350
	RecoilISMinPitchLimit=65035
   	RecoilBlendOutRatio=0.65
   	PostureHippedRecoilModifer=2.0
   	//PostureShoulderRecoilModifer=2
   	RecoilViewRotationScale=0.45

	ROBarrelClass=class'ACMGBarrelMG34'
  	bTrackBarrelHeat=true
  	BarrelHeatBone=Barrel
	BarrelChangeAnim=none
  	InitialBarrels=1
}
