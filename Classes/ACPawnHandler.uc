class ACPawnHandler extends ROPawnHandler
	config(MutExtras_Client);

var config	array<CharacterConfig>	ACNVAConfigsByClass;
var config	array<CharacterConfig>	ACNLFConfigsByClass;
var config	array<CharacterConfig>	ACUSArmyConfigsByClass;
var config	array<CharacterConfig>	ACUSMCConfigsByClass;
var config	array<CharacterConfig>	ACAusArmyConfigsByClass;
var config	array<CharacterConfig>	ACARVNConfigsByClass;

//These are all to save the config to the .ini
static function GetCharConfig(int Team, int ArmyIndex, byte bPilot, int ClassIndex, int HonorLevel, out byte TunicID, out byte TunicMaterialID, out byte ShirtID, out byte HeadID, out byte HairID, out byte HeadgearID, out byte HeadgearMatID, out byte FaceItemID, out byte FacialHairID, out byte TattooID, ROPlayerReplicationInfo ROPRI, optional bool bRandomiseAll, optional bool bInitByMenu, optional out byte bUseBase)
{
	if (bRandomiseAll)
	{
		TunicID = default.RandomConfig.TunicMesh;
		TunicMaterialID = default.RandomConfig.TunicMaterial;
		ShirtID = default.RandomConfig.ShirtTexture;
		HeadID = default.RandomConfig.HeadMesh;
		HairID = default.RandomConfig.HairMaterial;
		HeadgearID = default.RandomConfig.HeadgearMesh;
		HeadgearMatID = default.RandomConfig.HeadgearMaterial;
		FaceItemID = default.RandomConfig.FaceItemMesh;
		FacialHairID = default.RandomConfig.FacialHairMesh;
		TattooID = default.RandomConfig.TattooTex;
		
	}
	else if (Team == `AXIS_TEAM_INDEX)
	{
		switch (ArmyIndex)
		{
			case NFOR_NVA:

				TunicID = default.ACNVAConfigsByClass[ClassIndex].TunicMesh;
				TunicMaterialID = default.ACNVAConfigsByClass[ClassIndex].TunicMaterial;
				ShirtID = default.ACNVAConfigsByClass[ClassIndex].ShirtTexture;
				HeadID = default.ACNVAConfigsByClass[ClassIndex].HeadMesh;
				HairID = default.ACNVAConfigsByClass[ClassIndex].HairMaterial;
				HeadgearID = default.ACNVAConfigsByClass[ClassIndex].HeadgearMesh;
				HeadgearMatID = default.ACNVAConfigsByClass[ClassIndex].HeadgearMaterial;
				FaceItemID = default.ACNVAConfigsByClass[ClassIndex].FaceItemMesh;
				FacialHairID = default.ACNVAConfigsByClass[ClassIndex].FacialHairMesh;
				TattooID = default.ACNVAConfigsByClass[ClassIndex].TattooTex;
				break;

			case NFOR_NLF:

				TunicID = default.ACNLFConfigsByClass[ClassIndex].TunicMesh;
				TunicMaterialID = default.ACNLFConfigsByClass[ClassIndex].TunicMaterial;
				ShirtID = default.ACNLFConfigsByClass[ClassIndex].ShirtTexture;
				HeadID = default.ACNLFConfigsByClass[ClassIndex].HeadMesh;
				HairID = default.ACNLFConfigsByClass[ClassIndex].HairMaterial;
				HeadgearID = default.ACNLFConfigsByClass[ClassIndex].HeadgearMesh;
				HeadgearMatID = default.ACNLFConfigsByClass[ClassIndex].HeadgearMaterial;
				FaceItemID = default.ACNLFConfigsByClass[ClassIndex].FaceItemMesh;
				FacialHairID = default.ACNLFConfigsByClass[ClassIndex].FacialHairMesh;
				TattooID = default.ACNLFConfigsByClass[ClassIndex].TattooTex;
				break;

			default:
				TunicID = 0;
				TunicMaterialID = 0;
				ShirtID = 0;
				HeadID = 0;
				HairID = 0;
				HeadgearID = 0;
				HeadgearMatID = 0;
				FaceItemID = 0;
				FacialHairID = 0;
				TattooID = 0;
		}
	}
	else
	{
		switch (ArmyIndex)
		{
			case SFOR_USArmy:

				TunicID = default.ACUSArmyConfigsByClass[ClassIndex].TunicMesh;
				TunicMaterialID = default.ACUSArmyConfigsByClass[ClassIndex].TunicMaterial;
				ShirtID = default.ACUSArmyConfigsByClass[ClassIndex].ShirtTexture;
				HeadID = default.ACUSArmyConfigsByClass[ClassIndex].HeadMesh;
				HairID = default.ACUSArmyConfigsByClass[ClassIndex].HairMaterial;
				HeadgearID = default.ACUSArmyConfigsByClass[ClassIndex].HeadgearMesh;
				HeadgearMatID = default.ACUSArmyConfigsByClass[ClassIndex].HeadgearMaterial;
				FaceItemID = default.ACUSArmyConfigsByClass[ClassIndex].FaceItemMesh;
				FacialHairID = default.ACUSArmyConfigsByClass[ClassIndex].FacialHairMesh;
				TattooID = default.ACUSArmyConfigsByClass[ClassIndex].TattooTex;
				break;
			
			case SFOR_USMC:

				TunicID = default.ACUSMCConfigsByClass[ClassIndex].TunicMesh;
				TunicMaterialID = default.ACUSMCConfigsByClass[ClassIndex].TunicMaterial;
				ShirtID = default.ACUSMCConfigsByClass[ClassIndex].ShirtTexture;
				HeadID = default.ACUSMCConfigsByClass[ClassIndex].HeadMesh;
				HairID = default.ACUSMCConfigsByClass[ClassIndex].HairMaterial;
				HeadgearID = default.ACUSMCConfigsByClass[ClassIndex].HeadgearMesh;
				HeadgearMatID = default.ACUSMCConfigsByClass[ClassIndex].HeadgearMaterial;
				FaceItemID = default.ACUSMCConfigsByClass[ClassIndex].FaceItemMesh;
				FacialHairID = default.ACUSMCConfigsByClass[ClassIndex].FacialHairMesh;
				TattooID = default.ACUSMCConfigsByClass[ClassIndex].TattooTex;
				break;

			case SFOR_AusArmy:

				TunicID = default.ACAusArmyConfigsByClass[ClassIndex].TunicMesh;
				TunicMaterialID = default.ACAusArmyConfigsByClass[ClassIndex].TunicMaterial;
				ShirtID = default.ACAusArmyConfigsByClass[ClassIndex].ShirtTexture;
				HeadID = default.ACAusArmyConfigsByClass[ClassIndex].HeadMesh;
				HairID = default.ACAusArmyConfigsByClass[ClassIndex].HairMaterial;
				HeadgearID = default.ACAusArmyConfigsByClass[ClassIndex].HeadgearMesh;
				HeadgearMatID = default.ACAusArmyConfigsByClass[ClassIndex].HeadgearMaterial;
				FaceItemID = default.ACAusArmyConfigsByClass[ClassIndex].FaceItemMesh;
				FacialHairID = default.ACAusArmyConfigsByClass[ClassIndex].FacialHairMesh;
				TattooID = default.ACAusArmyConfigsByClass[ClassIndex].TattooTex;
				break;
			
			case SFOR_ARVN:

				TunicID = default.ACARVNConfigsByClass[ClassIndex].TunicMesh;
				TunicMaterialID = default.ACARVNConfigsByClass[ClassIndex].TunicMaterial;
				ShirtID = default.ACARVNConfigsByClass[ClassIndex].ShirtTexture;
				HeadID = default.ACARVNConfigsByClass[ClassIndex].HeadMesh;
				HairID = default.ACARVNConfigsByClass[ClassIndex].HairMaterial;
				HeadgearID = default.ACARVNConfigsByClass[ClassIndex].HeadgearMesh;
				HeadgearMatID = default.ACARVNConfigsByClass[ClassIndex].HeadgearMaterial;
				FaceItemID = default.ACARVNConfigsByClass[ClassIndex].FaceItemMesh;
				FacialHairID = default.ACARVNConfigsByClass[ClassIndex].FacialHairMesh;
				TattooID = default.ACARVNConfigsByClass[ClassIndex].TattooTex;
				break;	
			
			default:

				TunicID = 0;
				TunicMaterialID = 0;
				ShirtID = 0;
				HeadID = 0;
				HairID = 0;
				HeadgearID = 0;
				HeadgearMatID = 0;
				FaceItemID = 0;
				FacialHairID = 0;
				TattooID = 0;
		}
	}
	
	ValidateCharConfig(Team, ArmyIndex, bPilot, HonorLevel, TunicID, TunicMaterialID, ShirtID, HeadID, HairID, HeadgearID, HeadgearMatID, FaceItemID, FacialHairID, TattooID, ROPRI);
}

static function SaveCharConfig(int Team, int ArmyIndex, byte bPilot, int ClassIndex, int HonorLevel, out byte TunicID, out byte TunicMaterialID, out byte ShirtID, out byte HeadID, out byte HairID, out byte HeadgearID, out byte HeadgearMatID, out byte FaceItemID, out byte FacialHairID, out byte TattooID, byte bUseBase)
{	
	default.ACNVAConfigsByClass.length = `TOTALROLECOUNT_NORTH;
	default.ACNLFConfigsByClass.length = `TOTALROLECOUNT_NORTH;
	
	default.ACUSArmyConfigsByClass.length = `TOTALROLECOUNT_SOUTH;
	default.ACUSMCConfigsByClass.length = `TOTALROLECOUNT_SOUTH;
	default.ACAusArmyConfigsByClass.length = `TOTALROLECOUNT_SOUTH;
	default.ACARVNConfigsByClass.length = `TOTALROLECOUNT_SOUTH;
	
	StaticSaveConfig();
	
	if (Team == `AXIS_TEAM_INDEX)
	{
		switch (ArmyIndex)
		{
			case NFOR_NLF:

				default.ACNLFConfigsByClass[ClassIndex].TunicMesh = TunicID;
				default.ACNLFConfigsByClass[ClassIndex].TunicMaterial = TunicMaterialID;
				default.ACNLFConfigsByClass[ClassIndex].ShirtTexture = ShirtID;
				default.ACNLFConfigsByClass[ClassIndex].HeadMesh = HeadID;
				default.ACNLFConfigsByClass[ClassIndex].HairMaterial = HairID;
				default.ACNLFConfigsByClass[ClassIndex].HeadgearMesh = HeadgearID;
				default.ACNLFConfigsByClass[ClassIndex].HeadgearMaterial = HeadgearMatID;
				default.ACNLFConfigsByClass[ClassIndex].FaceItemMesh = FaceItemID;
				default.ACNLFConfigsByClass[ClassIndex].FacialHairMesh = FacialHairID;
				default.ACNLFConfigsByClass[ClassIndex].TattooTex = TattooID;
				break;
			
			case NFOR_NVA:

				default.ACNVAConfigsByClass[ClassIndex].TunicMesh = TunicID;
				default.ACNVAConfigsByClass[ClassIndex].TunicMaterial = TunicMaterialID;
				default.ACNVAConfigsByClass[ClassIndex].ShirtTexture = ShirtID;
				default.ACNVAConfigsByClass[ClassIndex].HeadMesh = HeadID;
				default.ACNVAConfigsByClass[ClassIndex].HairMaterial = HairID;
				default.ACNVAConfigsByClass[ClassIndex].HeadgearMesh = HeadgearID;
				default.ACNVAConfigsByClass[ClassIndex].HeadgearMaterial = HeadgearMatID;
				default.ACNVAConfigsByClass[ClassIndex].FaceItemMesh = FaceItemID;
				default.ACNVAConfigsByClass[ClassIndex].FacialHairMesh = FacialHairID;
				default.ACNVAConfigsByClass[ClassIndex].TattooTex = TattooID;
				break;
		}
	}
	else
	{
		switch (ArmyIndex)
		{
			case SFOR_USArmy:

				default.ACUSArmyConfigsByClass[ClassIndex].TunicMesh = TunicID;
				default.ACUSArmyConfigsByClass[ClassIndex].TunicMaterial = TunicMaterialID;
				default.ACUSArmyConfigsByClass[ClassIndex].ShirtTexture = ShirtID;
				default.ACUSArmyConfigsByClass[ClassIndex].HeadMesh = HeadID;
				default.ACUSArmyConfigsByClass[ClassIndex].HairMaterial = HairID;
				default.ACUSArmyConfigsByClass[ClassIndex].HeadgearMesh = HeadgearID;
				default.ACUSArmyConfigsByClass[ClassIndex].HeadgearMaterial = HeadgearMatID;
				default.ACUSArmyConfigsByClass[ClassIndex].FaceItemMesh = FaceItemID;
				default.ACUSArmyConfigsByClass[ClassIndex].FacialHairMesh = FacialHairID;
				default.ACUSArmyConfigsByClass[ClassIndex].TattooTex = TattooID;
				break;

			case SFOR_USMC:

				default.ACUSMCConfigsByClass[ClassIndex].TunicMesh = TunicID;
				default.ACUSMCConfigsByClass[ClassIndex].TunicMaterial = TunicMaterialID;
				default.ACUSMCConfigsByClass[ClassIndex].ShirtTexture = ShirtID;
				default.ACUSMCConfigsByClass[ClassIndex].HeadMesh = HeadID;
				default.ACUSMCConfigsByClass[ClassIndex].HairMaterial = HairID;
				default.ACUSMCConfigsByClass[ClassIndex].HeadgearMesh = HeadgearID;
				default.ACUSMCConfigsByClass[ClassIndex].HeadgearMaterial = HeadgearMatID;
				default.ACUSMCConfigsByClass[ClassIndex].FaceItemMesh = FaceItemID;
				default.ACUSMCConfigsByClass[ClassIndex].FacialHairMesh = FacialHairID;
				default.ACUSMCConfigsByClass[ClassIndex].TattooTex = TattooID;
				break;
			
			case SFOR_AusArmy:

				default.ACAusArmyConfigsByClass[ClassIndex].TunicMesh = TunicID;
				default.ACAusArmyConfigsByClass[ClassIndex].TunicMaterial = TunicMaterialID;
				default.ACAusArmyConfigsByClass[ClassIndex].ShirtTexture = ShirtID;
				default.ACAusArmyConfigsByClass[ClassIndex].HeadMesh = HeadID;
				default.ACAusArmyConfigsByClass[ClassIndex].HairMaterial = HairID;
				default.ACAusArmyConfigsByClass[ClassIndex].HeadgearMesh = HeadgearID;
				default.ACAusArmyConfigsByClass[ClassIndex].HeadgearMaterial = HeadgearMatID;
				default.ACAusArmyConfigsByClass[ClassIndex].FaceItemMesh = FaceItemID;
				default.ACAusArmyConfigsByClass[ClassIndex].FacialHairMesh = FacialHairID;
				default.ACAusArmyConfigsByClass[ClassIndex].TattooTex = TattooID;
				break;
			
			case SFOR_ARVN:

				default.ACARVNConfigsByClass[ClassIndex].TunicMesh = TunicID;
				default.ACARVNConfigsByClass[ClassIndex].TunicMaterial = TunicMaterialID;
				default.ACARVNConfigsByClass[ClassIndex].ShirtTexture = ShirtID;
				default.ACARVNConfigsByClass[ClassIndex].HeadMesh = HeadID;
				default.ACARVNConfigsByClass[ClassIndex].HairMaterial = HairID;
				default.ACARVNConfigsByClass[ClassIndex].HeadgearMesh = HeadgearID;
				default.ACARVNConfigsByClass[ClassIndex].HeadgearMaterial = HeadgearMatID;
				default.ACARVNConfigsByClass[ClassIndex].FaceItemMesh = FaceItemID;
				default.ACARVNConfigsByClass[ClassIndex].FacialHairMesh = FacialHairID;
				default.ACARVNConfigsByClass[ClassIndex].TattooTex = TattooID;
				break;

		}
	}
	
	StaticSaveConfig();
}

static function bool CopyConfigToClass(int Team, int ArmyIndex, int SourceClassIndex, int TargetClassIndex)
{
	local int i;
	
	if (Team == `AXIS_TEAM_INDEX)
	{
		switch (ArmyIndex)
		{
			case NFOR_NLF:
			for (i = 0; i < default.ACNLFConfigsByClass.length; i++)
			{
				if (i <= `ACCI_Tank)
				{
					default.ACNLFConfigsByClass[i].TunicMesh		= default.ACNLFConfigsByClass[SourceClassIndex].TunicMesh;
					default.ACNLFConfigsByClass[i].TunicMaterial	= default.ACNLFConfigsByClass[SourceClassIndex].TunicMaterial;
					default.ACNLFConfigsByClass[i].ShirtTexture		= default.ACNLFConfigsByClass[SourceClassIndex].ShirtTexture;
					default.ACNLFConfigsByClass[i].HeadMesh			= default.ACNLFConfigsByClass[SourceClassIndex].HeadMesh;
					default.ACNLFConfigsByClass[i].HairMaterial		= default.ACNLFConfigsByClass[SourceClassIndex].HairMaterial;
					default.ACNLFConfigsByClass[i].HeadgearMesh		= default.ACNLFConfigsByClass[SourceClassIndex].HeadgearMesh;
					default.ACNLFConfigsByClass[i].HeadgearMaterial	= default.ACNLFConfigsByClass[SourceClassIndex].HeadgearMaterial;
					default.ACNLFConfigsByClass[i].FaceItemMesh		= default.ACNLFConfigsByClass[SourceClassIndex].FaceItemMesh;
					default.ACNLFConfigsByClass[i].FacialHairMesh	= default.ACNLFConfigsByClass[SourceClassIndex].FacialHairMesh;
					default.ACNLFConfigsByClass[i].TattooTex		= default.ACNLFConfigsByClass[SourceClassIndex].TattooTex;
				}
			}
			break;
			
			case NFOR_NVA:
			for (i = 0; i < default.ACNVAConfigsByClass.length; i++)
			{
				if (i <= `ACCI_Tank)
				{
					default.ACNVAConfigsByClass[i].TunicMesh		= default.ACNVAConfigsByClass[SourceClassIndex].TunicMesh;
					default.ACNVAConfigsByClass[i].TunicMaterial	= default.ACNVAConfigsByClass[SourceClassIndex].TunicMaterial;
					default.ACNVAConfigsByClass[i].ShirtTexture	= default.ACNVAConfigsByClass[SourceClassIndex].ShirtTexture;
					default.ACNVAConfigsByClass[i].HeadMesh		= default.ACNVAConfigsByClass[SourceClassIndex].HeadMesh;
					default.ACNVAConfigsByClass[i].HairMaterial	= default.ACNVAConfigsByClass[SourceClassIndex].HairMaterial;
					default.ACNVAConfigsByClass[i].HeadgearMesh	= default.ACNVAConfigsByClass[SourceClassIndex].HeadgearMesh;
					default.ACNVAConfigsByClass[i].HeadgearMaterial= default.ACNVAConfigsByClass[SourceClassIndex].HeadgearMaterial;
					default.ACNVAConfigsByClass[i].FaceItemMesh	= default.ACNVAConfigsByClass[SourceClassIndex].FaceItemMesh;
					default.ACNVAConfigsByClass[i].FacialHairMesh	= default.ACNVAConfigsByClass[SourceClassIndex].FacialHairMesh;
					default.ACNVAConfigsByClass[i].TattooTex		= default.ACNVAConfigsByClass[SourceClassIndex].TattooTex;
				}
			}
			break;
		}
	}
	else if (SourceClassIndex < `ACCI_CombatPilot)
	{
		switch (ArmyIndex)
		{
			case SFOR_USArmy:
			for (i = 0; i < default.ACUSArmyConfigsByClass.length; i++)
			{
				if (i <= `ACCI_Tank)
				{
					default.ACUSArmyConfigsByClass[i].TunicMesh		= default.ACUSArmyConfigsByClass[SourceClassIndex].TunicMesh;
					default.ACUSArmyConfigsByClass[i].TunicMaterial	= default.ACUSArmyConfigsByClass[SourceClassIndex].TunicMaterial;
					default.ACUSArmyConfigsByClass[i].ShirtTexture		= default.ACUSArmyConfigsByClass[SourceClassIndex].ShirtTexture;
					default.ACUSArmyConfigsByClass[i].HeadMesh			= default.ACUSArmyConfigsByClass[SourceClassIndex].HeadMesh;
					default.ACUSArmyConfigsByClass[i].HairMaterial		= default.ACUSArmyConfigsByClass[SourceClassIndex].HairMaterial;
					default.ACUSArmyConfigsByClass[i].HeadgearMesh		= default.ACUSArmyConfigsByClass[SourceClassIndex].HeadgearMesh;
					default.ACUSArmyConfigsByClass[i].HeadgearMaterial	= default.ACUSArmyConfigsByClass[SourceClassIndex].HeadgearMaterial;
					default.ACUSArmyConfigsByClass[i].FaceItemMesh		= default.ACUSArmyConfigsByClass[SourceClassIndex].FaceItemMesh;
					default.ACUSArmyConfigsByClass[i].FacialHairMesh	= default.ACUSArmyConfigsByClass[SourceClassIndex].FacialHairMesh;
					default.ACUSArmyConfigsByClass[i].TattooTex		= default.ACUSArmyConfigsByClass[SourceClassIndex].TattooTex;
				}
			}
			break;
			
			case SFOR_USMC:
			for (i = 0; i < default.ACUSMCConfigsByClass.length; i++)
			{
				if (i <= `ACCI_Tank)
				{
					default.ACUSMCConfigsByClass[i].TunicMesh			= default.ACUSMCConfigsByClass[SourceClassIndex].TunicMesh;
					default.ACUSMCConfigsByClass[i].TunicMaterial		= default.ACUSMCConfigsByClass[SourceClassIndex].TunicMaterial;
					default.ACUSMCConfigsByClass[i].ShirtTexture		= default.ACUSMCConfigsByClass[SourceClassIndex].ShirtTexture;
					default.ACUSMCConfigsByClass[i].HeadMesh			= default.ACUSMCConfigsByClass[SourceClassIndex].HeadMesh;
					default.ACUSMCConfigsByClass[i].HairMaterial		= default.ACUSMCConfigsByClass[SourceClassIndex].HairMaterial;
					default.ACUSMCConfigsByClass[i].HeadgearMesh		= default.ACUSMCConfigsByClass[SourceClassIndex].HeadgearMesh;
					default.ACUSMCConfigsByClass[i].HeadgearMaterial	= default.ACUSMCConfigsByClass[SourceClassIndex].HeadgearMaterial;
					default.ACUSMCConfigsByClass[i].FaceItemMesh		= default.ACUSMCConfigsByClass[SourceClassIndex].FaceItemMesh;
					default.ACUSMCConfigsByClass[i].FacialHairMesh		= default.ACUSMCConfigsByClass[SourceClassIndex].FacialHairMesh;
					default.ACUSMCConfigsByClass[i].TattooTex			= default.ACUSMCConfigsByClass[SourceClassIndex].TattooTex;
				}
			}
			break;

			case SFOR_ARVN:
			for (i = 0; i < default.ACARVNConfigsByClass.length; i++)
			{
				if (i <= `ACCI_Tank)
				{
					default.ACARVNConfigsByClass[i].TunicMesh			= default.ACARVNConfigsByClass[SourceClassIndex].TunicMesh;
					default.ACARVNConfigsByClass[i].TunicMaterial		= default.ACARVNConfigsByClass[SourceClassIndex].TunicMaterial;
					default.ACARVNConfigsByClass[i].ShirtTexture		= default.ACARVNConfigsByClass[SourceClassIndex].ShirtTexture;
					default.ACARVNConfigsByClass[i].HeadMesh			= default.ACARVNConfigsByClass[SourceClassIndex].HeadMesh;
					default.ACARVNConfigsByClass[i].HairMaterial		= default.ACARVNConfigsByClass[SourceClassIndex].HairMaterial;
					default.ACARVNConfigsByClass[i].HeadgearMesh		= default.ACARVNConfigsByClass[SourceClassIndex].HeadgearMesh;
					default.ACARVNConfigsByClass[i].HeadgearMaterial	= default.ACARVNConfigsByClass[SourceClassIndex].HeadgearMaterial;
					default.ACARVNConfigsByClass[i].FaceItemMesh		= default.ACARVNConfigsByClass[SourceClassIndex].FaceItemMesh;
					default.ACARVNConfigsByClass[i].FacialHairMesh		= default.ACARVNConfigsByClass[SourceClassIndex].FacialHairMesh;
					default.ACARVNConfigsByClass[i].TattooTex			= default.ACARVNConfigsByClass[SourceClassIndex].TattooTex;
				}
			}
			break;
			
			case SFOR_AusArmy:
			for (i = 0; i < default.ACAusArmyConfigsByClass.length; i++)
			{
				if (i <= `ACCI_Tank)
				{
					default.ACAusArmyConfigsByClass[i].TunicMesh		= default.ACAusArmyConfigsByClass[SourceClassIndex].TunicMesh;
					default.ACAusArmyConfigsByClass[i].TunicMaterial	= default.ACAusArmyConfigsByClass[SourceClassIndex].TunicMaterial;
					default.ACAusArmyConfigsByClass[i].ShirtTexture	= default.ACAusArmyConfigsByClass[SourceClassIndex].ShirtTexture;
					default.ACAusArmyConfigsByClass[i].HeadMesh		= default.ACAusArmyConfigsByClass[SourceClassIndex].HeadMesh;
					default.ACAusArmyConfigsByClass[i].HairMaterial	= default.ACAusArmyConfigsByClass[SourceClassIndex].HairMaterial;
					default.ACAusArmyConfigsByClass[i].HeadgearMesh	= default.ACAusArmyConfigsByClass[SourceClassIndex].HeadgearMesh;
					default.ACAusArmyConfigsByClass[i].HeadgearMaterial= default.ACAusArmyConfigsByClass[SourceClassIndex].HeadgearMaterial;
					default.ACAusArmyConfigsByClass[i].FaceItemMesh	= default.ACAusArmyConfigsByClass[SourceClassIndex].FaceItemMesh;
					default.ACAusArmyConfigsByClass[i].FacialHairMesh	= default.ACAusArmyConfigsByClass[SourceClassIndex].FacialHairMesh;
					default.ACAusArmyConfigsByClass[i].TattooTex		= default.ACAusArmyConfigsByClass[SourceClassIndex].TattooTex;
				}
			}
			break;
		}
	}
	
	StaticSaveConfig();
	
	return true;
}

static function array<TunicInfo> GetTunicArray(byte TeamIndex, byte ArmyIndex, optional byte bPilot)
{
	if( TeamIndex == `AXIS_TEAM_INDEX )
	{
		if( ArmyIndex == NFOR_NVA )
			return default.NVATunics;
		else
			return default.NLFTunics;
	}
	else
	{
		if( ArmyIndex == SFOR_AusArmy )
		{
			if( bPilot > 0 )
				return default.AusPilotTunics;
			else
				return default.AusArmyTunics;
		}
		else if( ArmyIndex == SFOR_ARVN )
		{
			if( bPilot > 1 )
				return default.USPilotTunics;
			else if( bPilot == 1 )
				return default.ARVNPilotTunics;
			else
				return default.ARVNTunics;
		}
		else
		{
			if( bPilot > 0 )
				return default.USPilotTunics;
			else if( ArmyIndex == SFOR_USMC )
				return default.USMCTunics;
			else
				return default.USArmyTunics;
		}
	}
}

defaultproperties
{
	// Fieldgear by role first and tunic mesh type second (for tunic types, 0 = Pants and Top, 1 = Pants Only)
	NVAFieldgearByRole(`ACCI_Rifle)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Gear_Long_Rifleman',SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Camo_Gear_Long_Rifleman'))
	NVAFieldgearByRole(`ACCI_Light)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Gear_Long_Scout',SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Camo_Gear_Long_Scout'))
	NVAFieldgearByRole(`ACCI_MG)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Gear_Long_Machinegunner',SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Camo_Gear_Long_Machinegunner'))
	NVAFieldgearByRole(`ACCI_Sniper)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Gear_Long_Sniper',SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Camo_Gear_Long_Sniper'))
	NVAFieldgearByRole(`ACCI_CE)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Gear_Long_RPG',SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Camo_Gear_Long_RPG'))
	NVAFieldgearByRole(`ACCI_Radioman)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Gear_Long_Radio',SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Gear_Long_Radio'))
	NVAFieldgearByRole(`ACCI_Commander)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Gear_Long_Commander',SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Camo_Gear_Long_Commander'))
	NVAFieldgearByRole(`ACCI_Tank)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Gear_Long_Commander',SkeletalMesh'CHR_VN_NVA.GearMesh.NVA_Camo_Gear_Long_Commander'))

	// Fieldgear by role first and tunic mesh type second (for tunic types, 0 = Pants and Top, 1 = Pants Only)
	NLFFieldgearByRole(`ACCI_Rifle)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Gear_Long_Rifleman',SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Camo_Gear_Long_Rifleman'))
	NLFFieldgearByRole(`ACCI_Light)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Gear_Long_Scout',SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Camo_Gear_Long_Scout'))
	NLFFieldgearByRole(`ACCI_MG)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Gear_Long_Machinegunner',SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Camo_Gear_Long_Machinegunner'))
	NLFFieldgearByRole(`ACCI_Sniper)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Gear_Long_Sniper',SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Camo_Gear_Long_Sniper'))
	NLFFieldgearByRole(`ACCI_CE)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Gear_Long_RPG',SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Camo_Gear_Long_RPG'))
	NLFFieldgearByRole(`ACCI_Radioman)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Gear_Long_Radio',SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Gear_Long_Radio'))
	NLFFieldgearByRole(`ACCI_Commander)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Gear_Long_Commander',SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Camo_Gear_Long_Commander'))
	NLFFieldgearByRole(`ACCI_Tank)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Gear_Long_Commander',SkeletalMesh'CHR_VN_Vietcong.GearMesh.VC_Camo_Gear_Long_Commander'))

	// Fieldgear by role first and tunic mesh type second (for tunic types, 0 = Pants and Top, 1 = Pants Only)
	USArmyFieldgearByRole(`ACCI_Rifle)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Rifleman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Rifleman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Vest_Rifleman',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Rifleman'))
	USArmyFieldgearByRole(`ACCI_Light)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Pointman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Pointman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Vest_Pointman',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Pointman'))
	USArmyFieldgearByRole(`ACCI_MG)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Machinegunner',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Machinegunner',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Vest_Machinegunner',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Machinegunner'))
	USArmyFieldgearByRole(`ACCI_Sniper)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Marksman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Marksman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Vest_Marksman',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Marksman'))
	USArmyFieldgearByRole(`ACCI_CE)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Grenadier',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Grenadier',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Vest_Grenadier',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Grenadier'))
	USArmyFieldgearByRole(`ACCI_Radioman)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Radioman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Radioman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Radioman',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Radioman'))
	USArmyFieldgearByRole(`ACCI_Commander)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Rifleman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Rifleman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Vest_Rifleman',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Rifleman'))
	USArmyFieldgearByRole(`ACCI_Tank)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pilot'))
	USArmyFieldgearByRole(`ACCI_CombatPilot)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pilot'))
	USArmyFieldgearByRole(`ACCI_TransportPilot)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pilot'))
	USArmyFieldgearByRole(`ACCI_Lineup)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Rifleman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Rifleman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Vest_Rifleman',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Rifleman'))

	// Fieldgear by role first and tunic mesh type second (for tunic types, 0 = Pants and Top, 1 = Pants Only)
	USMCFieldgearByRole(`ACCI_Rifle)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Rifleman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Rifleman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Vest_Rifleman',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Rifleman'))
	USMCFieldgearByRole(`ACCI_Light)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Pointman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Pointman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Vest_Pointman',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Pointman'))
	USMCFieldgearByRole(`ACCI_MG)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Machinegunner',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Machinegunner',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Vest_Machinegunner',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Machinegunner'))
	USMCFieldgearByRole(`ACCI_Sniper)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Marksman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Marksman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Vest_Marksman',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Marksman'))
	USMCFieldgearByRole(`ACCI_CE)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Grenadier',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Grenadier',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Vest_Grenadier',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Grenadier'))
	USMCFieldgearByRole(`ACCI_Radioman)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Radioman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Radioman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Radioman',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Radioman'))
	USMCFieldgearByRole(`ACCI_Commander)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Rifleman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Rifleman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Vest_Rifleman',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Rifleman'))
	USMCFieldgearByRole(`ACCI_Lineup)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Long_Rifleman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pants_Rifleman',SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Vest_Rifleman',SkeletalMesh'CHR_VN_DLC_CGOM_US.GearMesh.US_Gear_OpenVest_Rifleman'))
	USMCFieldgearByRole(`ACCI_Tank)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pilot'))
	USMCFieldgearByRole(`ACCI_CombatPilot)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pilot'))
	USMCFieldgearByRole(`ACCI_TransportPilot)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pilot'))

	// Fieldgear by role first and tunic mesh type second (for tunic types, 0 = Pants and Top, 1 = Pants Only)
	AusArmyFieldgearByRole(`ACCI_Rifle)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Long_Rifleman_B',SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Pants_Rifleman_B'))
	AusArmyFieldgearByRole(`ACCI_Light)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Long_Pointman',SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Pants_Pointman'))
	AusArmyFieldgearByRole(`ACCI_MG)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Long_Machinegunner',SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Pants_Machinegunner'))
	AusArmyFieldgearByRole(`ACCI_Sniper)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Long_Marksman',SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Pants_Marksman'))
	AusArmyFieldgearByRole(`ACCI_CE)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Long_Grenadier',SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Pants_Grenadier'))
	AusArmyFieldgearByRole(`ACCI_Radioman)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Long_Radioman',SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Pants_Radioman'))
	AusArmyFieldgearByRole(`ACCI_Commander)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Long_Commander',SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Pants_Commander'))
	AusArmyFieldgearByRole(`ACCI_Lineup)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Long_Commander',SkeletalMesh'CHR_VN_AUS.GearMesh.AUS_Gear_Pants_Commander'))
	AusArmyFieldgearByRole(`ACCI_Tank)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pilot'))
	AusArmyFieldgearByRole(`ACCI_CombatPilot)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pilot'))
	AusArmyFieldgearByRole(`ACCI_TransportPilot)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pilot'))

	ARVNFieldgearByRole(`ACCI_Rifle)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Long_Rifleman',SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Pants_Rifleman',SkeletalMesh'CHR_VN_DLC_CGOM_ARVN.GearMesh.ARVN_Gear_OpenVest_Rifleman'))
	ARVNFieldgearByRole(`ACCI_Light)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Long_Pointman',SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Pants_Pointman',SkeletalMesh'CHR_VN_DLC_CGOM_ARVN.GearMesh.ARVN_Gear_OpenVest_Pointman'))
	ARVNFieldgearByRole(`ACCI_MG)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Long_Machinegunner',SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Pants_Machinegunner',SkeletalMesh'CHR_VN_DLC_CGOM_ARVN.GearMesh.ARVN_Gear_OpenVest_Machinegunner'))
	ARVNFieldgearByRole(`ACCI_Sniper)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Long_Marksman',SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Pants_Marksman',SkeletalMesh'CHR_VN_DLC_CGOM_ARVN.GearMesh.ARVN_Gear_OpenVest_Marksman'))
	ARVNFieldgearByRole(`ACCI_Lineup)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Long_Rifleman',SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Pants_Rifleman',SkeletalMesh'CHR_VN_DLC_CGOM_ARVN.GearMesh.ARVN_Gear_OpenVest_Rifleman'))
	ARVNFieldgearByRole(`ACCI_CE)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Long_Grenadier',SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Pants_Grenadier',SkeletalMesh'CHR_VN_DLC_CGOM_ARVN.GearMesh.ARVN_Gear_OpenVest_Grenadier'))
	ARVNFieldgearByRole(`ACCI_Radioman)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Long_Radioman',SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Pants_Radioman',SkeletalMesh'CHR_VN_DLC_CGOM_ARVN.GearMesh.ARVN_Gear_OpenVest_Radioman'))
	ARVNFieldgearByRole(`ACCI_Commander)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Long_Commander',SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Pants_Commander',SkeletalMesh'CHR_VN_DLC_CGOM_ARVN.GearMesh.ARVN_Gear_OpenVest_Commander'))
	ARVNFieldgearByRole(`ACCI_Tank)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Long_Commander',SkeletalMesh'CHR_VN_ARVN.GearMesh.ARVN_Gear_Pants_Commander',SkeletalMesh'CHR_VN_DLC_CGOM_ARVN.GearMesh.ARVN_Gear_OpenVest_Commander'))
	ARVNFieldgearByRole(`ACCI_CombatPilot)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pilot'))
	ARVNFieldgearByRole(`ACCI_TransportPilot)=(FieldgearByTunicType=(SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pilot'))

	USArmyTattoos(13)=(TattooTex=Texture2D'MutExtrasContent.Tattoos.US_CamoV3',ThumbnailImage=Texture2D'VN_UI_Textures_Character_Two.Tattoos.Tattoo_US_Camo2')
	USArmyTattoos(14)=(TattooTex=Texture2D'MutExtrasContent.Tattoos.US_CamoV4',ThumbnailImage=Texture2D'VN_UI_Textures_Character_Two.Tattoos.Tattoo_US_Camo2')
	USArmyTattoos(15)=(TattooTex=Texture2D'MutExtrasContent.Tattoos.Joker',ThumbnailImage=Texture2D'CHR_VN_DLC_PCGamer.Tattoos.AUS_CoconutMonkey')

	USMCTattoos(13)=(TattooTex=Texture2D'MutExtrasContent.Tattoos.US_CamoV3',ThumbnailImage=Texture2D'VN_UI_Textures_Character_Two.Tattoos.Tattoo_US_Camo2')
	USMCTattoos(14)=(TattooTex=Texture2D'MutExtrasContent.Tattoos.US_CamoV4',ThumbnailImage=Texture2D'VN_UI_Textures_Character_Two.Tattoos.Tattoo_US_Camo2')
	USMCTattoos(15)=(TattooTex=Texture2D'MutExtrasContent.Tattoos.Joker',ThumbnailImage=Texture2D'CHR_VN_DLC_PCGamer.Tattoos.AUS_CoconutMonkey')

	USAHeadgear(38)=(HeadgearMeshes=(SkeletalMesh'MutExtrasContent.Mesh.29thHelmet'),HeadgearMICs=(20),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'MutExtrasContent.Textures.29th')
	AusArmyHeadgear(20)=(HeadgearMeshes=(SkeletalMesh'MutExtrasContent.Mesh.29thHelmet'),HeadgearMICs=(14),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'MutExtrasContent.Textures.29th')
	ARVNHeadgear(26)=(HeadgearMeshes=(SkeletalMesh'MutExtrasContent.Mesh.29thHelmet'),HeadgearSocket=helmet,bIsHelmet=1,ThumbnailImage=Texture2D'MutExtrasContent.Textures.29th')

	USAHeadgearMICs(20)=(HeadgearMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Headgear.Materials.M_ARVN_Headgear_M1Bare_INST')
	AusHeadgearMICs(14)=(HeadgearMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Headgear.Materials.M_ARVN_Headgear_M1Bare_INST')
}