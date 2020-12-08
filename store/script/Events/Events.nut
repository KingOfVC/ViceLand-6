function KeyBind::OnDown( keyBind ) 
{
	ContextManager.onKeyBindDown( keyBind );
}

function KeyBind::OnUp( keyBind ) 
{
	ContextManager.onKeyBindUp( keyBind );
}

function GUI::InputReturn( element ) 
{
	ContextManager.onInputReturn( element );
}

function GUI::ElementRelease( element, mouseX, mouseY )
{
	ContextManager.onElementRelease( element, mouseX, mouseY );
}

function GUI::ElementHoverOver( element )
{
	ContextManager.onElementHoverOver( element );
}

function GUI::ElementHoverOut( element )
{
	ContextManager.onElementHoverOut( element );
}

function GUI::ElementClick( element, mouseX, mouseY ) 
{
	ContextManager.onElementClick( element, mouseX, mouseY );
}

function GUI::WindowClose( window ) 
{
	ContextManager.onWindowClose( window );
}

function GUI::WindowResize( window, width, height ) 
{
	ContextManager.onWindowResize( window, width, height );
}

function GUI::ListboxSelect( element, item ) 
{
	ContextManager.onListboxSelect( element, item );
}

function Server::ServerData( stream ) 
{
	local type = stream.ReadInt(), readString = stream.ReadString();

	ContextManager.onServerData( type, readString );
}

function GUI::CheckboxToggle( element, checked )
{
	ContextManager.onCheckboxToggle( element, checked );
}

function Script::ScriptProcess() 
{
	ContextManager.onScriptProcess();

	Timer.Process();
}

function Script::ScriptLoad()
{
	ContextManager.onScriptLoad();
}

function Player::PlayerShoot( player, weapon, hitEntity, hitPosition ) 
{
    ContextManager.onPlayerShoot( player, weapon, hitEntity, hitPosition );
}

function GUI::ScrollbarScroll( scrollbar, position, change )
{
    ContextManager.onScrollbarScroll( scrollbar, position, change );
}
