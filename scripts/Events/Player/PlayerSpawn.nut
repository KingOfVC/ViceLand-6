SqCore.On().PlayerSpawn.Connect( this, function (player)
{

	if( player.Data.Settings.Team == "Gang" )
	{
		if( !SqDM.isTeam( player.Team ) ) player.Team = player.Data.ActiveGang;
	}
	//else player.Team 			= 255;

	if( !SqDM.isTeam( player.Team ) ) player.Skin = player.Data.Skin;
	player.Data.PFPSWarn	= 0;
	player.Data.AutoSpawn = true;

	if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.HelpMsgF4[ player.Data.Language ], TextColor.InfoS );

	SqWeapon.GivePlayerSpawnwep( player );


	if( player.Data.Player.Permission.VIP.Position.tointeger() > 0 && !player.Data.InEvent ) player.Armour = 100;

	if( player.Data.InEvent == "DM" ) 
	{
		player.Pos = Vector3.FromStr( Server.DMArena.Arena[ Server.DMArena.Position.tostring() ].Pos );

		player.World = 101;

	}

	if( player.Data.InEvent == "Cash" ) 
	{
		player.Pos = RandSpawn[ rand()%RandSpawn.len() ];

		player.World = 102;
		
		if( player.Data.Job.rawin( "Pizza" ) ) player.Msg( TextColor.InfoS, Lang.StartPizzaJob2[ player.Data.Language ] );
	}

	if( player.Data.Interior == "Lobby" ) 
	{
		switch( player.Data.Settings.LobbySpawn )
		{
			case "Normal":
			player.World 	= 100;
			player.Pos 		= Vector3.FromStr( "-1471.868164,553.079102,2008.979980" );
			break;

			case "Admin":
			player.World 	= 100;
			player.Pos 		= Vector3.FromStr( "-1471.868164,553.079102,2008.979980" );
			break;

			case "DM":
			player.Data.Interior = null;

			SqSpawn.SetPlayerSpawn( player );
						
			if( SqWorld.GetPrivateWorld( player.World ) )
			{
				local world = SqWorld.World[ player.World ];
																
				if( world.Settings.WorldSpawn != "0,0,0" && player.Data.Player.Spawnloc.SpawnData.Enabled == "2" ) player.Pos = Vector3.FromStr( world.Settings.WorldSpawn );

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
		}
	}

	else 
	{
		if( player.Data.InEvent == null )
		{
			SqSpawn.SetPlayerSpawn( player );
						
			if( SqWorld.GetPrivateWorld( player.World ) )
			{
				local world = SqWorld.World[ player.World ];
																
				if( world.Settings.WorldSpawn != "0,0,0" && player.Data.Player.Spawnloc.SpawnData.Enabled == "2" ) player.Pos = Vector3.FromStr( world.Settings.WorldSpawn );

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
		}
	}

	if( player.Data.InEvent != "Cash" && !player.Data.Interior )
	{
		player.MakeTask( function( pos, old )
		{
			if( this.Data == null ) this.Data = 0;

			player.SetOption( SqPlayerOption.CanAttack, false );

			player.Data.SpawnProtection = true;

			if( ++this.Data > 9 )
			{
				player.World 	= old;

				player.Data.SpawnProtection = false;

				if( !SqDM.isTeam( player.Team ) ) player.Skin = player.Data.Skin;

				if( SqWorld.GetPrivateWorld( player.World ) ) player.SetOption( SqPlayerOption.CanAttack, SToB( SqWorld.World[ player.World ].Settings.WorldKill ) );
				else 
				{
					if( player.World != 100 ) player.SetOption( SqPlayerOption.CanAttack, true );
				}

				SqCast.sendAnnounceToPlayer( player, "Spawn protection has been disabled." );

				this.Terminate();
			}
		}, 500, 10, player.Pos, player.World );

		player.World = player.UniqueWorld;

		SqCast.sendAnnounceToPlayer( player, "Spawn protection has been enabled." );
	}

	player.StreamInt( 6001 );
	player.StreamString( "" );
	player.FlushStream( true );
});