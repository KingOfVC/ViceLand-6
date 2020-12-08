class CWorld
{	
	World = {};

	function constructor()
	{
		local result = SqDatabase.Query( format( "SELECT * FROM Worlds" ) ), count = 0;

		while( result.Step() )
		{
			this.World.rawset( result.GetInteger( "World" ),
			{
				Owner			= result.GetInteger( "Owner" ),
				NameList		= this.ConvertToJSON( result.GetString( "NameList" ) ),
				Permissions		= this.ConvertToJSON( result.GetString( "Permissions" ) ),
				Permissions2	= this.ConvertToJSON( result.GetString( "Permissions2" ) ),
				Settings		= this.ConvertToJSON( result.GetString( "Settings" ) ),
				AddOn			= this.ConvertToJSON( result.GetString( "AddOn" ) ),
				Price			= result.GetInteger( "Price" ),
			});

			count ++;
		}

		SqLog.Scs( "Total worlds loaded in table: %s", SqInteger.ToThousands( count ) );
	}

	function Register( id )
	{
		this.World.rawset( id,
		{
			Owner 			= 100000,
			NameList 		= {},
			Permissions		= {},
			Permissions2	= {},
			Settings		= {},
			AddOn			= {},
			Price 			= 2000,
		});

		local worlds = this.World[ id ];

		this.SetUpPermission( id );
		this.SetUpPermission2( id );
		this.SetUpSettings( id );
		this.SetUpAddOn( id );
			
		SqDatabase.Exec( format( "INSERT INTO Worlds ( 'World', 'Owner', 'NameList', 'Permissions', 'Permissions2', 'Settings', 'AddOn' ) VALUES ( '%d', '%d', '%s', '%s', '%s', '%s', '%s' )", id, 100000, "N/A", this.ConvertFromJson( worlds.Permissions ), this.ConvertFromJson( worlds.Permissions2 ), this.ConvertFromJson( worlds.Settings ), this.ConvertFromJson( worlds.AddOn ) ) );
	}

	function AddPlayerToWorld( player, level, world, ban = "false" )
	{
		local worlds = this.World[ world ];

		if( this.FindWorldPlayer( player, world ) != null ) 
		{
			if( level.tointeger() > 0 ) worlds.NameList[ player.tostring() ].Level = level;
			if( ban == "true" ) worlds.NameList[ player.tostring() ].Ban = "true";
		}
		
		else
		{
			if( worlds.NameList == null ) worlds.NameList = {};
			
			worlds.NameList.rawset( player.tostring(), 
			{
				Level	= level.tostring(),
				Ban		= ban.tostring(),
			});
		}
		
		this.Save( world );
	}
	
	function FindWorldPlayer( player, world )
	{	
		local worlds = this.World[ world ];

		if( worlds.NameList == null ) worlds.NameList = {};
		if( worlds.NameList.rawin( player.tostring() ) ) return true; 	
	}	
	
	function SetUpPermission( id )
	{
		local worlds = this.World[ id ];

		worlds.Permissions.rawset( "setworldname", "1" );
		worlds.Permissions.rawset( "setworldmessage", "1" );
		worlds.Permissions.rawset( "setworldtype", "1" );
		worlds.Permissions.rawset( "setworldspawn", "1" );
		worlds.Permissions.rawset( "worldkick", "1" );
		worlds.Permissions.rawset( "worldban", "1" );
		worlds.Permissions.rawset( "worldunban", "1" );
		worlds.Permissions.rawset( "worldsetlevel", "1" );
		worlds.Permissions.rawset( "mapping", "1" );
		worlds.Permissions.rawset( "vehspawning", "1" );
		worlds.Permissions.rawset( "vehmanage", "1" );
		worlds.Permissions.rawset( "worldkill", "1" );
		worlds.Permissions.rawset( "worldann", "1" );
		worlds.Permissions.rawset( "worldsetlevelcmd", "1" );
		worlds.Permissions.rawset( "setfpspinglimit", "1" );
		worlds.Permissions.rawset( "worldlock", "1" );
		worlds.Permissions.rawset( "worlddb", "1" );
	}
	
	function SetUpPermission2( id )
	{
		local worlds = this.World[ id ];

		worlds.Permissions2.rawset( "goto", "0" );
		worlds.Permissions2.rawset( "gotoloc", "0" );
		worlds.Permissions2.rawset( "heal", "0" );
		worlds.Permissions2.rawset( "spawnloc", "0" );
		worlds.Permissions2.rawset( "wep", "0" );
		worlds.Permissions2.rawset( "enterworld", "0" );
		worlds.Permissions2.rawset( "canattack", "0" );
		worlds.Permissions2.rawset( "candriveby", "0" );
		worlds.Permissions2.rawset( "fix", "0" );
	}
	
	function SetUpSettings( id )
	{
		local worlds = this.World[ id ];

		worlds.Settings.rawset( "WorldName", "N/A" );
		worlds.Settings.rawset( "WorldMessage", "N/A" );
		worlds.Settings.rawset( "WorldType", "normal" );
		worlds.Settings.rawset( "WorldSpawn", "0,0,0" );
		worlds.Settings.rawset( "LockWorld", "false" );
		worlds.Settings.rawset( "WorldKill", "true" );
		worlds.Settings.rawset( "WorldFPS", "0" );
		worlds.Settings.rawset( "WorldPing", "0" );
		worlds.Settings.rawset( "WorldDriveBy", "true" );
	}
	
	function SetUpAddOn( id )
	{
		local worlds = this.World[ id ];

		worlds.AddOn.rawset( "WorldAdmin", "false" );
		worlds.AddOn.rawset( "WorldFPS", "false" );
	}
	
	function GetPlayerLevelInWorld( player, world )
	{
		local worlds = this.World[ world ];

		if( worlds.Owner == player ) return 1000000;
		
		if( worlds.NameList )
		{
			if( worlds.NameList.rawin( player.tostring() ) ) return worlds.NameList[ player.tostring() ].Level.tointeger();
		}
		
		return 0;
	}

	function GetPlayerBanInWorld( player, world )
	{
		if( this.World.rawin( world ) )
		{
			local worlds = this.World[ world ];

			if( worlds.Owner == player ) return false;
			
			if( worlds.NameList )
			{
				if( worlds.NameList.rawin( player.tostring() ) ) return SToB( worlds.NameList[ player.tostring() ].Ban );
			}
			else return false;
		}
		else return false;
	}
	
	function Save( id )
	{
		local worlds = this.World[ id ];

		SqDatabase.Exec( format( "UPDATE Worlds SET Owner = '%d', NameList = '%s', Permissions = '%s', Permissions2 = '%s', Settings = '%s', AddOn = '%s', Price = '%d' WHERE World = '%d' ", worlds.Owner, ::EscapeString( this.ConvertFromJson( worlds.NameList ) ), ::EscapeString( this.ConvertFromJson( worlds.Permissions ) ), ::EscapeString( this.ConvertFromJson( worlds.Permissions2 ) ), ::EscapeString( this.ConvertFromJson( worlds.Settings ) ), ::EscapeString( this.ConvertFromJson( worlds.AddOn ) ), worlds.Price, id ) );
	}

	function GetPrivateWorld( id )
	{
		if( SqMath.IsGreater( id, 1999 ) && SqMath.IsLess( id, 4001 ) ) return true;
		if( SqMath.IsGreater( id, 4999 ) && SqMath.IsLess( id, 10001 ) ) return true;
		
		else return false;
	}
				
	function ConvertToJSON( string )
	{
		if( string == "N/A" ) return null;
		if( string == null ) return null;
		if( string.find("null") >= 0 ) return null;

		else return ::json_decode( string );
	}

	function ConvertFromJson( string )
	{
		local result = ::json_encode( string );
		
		if( typeof result == "string" ) return result;

		else return "N/A";
	}
	
	function GetCorrectValue( value )
	{
		if( SqMath.IsLess( value, 1000001 ) ) return true;
		if( SqMath.IsGreaterEqual( value, 0 ) ) return true;
		
		else return false;
	}
	
	function GetCorrectFPSValue( value )
	{
		if( SqMath.IsGreaterEqual( value, 0 ) && SqMath.IsLess( value, 61 ) ) return true;
		
		else return false;
	}

	function GetCorrectPingValue( value )
	{
		if( SqMath.IsLess( value, 60001 ) && SqMath.IsGreaterEqual( value, 0 ) ) return true;
		
		else return false;
	}
	
	function GetWorldPrice( player )
	{
		local getDiscount = ( ( 2000/100 ) * Server.Discount.World.World ), countPrice = ( 2000 - getDiscount );
		
		if( player.Data.Event.FreeWorld.tointeger() > 0 ) return 0;
		
		if( player.Data.Player.Permission.VIP.Duration == "0" )
		{
			local getVIPDiscount = ( ( countPrice/100 ) * 25 );
			return ( countPrice - getVIPDiscount );
		}
		else return countPrice;
	}
	
	function PurchaseWorld( player, str )
	{
		local stripValue = split( str, "-" );
		
		if( player.World == stripValue[0].tointeger() )
		{
			if( this.World[ stripValue[0].tointeger() ].Owner == 100000 )
			{
				if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, stripValue[1].tointeger() ) )
				{
					local world = this.World[ stripValue[0].tointeger() ];
						
					player.Data.Stats.Coin	-= stripValue[1].tointeger();
						
					world.Owner 			= player.Data.AccID;
					world.Price				= stripValue[1].tointeger();
					world.AddOn.WorldAdmin	= stripValue[2];
					world.AddOn.WorldFPS	= stripValue[3];

					this.Save( stripValue[0].tointeger() );
						
					player.Msg( TextColor.Sucess, Lang.BuyWorld[ player.Data.Language ], stripValue[0], TextColor.Sucess, SqInteger.ToThousands( stripValue[1].tointeger() ) );
				
					
					player.StreamInt( 102 );
					player.StreamString( "" );
					player.FlushStream( true );
				}
					
				else
				{
					player.StreamInt( 103 );
					player.StreamString( format( Lang.NotEnoughBuyWorld[ player.Data.Language ], SqInteger.ToThousands( stripValue[1].tointeger() ) ) );
					player.FlushStream( true );
				}
			}
				
			else
			{
				player.StreamInt( 103 );
				player.StreamString( format( Lang.NoWorldModSelected[ player.Data.Language ] ) );
				player.FlushStream( true );
			}
		}
			
		else
		{
			player.StreamInt( 102 );
			player.StreamString( "" );
			player.FlushStream( true );
		}
	}
	
	function GetLockedWorldStatus( player, world )
	{
		if( player.World != world )
		{
			if( this.GetPrivateWorld( world ) )
			{
				if( this.World.rawin( world ) )
				{
					if( this.World[ world ].Settings.LockWorld == "true" && SqMath.IsGreaterEqual( this.GetPlayerLevelInWorld( player.Data.AccID, world ), this.World[ world ].Permissions2.enterworld.tointeger() ) ) return true;
					if( this.World[ world ].Settings.LockWorld == "true" && SqMath.IsLess( this.GetPlayerLevelInWorld( player.Data.AccID, world ), this.World[ world ].Permissions2.enterworld.tointeger() ) ) return false;
				
					else return true;
				}
			}
		}
	}
	
	function ModWorld( player, str )
	{
		local stripValue = split( str, "-" );
		
		if( player.World == stripValue[0].tointeger() )
		{
			if( this.World[ stripValue[0].tointeger() ].Owner == player.Data.AccID )
			{
				if( SqMath.IsGreater( stripValue[1].tointeger(), 0 ) )
				{
					if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, stripValue[1].tointeger() ) )
					{
						local world = this.World[ stripValue[0].tointeger() ];
						
						player.Data.Stats.Coin	-= stripValue[1].tointeger();
						
						world.Owner 			= player.Data.AccID;
						world.Price				= stripValue[1].tointeger();
						if( stripValue[2] == "true" ) world.AddOn.WorldAdmin	= "true";
						if( stripValue[3] == "true" ) world.AddOn.WorldFPS		= "true";

						this.Save( stripValue[0].tointeger() );
						
						if( stripValue[2] == "true" && stripValue[3] == "true" ) player.Msg( TextColor.Sucess, Lang.ModWorld[ player.Data.Language ], SqInteger.ToThousands( stripValue[1].tointeger() ) );
						else player.Msg( TextColor.Sucess, Lang.ModWorld1[ player.Data.Language ], ( ( stripValue[2] == "true" ) ? "World Admin" : "FPS/Ping limit feature" ), SqInteger.ToThousands( stripValue[1].tointeger() ) );
					
						player.StreamInt( 102 );
						player.StreamString( "" );
						player.FlushStream( true );
					}
					
					else
					{
						player.StreamInt( 103 );
						player.StreamString( format( Lang.NotEnoughBuyMod[ player.Data.Language ], SqInteger.ToThousands( stripValue[1].tointeger() ) ) );
						player.FlushStream( true );
					}
				}
				
				else
				{
					player.StreamInt( 103 );
					player.StreamString( format( Lang.NoWorldModSelected[ player.Data.Language ] ) );
					player.FlushStream( true );
				}
			}
			
			else
			{
				player.StreamInt( 103 );
				player.StreamString( format( Lang.WorldNotOwner[ player.Data.Language ] ) );
				player.FlushStream( true );
			}
		}
		
		else
		{
			player.StreamInt( 102 );
			player.StreamString( "" );
			player.FlushStream( true );
		}
	}
	
	function GetWorldPermission2( player, perm )
	{
		if( this.GetPrivateWorld( player.World ) )
		{
			if( SqMath.IsGreaterEqual( this.GetPlayerLevelInWorld( player.Data.AccID, player.World ), this.World[ player.World ].Permissions2[ perm ].tointeger() ) ) return true;
		}
		else return true;
	}

	function GetWorldPermission( player, perm )
	{
		if( this.GetPrivateWorld( player.World ) )
		{
			if( SqMath.IsGreaterEqual( this.GetPlayerLevelInWorld( player.Data.AccID, player.World ), this.World[ player.World ].Permissions[ perm ].tointeger() ) ) return true;
		}
		else return true;
	}

	function IsStunt( world )
	{
		if( this.GetPrivateWorld( world ) )
		{
			if( this.World[ world ].Settings.WorldType == "stunt" ) return true;
		}
		else return false;
	}

	function GetWorldName( world )
	{
		switch( world )
		{
			case 0:
			case 1:
			return "Main";

			case 100:
			return "Lobby";

			case 101:
			return "DM Arena";

			case 102:
			return "Grinding world";

			default:
			if( this.GetPrivateWorld( world ) )
			{
				return "Private world " + world + " - " + this.World[ world ].Settings.WorldName;
			}
			else return "Unknown";
		}
	}
}
