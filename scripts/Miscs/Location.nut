SqLocation <-
{
	function GetLocation( text )
	{
		local q = SqDatabase.Query( format( "SELECT * FROM Locations WHERE Lower(Name) = '%s'", text.tolower() ) ), result = {};
		if( q.Step() ) 
		{
			return result = 
			{ 
				Name		= text,
				Pos			= Vector3.FromStr( q.GetString( "Pos" ) ),
				Creator		= q.GetString( "Creator" ),
				DateCreate	= q.GetInteger( "Time" ),
			}
		}
		
		else return null;
	}

	function SaveLocation( text, pos, author )
	{
		local getPos = pos.x + "," + pos.y + "," + pos.z;
		
		SqDatabase.Exec( format( "INSERT INTO Locations ( 'Name', 'Pos', 'Creator', 'Time' ) VALUES ( '%s', '%s', '%s', '%d' )", SQLite.EscapeString( text ), getPos, author, time() ) );
	}


	function UpdateLocation( text, pos )
	{
		local getPos = pos.x + "," + pos.y + "," + pos.z;
		
		SqDatabase.Exec( format( "UPDATE Locations SET Pos = '%s' WHERE lower(Name) = '%s'", getPos, text ) );
	}
	
	function DeleteLocation( text )
	{
		SqDatabase.Exec( format( "DELETE FROM Locations WHERE lower(Name) = '%s'", text ) ); 
	}
	
	function IsTeleporting( player )
	{
		try
		{
			return player.FindTask( "Teleport" );
		}
		catch( _ ) _;
	
		return null;
	}
	
	function GetDistancePrice( player, to )
	{
		if( player.Data.Player.Permission.VIP.Position == "0" )
		{
			return ( player.Pos.DistanceTo( to ).tointeger() * 10 );
		}
		else return 0;
	}
	
	function GetSavelocPrice( player )
	{
		if( player.Data.Player.Permission.VIP.Position == "0" )
		{
			return 10000;
		}
		else return 0;
	}

	function VerifyBL( location )
	{
		switch( location )
		{
			case "Lobby":
			case "Bank":
			return true;

			default: 
			return false;
		}
	}

}