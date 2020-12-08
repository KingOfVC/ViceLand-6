SqCore.On().PlayerRequestClass.Connect(this, function ( player, classes )
{
	//if( player.Data.AutoSpawn ) player.Spawn();

//	if( player.Data.Settings.LobbySpawn == "DM" )
//	{
		local team = "[#ffffff]Free Team";

	//	player.Angle = -2.59526;
		player.PlaySound( 362 );
		if( player.Skin == 202 ) player.SetWeapon( 30, 1 );
		else player.SetWeapon( 110, 1 );

		switch( player.Team )
		{
			case 1:
			team = "Team Business";
			break

			case 2:
			team = "Team Medic";
			break

			case 3:
			team = "Team Taxi";
			break

			case 4:
			team = "Team Haitian";
			break

			case 5:
			team = "Team Police";
			break

			case 6:
			team = "Team Biker";
			break

			default:
			team = "[#ffffff]Free Team";
			break
		}

		player.StreamInt( 6000 );
		player.StreamString( RGBToHex( player.Color ) + team );
		player.FlushStream( true );
//	}
	
/*	else 
	{
		if( player.Data.Logged && player.Data.IsReg ) player.Spawn();
	}*/
});