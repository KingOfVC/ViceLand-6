class CSpecialShop extends CContext
{
	Titlebar = null;
	Titletext = null;

	Body = null;

	Membox = null;

	Close = null;
	Closetext = null;

	ErrorText = null;
	
	function constructor( Key )
	{
		base.constructor();

		this.Load();
	}

	function Load()
	{
		local rel = GUI.GetScreenSize();

		this.Titlebar = GUICanvas();
		this.Titlebar.Pos = VectorScreen( rel.X * 0.2862371888726208, rel.Y * 0.1328125 );
		this.Titlebar.Size = VectorScreen( rel.X * 0.4282576866764275, rel.Y * 0.0455729166666667 );
		this.Titlebar.Colour = Colour( 32, 34, 37, 0 );

		this.Titletext = GUILabel();
		this.Titlebar.AddChild( Titletext );
		this.Titletext.TextColour = Colour( 255, 255, 255 );
		this.Titletext.Pos =  VectorScreen( rel.X * 0.1976573938506589, rel.Y * 0.0104166666666667 );		
		this.Titletext.TextAlignment = GUI_ALIGN_CENTER;
		this.Titletext.FontFlags = GUI_FFLAG_BOLD;		
		this.Titletext.Text = "Shop";
		this.Titletext.FontName = "Tahoma";
		this.Titletext.FontSize = ( rel.Y * 0.0148148148148148 );
		this.centerinchildX( this.Titlebar, this.Titletext );

		this.Body = GUISprite();
		this.Titlebar.AddChild( Body );
		this.Body.SetTexture( "vl-bg.png" );
		this.Body.Pos = VectorScreen( rel.X * -0.0416666666666667, rel.Y * -0.0657407407407407 );
		this.Body.Size = VectorScreen( rel.X * 0.5114583333333333, rel.Y * 0.7166666666666667 );

		this.Membox = GUIListbox();
		this.Membox.FontFlags = GUI_FFLAG_BOLD;
		this.Membox.AddFlags( GUI_FLAG_TEXT_TAGS );
		this.Membox.FontName = "Tahoma";
		this.Membox.FontSize = ( rel.Y * 0.0148148148148148 );
		this.Membox.Pos = VectorScreen( 0, rel.Y * 0.1783854166666667 );
		this.Membox.Size = VectorScreen( rel.X * 0.4282576866764275, rel.Y * 0.3971354166666667 );
		this.Membox.Colour = Colour( 66, 70, 71, 150 );
		this.Membox.TextColour = Colour( 255, 255, 255 );
		this.Membox.SelectedColour = Colour( 47, 49, 54, 255 );
		this.centerX( this.Membox, this.Titlebar );

		this.Close = GUIWindow();
		this.Close.Pos = VectorScreen( 0, rel.Y * 0.6510416666666667 );
		this.Close.Size = VectorScreen( rel.X * 0.2598828696925329, rel.Y * 0.0455729166666667 );
		this.Close.Colour = Colour( 255, 0, 0, 255 );
		this.Close.AddFlags( GUI_FLAG_MOUSECTRL );
		this.Close.RemoveFlags( GUI_FLAG_SHADOW | GUI_FLAG_WINDOW_TITLEBAR | GUI_FLAG_WINDOW_CLOSEBTN | GUI_FLAG_WINDOW_RESIZABLE );
		this.centerX( this.Close, this.Titlebar );

		this.Closetext = GUILabel();
		this.Close.AddChild( Closetext );
		this.Closetext.TextColour = Colour( 255, 255, 255 );
		this.Closetext.Pos =  VectorScreen( rel.X * 0.1976573938506589, rel.Y * 0.0065104166666667 );		
		this.Closetext.TextAlignment = GUI_ALIGN_CENTER;
		this.Closetext.FontFlags = GUI_FFLAG_BOLD;		
		this.Closetext.Text = "Close";
		this.Closetext.FontSize = ( rel.Y * 0.0148148148148148 );
		this.Closetext.AddFlags( GUI_FLAG_MOUSECTRL );
		this.centerinchild( this.Close, this.Closetext );

		this.Membox.AddItem( "[#2196f3]Name [#ffffff]Weapon name tag [#2196f3]Cost [#ffffff]1,500 Vice Coin" );
		this.Membox.AddItem( "[#2196f3]Name [#ffffff]Vehicle name tag [#2196f3]Cost [#ffffff]500 Vice Coin" );
		this.Membox.AddItem( "[#2196f3]Name [#ffffff]VIP pass (30days) [#2196f3]Cost [#ffffff]320 Vice Coin" );
		this.Membox.AddItem( "[#2196f3]Name [#ffffff]Gang create pass [#2196f3]Cost [#ffffff]50 Vice Coin" );
		this.Membox.AddItem( "[#2196f3]Name [#ffffff]Armour case [#2196f3]Cost [#ffffff]20 Vice Coin" );

		this.ErrorText = GUILabel();
		this.Titlebar.AddChild( ErrorText );
		this.ErrorText.TextColour = Colour( 255, 255, 255 );
		this.ErrorText.Pos =  VectorScreen( rel.X * 0.1976573938506589, rel.Y * 0.46875 );		
		this.ErrorText.TextAlignment = GUI_ALIGN_CENTER;
		this.ErrorText.FontFlags = GUI_FFLAG_BOLD;		
		this.ErrorText.FontName = "Tahoma";
		this.ErrorText.Text = "You cannot carry anymore.";
		this.ErrorText.FontSize = ( rel.Y * 0.0138888888888889 );
		this.centerinchildX( this.Titlebar, this.ErrorText );

		this.Titlebar.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Titletext.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Body.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Membox.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_BORDER | GUI_FLAG_KBCTRL );
		this.Close.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Closetext.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.ErrorText.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
	}

	function Show()
	{
		this.Titlebar.AddFlags( GUI_FLAG_VISIBLE );
		this.Titletext.AddFlags( GUI_FLAG_VISIBLE );
		this.Body.AddFlags( GUI_FLAG_VISIBLE );
		this.Membox.AddFlags( GUI_FLAG_VISIBLE );
		this.Close.AddFlags( GUI_FLAG_VISIBLE );
		this.Closetext.AddFlags( GUI_FLAG_VISIBLE );
		this.ErrorText.AddFlags( GUI_FLAG_VISIBLE );

		this.Titletext.SendToTop();

		this.ErrorText.Text = "";

		GUI.SetMouseEnabled( true );
	}

	function Hide()
	{
		this.Titlebar.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Titletext.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Body.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Membox.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Close.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Closetext.RemoveFlags( GUI_FLAG_VISIBLE );
		this.ErrorText.RemoveFlags( GUI_FLAG_VISIBLE );
		
		GUI.SetMouseEnabled( false );
	}

	function onElementHoverOver( element )
	{
		switch( element )
		{
			case this.Close:
			case this.Closetext:

			this.Close.Colour = Colour( 255, 255, 255, 150 );
			this.Closetext.TextColour = Colour( 66, 70, 71, 255 );
			break;
		}
	}

	function onElementHoverOut( element )
	{
		switch( element )
		{
			case this.Close:
			case this.Closetext:

			this.Close.Colour = Colour( 66, 70, 71, 150 );
			this.Closetext.TextColour = Colour( 255, 255, 255, 255 );
			break;
		}
	}

	function onElementRelease( element, x, y )
	{
		switch( element )
		{
			case this.Close:
			case this.Closetext:
			this.Hide();

			break;
		}
	}

	function onServerData( type, str )
	{
		switch( type )
		{
			case 210:
			this.Hide();
			break;
					
			case 211:
			this.Show();
			break;

			case 212:
			this.setErrorText( str );
			this.ErrorText.TextColour = Colour( 255,0,0 );
			break;

			case 213:
			this.setErrorText( str );
			this.ErrorText.TextColour = Colour( 255,255,255 );
			break;
		}
	}

	function onListboxSelect( element, listbox )
	{
		if( this.Membox == element )
		{
			if( listbox )
			{
				switch( listbox )
				{
					case "Name Weapon name tag Cost 1,500 Vice Coin":
					local data = Stream();

					data.WriteInt( 210 );
					data.WriteString( "1" );
					Server.SendData( data );
					break;

					case "Name Armour case Cost 20 Vice Coin":
					local data = Stream();

					data.WriteInt( 210 );
					data.WriteString( "2" );
					Server.SendData( data );
					break;

					case "Name Vehicle name tag Cost 500 Vice Coin":
					local data = Stream();

					data.WriteInt( 210 );
					data.WriteString( "3" );
					Server.SendData( data );
					break;

					case "Name VIP pass (30days) Cost 320 Vice Coin":
					local data = Stream();

					data.WriteInt( 210 );
					data.WriteString( "4" );
					Server.SendData( data );
					break;

					case "Name Gang create pass Cost 50 Vice Coin":
					local data = Stream();

					data.WriteInt( 210 );
					data.WriteString( "5" );
					Server.SendData( data );
					break;
				}
			}
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