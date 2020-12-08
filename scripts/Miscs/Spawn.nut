SqSpawn <-
{
	function SetPlayerSpawn( player )
	{
		if( player.Data.Player.Spawnloc.SpawnData.Pos == "0" )
		{
			player.Pos		= RandSpawn[ rand()%RandSpawn.len() ];
			player.World	= 0;
			
			player.Data.Player.Spawnloc.SpawnData.Enabled = "2";
		}
		
		else
		{
			if( player.Data.Player.Spawnloc.SpawnData.Enabled == "1" )
			{
				player.Pos		= Vector3.FromStr( player.Data.Player.Spawnloc.SpawnData.Pos );
				player.World	= player.Data.Player.Spawnloc.SpawnData.World.tointeger();
			}
			
			else
			{
				if( player.Data.Player.Spawnloc.SpawnData.World == "6" )
				{
					player.Pos				= Vector3( -883.686, -340.697, 11.1034 );
					player.World			= 0;
					player.Data.Interior	= null;
					player.SetOption( SqPlayerOption.CanAttack, true );
				}
				
				if( player.Data.Player.Spawnloc.SpawnData.World == "100" )
				{
					player.Pos				= RandSpawn[ rand()%RandSpawn.len() ];
					player.World			= 0;
					player.SetOption( SqPlayerOption.CanAttack, true );
				}
	
				if( player.Data.Player.Spawnloc.SpawnData.World == "101" )
				{
					player.Pos				= RandSpawn[ rand()%RandSpawn.len() ];
					player.World			= 0;
					player.SetOption( SqPlayerOption.CanAttack, true );
				}
		
				else
				{
					if( player.Data.Player.Spawnloc.SpawnData.Pos )
					{
						player.Pos		= RandSpawn[ rand()%RandSpawn.len() ];
						player.World	= 0;
					}
					else 
					{
						player.Pos		= RandSpawn[ rand()%RandSpawn.len() ];
						player.World	= 0;
					}
				}
			}
		}
	}
	
	function SavePlayerSpawn( player )
	{
		if( player.Data.Player.Spawnloc.SpawnData.Enabled == "2" ) 
		{
			if( player.World != 100 )
			{
			//	local getPos = ( ( rand() % player.Data.Player.Spawnloc.SpawnData.Pos ) - 50 ) + "," + ( ( rand() % player.Data.Player.Spawnloc.SpawnData.Pos ) - 50 ) + "," + -9999;

				player.Data.Player.Spawnloc.SpawnData.Pos 	= player.Pos.tostring();
				player.Data.Player.Spawnloc.SpawnData.World	= player.World.tostring();
			}
		}
	}
	
	function GetSpawnPrice( player )
	{
		if( player.Data.Player.Permission.VIP.Position == "0" ) return 5000;
		else return 0;
	}
	
	function GetSpawnlocPrice( player )
	{
		if( player.Data.Player.Permission.VIP.Position == "0" ) return 10000;
		else return 0;
	}
	
	function GetlocPrice( player, to )
	{
		if( player.Data.Player.Permission.VIP.Position == "0" )
		{
			return ( ( player.Pos.DistanceTo( to ) * 10 ) + 2500 );
		}
		else return 0;
	}


}

/*RandSpawn <- 
[
	Vector3( -883.101, -471.864, 13.1099 ), 
	Vector3( 493.654, 702.559, 12.1033 ), 
	Vector3( -137.176, -981.112, 10.4653 ),
	Vector3( -137.176, -981.112, 10.4653 ),
	Vector3( -822.674, 1140.28, 12.4111 ),
	Vector3( 501.397, 512.665, 11.4859 ), 
	Vector3(-877.96, -678.159, 11.2101 ), 
	Vector3( -661.222, 767.597, 11.1652 ),
	Vector3( 405.916, -477.516, 10.0662),
	Vector3( 5.00792, -1000.05, 10.4633 ),
	Vector3( -1166.1410, -620.6473, 11.8277 ),
	Vector3( -1003.7244, 197.7314, 11.4306 ),
	Vector3( -63.6423, 946.9459, 10.9402 ),
	Vector3( -379.0713, -538.9711, 17.2835 ),
	Vector3( -599.2484, 632.0645, 11.6765 ),
	Vector3( 218.0042, -346.6602, 10.8721 ),]*/

	RandSpawn <-
	[
		Vector3( -899.297180,390.123108,11.148675 ),
	]