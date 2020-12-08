SqCore.On().ClientScriptData.Connect(this, function ( player, stream, size )
{	
	local type = stream.ReadInt(), readString = stream.ReadString();
	
	switch( type )
	{
		case 100:
		SqWorld.PurchaseWorld( player, readString );
		break;
		
		case 102:
		SqWorld.ModWorld( player, readString );
		break;
		
		case 300:
		SqVehicles.BuyVehicle( player, readString );
		break;
		
		case 200:
		SqVehicles.BuyVehicle( player, readString );
		break;

		case 201:
		SqVehicles.SendPriceData( player, readString );
		break;

		case 202:
		SqVehicles.GetVehicle( player, readString );
		break;

		case 210:
		switch( readString )
		{
			case "1":
			if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, 1500 ) )
			{
				player.Data.GetInventoryItem( "NameTag" );
				
				local deduQuatity = player.Data.Player.Inventory[ "NameTag" ].Quatity.tointeger();

				player.StreamInt( 213 );
				player.StreamString( format( Lang.BroughtNameTag[ player.Data.Language ] ) );
				player.FlushStream( true );

				player.Data.Stats.Coin -= 1500;

				player.Data.Player.Inventory[ "NameTag" ].Quatity = ( deduQuatity + 1 );
			}
			else 
			{
				player.StreamInt( 212 );
				player.StreamString( format( Lang.BroughtNVehNameTag[ player.Data.Language ] ) );
				player.FlushStream( true );
			}
			break;

			case "3":
			if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, 500 ) )
			{
				player.Data.GetInventoryItem( "VehTag" );

				local deduQuatity = player.Data.Player.Inventory[ "VehTag" ].Quatity.tointeger();

				player.StreamInt( 213 );
				player.StreamString( format( Lang.BroughtNVehNameTag[ player.Data.Language ] ) );
				player.FlushStream( true );

				player.Data.Stats.Coin -= 500;
				
				player.Data.Player.Inventory[ "VehTag" ].Quatity = ( deduQuatity + 1 );
			}
			else 
			{
				player.StreamInt( 212 );
				player.StreamString( format( Lang.XCoinBuyVehNameTag[ player.Data.Language ] ) );
				player.FlushStream( true );
			}
			break;

			case "2":
			if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, 20 ) )
			{
				player.Data.GetInventoryItem( "ArmCase" );
				
				local deduQuatity = player.Data.Player.Inventory[ "ArmCase" ].Quatity.tointeger();

				player.StreamInt( 213 );
				player.StreamString( format( Lang.BroughtNArmCase[ player.Data.Language ] ) );
				player.FlushStream( true );

				player.Data.Stats.Coin -= 20;
				
				player.Data.Player.Inventory[ "ArmCase" ].Quatity = ( deduQuatity + 1 );
			}
			else 
			{
				player.StreamInt( 212 );
				player.StreamString( format( Lang.XCoinBuyArmCase[ player.Data.Language ] ) );
				player.FlushStream( true );
			}
			break;

			case "4":
			if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, 320 ) )
			{
				player.Data.GetInventoryItem( "vippass" );
				
				local deduQuatity = player.Data.Player.Inventory[ "vippass" ].Quatity.tointeger();

				player.StreamInt( 213 );
				player.StreamString( format( Lang.BroughtVIPPass[ player.Data.Language ] ) );
				player.FlushStream( true );

				player.Data.Stats.Coin -= 320;
				
				player.Data.Player.Inventory[ "vippass" ].Quatity = ( deduQuatity + 1 );
			}
			else 
			{
				player.StreamInt( 212 );
				player.StreamString( format( Lang.XCoinBuyPass[ player.Data.Language ] ) );
				player.FlushStream( true );
			}
			break;

			case "5":
			if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, 50 ) )
			{
				player.Data.GetInventoryItem( "gangpass" );
				
				local deduQuatity = player.Data.Player.Inventory[ "gangpass" ].Quatity.tointeger();

				player.StreamInt( 213 );
				player.StreamString( format( Lang.BroughtGPass[ player.Data.Language ] ) );
				player.FlushStream( true );

				player.Data.Stats.Coin -= 50;
				
				player.Data.Player.Inventory[ "gangpass" ].Quatity = ( deduQuatity + 1 );
			}
			else 
			{
				player.StreamInt( 212 );
				player.StreamString( format( Lang.XCoinBuyGPass[ player.Data.Language ] ) );
				player.FlushStream( true );
			}
			break;			
		}
		break;

		case 400:
		if( player.Data.Settings.Hitsound != "off" )
		{
			player.PlaySound( player.Data.Settings.Hitsound.tointeger() );
		}

		local plr = SqPlayer.FindPlayer( readString );
		if( plr ) 
		{
			plr.Data.LastHit = {};
			plr.Data.LastHit.rawset( "Time", time() );
			plr.Data.LastHit.rawset( "Player", player.Name );
		}
		break;

		case 401:
	    player.StreamInt( 300 );
		player.StreamString( "" );
		player.FlushStream( true );

		player.Data.LoadAccount();

		foreach( index, value in Server.PlayerTitle )
		{
			player.StreamInt( 1030 );
			player.StreamString( index + ";" + value.Text );
			player.FlushStream( true );
		}
		break;

		case 500:
		local q = SqDatabase.Query( "SELECT ID, Kills FROM PlayerData ORDER BY Kills DESC LIMIT 5");
		while( q.Step() ) 
	    {
			player.StreamInt( 501 );
			player.StreamString( HexColour.Red + " Name " + HexColour.White + SqAccount.GetNameFromID( q.GetInteger( "ID" ) ) + HexColour.Red + " Kills " + HexColour.White + SqInteger.ToThousands( q.GetString( "Kills" ) ) );
			player.FlushStream( true );
		}
		break;

		case 501:
		local q = SqDatabase.Query( "SELECT ID, Cash FROM PlayerData ORDER BY Cash DESC LIMIT 5");
		while( q.Step() ) 
	    {
			player.StreamInt( 501 );
			player.StreamString( HexColour.Red + " Name " + HexColour.White + SqAccount.GetNameFromID( q.GetInteger( "ID" ) ) + HexColour.Red + " Cash " + HexColour.White + "$" + SqInteger.ToThousands( q.GetString( "Cash" ) ) );
			player.FlushStream( true );
		}
		break;

		case 502:
		local q = SqDatabase.Query( "SELECT ID, Kills, Deaths, CAST( Kills as decimal( 10,2 )) / Deaths AS Result FROM PlayerData ORDER BY Result DESC LIMIT 5");
		while( q.Step() ) 
	    {
			player.StreamInt( 501 );
			player.StreamString( HexColour.Red + " Name " + HexColour.White + SqAccount.GetNameFromID( q.GetInteger( "ID" ) ) + HexColour.Red + " Ratio " + HexColour.White + q.GetString( "Result" ) );
			player.FlushStream( true );
		}
		break;

		case 503:
		local q = SqDatabase.Query( "SELECT ID, Playtime FROM Accounts ORDER BY Playtime DESC LIMIT 5");
		while( q.Step() ) 
	    {
			player.StreamInt( 501 );
			player.StreamString( HexColour.Red + " Name " + HexColour.White + SqAccount.GetNameFromID( q.GetInteger( "ID" ) ) + HexColour.Red + " Total playtime " + HexColour.White + SqInteger.SecondToTime( q.GetInteger( "Playtime" ) ) );
			player.FlushStream( true );
		}
		break;

		case 504:
		local getMembers = {};
		local t, ta , j , k = 0, i = 0, getStr = null;

		foreach( index, value in SqGang.Gangs )
		{
			getMembers.rawset( i, 
			{
				Name	= value.Name,
				Level   = value.Stats.Kills.tointeger(),
			});

			k++;
			i++;			
		}
								
		for( j = 0; j < getMembers.len(); j++ )
		{
			for( local i = 0 ; i<getMembers.len()-1-j; i++ )
			{
				if( ( getMembers.rawin( i ) ) && ( getMembers.rawin( i + 1 ) ) )
				{
					if( getMembers[ i ].Level < getMembers[ i + 1 ].Level )
					{
						t = getMembers[ i + 1 ].Name;
						ta = getMembers[ i + 1 ].Level;
						getMembers[ i + 1 ].Name <- getMembers[ i ].Name;
						getMembers[ i + 1 ].Level <- getMembers[ i ].Level;
						getMembers[ i ].Name <- t;
						getMembers[ i ].Level <- ta;
					}
				}
			}
		}

		for( local i = 0, j = 1; i < k ; i++, j++ )
		{
			if( ( getMembers.rawin( i ) ) && ( getMembers.rawin( i + 1 ) ) )
			{
				if( i > 5 ) continue;
															
				player.StreamInt( 501 );
				player.StreamString( HexColour.Red + " Gang " + HexColour.White + getMembers[ i ].Name + HexColour.Red + " Kills " + HexColour.White + SqInteger.ToThousands( getMembers[ i ].Level ) );
				player.FlushStream( true );
			}
		}
		break;

		case 505:
		local getMembers = {};
		local t, ta , j , k = 0, i = 0, getStr = null;

		foreach( index, value in SqGang.Gangs )
		{
			if( typeof value.Members != "table" ) continue;

			getMembers.rawset( i, 
			{
				Name	= value.Name,
				Level   = value.Members.len(),
			});

			k++;
			i++;			
		}
								
		for( j = 0; j < getMembers.len(); j++ )
		{
			for( local i = 0 ; i<getMembers.len()-1-j; i++ )
			{
				if( ( getMembers.rawin( i ) ) && ( getMembers.rawin( i + 1 ) ) )
				{
					if( getMembers[ i ].Level < getMembers[ i + 1 ].Level )
					{
						t = getMembers[ i + 1 ].Name;
						ta = getMembers[ i + 1 ].Level;
						getMembers[ i + 1 ].Name <- getMembers[ i ].Name;
						getMembers[ i + 1 ].Level <- getMembers[ i ].Level;
						getMembers[ i ].Name <- t;
						getMembers[ i ].Level <- ta;
					}
				}
			}
		}

		for( local i = 0, j = 1; i < k ; i++, j++ )
		{
			if( ( getMembers.rawin( i ) ) && ( getMembers.rawin( i + 1 ) ) )
			{	
				if( i > 5 ) continue;

				player.StreamInt( 501 );
				player.StreamString( HexColour.Red + " Gang " + HexColour.White + getMembers[ i ].Name + HexColour.Red + " Total members " + HexColour.White + SqInteger.ToThousands( getMembers[ i ].Level ) );
				player.FlushStream( true );
			}
		}
		break;		

		case 600:
		player.World			= 0;
		player.Data.Interior	= null;
		player.SetOption( SqPlayerOption.CanAttack, true );

		SqSpawn.SetPlayerSpawn( player );
			
		SqWeapon.GivePlayerSpawnwep( player );

		if( SqWorld.GetPrivateWorld( player.World ) )
		{
			local world = SqWorld.World[ player.World ];
																
			if( world.Settings.WorldSpawn != "0,0,0" && player.Data.Player.Spawnloc.SpawnData.Enabled == "2" ) player.Pos = Vector3.FromStr( world.Settings.WorldSpawn );
			if( world.Settings.WorldMessage != "N/A" ) player.Msg( TextColor.Sucess, Lang.WorldWelcomeMessage[ player.Data.Language ], world.Settings.WorldMessage );

			player.SetOption( SqPlayerOption.CanAttack, SToB( world.Settings.WorldKill ) );
			player.SetOption( SqPlayerOption.DriveBy, SToB( world.Settings.WorldDriveBy ) );

			if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.canattack ) ) player.SetOption( SqPlayerOption.CanAttack, true );
			if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.candriveby ) ) player.SetOption( SqPlayerOption.DriveBy, true );
			if( SqMath.IsLess( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.wep ) ) player.StripWeapons();
			if( SqMath.IsLess( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.spawnloc ) && player.Data.Player.Spawnloc.SpawnData.Enabled == "1" )
			{
				player.World = 0;
				player.Msg( TextColor.InfoS, Lang.WorldMovedNoPermission[ player.Data.Language ] );
			}
		}
		break;

		case 601:
		local getWorld = [];

		foreach( index, value in SqWorld.World )
		{
			if( value.Owner == player.Data.AccID )
			{
				getWorld.push( HexColour.White + index + HexColour.Red + " - " + HexColour.White + value.Settings.WorldName );
			}
		}

		if( getWorld.len() > 0 )
		{
			player.StreamInt( 604 );
			player.StreamString( "" );
			player.FlushStream( true );

			foreach( value in getWorld )
			{
				player.StreamInt( 603 );
				player.StreamString( value );
				player.FlushStream( true );
			}
		}

		else
		{
			player.StreamInt( 601 );
			player.StreamString( "You dont own any world." );
			player.FlushStream( true );
		}
		break;

		case 602:
		if( SqWorld.GetPrivateWorld( readString.tointeger() ) )
		{
			player.World = readString.tointeger();

			player.Data.Interior = null;

			local world = SqWorld.World[ readString.tointeger() ];

			if( world.Settings.WorldSpawn != "0,0,0" ) player.Pos = Vector3.FromString( world.Settings.WorldSpawn );
			if( world.Settings.WorldMessage != "N/A" ) player.Msg( TextColor.Sucess, Lang.WorldWelcomeMessage[ player.Data.Language ], world.Settings.WorldMessage );

			player.SetOption( SqPlayerOption.CanAttack, SToB( world.Settings.WorldKill ) );
			player.SetOption( SqPlayerOption.DriveBy, SToB( world.Settings.WorldDriveBy ) );

			if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, readString.tointeger() ), world.Permissions2.canattack ) ) player.SetOption( SqPlayerOption.CanAttack, true );
			if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, readString.tointeger() ), world.Permissions2.candriveby ) ) player.SetOption( SqPlayerOption.DriveBy, true );
		}
		break;

		case 603:
		player.Data.Interior	= null;

		player.World = 102;

		player.Data.InEvent = "Cash";
																															
		player.Msg( TextColor.Sucess, Lang.EnterGrindingWorld[ player.Data.Language ] );

		player.SetOption( SqPlayerOption.CanAttack, false );

		player.Pos		= RandSpawn[ rand()%RandSpawn.len() ];
		break;

		case 1000:
		if( !player.Data.IsReg )
		{
			if( readString.len() > 5 )
			{
				player.Data.Register( readString );

				player.StreamInt( 1001 );
				player.StreamString( "" );
				player.FlushStream( true );
			}
			else 
			{
				player.StreamInt( 1002 );
				player.StreamString( format( Lang.PasswordNotLonger[ player.Data.Language ] ) );
				player.FlushStream( true );
			}
		}

		else 
		{
			player.StreamInt( 1002 );
			player.StreamString( format( Lang.AlreadyRegistered[ player.Data.Language ] ) );
			player.FlushStream( true );
		}
		break;

		case 1010:
		if( player.Data.IsReg )
		{
			if( !player.Data.Logged )
			{
				if( player.Data.Password == SqHash.GetSHA256( readString ).tolower() )
				{
					player.Data.Login();

					player.StreamInt( 1011 );
					player.StreamString( "" );
					player.FlushStream( true );
				}
				else 
				{
					player.StreamInt( 1012 );
					player.StreamString( format( Lang.WrongPassword[ player.Data.Language ] ) );
					player.FlushStream( true );
				}
			}

			else 
			{
				player.StreamInt( 1012 );
				player.StreamString( format( Lang.AlreadyLogged[ player.Data.Language ] ) );
				player.FlushStream( true );
			}
		}

		else 
		{
			player.StreamInt( 1012 );
			player.StreamString( format( Lang.NotRegistered[ player.Data.Language ] ) );
			player.FlushStream( true );
		}
		break;

		case 1020:
		player.Data.Settings.LobbySpawn = readString;

		switch( readString )
		{
			case "Normal":
			player.Msg( TextColor.Sucess, Lang.SetLobbySpawn3[ player.Data.Language ] );
			break;

			case "DM":
			player.Msg( TextColor.Sucess, Lang.SetLobbySpawn4[ player.Data.Language ] );
			
			player.Data.Settings.Hud = "0";
			
			player.StreamInt( 305 );
			player.StreamString( player.Data.Settings.Hud );
			player.FlushStream( true );								
			break;
		}

		player.StreamInt( 305 );
		player.StreamString( "1" );
		player.FlushStream( true );


	/*	player.StreamInt( 1030 );
		player.StreamString( "1" );
		player.FlushStream( true );*/

		player.Spawn();
		break;

		case 1060:
		player.Data.ReadMsg = true;
		break;
	}
});