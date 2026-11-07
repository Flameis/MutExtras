// An engineer's sandbag kit: three sandbag walls, about 2.4 m long and 1.2 m high, placed across your view
class ACItem_SandbagKit extends ACItem_FortificationKit;

defaultproperties
{
    PieceName="sandbag wall"
    PieceMeshPath="ENV_VN_Sandbags.Mesh.S_ENV_Sandbags_112uu"
    PieceCentreOffset=(X=-58,Y=-2,Z=0)
    PieceYawOffset=16384
    PieceHealth=800
    KitsLeft=3
    InvIndex=240 // its own slot: items that share one are merged (the ammo crate is 68)
}
