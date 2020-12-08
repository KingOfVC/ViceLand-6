SqAccount <-
{
	function GetNameFromID( id )
	{
		try 
		{
			local q = SqDatabase.Query( format( "SELECT * FROM Accounts WHERE ID = '%d'", id.tointeger() ) );
			if( q.Step() ) return q.GetString( "Name" );
			else return "Unknown";
		}
		catch( e ) return "Unknown";
	}

	function FindAccountByName( name )
	{
		local q = SqDatabase.Query( format( "SELECT * FROM Accounts WHERE Lower(Name) = '%s'", name.tolower() ) );
		if( q.Step() ) return q.GetString( "Name" );
		else return false;
	}

	function GetUID1ByName( name )
	{
		local q = SqDatabase.Query( format( "SELECT * FROM Accounts WHERE Lower(Name) = '%s'", name.tolower() ) );
		if( q.Step() ) return q.GetString( "UID1" );
		else return false;
	}

	function GetUID2ByName( name )
	{
		local q = SqDatabase.Query( format( "SELECT * FROM Accounts WHERE Lower(Name) = '%s'", name.tolower() ) );
		if( q.Step() ) return q.GetString( "UID2" );
		else return false;
	}

	function GetAccountData( name, type )
	{
		local q = SqDatabase.Query( format( "SELECT * FROM Accounts INNER JOIN PlayerData ON Accounts.ID = PlayerData.ID WHERE Lower(Name) = '%s'", name.tolower() ) );
		if( q.Step() ) 
		{
			switch( type )
			{
				case "IP":
				return q.GetString( "IP" );

				case "Cash":
				return q.GetInteger( "Cash" );

				case "Coin":
				return q.GetInteger( "Coin" );
			}
		}
		else return false;
	}

	function GetIDFromName( name )
	{
		local q = SqDatabase.Query( format( "SELECT * FROM Accounts WHERE Lower(Name) = '%s'", name.tolower() ) );
		if( q.Step() ) return q.GetInteger( "ID" );
		else return 100000;
	}

	function GetAccountPassword( name )
	{
		local q = SqDatabase.Query( format( "SELECT * FROM Accounts WHERE Lower(Name) = '%s'", name.tolower() ) );
		if( q.Step() ) return q.GetString( "Password" ).tolower();
	}

	function GetAccountUIDs( name )
	{
		local q = SqDatabase.Query( format( "SELECT * FROM Accounts WHERE Lower(Name) = '%s'", name.tolower() ) );
		if( q.Step() ) return [ q.GetString( "UID1" ), q.GetString( "UID2" ) ];
	}

	function GetAccounPermission( name )
	{
		local q = SqDatabase.Query( format( "SELECT * FROM Accounts INNER JOIN PlayerData ON Accounts.ID = PlayerData.ID WHERE Lower(Name) = '%s'", name.tolower() ) );
		if( q.Step() ) return ::json_decode( q.GetString( "Permission" ) );
	}

	function FindOnlinePlayerByID( id )
	{
		local result = null;
		SqForeach.Player.Active( this, function( plr ) 
		{
			if( id == plr.Data.AccID ) result = plr;
		});

		return result;
	}
}