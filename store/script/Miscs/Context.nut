class CContext
{
	Key = null;
	GUIElements = null;

	function constructor() 
	{
		this.GUIElements = {};

		ContextManager.Add( this );
	}

	function Close()
	{
		ContextManager.Remove( this );
		Handler.Remove( Key );
	}

	function AddElement( Element )
	{
		this.GUIElements.rawset( Element, true );

		return Element;
	}

	function RemoveElement( Element )
	{
		this.GUIElements.rawdelete( Element );
	}

	function onContextRemove() 
	{

	}

	function onServerData( type, Stream ) 
	{

	}

	function onElementFocus( Element )
	{

	}

	function onElementBlur( Element )
	{

	}

	function onElementHoverOver( Element )
	{

	}

	function onElementHoverOut( Element )
	{

	}

	function onElementClick( Element, MouseX, MouseY )
	{

	}

	function onElementRelease( Element, MouseX, MouseY )
	{
		
	}

	function onElementDrag( Element, MouseX, MouseY )
	{
		
	}

	function onCheckboxToggle( Checkbox, Checked )
	{
		
	}

	function onWindowClose( Window )
	{
		
	}

	function onInputReturn( Editbox )
	{

	}

	function onListboxSelect( Listbox, Item )
	{

	}

	function onScrollbarScroll( Scrollbar, Position, Change )
	{

	}

	function onWindowResize( Window, Width, Height )
	{

	}

	function onGameResize( Width, Height )
	{

	}

	function onKeyPressed( Key )
	{

	}

	function onKeyBindUp( Key )
	{

	}

	function onKeyBindDown( Key )
	{

	}

	function onScriptProcess()
	{

	}

	function onScriptLoad()
	{

	}

	function onPlayerShoot( player, weapon, hitEntity, hitPosition ) 
	{

	}
}
