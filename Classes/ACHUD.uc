//=============================================================================
// ACHUD
//=============================================================================
// Swaps in ACHUDWidgetOverheadMap so players who don't get a native
// TeamPRIArray slot (team full at 32) can still be tracked on the overhead map.
//=============================================================================
class ACHUD extends ROHUD;

defaultproperties
{
	DefaultOverheadMapWidget=class'MutExtras.ACHUDWidgetOverheadMap'
}
