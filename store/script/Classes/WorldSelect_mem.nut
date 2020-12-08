class CWorldSelector extends CContext
{
	Titlebar = null;
	Titletext = null;

	Body = null;

	Membox = null;

	Close = null;
	Closetext = null;

	Close1 = null;
	Closetext1 = null;

	ErrorText = null;

	State = 0;
	
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
		this.Titletext.Text = "World Selector";
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
		this.Membox.AddFlags( GUI_FLAG_TEXT_TAGS | GUI_FLAG_KBCTRL );
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

		this.Close1 = GUIWindow();
		this.Close1.Pos = VectorScreen( rel.X * 0.3294289897510981, rel.Y * 0.6510416666666667 );
		this.Close1.Size = VectorScreen( rel.X * 0.0256222547584187, rel.Y * 0.0455729166666667 );
		this.Close1.Colour = Colour( 66, 70, 71, 255 );
		this.Close1.RemoveFlags( GUI_FLAG_SHADOW | GUI_FLAG_WINDOW_TITLEBAR | GUI_FLAG_WINDOW_CLOSEBTN | GUI_FLAG_WINDOW_RESIZABLE );
		this.Close1.AddFlags( GUI_FLAG_MOUSECTRL );

		this.Closetext1 = GUILabel();
		this.Close1.AddChild( Closetext1 );
		this.Closetext1.TextColour = Colour( 255, 255, 255 );
		this.Closetext1.Pos =  VectorScreen( rel.X * 0.1976573938506589, rel.Y * 0.0065104166666667 );		
		this.Closetext1.TextAlignment = GUI_ALIGN_CENTER;
		this.Closetext1.FontFlags = GUI_FFLAG_BOLD;		
		this.Closetext1.Text = "<";
		this.Closetext1.FontSize = ( rel.Y * 0.0148148148148148 );
		this.Closetext1.AddFlags( GUI_FLAG_MOUSECTRL | GUI_FLAG_KBCTRL );
		this.centerinchild( this.Close1, this.Closetext1 );

		this.Titlebar.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Titletext.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Body.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Membox.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_BORDER | GUI_FLAG_KBCTRL );
		this.Close.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Closetext.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.ErrorText.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Close1.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
		this.Closetext1.RemoveFlags( GUI_FLAG_VISIBLE | GUI_FLAG_KBCTRL );
	}


	function Show()
	{
		this.Membox.Clean();

		this.Titlebar.AddFlags( GUI_FLAG_VISIBLE );
		this.Titletext.AddFlags( GUI_FLAG_VISIBLE );
		this.Body.AddFlags( GUI_FLAG_VISIBLE );
		this.Membox.AddFlags( GUI_FLAG_VISIBLE );
		this.Close.AddFlags( GUI_FLAG_VISIBLE );
		this.Closetext.AddFlags( GUI_FLAG_VISIBLE );
		this.ErrorText.AddFlags( GUI_FLAG_VISIBLE );

		this.ErrorText.Text = "";

		this.Titletext.SendToTop();

		this.Membox.AddItem( "Main world/spawnloc" );
		this.Membox.AddItem( "Your private world" );

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
		this.Close1.RemoveFlags( GUI_FLAG_VISIBLE );
		this.Closetext1.RemoveFlags( GUI_FLAG_VISIBLE );

		GUI.SetMouseEnabled( false );
	}
	
	function onListboxSelect( element, listbox )
	{
		if( element == this.Membox )
		{
			switch( listbox )
			{
				case "Main world/spawnloc":
				this.Hide();

				local data = Stream();
				data.WriteInt( 600 );
				data.WriteString( "" );
				Server.SendData( data );
				break;

				case "Grinding world (money making world)":
				this.Hide();

				local data = Stream();
				data.WriteInt( 603 );
				data.WriteString( "" );
				Server.SendData( data );
				break;

				case "Your private world":
				local data = Stream();

				data.WriteInt( 601 );
				data.WriteString( "" );
				Server.SendData( data );
				break;

				default:
				try 
				{
					local getWorld = split( listbox, "-" ), getWorld2 = getWorld[0].tointeger(), data = Stream();
					this.Hide();

					data.WriteInt( 602 );
					data.WriteString( getWorld2.tostring() );
					Server.SendData( data );
				}
				catch( _ ) _;
				break;
			}
		}
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

			case this.Close1:
			case this.Closetext1:

			this.Close1.Colour = Colour( 255, 255, 255, 150 );
			this.Closetext1.TextColour = Colour( 66, 70, 71, 255 );
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

			case this.Close1:
			case this.Closetext1:

			this.Close1.Colour = Colour( 66, 70, 71, 150 );
			this.Closetext1.TextColour = Colour( 255, 255, 255, 255 );
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

			case this.Close1:
			case this.Closetext1:
			this.State = 0;
			this.Membox.Clean();

			this.Membox.AddItem( "Main world/spawnloc" );
			this.Membox.AddItem( "Your private world" );

			this.Close1.RemoveFlags( GUI_FLAG_VISIBLE );
			this.Closetext1.RemoveFlags( GUI_FLAG_VISIBLE );
			break;
		}
	}
	
	function onServerData( type, str )
	{
		switch( type )
		{
			case 600: 
			this.Show();
			break;
			
			case 601:
			this.setErrorText( str );
			this.ErrorText.TextColour = Colour( 255,0,0 );
			break;
						
			case 602:
			this.Hide();
			break;

			case 603:
			this.Membox.AddItem( str );
			break;

			case 604:
			this.State = 1;
			this.Membox.Clean();

			this.Close1.AddFlags( GUI_FLAG_VISIBLE );
			this.Closetext1.AddFlags( GUI_FLAG_VISIBLE );
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