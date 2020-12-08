class CMSelector extends CContext
{
	Background = null;

	Titlebar = null;
	Titletext = null;

	Body = null;

	Button1 = null;
	ButtonText1 = null;

	Button = null;
	ButtonText = null;

	ErrorText = null;

	function constructor( Key )
	{
		base.constructor();

		this.Load();
	}

	function Load()
	{
		local rel = GUI.GetScreenSize();

		this.Background = GUISprite();
	//	this.Background.SetTexture( "login-bg.jpg" );
		this.Background.Pos = VectorScreen( 0, 0 );
		this.Background.Size = VectorScreen( rel.X, rel.Y );
		this.Background.Colour = Colour( 0, 0, 0, 155 );

		this.Titlebar = GUICanvas();
		this.Titlebar.Pos = VectorScreen( rel.X * 0.2862371888726208, rel.Y * 0.1328125 );
		this.Titlebar.Size = VectorScreen( rel.X * 0.2818448023426061, rel.Y * 0.2057291666666667 );
		this.Titlebar.Colour = Colour( 32, 34, 37, 255 );
		this.center( this.Titlebar );

		this.Titletext = GUILabel();
		this.Titlebar.AddChild( Titletext );
		this.Titletext.TextColour = Colour( 255, 255, 255 );
		this.Titletext.Pos =  VectorScreen( rel.X * 0.1976573938506589, rel.Y * 0.0104166666666667 );		
		this.Titletext.TextAlignment = GUI_ALIGN_CENTER;
		this.Titletext.FontFlags = GUI_FFLAG_BOLD;		
		this.Titletext.Text = "Select your default mode";
		this.Titletext.FontName = "Tahoma";
		this.Titletext.FontSize = ( rel.X * 0.0087847730600293 );
		this.centerinchildX( this.Titlebar, this.Titletext );

		this.Body = GUICanvas();
		this.Titlebar.AddChild( Body );
		this.Body.Pos = VectorScreen( 0, rel.Y * 0.04557291666666677 );
		this.Body.Size = VectorScreen( rel.X * 0.2818448023426061, rel.Y * 0.2057291666666667 );
		this.Body.Colour = Colour( 47, 49, 54, 255 );

		this.Button1 = GUICanvas();
		this.Titlebar.AddChild( Button1 );
		this.Button1.Pos = VectorScreen( rel.X * 0.1976573938506589, rel.Y * 0.078125 );
		this.Button1.Size = VectorScreen( rel.X * 0.2598828696925329, rel.Y * 0.0455729166666667 );
		this.Button1.Colour = Colour( 66, 70, 71, 255 );
		this.Button1.AddFlags( GUI_FLAG_MOUSECTRL );
		this.centerinchildX( this.Titlebar, this.Button1 );

		this.ButtonText1 = GUILabel();
		this.Button1.AddChild( ButtonText1 );
		this.ButtonText1.TextColour = Colour( 255, 255, 255 );
		this.ButtonText1.Pos =  VectorScreen( rel.X * 0.1976573938506589, rel.Y * 0.0065104166666667 );		
		this.ButtonText1.TextAlignment = GUI_ALIGN_CENTER;
		this.ButtonText1.FontFlags = GUI_FFLAG_BOLD;		
		this.ButtonText1.Text = "Normal";
		this.ButtonText1.FontName = "Tahoma";
		this.ButtonText1.FontSize = ( rel.X * 0.0087847730600293 );
		this.centerinchild( this.Button1, this.ButtonText1 );

		this.Button = GUICanvas();
		this.Titlebar.AddChild( Button );
		this.Button.Pos = VectorScreen( 0, rel.Y * 0.1432291666666667 );
		this.Button.Size = VectorScreen( rel.X * 0.2598828696925329, rel.Y * 0.0455729166666667 );
		this.Button.Colour = Colour( 66, 70, 71, 255 );
		this.Button.AddFlags( GUI_FLAG_MOUSECTRL );
		this.centerinchildX( this.Titlebar, this.Button );

		this.ButtonText = GUILabel();
		this.Button.AddChild( ButtonText );
		this.ButtonText.TextColour = Colour( 255, 255, 255 );
		this.ButtonText.Pos =  VectorScreen( rel.X * 0.1976573938506589, rel.Y * 0.0065104166666667 );		
		this.ButtonText.TextAlignment = GUI_ALIGN_CENTER;
		this.ButtonText.FontFlags = GUI_FFLAG_BOLD;		
		this.ButtonText.Text = "Deathmatch (for dm veteran)";
		this.ButtonText.FontName = "Tahoma";
		this.ButtonText.FontSize = ( rel.X * 0.0087847730600293 );
		this.centerinchild( this.Button, this.ButtonText );

		this.ErrorText = GUILabel();
		this.Titlebar.AddChild( ErrorText );
		this.ErrorText.TextColour = Colour( 255, 255, 255 );
		this.ErrorText.Pos =  VectorScreen( rel.X * 0.1976573938506589, rel.Y * 0.2083333333333333 );		
		this.ErrorText.TextAlignment = GUI_ALIGN_CENTER;
		this.ErrorText.FontFlags = GUI_FFLAG_BOLD;		
		this.ErrorText.FontName = "Tahoma";
		this.ErrorText.FontSize = ( rel.Y * 0.0138888888888889 );
		this.centerinchildX( this.Titlebar, this.ErrorText );

		this.Background.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Titlebar.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Titletext.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Body.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Button1.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.ButtonText1.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Button.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.ButtonText.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.ErrorText.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
	}

	function Show()
	{
		this.Background.AddFlags( GUI_FLAG_VISIBLE );
		this.Titlebar.AddFlags( GUI_FLAG_VISIBLE );
		this.Titletext.AddFlags( GUI_FLAG_VISIBLE );
		this.Body.AddFlags( GUI_FLAG_VISIBLE );
		this.Button1.AddFlags( GUI_FLAG_VISIBLE );
		this.ButtonText1.AddFlags( GUI_FLAG_VISIBLE );
		this.Button.AddFlags( GUI_FLAG_VISIBLE );
		this.ButtonText.AddFlags( GUI_FLAG_VISIBLE );
		this.ErrorText.AddFlags( GUI_FLAG_VISIBLE );

		this.ErrorText.Text = "";

		Handler.Handlers.PlayerHud.HideHud();

		Timer.Create( this, function() 
		{
			GUI.SetMouseEnabled( true );
		}, 2000, 1 );
	}

	function Hide()
	{
		this.Background.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Titlebar.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Titletext.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Body.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Button1.RemoveFlags( GUI_FLAG_VISIBLE );
		this.ButtonText1.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Button.RemoveFlags( GUI_FLAG_VISIBLE );
		this.ButtonText.RemoveFlags( GUI_FLAG_VISIBLE );
		this.ErrorText.RemoveFlags( GUI_FLAG_VISIBLE );

		Handler.Handlers.PlayerHud.ShowHud();

		GUI.SetMouseEnabled( false );
	}

	function onElementHoverOver( element )
	{
		switch( element )
		{
			case this.Button:
			case this.ButtonText:

			this.Button.Colour = Colour( 255, 255, 255, 255 );
			this.ButtonText.TextColour = Colour( 66, 70, 71, 255 );

			this.setErrorText( "You will spawn in spawnloc when you joined the server." );
			break;

			case this.Button1:
			case this.ButtonText1:

			this.Button1.Colour = Colour( 255, 255, 255, 255 );
			this.ButtonText1.TextColour = Colour( 66, 70, 71, 255 );

			this.setErrorText( "You will spawn in lobby when you joined the server." );
			break;
		}
	}

	function onElementHoverOut( element )
	{
		switch( element )
		{
			case this.Button:
			case this.ButtonText:

			this.Button.Colour = Colour( 66, 70, 71, 255 );
			this.ButtonText.TextColour = Colour( 255, 255, 255, 255 );

			this.setErrorText( "" );
			break;

			case this.Button1:
			case this.ButtonText1:

			this.Button1.Colour = Colour( 66, 70, 71, 255 );
			this.ButtonText1.TextColour = Colour( 255, 255, 255, 255 );

			this.setErrorText( "" );
			break;
		}
	}

	function onElementRelease( element, x, y )
	{
		switch( element )
		{
			case this.Button1:
			case this.ButtonText1:

			local data = Stream();
			data.WriteInt( 1020 );
			data.WriteString( "Normal" );
			Server.SendData( data );

			this.Hide();
			break;

			case this.Button:
			case this.ButtonText:

			local data = Stream();
			data.WriteInt( 1020 );
			data.WriteString( "DM" );
			Server.SendData( data );

			this.Hide();
			break;
		}
	}

	function onServerData( type, str )
	{
		switch( type )
		{
			case 1020:
			this.Show();
			break;

			case 1021:
			this.Hide();
			break;

			case 1022:
			this.setErrorText( str );
			break;
		}
	}

	function setErrorText( text )
	{
		this.ErrorText.Text = text;
		this.centerinchildX( this.Titlebar, this.ErrorText );
	}

	function center( instance, instance2 = null )
	{
		if( !instance2 ) 
		{
			local size = instance.Size;
			local screen = ::GUI.GetScreenSize();
			local x = (screen.X/2)-(size.X/2);
			local y = (screen.Y/2)-(size.Y/2);
			
			instance.Position = ::VectorScreen(x, y);
		}

		else 
		{
			local position = instance2.Position;
			local size = instance2.Size;
			instance.Position.X = (position.X + (position.X + size.X) - instance.Size.X)/2;
			instance.Position.Y = (position.Y + (position.Y + size.Y) - instance.Size.Y)/2;
		}
	}

	function centerX( instance, instance2 = null )
	{
		if( !instance2 ) 
		{
			local size = instance.Size;
			local screen = ::GUI.GetScreenSize();
			local x = (screen.X/2)-(size.X/2);
			
			instance.Position.X = x;
		} 

		else 
		{
			local position = instance2.Position;
			local size = instance2.Size;
			instance.Position.X = (position.X + (position.X + size.X) - instance.Size.X)/2;
		}
	}

	function left( instance, instance2 = null ) 
	{
		if( !instance2 ) instance.Position.X = 0;
		else 
		{
			local position = instance2.Position;
			local size = instance2.Size;
			instance.Position.X = position.X;
		}
	}

	function centerinchild( parents, child )
	{
		local parentElement = parents.Size;
		local childElement = child.Size;
		local x = ( parentElement.X/2 )-( childElement.X/2 );
		local y = ( parentElement.Y/2 )-( childElement.Y/2 );

		child.Pos = ::VectorScreen( x, y );
	}

	function centerinchildX( parents, child )
	{
		local parentElement = parents.Size;
		local childElement = child.Size;
		local x = ( parentElement.X/2 )-( childElement.X/2 );

		child.Pos.X = x;
	}	
}