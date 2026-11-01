class ACCharCustMannequin extends ROCharCustMannequin
	config(Game)
	notplaceable;

var MaterialInstanceConstant HeadgearMIC2;
var MaterialInstanceConstant HeadgearMIC3;

var MaterialInstanceConstant HeadgearTemplateMIC2;
var MaterialInstanceConstant HeadgearTemplateMIC3;

var DecalComponent MyDecal;

event PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	PawnHandlerClass = class'ACPawnHandler';

	mesh.AttachComponent(MyDecal, 'CHR_LArmshoulder');
	mesh.AttachComponent(MyDecal, 'CHR_RArmshoulder');
}

function AttachNewHeadgear(SkeletalMesh NewHeadgearMesh)
{
	local SkeletalMeshSocket HeadSocket;

	ThirdPersonHeadgearMeshComponent.SetSkeletalMesh(NewHeadgearMesh);
	ThirdPersonHeadgearMeshComponent.SetMaterial(0, HeadgearMIC);

	if (ThirdPersonHeadgearMeshComponent.GetNumElements() > 1)
	{
		if (!bIsPilot && HairMIC != none)
			ThirdPersonHeadgearMeshComponent.SetMaterial(1, HairMIC);
		if (NewHeadgearMesh.name != '29thHelmet') // Set to default to avoid overwriting stuff like visors for pilots
		{
			ThirdPersonHeadgearMeshComponent.SetMaterial(2, NewHeadgearMesh.Materials[2]);
			ThirdPersonHeadgearMeshComponent.SetMaterial(3, NewHeadgearMesh.Materials[3]);
		}
	}

	// Set up the MICS for the 29th helmet
	// `log ("[MutExtras Debug] NewHeadgearMesh.name "$NewHeadgearMesh.name);
	if (NewHeadgearMesh.name == '29thHelmet')
	{
		HeadgearTemplateMIC2 = MaterialInstanceConstant(DynamicLoadObject("MutExtrasContent.Materials." $ ACPlayerReplicationInfo(ROPC.PlayerReplicationInfo).PlayerRank, class'MaterialInstanceConstant', true));
		HeadgearTemplateMIC3 = MaterialInstanceConstant(DynamicLoadObject("MutExtrasContent.Materials." $ ACPlayerReplicationInfo(ROPC.PlayerReplicationInfo).PlayerUnit, class'MaterialInstanceConstant', true));

		// `log ("[MutExtras Debug] GetRankTexture "$ACPlayerReplicationInfo(ROPC.PlayerReplicationInfo).PlayerRank);
		// `log ("[MutExtras Debug] GetUnitTexture "$ACPlayerReplicationInfo(ROPC.PlayerReplicationInfo).PlayerUnit);

		if (HeadgearTemplateMIC2 != none)
			HeadgearMIC2 = new class'MaterialInstanceConstant';
		if (HeadgearTemplateMIC3 != none)
			HeadgearMIC3 = new class'MaterialInstanceConstant';

		HeadgearMIC2.SetParent(HeadgearTemplateMIC2);
		HeadgearMIC3.SetParent(HeadgearTemplateMIC3);
		ThirdPersonHeadgearMeshComponent.SetMaterial(2, HeadgearMIC2);
		ThirdPersonHeadgearMeshComponent.SetMaterial(3, HeadgearMIC3);
	}

	HeadSocket = ThirdPersonHeadAndArmsMeshComponent.GetSocketByName(HeadgearAttachSocket);
	if (HeadSocket != none)
	{
		if (mesh.MatchRefBone(HeadSocket.BoneName) != INDEX_NONE)
		{
			ThirdPersonHeadgearMeshComponent.SetShadowParent(mesh);
			ThirdPersonHeadgearMeshComponent.SetLODParent(mesh);
			mesh.AttachComponent(ThirdPersonHeadgearMeshComponent, HeadSocket.BoneName, HeadSocket.RelativeLocation, HeadSocket.RelativeRotation, HeadSocket.RelativeScale);
		}
		else
		{
			`warn("Bone name specified in socket not found in parent anim component. Headgear component will not be attached");
		}
	}
}

defaultproperties
{
	Begin Object Class=DecalComponent Name=Decal
		bIgnoreOwnerHidden=TRUE
		bProjectOnBackfaces=TRUE
		DecalMaterial=MaterialInstanceConstant'MutExtrasContent.Materials.TestMat'
	End Object
	Components.Add(Decal)
	MyDecal=Decal
}