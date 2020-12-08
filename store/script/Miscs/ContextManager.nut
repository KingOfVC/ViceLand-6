class CContextManager 
{
	contexts = {};
	
	constructor() 
	{
		contexts = {};
	}
	
	function Add( context ) 
	{
		contexts.rawset( context, true );
	}
	
	function Remove( context ) 
	{
		contexts.rawdelete( context );
		
		onContextRemove( context );
	}
	
	function onContextRemove( removedContext ) 
	{
		foreach( context, value in contexts ) 
		{
			context.onContextRemove( removedContext );
		}
	}
	
	function onKeyBindDown( keyBind ) 
	{
		foreach( context, value in contexts ) 
		{
			context.onKeyBindDown( keyBind );
		}
	}
	
	function onKeyBindUp( keyBind ) 
	{
		foreach( context, value in contexts )
		{
			context.onKeyBindUp( keyBind );
		}
	}
	
	function onInputReturn( element ) 
	{
		foreach( context, value in contexts ) 
		{
			context.onInputReturn( element );
		}
	}
	
	function onElementRelease( element, mouseX, mouseY ) 
	{
		foreach(context, value in contexts)
		{
			context.onElementRelease( element, mouseX, mouseY );
		}
	}
	
	function onElementClick( element, mouseX, mouseY )
	{
		foreach( context, value in contexts ) 
		{
			context.onElementClick( element, mouseX, mouseY );
		}
	}
	
	function onElementHoverOver( element )
	{
		foreach( context, value in contexts ) 
		{
			context.onElementHoverOver( element );
		}
	}
	
	function onElementHoverOut( element )
	{
		foreach( context, value in contexts ) 
		{
			context.onElementHoverOut( element );
		}
	}
	
	function onWindowClose( window )
	{
		foreach( context, value in contexts ) 
		{
			context.onWindowClose( window );
		}
	}

	function onListboxSelect( element, item )
	{
		foreach( context, value in contexts ) 
		{
			context.onListboxSelect( element, item );
		}
	}
	
	function onWindowResize( window, width, height )
	{
		foreach( context, value in contexts ) 
		{
			context.onWindowResize( window, width, height );
		}
	}
	
	function onServerData( type, stream ) 
	{
		foreach( context, value in contexts ) 
		{
			context.onServerData( type, stream );
		}
	}
	
	function onCheckboxToggle( element, item )
	{
		foreach( context, value in contexts ) 
		{
			context.onCheckboxToggle( element, item );
		}
	}

	function onScriptProcess()
	{
		foreach( context, value in contexts ) 
		{
			context.onScriptProcess();
		}
	}

	function onScriptLoad()
	{
		foreach( context, value in contexts ) 
		{
			context.onScriptLoad();
		}
	}

	function onPlayerShoot( player, weapon, hitEntity, hitPosition ) 
	{
		foreach( context, value in contexts ) 
		{
	   	 	context.onPlayerShoot( player, weapon, hitEntity, hitPosition );
	   	}
	}

	function onScrollbarScroll( scrollbar, position, change )
	{
		foreach( context, value in contexts ) 
		{
	   	 	context.onScrollbarScroll( scrollbar, position, change );
	   	}
	}

}