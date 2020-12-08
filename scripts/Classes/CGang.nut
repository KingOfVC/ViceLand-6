class CGang
{
	Gangs	= {};

	function constructor()
	{
		local result = SqDatabase.Query( format( "SELECT * FROM Gangs" ) ), count = 0;

		while( result.Step() )
		{
			this.Gangs.rawset( result.GetInteger( "ID" ),
			{
				Name			= result.GetString( "Name" ),
				Tag				= result.GetString( "Tag" ),
				Members			= SqWorld.ConvertToJSON( result.GetString( "Members" ) ),
				Permissions		= SqWorld.ConvertToJSON( result.GetString( "Permissions" ) ),
				Ranks			= SqWorld.ConvertToJSON( result.GetString( "Ranks" ) ),

				Stats			= 
				{
					Kills		= result.GetInteger( "Kills" ),
					Deaths		= result.GetInteger( "Deaths" ),
				}

				Status			= result.GetString( "Status" ),
				Description		= result.GetString( "Description" ),
				IsOpen			= result.GetString( "IsOpen" ),
				Founder			= result.GetInteger( "Founder" ),
				Color 			= Color3.FromStr( result.GetString( "Color" ) ),
			});

			count ++;
		}

		SqLog.Scs( "Total gangs loaded in table: %s", SqInteger.ToThousands( count ) );
	}

	function printbitch()
	{
		foreach( index, value in this.Gangs )
		{
			print( index + ": Members " + value.Name + " Founder " + SqAccount.GetNameFromID( value.Founder ) );
		}
	}

	function EditPlayer( id, player, rank )
	{
		local getGang = this.Gangs[ id ];

		if( this.FindPlayer( id, player.tostring() ) != null ) 
		{
			getGang.Members[ player.tostring() ].Rank = rank;
		}
		
		else
		{
			if( getGang.Members == null ) getGang.Members = {};
			
			getGang.Members.rawset( player.tostring(), 
			{
				Rank	= rank,
			});
		}
		
		this.Save( id );
	}

	function EditRank( id, name, level )
	{
		local getGang = this.Gangs[ id ];

		if( this.FindRank( id, name ) != null ) 
		{
			getGang.Ranks[ name ].Level = level.tostring();
		}
		
		else
		{
			if( getGang.Ranks == null ) getGang.Ranks = {};
			
			getGang.Ranks.rawset( name, 
			{
				Level	= level.tostring(),
			});
		}
		
		this.Save( id );
	}
	
	function FindPlayer( id, player )
	{	
		local getGang = this.Gangs[ id ];

		if( getGang.Founder == player ) return true;

		if( getGang.Members == null ) getGang.Members = {};
		if( getGang.Members.rawin( player.tostring() ) ) return true; 	
	}

	function FindGang( name )
	{
		foreach( index, value in this.Gangs )
		{
			if( value.Name.tolower() == name.tolower() ) return index;
		}

		return null;
	}

	function FindRank( id, player )
	{	
		local getGang = this.Gangs[ id ];

		if( player.tolower() == "default" ) return false;

		if( getGang.Ranks == null ) getGang.Ranks = {};
		if( getGang.Ranks.rawin( player ) ) return true; 	
	}

	function GetPlayerLevel( id, player )
	{
		local getGang = this.Gangs[ id ];

		if( getGang.Founder == player ) return 1000000;
		
		if( getGang.Members )
		{
			if( getGang.Members.rawin( player.tostring() ) ) 
			{
				if( this.FindRank( id, getGang.Members[ player.tostring() ].Rank ) ) return getGang.Ranks[ getGang.Members[ player.tostring() ].Rank ].Level.tointeger();
				else return 0;
			}
		}
		else return null;
	}

	function Create( name, tag, founder )
	{
		local getID = 0;

		SqDatabase.Exec( format( "INSERT INTO Gangs ( 'Name', 'Founder' ) VALUES ( '%s', '%d' )", name, founder ) );


		getID	= SqDatabase.LastInsertRowId.tointeger();

		this.Gangs.rawset( getID,
		{
			Name			= name,
			Tag				= tag,
			Members			= null,
			Permissions		= this.InitPermissions(),
			Ranks			= null,

			Stats			= 
			{
				Kills		= 0,
				Deaths		= 0,
			}

			Status			= "Normal",
			Description		= "N/A",
			IsOpen			= "Invite",
			Founder			= founder,
			Color 			= Color3( 255, 255, 255 ),
		});

		this.Gangs[ getID ].Ranks = {};

		this.Gangs[ getID ].Ranks.rawset( "Default", 
		{
			Level	= "0",
		});

		this.Save( getID );
	}

	function InitPermissions() 
	{
	   local element = {};

	   element.rawset( "editrank", "1" );
	   element.rawset( "addrank", "1" );
	   element.rawset( "setcmdlevel", "1" );
	   element.rawset( "invite", "1" );
	   element.rawset( "chat", "1" );
	   element.rawset( "editranklevel", "1" );
	   element.rawset( "editsetting", "1" );
	   element.rawset( "kick", "1" );

	   return element;
	}

	function Save( id )
	{
		local getGang = this.Gangs[ id ];

		SqDatabase.Exec( format( "UPDATE Gangs SET Name = '%s', Tag = '%s', Members = '%s', Permissions = '%s', Ranks = '%s', Kills = '%d', Deaths = '%d', Status = '%s', Description = '%s', IsOpen = '%s', Color = '%s' WHERE ID = '%d'", getGang.Name, ::EscapeString( getGang.Tag ), ::EscapeString( SqWorld.ConvertFromJson( getGang.Members ) ), ::EscapeString( SqWorld.ConvertFromJson( getGang.Permissions ) ), ::EscapeString( SqWorld.ConvertFromJson( getGang.Ranks ) ), getGang.Stats.Kills, getGang.Stats.Deaths, getGang.Status, ::EscapeString( getGang.Description ), getGang.IsOpen, getGang.Color.tostring(), id ) );
	}

	function IsNull( element )
	{
		try
		{
			return element.len();
		}
		catch( _ ) _;

		return 0;
	}

	function playerJoin( player )
	{
		local getGang = null;

		foreach( index, value in this.Gangs )
		{
			if( value.Founder == player.Data.AccID ) getGang = index;

			if( value.Members == null ) continue;

			foreach( index1, value1 in value.Members )
			{
				if( index1.tointeger() == player.Data.AccID ) getGang = index;
			}
		}

		if( getGang )
		{
			player.Data.ActiveGang = getGang;

		//	player.Color = this.Gangs[ getGang ].Color;

			if( player.Data.Settings.Team == "Gang" )
			{
				//player.Team = getGang;
			}
		}
	}




}