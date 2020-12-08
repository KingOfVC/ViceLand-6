class CPlayer
{
	instance    	= null;
	
	AccID      		= 0;
	IsReg			= false;
	Logged     		= false;
	AutoLogin 		= false;
	Password    	= null;
	Level       	= 0;
	DateReg			= 0;
	LastLogin   	= 0;
	Joined      	= 0;
	Playtime		= 0;
	Cooldown		= 0;
	Skin 			= 0;
	OldName 		= null;

	Language    	= 0;
	Muted       	= false;
	
	IsEditing   	= "";
	EditSens    	= 0.1;
	EditingMode 	= "XYZ";
	
	Stats 			= null;
	Player			= null;
	CurrentStats	= null;
	Settings 		= null;

	InEvent			= null;
	
	Interior		= null;
	
	PFPSWarn		= 0;

	ActiveGang 		= "N/A";

	AdminDuty 		= false;

	Report 			= null;

	Afk 			= null;

	GangInvite 		= null;

	Chat 			= null;
	
	Job 			= null;

	TempAdmin 		= null;

	LastHit 		= null;

	Area 			= null;

	Event 			= null;

	Hidden 			= false;

	WorldInvite 	= null;
	
	TradeInvite 	= null;

	Title 			= "none";

	OldTitle 		= "none";

	ReadMsg 		= true;

	SpawnProtection = false;

	AutoSpawn 		= false;

	function constructor( player )
	{
		this.instance = player;
		this.OldName = player.Name;

		player.Name = "VL-" + player.ID;

		SqCast.MsgAdmin( TextColor.Staff, Lang.AdminJoinMsg, this.OldName, player.Name, TextColor.Staff );		
		
		this.Stats = 
		{
			Kills 		= 0,
			Deaths		= 0,
			TopSpree	= 0,
			Cash		= 0,
			Coin		= 0,
			XP 			= 0,
			WFWon 		= 0,
			ReactionWon  = 0,
			TotalEarn   = 0,
			TotalSpend  = 0,
		};
		
		this.CurrentStats =
		{
			Kills 			= 0,
			Deaths			= 0,
			Spree			= 0,
			CurrentSession	= 0,
		};
		
		this.Player =
		{
			Weapons			= {},
			Spawnloc 		= {},
			Inventory		= {},
			Achievement		= {},
			Permission		= {},
			TextColor 		= {},
			CustomiseMsg 	= {},
			TextStyle		= 0,
			ActiveGang		= "N/A",
		};

		this.Afk =
		{
			LastPos = Vector3.FromStr( "0,0,0" ),
			Count 	= 0,
		}

		this.Chat =
		{
			RepeatMessage = "",
			Time = time(),
		}

		this.Settings 		= {};

		this.InsertPermission();
		this.InsertAchievement();
		this.InsertTextColor();
		this.InsertInventory();
		this.InsertSpawnloc();
		this.InsertCustomiseMsg();
		this.InsertSettings();

		this.Report 		= [];

		this.GangInvite		= {};
		
		this.Job  			= {};

		this.LastHit 		= {};
	}
	
	function LoadAccount()
	{
		this.instance.Announce(" ", 1 );

		local q = SqDatabase.Query( format( "SELECT * FROM Accounts INNER JOIN PlayerData ON Accounts.ID = PlayerData.ID WHERE Lower(Name) = '%s'", this.OldName.tolower() ) );
		if( q.Step() )
		{
			this.instance.SetWeapon( 110, 1 );

			this.Password               	= q.GetString( "Password" ).tolower();
			this.AutoLogin					= SToB( q.GetString( "AutoLogin" ) );
			this.AccID               		= q.GetInteger( "ID" );
			this.IsReg                 		= true;
			 
			this.Joined                 = q.GetInteger( "Joined" );
			this.instance.Authority     = 1;
			this.Language               = q.GetInteger( "Language" );
			this.LastLogin				= q.GetInteger( "LastLogin" );
			this.Playtime				= q.GetInteger( "Playtime" );
			this.DateReg				= q.GetInteger( "DateReg" );
			this.Skin					= q.GetInteger( "Skin" );
			this.Title 					= q.GetString( "Title" );

			this.Joined++;
			
			this.Stats.Kills			= q.GetInteger( "Kills" );
			this.Stats.Deaths			= q.GetInteger( "Deaths" );
			this.Stats.TopSpree			= q.GetInteger( "HighestSpree" );
			this.Stats.Cash				= q.GetInteger( "Cash" );
			this.Stats.Coin				= q.GetInteger( "Coin" );
			this.Stats.XP 				= q.GetInteger( "XP" );
			this.Stats.WFWon 			= q.GetInteger( "WFWon" );
			this.Stats.ReactionWon 		= q.GetInteger( "ReactionWon" );

			this.Event					= ::json_decode( q.GetString( "Event" ) );

			try
			{
				this.Player.Weapons			= ::json_decode( q.GetString( "Weapons" ) );
				this.Player.Inventory		= ( ::json_decode( q.GetString( "Inventory" ) ) == null ) ? {} : ::json_decode( q.GetString( "Inventory" ) );
				this.Player.Achievement		= ::json_decode( q.GetString( "Achievement" ) );
				this.Player.TextColor		= ::json_decode( q.GetString( "TextColor" ) );
				this.Player.Spawnloc		= ::json_decode( q.GetString( "Spawnloc" ) );
				this.Player.Permission		= ::json_decode( q.GetString( "Permission" ) );
				this.Settings				= ::json_decode( q.GetString( "Settings" ) );
			}

			catch( _ ) 
			{
				this.InsertPermission();
				this.InsertAchievement();
				this.InsertTextColor();
				this.InsertInventory();
				this.InsertSpawnloc();
				this.InsertCustomiseMsg();
				this.InsertSettings();
			}

			this.Player.TextStyle		= q.GetInteger( "TextStyle" );
			this.Player.ActiveGang		= q.GetString( "ActiveGang" );

			this.ReadMsg				= SToB( q.GetString( "ReadNews" ) );

			if( this.instance.UID == q.GetString( "UID1" ) && this.instance.UID2 == q.GetString( "UID2" ) )
			{
				if( this.AutoLogin )
				{
					this.instance.Name = this.OldName;

					if( this.Player.Permission.Staff.Position.tointeger() > 0 ) this.instance.Msg( HexColour.Purple, Lang.JoinMsg2[ this.Language ], this.Player.Permission.Staff.Name, this.instance.Name );
					else this.instance.Msg( HexColour.Purple, Lang.JoinMsg2[ this.Language ], "", this.instance.Name );

					this.CurrentStats.CurrentSession	= time();
					this.Logged				 			= true;
					
					if( this.Settings.JoinPart == "true" )
					{
						switch( this.Settings.FakeCountry.tolower() )
						{
							case "default":
							SqCast.MsgAllExp( this.instance, TextColor.Info, Lang.PlayerJoin, this.instance.Name, TextColor.Info, SqGeo.GetDIsplayInfo( this.instance.IP ) );
							
							SqCast.EchoMessage( format( "**%s** has joined the server from **%s**.", this.instance.Name, SqGeo.GetDIsplayInfo( this.instance.IP ) ) );
							break;

							case "hidden":
							SqCast.MsgAllExp( this.instance, TextColor.Info, Lang.PlayerJoin1, this.instance.Name, TextColor.Info );
							
							SqCast.EchoMessage( format( "**%s** has joined the server.", this.instance.Name ) );
							break;

							default:
							SqCast.MsgAllExp( this.instance, TextColor.Info, Lang.PlayerJoin, this.instance.Name, TextColor.Info, this.Settings.FakeCountry );
							
							SqCast.EchoMessage( format( "**%s** has joined the server from **%s**.", this.instance.Name, this.Settings.FakeCountry ) );
							break;
						}
					}
					else SqCast.MsgAdmin( TextColor.Staff, Lang.ASilentJoin, this.instance.Name, TextColor.Staff, SqGeo.GetIPInfo( this.instance.IP ) );

					if( this.Player.Permission.VIP.Position == "1" && SqMath.IsGreaterEqual( ( time() - this.Player.Permission.VIP.Time.tointeger() ), this.Player.Permission.VIP.Duration.tointeger() ) )
					{
						this.instance.Msg( TextColor.Error, Lang.VIPExpired[ this.Language ] );

						this.Player.Permission.VIP.Position = "0";
						this.Player.Permission.VIP.Time 	= "0";
						this.Player.Permission.VIP.Duration	= "0";
					}

					if( this.Player.Permission.Staff.Time != "0" && SqMath.IsGreaterEqual( ( time() - this.Player.Permission.Staff.Time.tointeger() ), this.Player.Permission.Staff.Duration.tointeger() ) )
					{
						this.instance.Msg( TextColor.Error, Lang.ModExpired[ this.Language ] );

						this.Player.Permission.Staff.Position 		= "0";
						this.Player.Permission.Staff.Time 			= "0";
						this.Player.Permission.Staff.Duration		= "0";

					}

					this.Interior = "Lobby";
					
					SqAdmin.AddAlias( this.instance );

					if( this.Event == null ) this.InsertEvent();

					if( this.Event.FreeCrate.tointeger() == 6435435342 ) this.Event.FreeCrate = 1552031221;

					if( this.Settings.rawin( "Editsens" ) ) this.EditSens = this.Settings.Editsens.tofloat();
					else this.Settings.rawset( "Editsens", "0.1" ); 

					if( this.Settings.rawin( "LobbySpawn" ) == false ) this.Settings.rawset( "LobbySpawn", "Normal" ); 
					if( this.Settings.rawin( "Hitsound" ) == false ) this.Settings.rawset( "Hitsound", "off" );
					if( this.Settings.rawin( "Hud" ) == false ) this.Settings.rawset( "Hud", "1" ); 

					if( this.Player.CustomiseMsg.Type.HelpMsg == "true" ) this.instance.Msg( TextColor.InfoS, Lang.HelpMsgJoin[ this.Language ], TextColor.InfoS, TextColor.InfoS );
					
					if( ( time() - this.Event.FreeCrate.tointeger() ) > 86400 ) 
					{
						this.instance.Msg( TextColor.Ann, Lang.RecCrate[ this.Language ] );
						
						this.addInventQuatity( "crate", 2 );

						this.Event.FreeCrate = time().tostring();				
					}
				
					this.RewardPerHour();
					this.GiveVIP();

					SqGang.playerJoin( this.instance );

					if( this.Title != "none" ) SqCast.setTitle( this.instance, this.Title );

					this.instance.StreamInt( 305 );
					this.instance.StreamString( this.Settings.Hud );
					this.instance.FlushStream( true );

				//	if( this.Settings.LobbySpawn != "DM" ) this.instance.Spawn();

					if( !this.ReadMsg ) SqCast.SendNewsToPlayer( this.instance );
				}
				else 
				{
					this.instance.CameraPosition( Vector3( 998.525940,146.518936,90.116692 ), Vector3( 536.416382,-616.541626,169.366913 ) );
					
					this.instance.StreamInt( 1010 );
					this.instance.StreamStrings( "" );
					this.instance.FlushStream( true );
				}

			}
			else 
			{
				if( this.Player.Permission.Staff.Position.tointeger() > 0 )
				{
					if( SToB( q.GetString( "AllowRemoteLogin" ) ) == true )
					{
						this.instance.Msg( HexColour.Purple, Lang.JoinMsg[ this.Language ], this.instance.Name );

						this.instance.CameraPosition( Vector3( 998.525940,146.518936,90.116692 ), Vector3( 536.416382,-616.541626,169.366913 ) );

						this.instance.StreamInt( 1010 );
						this.instance.StreamString( "" );
						this.instance.FlushStream( true );					
					}
					else 
					{
						this.instance.Msg( TextColor.Error, Lang.NeedAllowLogin[ this.Language ] );
						
				/*		local header = SqDiscord.EmbedAuthor();
                        header.SetName( "An admin login from another pc but need authorize" );

                        local embed = SqDiscord.Embed();
                        embed.SetTitle( this.instance.Name );
                        embed.SetColor( 6959775 );
						
						local embedField1 = SqDiscord.EmbedField();
                        embedField1.SetName( "Last IP" );
                        embedField1.SetValue( SqGeo.GetIPInfo( q.GetString( "IP" ) ) );
                        embedField1.SetInline( true );

						local embedField2 = SqDiscord.EmbedField();
                        embedField2.SetName( "Current IP" );
                        embedField2.SetValue( SqGeo.GetIPInfo( this.instance.IP ) );
                        embedField2.SetInline( true );

						local embedField3 = SqDiscord.EmbedField();
                        embedField3.SetName( "---------------------------" );
                        embedField3.SetValue( "Type **!allowaccess " + this.instance.Name + "** to allow this admin account login from different PC." );
                        embedField3.SetInline( true );


                        embed.SetAuthor( header );

                        embed.AddField( embedField1 );
                        embed.AddField( embedField2 );
                        embed.AddField( embedField3 );
                     
                        StaffBot.MessageEmbed( Server.DiscordBot.StaffBot.Channel, embed );      */

				    	this.instance.Kick();						
					}
				}

				else 
				{
					this.instance.Msg( HexColour.Purple, Lang.JoinMsg[ this.Language ], this.instance.Name );

					this.instance.CameraPosition( Vector3( 998.525940,146.518936,90.116692 ), Vector3( 536.416382,-616.541626,169.366913 ) );

					this.instance.StreamInt( 1010 );
					this.instance.StreamString( "" );
					this.instance.FlushStream( true );
				}
			}
		}
		
		else 
		{			
			this.instance.Authority = 0;

			this.instance.CameraPosition( Vector3( 998.525940,146.518936,90.116692 ), Vector3( 536.416382,-616.541626,169.366913 ) );

			this.instance.StreamInt( 1000 );
			this.instance.StreamString( "" );
			this.instance.FlushStream( true );
		}
	}
	
	function Register( password )
	{
		this.instance.Name = this.OldName;

		SqDatabase.Exec( format( "INSERT INTO Accounts ( 'Name', 'Password', 'UID1', 'UID2', 'UID3', 'IP', 'LastLogin', 'DateReg' ) VALUES ( '%s', '%s', '%s', '%s', '%s', '%s', '%d', '%d' )", this.instance.Name, SqHash.GetSHA256( password ), this.instance.UID, this.instance.UID2, "none", this.instance.IP, 0, time(), time() ) );
		SqDatabase.Exec( format( "INSERT INTO PlayerData ( 'ID' ) VALUES ( '%d' )", this.GetID() ) );

		this.instance.Authority 	= 1;
		this.Logged				 	= true;
		this.AccID 					= this.GetID();
		this.IsReg                 	= true;
		this.DateReg				= time();
		this.Stats.Cash 			= 150000;
		this.Stats.Coin 			= 25;
		
		this.CurrentStats.CurrentSession	= time();
		
		this.InsertWeapon( 21, "true" );
		
		SqCast.MsgAllExp( this.instance, TextColor.Info, Lang.PlayerJoin3, this.instance.Name, TextColor.Info, SqGeo.GetDIsplayInfo( this.instance.IP ) );
		
		SqCast.EchoMessage( format( "**%s** has joined the server for the first time from **%s**.", this.instance.Name, SqGeo.GetDIsplayInfo( this.instance.IP ) ) );
		
		this.instance.Msg( TextColor.Sucess, Lang.Register[ this.Language ] );
		this.instance.Msg( TextColor.Ann, Lang.Register2[ this.Language ], TextColor.Ann );

		this.Interior = "Lobby";

		SqAdmin.AddAlias( this.instance );

		this.instance.Msg( TextColor.InfoS, Lang.HelpMsgJoin[ this.Language ], TextColor.InfoS, TextColor.InfoS );

		this.RewardPerHour();

		this.InsertEvent();

		this.InsertPermission();
		this.InsertAchievement();
		this.InsertTextColor();
		this.InsertInventory();
		this.InsertSpawnloc();
		this.InsertCustomiseMsg();
		this.InsertSettings();

		this.addInventQuatity( "vippass", 1 );
		this.addInventQuatity( "NameTag", 5 );
		this.addInventQuatity( "worldpass", 1 );

		this.Save();
	}
	
	function GetID()
	{
		local q = SqDatabase.Query( format( "SELECT * FROM Accounts WHERE Lower(Name) = '%s'", this.instance.Name.tolower() ) );
		if( q.Step() ) return q.GetInteger( "ID" );
	}
	
	function InsertWeapon( weapon, spawnwep = "false" )
	{
		weapon = weapon.tostring();
		
		this.Player.Weapons.rawset( weapon, 
		{
			Spawnwep	= spawnwep.tostring(),
			Kill		= "0",
			Name		= GetWeaponName( weapon.tointeger() ),
			Mode		= "none",
		});
	}
	
	function InsertPermission()
	{
		this.Player.Permission.rawset( "Staff",
		{
			Time 		= "0",
			Duration	= "0",
			Position	= "0",
			Name		= "Player",
		});
		
		this.Player.Permission.rawset( "Mapper",
		{
			Time 		= "0",
			Duration	= "0",
			Position	= "0",
			Name		= "Player",
		});

		this.Player.Permission.rawset( "VIP",
		{
			Time 		= "0",
			Duration	= "0",
			Position	= "0",
			Name		= "Player",
		});
	}
	
	function InsertSpawnloc()
	{
		this.Player.Spawnloc.rawset( "SpawnData",
		{
			Enabled 		= "0",
			Pos				= "0",
			World			= "0",
		});
	}

	function InsertAchievement()
	{
		this.Player.Achievement.rawset( "Loggedv5",
		{
			Time 		= "0",
			Progress	= "0",
		});
	}
	
	function InsertInventory()
	{
		this.Player.Inventory.rawset( "NameTag",
		{
			Quatity 		= "0",
		});
	}

	function InsertTextColor()
	{
		this.Player.TextColor.rawset( "Color",
		{
			Error	= "[#F44336]",
			World	= "[#FF80AB]",
			Sucess	= "[#4CAF50]",
			Info	= "[#FFD600]",
			Event	= "[#F57C00]",
			Admin	= "[#CDDC39]",
			Ann		= "[#00E5FF]",
			Staff	= "[#FFD180]",
		});
	}
	
	function InsertCustomiseMsg()
	{
		this.Player.CustomiseMsg.rawset( "Type",
		{
			Event		= "true",
			Kill		= "true",
			PrivMsg		= "true",
			HelpMsg		= "true",
		});
	}
	
	function InsertSettings()
	{
		this.Settings.rawset( "Teleport", "true" );
		this.Settings.rawset( "Team", "Free" );
		this.Settings.rawset( "FakeCountry", "default" );
		this.Settings.rawset( "JoinPart", "true" );
		this.Settings.rawset( "AllowSpectate", "true" );
		this.Settings.rawset( "Editsens", "0.1" ); 
		this.Settings.rawset( "LobbySpawn", "Normal" ); 
		this.Settings.rawset( "Hitsound", "off" ); 
		this.Settings.rawset( "Hud", "1" );
	}

	function InsertEvent()
	{
		this.Event = {};

		this.Event.rawset( "FreeWorld", "0" );

		this.Event.rawset( "FreeCrate", "1552031221" );
	}

	function Login()
	{
		this.instance.Name = this.OldName;
		this.CurrentStats.CurrentSession	= time();
		this.Logged           			    = true;
		
		if( this.Player.Permission.Staff.Position.tointeger() > 0 ) this.instance.Msg( HexColour.Purple, Lang.JoinMsg2[ this.Language ], this.Player.Permission.Staff.Name, this.instance.Name );
		else this.instance.Msg( HexColour.Purple, Lang.JoinMsg2[ this.Language ], "", this.instance.Name );
		
		if( this.Settings.JoinPart == "true" )
		{
			switch( this.Settings.FakeCountry.tolower() )
			{
				case "default":
				SqCast.MsgAllExp( this.instance, TextColor.Info, Lang.PlayerJoin, this.instance.Name, TextColor.Info, SqGeo.GetDIsplayInfo( this.instance.IP ) );
							
				SqCast.EchoMessage( format( "**%s** has joined the server from **%s**.", this.instance.Name, SqGeo.GetDIsplayInfo( this.instance.IP ) ) );
				break;

				case "hidden":
				SqCast.MsgAllExp( this.instance, TextColor.Info, Lang.PlayerJoin1, this.instance.Name, TextColor.Info );
						
				SqCast.EchoMessage( format( "**%s** has joined the server.", this.instance.Name ) );
				break;

				default:
				SqCast.MsgAllExp( this.instance, TextColor.Info, Lang.PlayerJoin, this.instance.Name, TextColor.Info, this.Settings.FakeCountry );
							
				SqCast.EchoMessage( format( "**%s** has joined the server from **%s**.", this.instance.Name, this.Settings.FakeCountry ) );
				break;
			}
		}
		else SqCast.MsgAdmin( TextColor.Staff, Lang.ASilentJoin, this.instance.Name, TextColor.Staff, SqGeo.GetIPInfo( this.instance.IP ) );

		if( this.Player.Permission.VIP.Position == "1" && SqMath.IsGreaterEqual( ( time() - this.Player.Permission.VIP.Time.tointeger() ), this.Player.Permission.VIP.Duration.tointeger() ) )
		{
			this.instance.Msg( TextColor.Error, Lang.VIPExpired[ this.Language ] );

			this.Player.Permission.VIP.Position = "0";
			this.Player.Permission.VIP.Time 	= "0";
			this.Player.Permission.VIP.Duration	= "0";
		}

		if( this.Player.Permission.Staff.Time != "0" && SqMath.IsGreaterEqual( ( time() - this.Player.Permission.Staff.Time.tointeger() ), this.Player.Permission.Staff.Duration.tointeger() ) )
		{
			this.instance.Msg( TextColor.Error, Lang.ModExpired[ this.Language ] );

			this.Player.Permission.Staff.Position 		= "0";
			this.Player.Permission.Staff.Time 			= "0";
			this.Player.Permission.Staff.Duration		= "0";
		}

		this.Interior = "Lobby";

		SqAdmin.AddAlias( this.instance );

		if( this.Event == null ) this.InsertEvent();

		if( this.Event.FreeCrate.tointeger() == 6435435342 ) this.Event.FreeCrate = 1552031221;

		if( this.Title != "none" ) SqCast.setTitle( this.instance, this.Title );

		if( this.Settings.rawin( "Editsens" ) ) this.EditSens = this.Settings.Editsens.tofloat();
		else this.Settings.rawset( "Editsens", "0.1" ); 

		if( this.Settings.rawin( "LobbySpawn" ) == false ) this.Settings.rawset( "LobbySpawn", "Normal" ); 
		if( this.Settings.rawin( "Hitsound" ) == false ) this.Settings.rawset( "Hitsound", "off" ); 
		if( this.Settings.rawin( "Hud" ) == false ) this.Settings.rawset( "Hud", "1" ); 
		
		if( this.Player.CustomiseMsg.Type.HelpMsg == "true" ) this.instance.Msg( TextColor.InfoS, Lang.HelpMsgJoin[ this.Language ], TextColor.InfoS, TextColor.InfoS );

		if( ( time() - this.Event.FreeCrate.tointeger() ) > 86400 ) 
		{
			this.instance.Msg( TextColor.Ann, Lang.RecCrate[ this.Language ] );
						
			this.addInventQuatity( "crate", 1 );

			this.Event.FreeCrate = time().tostring();
		}

		this.GiveVIP();
	
		this.RewardPerHour();

		SqGang.playerJoin( this.instance );

		this.instance.StreamInt( 305 );
		this.instance.StreamString( this.Settings.Hud );
		this.instance.FlushStream( true );

	//	if( this.Settings.LobbySpawn != "DM" ) this.instance.Spawn();

		if( !this.ReadMsg ) SqCast.SendNewsToPlayer( this.instance );
	}
	
	function GetAchievementComplete()
	{
		local getCount = 0;
		
		foreach( value in this.Player.Achievement )
		{
			if( value.Progress == "1" ) getCount ++;
		}
		
		return getCount + "/" + this.Player.Achievement.len();
	}
	
	function Save()
	{
		if( this.Logged )
		{
			local countTime = time() - this.CurrentStats.CurrentSession, countTotalTime = ( countTime + this.Playtime ), saveTemp = ( this.TempAdmin == null ) ? this.Player.Permission : this.TempAdmin;
			local title = ( this.AdminDuty == true ) ? ::EscapeString( this.OldTitle ) : ::EscapeString( this.Title );
			local saveskin = ( SqDM.isTeam( this.instance.Team ) ) ? this.Skin : this.instance.Skin;

			SqDatabase.Exec( format( "UPDATE Accounts SET IP = '%s', UID1 = '%s', UID2 = '%s', Joined = '%d', Language = '%d', LastLogin = '%d', Playtime = '%d', Name = '%s', AllowRemoteLogin = '%s' WHERE ID = '%d' ", this.instance.IP, this.instance.UID, this.instance.UID2, this.Joined, this.Language, this.LastLogin, countTotalTime, this.instance.Name, "false", this.AccID ) );
			SqDatabase.Exec( format( "UPDATE PlayerData SET Kills = '%d', Deaths = '%d', HighestSpree = '%d', Cash = '%d', Coin = '%d', Weapons = '%s', Inventory = '%s', Achievement = '%s', TextColor = '%s', TextStyle = '%d', Spawnloc = '%s', Permission = '%s', CustomiseMsg = '%s', Skin = '%d', Settings = '%s', Event = '%s', Title = '%s', ReadNews = '%s', XP = '%d', WFWon = '%d', ReactionWon = '%d', TotalSpend = '%d', TotalEarn = '%d' WHERE ID = '%d' ", this.Stats.Kills, this.Stats.Deaths, this.Stats.TopSpree, this.Stats.Cash, this.Stats.Coin, ::json_encode( this.Player.Weapons ), ::json_encode( this.Player.Inventory ), ::json_encode( this.Player.Achievement ), ::json_encode( this.Player.TextColor ), this.Player.TextStyle, ::json_encode( this.Player.Spawnloc ), ::json_encode( saveTemp ), ::json_encode( this.Player.CustomiseMsg ), saveskin, ::json_encode( this.Settings ), ::json_encode( this.Event ), title, this.ReadMsg.tostring(), this.Stats.XP, this.Stats.WFWon, this.Stats.ReactionWon, this.Stats.TotalSpend, this.Stats.TotalEarn, this.AccID ) );
		}
	}

	function VerifyEvent()
	{
		if( this.InEvent.rawin( "Vehicle" ) ) return false;
	}

	function GetEventType( type = "None" )
	{
		switch( this.InEvent )
		{
			case "DM": return false;

			case "Cash": return false;

		//	default:
		//	if( this.InEvent )
			//if( this.InEvent.rawin( "TDM" ) ) return true;
		}
	}

	function GetInventoryItem( item )
	{
		if( !this.Player.Inventory.rawin( item ) )
		{
			this.Player.Inventory.rawset( item,
			{
				Quatity 		= "0",
			});

			return false;
		}

		else 
		{
			if( this.Player.Inventory[ item ].Quatity.tointeger() > 0 ) return true;
		}
	}

	function GetInventoryItem2( item )
	{
		if( !this.Player.Inventory.rawin( item ) )
		{
			this.Player.Inventory.rawset( item,
			{
				Quatity 		= "0",
			});

			return 0;
		}

		else 
		{
			if( this.Player.Inventory[ item ].Quatity.tointeger() > 0 ) return this.Player.Inventory[ item ].Quatity.tointeger();
		}
	}

	function RewardPerHour()
	{
		this.instance.MakeTask( function( player )
		{
			local getReward = 15000;

			getReward = ( 10000 * ::getLevelAtExperience( player.Data.Stats.XP ) );
			local XPReward = 2;
			if( getReward == 0 ) getReward = 10000;
			if( player.Data.Player.Permission.VIP.Position.tointeger() > 0 ) getReward = ( getReward * 1.5 );

			player.Data.Stats.Cash += getReward;
			player.Data.Stats.TotalEarn += getReward;

			player.Data.AddXP( player, XPReward );

			player.Msg( TextColor.InfoS, Lang.RewardPerHour[ player.Data.Language ], SqInteger.ToThousands( getReward ), TextColor.InfoS, SqInteger.ToThousands( XPReward ), TextColor.InfoS );
		}, 600000, 0, this.instance );
	}
	
	function canTrade()
	{
		if( this.TradeInvite != true )
		{
			if( typeof( this.TradeInvite ) == "table" )
			{
				if( this.TradeInvite.rawin( "Invite" ) )
				{
					return true;
				}
			}
			return false;
		}
		return false;
	}

	function addInventQuatity( item, count )
	{
		this.GetInventoryItem( item );
				
		local deduQuatity = this.Player.Inventory[ item ].Quatity.tointeger();

		this.Player.Inventory[ item ].Quatity = ( deduQuatity + count );
	}

	function remInventQuatity( item, count )
	{
		this.GetInventoryItem( item );
				
		local deduQuatity = this.Player.Inventory[ item ].Quatity.tointeger();

		this.Player.Inventory[ item ].Quatity = ( deduQuatity - count );
	}

	function AddXP( player, xp )
	{
		local add_xp = ( this.Stats.XP + xp );

		if( ::getLevelAtExperience( add_xp ) > ::getLevelAtExperience( this.Stats.XP ) ) 
		{
			for( local i = ::getLevelAtExperience( this.Stats.XP ); i <= ::getLevelAtExperience( add_xp ); ++i )
			{
                SqCast.MsgAll( TextColor.Info, Lang.LevelUp, player.Name, TextColor.Info, i );
            }
        }
        
        this.Stats.XP += xp;
    }

	function GiveVIP()
	{
		if( !this.Settings.rawin( "FreeVIP" ) )
		{
			this.Settings.rawset( "FreeVIP", "1" ); 

			if( this.Player.Permission.VIP.Position.tointeger() != 2 )
			{
				this.Player.Permission.VIP.Position 		= "1";
				this.Player.Permission.VIP.Duration 		= SqAdmin.GetDuration( "30d" ).tostring();
				this.Player.Permission.VIP.Time  			= time().tostring()
				this.Player.Permission.VIP.Name 			= "Temporary";
			}
			
			this.addInventQuatity( "santahat", 1 );

			this.instance.Msg( TextColor.Event, Lang.NewyarReward[ this.Language ] );
		}
	}
}

function getExperienceAtLevel( level )
{
    local total = 0;
    for( local i = 1; i < level; i++ )
    {
        total += floor( ( i + 500 ) * pow(2, i / 7.0));
    }

    return floor(total / 4);
}

function getLevelAtExperience( experience ) 
{
    local index;

    for( index = 0; index < 120; index++ ) 
    {
        if ( getExperienceAtLevel(index + 1) > experience )
        break;
    }

    return index;
}
