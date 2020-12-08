class CPlayerHud extends CContext
{
	Background	= null;

	HealthBar	= null;
	ArmourBar	= null;

	Countdown	= null;
	CountdownText = null;

	WeaponName	= null;
	WeaponLogo  = null;

	LobbyLogo	= null;
	DonatorT	= null;
	Donor 		= null;

	LobbyText   = null;

	F3Key 		= null;
	IsHidden 	= false;

	HudType 	= 1;

	Background2 = null;
	Textline = null;
	
	function constructor( Key )
	{
		base.constructor();

		this.LobbyText =
		{
			"World selector":
			{
				"Element": "xxx",
				"Pos": Vector( -1457.259888,550.200256,2007.010132 ),
			},
		
			"Hall of fame":
			{
				"Element": "xxx",
				"Pos": Vector( -1457.930542,543.614014,2007.431885 ),				
			},

			"Type /buycoin to buy Vice Coin":
			{
				"Element": "xxx",
				"Pos": Vector( 1378.208618,377.816864,27.975609 ),				
			},

			"Type /spec to spectate player":
			{
				"Element": "xxx",
				"Pos": Vector( -1478.029663,550.128235,2008.975220 ),				
			},

			"Shop":
			{
				"Element": "xxx",
				"Pos": Vector( -1466.574341,551.024231,2008.975220 ),				
			},
		}

		this.LoadLobbyText();
	}

	function Load()
	{
		local rel = GUI.GetScreenSize();

		this.F3Key = KeyBind( 0x72 );

		this.HealthBar = GUIProgressBar();
		this.HealthBar.Pos = VectorScreen( 80, rel.Y * 0.91796875 );
		this.HealthBar.Size = VectorScreen( rel.X * 0.3587115666178624, rel.Y * 0.0390625 ); 
	//	this.HealthBar.Colour = Colour( 169, 170, 172, 255 );
		this.HealthBar.Colour = Colour( 0, 0, 0, 150 );
		this.HealthBar.EndColour = Colour( 255, 255, 255, 150 );
		this.HealthBar.StartColour = Colour( 255, 255, 255, 150 );
		this.HealthBar.MaxValue = 100;
		this.HealthBar.Thickness = 1;
		this.HealthBar.BackgroundShade = 0;
		this.centerX( this.HealthBar );

		this.ArmourBar = GUIProgressBar();
		this.ArmourBar.Pos = VectorScreen( 250, rel.Y * 0.9635416666666667 );
		this.ArmourBar.Size = VectorScreen( rel.X * 0.3587115666178624, rel.Y * 0.01953125 ); 
		this.ArmourBar.Colour = Colour( 169, 170, 172, 150 );
		this.ArmourBar.EndColour = Colour( 169, 170, 172, 150 );
		this.ArmourBar.StartColour = Colour( 169, 170, 172, 150 );
		this.ArmourBar.MaxValue = 100;
		this.ArmourBar.Thickness = 1;
		this.ArmourBar.BackgroundShade = 0;
		this.centerX( this.ArmourBar );

		this.WeaponName = GUILabel();
		this.WeaponName.Text = "";
		this.WeaponName.FontFlags = GUI_FFLAG_BOLD;		
		this.WeaponName.FontName = "Tahoma";
		this.WeaponName.TextAlignment = GUI_ALIGN_LEFT;
		this.WeaponName.FontSize = ( rel.Y * 0.0148148148148148 );
		this.WeaponName.TextColour = Colour( 255, 255, 255 );
		this.WeaponName.Pos = VectorScreen( 530, rel.Y * 0.87890625 );
		this.WeaponName.AddFlags( GUI_FLAG_TEXT_SHADOW );
		this.centerX( this.WeaponName );

		this.WeaponLogo = GUISprite();
		this.WeaponLogo.SetTexture( "0.png" );
		this.WeaponLogo.Pos = VectorScreen( rel.X * 0.8333333333333333, rel.Y * 0.9114583333333333 );
		this.WeaponLogo.Size = VectorScreen( rel.X * 0.1464128843338214, rel.Y * 0.1953125 );
		this.WeaponLogo.Colour = Colour( 255, 255, 255, 255 );
	//	this.right( this.WeaponLogo );

		this.LobbyLogo = GUISprite();
		this.LobbyLogo.SetTexture( "Lobby_s.png" );
		this.LobbyLogo.AddFlags( GUI_FLAG_3D_ENTITY );
		this.LobbyLogo.Size = VectorScreen( 500, 210 );
		this.LobbyLogo.Rotation3D = Vector( -1.558, 0.001, 9.53199 );
		this.LobbyLogo.Pos3D = Vector( -1467.44,540.151,2013.51 );	
		this.LobbyLogo.Size3D = Vector( 10, 4, 0 );

		Hud.RemoveFlags( HUD_FLAG_CASH | HUD_FLAG_CLOCK | HUD_FLAG_HEALTH | HUD_FLAG_WANTED | HUD_FLAG_WEAPON | HUD_FLAG_RADAR );

		this.Background2 = GUISprite();
		this.Background2.SetTexture( "alert-bg.png" );
		this.Background2.Pos = VectorScreen( rel.X * 0.3294289897510981, rel.Y * 0.70703125 );
		this.Background2.Size = VectorScreen( rel.X * 0.369692532942899, rel.Y * 0.1388888888888889 ); 
		this.Background2.Colour = Colour( 0, 0, 0, 255 );

		this.Background2.RemoveFlags( GUI_FLAG_VISIBLE );
	}

	function onScriptProcess() 
	{
		local player = World.FindLocalPlayer();

	    if( this.HealthBar && this.ArmourBar )
	    {
	    	this.HealthBar.Value = player.Health;
	    	if( player.Health < 15 )
	    	{
	    		this.HealthBar.Colour = Colour( 179, 0, 0, 150 );
				this.HealthBar.EndColour = Colour( 179, 0, 0, 150 );
				this.HealthBar.StartColour = Colour( 179, 0, 0, 150 );
	    	}

	    	else 
	    	{
	    		this.HealthBar.Colour = Colour( 169, 170, 172, 150 );
				this.HealthBar.EndColour = Colour( 255, 255, 255, 150 );
				this.HealthBar.StartColour = Colour( 255, 255, 25, 150 );
	    	}

	    	if( player.Armour > 0 ) 
	    	{
	    		if( !this.IsHidden ) this.ArmourBar.AddFlags( GUI_FLAG_VISIBLE );
	    		this.ArmourBar.Value = player.Armour;
	    	}
	    	else this.ArmourBar.RemoveFlags( GUI_FLAG_VISIBLE );
	    }

	   	if( this.LobbyText )
	    {
			foreach( index, value in this.LobbyText )
			{
	            local player = World.FindLocalPlayer(), ppos = player.Position, vehpos = value.Pos;
	            if( Distance( ppos.X, ppos.Y, ppos.Z, vehpos.X, vehpos.Y, vehpos.Z ) < 5 )
	            {
	                local screenpos = GUI.WorldPosToScreen( vehpos );
					local alpha = 255;
					
					if( screenpos.Z > 1 ) alpha = 0;

	                value.Element.Alpha = alpha;

	                value.Element.Position = VectorScreen( screenpos.X - 20, screenpos.Y ); 
	            }
	            else value.Element.Alpha = 0;
			}
		}
	}

	function LoadLobbyText()
	{
		foreach( index, value in this.LobbyText )
		{
			value.Element = GUILabel();
			value.Element.FontFlags = GUI_FFLAG_BOLD | GUI_FFLAG_OUTLINE;
			value.Element.AddFlags( GUI_FLAG_TEXT_TAGS );
			value.Element.TextColour = Colour( 255, 0, 255 );
			value.Element.Text = index;
			value.Element.TextAlignment = GUI_ALIGN_RIGHT;
			value.Element.FontSize = 12;
		}
	}

	function RemoveLobbyText()
	{
		foreach( index, value in this.LobbyText )
		{
			value.Element = null;
			value.Element = "xxx";
		}
	}

	function ShowTeamOnClass( text )
	{
		local rel = GUI.GetScreenSize();

		this.Textline = GUILabel();
		this.Textline.TextColour = Colour( 255, 255, 255 );
		this.Textline.Pos = VectorScreen( 0, rel.Y * 0.0494791666666667 );		
		this.Textline.AddFlags( GUI_FLAG_TEXT_TAGS );
		this.Textline.Text = text;
		this.Textline.FontFlags = GUI_FFLAG_BOLD;
		this.Textline.FontName = "Bahnschrift";
		this.Textline.FontSize = ( rel.Y * 0.0222222222222222 );
		this.Background2.AddChild( this.Textline );

		this.Background2.Size.X = this.getTextWidth( this.Textline ) * 2;
		this.centerX( this.Background2 );
		this.centerinchildX( this.Background2, this.Textline );

		this.Background2.AddFlags( GUI_FLAG_VISIBLE );
	}
	
	function onServerData( type, str )
	{
		switch( type )
		{
			case 300:
		//	this.LoadLobbyText( str );
			break;

			case 301:
		//	this.RemoveLobbyText();
			break;

			case 302:
			if( this.LobbyText[ "DMArena Entrance" ].Element != "xxx" ) this.LobbyText[ "DMArena Entrance" ].Element.Text = "DM Arena: " + str;
			break;
			
			case 303:
			this.Countdown.AddFlags( GUI_FLAG_VISIBLE );
			this.CountdownText.Value = ( str.tointeger() * 5 );
			
			if( this.CountdownText.Value > 100 ) 
			{
				this.CountdownText.Value = 0;
				this.Countdown.RemoveFlags( GUI_FLAG_VISIBLE );
			}
			break;
			
			case 304:
			try 
			{
				local sp = split( str, "/" ), weps = 0;

				if( sp[1] == "nullx" ) this.WeaponName.Text = "";
				else this.WeaponName.Text = sp[1];

				switch( sp[0] )
				{
					case "100":
					weps = 26;
					break;

					case "101":
					weps = 26;
					break;
					
					case "102":
					weps = 32;
					break;
					
					case "103":
					weps = 18;
					break;
					
					case "104":
					weps = 21;
					break;
					
					case "105":
					weps = 26;
					break;
					
					case "106":
					weps = 29;
					break;
					
					case "107":
					weps = 25;
					break;
					
					case "108":
					weps = 26;
					break;

					default:
					weps = sp[0];
					break;
				}

				this.WeaponLogo.SetTexture( weps + ".png" );
				this.centerX( this.WeaponName );
			}
			catch( _ ) _;
			break;

			case 305:
			if( ::IsNum( str ) ) this.HudType = str.tointeger();
			
			this.ShowHud();
			break;

			case 306:
			this.HideHud();
			break;

			case 6000:
			this.ShowTeamOnClass( str );
			break;

			case 6001:
			this.Background2.RemoveFlags( GUI_FLAG_VISIBLE );
			break;
		}
	}

	function onScriptLoad()
	{
		this.Load();
	
	   local data = Stream();

		data.WriteInt( 401 );
		data.WriteString( "" );
		Server.SendData( data );
	}

	function onKeyBindDown( key )
	{
		if( key == this.F3Key )
		{
			switch( this.IsHidden )
			{
				case true:
				this.ShowHud();
				
				this.IsHidden = false;
				break;

				case false:
				this.HideHud();
				
				this.IsHidden = true;
				Hud.RemoveFlags( HUD_FLAG_RADAR );
				break;
			}

		}
	}
	
	function ShowHud()
	{
		this.HealthBar.RemoveFlags( GUI_FLAG_VISIBLE );
		this.ArmourBar.RemoveFlags( GUI_FLAG_VISIBLE );
		this.WeaponName.RemoveFlags( GUI_FLAG_VISIBLE );
		this.WeaponLogo.RemoveFlags( GUI_FLAG_VISIBLE );

		Hud.RemoveFlags( HUD_FLAG_CASH | HUD_FLAG_CLOCK | HUD_FLAG_HEALTH | HUD_FLAG_WANTED | HUD_FLAG_WEAPON | HUD_FLAG_RADAR );

		this.IsHidden = false;

		switch( this.HudType )
		{
			case 1:
			this.HealthBar.AddFlags( GUI_FLAG_VISIBLE );
			this.WeaponName.AddFlags( GUI_FLAG_VISIBLE );
			this.WeaponLogo.AddFlags( GUI_FLAG_VISIBLE );
			
			if( this.ArmourBar.Value > 0 ) this.ArmourBar.AddFlags( GUI_FLAG_VISIBLE );
			
			Hud.AddFlags( HUD_FLAG_RADAR );
			break;
			
			case 0:
			Hud.AddFlags( HUD_FLAG_HEALTH | HUD_FLAG_WEAPON | HUD_FLAG_RADAR );
			break;
		}
	}
	
	function HideHud()
	{
		this.IsHidden = true;

		switch( this.HudType )
		{
			case 1:
			this.HealthBar.RemoveFlags( GUI_FLAG_VISIBLE );
			this.ArmourBar.RemoveFlags( GUI_FLAG_VISIBLE );
			this.WeaponName.RemoveFlags( GUI_FLAG_VISIBLE );
			this.WeaponLogo.RemoveFlags( GUI_FLAG_VISIBLE );
			break;
			
			case 0:
			Hud.RemoveFlags( HUD_FLAG_HEALTH | HUD_FLAG_WEAPON | HUD_FLAG_RADAR );
			break;
		}
	}

	function onPlayerShoot( player, weapon, hitEntity, hitPosition )
	{	
    	local p = World.FindLocalPlayer();
   		if ( p.ID == player.ID ) 
   		{
   			if( hitEntity && weapon == 109 && hitEntity.Type == OBJ_BUILDING ) Console.Print( format( "[#00BCD4]** Object model id[#ffffff] %d", hitEntity.ModelIndex ) );

   			if( hitEntity && hitEntity.Type == OBJ_PLAYER )
   			{
   				local data = Stream();

				data.WriteInt( 400 );
				data.WriteString( hitEntity.ID );
				Server.SendData( data );
			}
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

	function right( instance, instance2 = null ) 
	{
		if( !instance2 ) 
		{
			local size = instance.Size;
			local screen = ::GUI.GetScreenSize();
			local x = screen.X-220;
			
			instance.Position.X = x;

		}

		else 
		{
			local position = instance2.Position;

			instance.Position.X = position.X - 20 ;
		}
	}

	function getTextWidth( element ) 
	{
		local size = element.Size;
		return size.X;
	}

	function centerinchildX( parents, child )
	{
		local parentElement = parents.Size;
		local childElement = child.Size;
		local x = ( parentElement.X/2 )-( childElement.X/2 );

		child.Pos.X = x;
	}
}