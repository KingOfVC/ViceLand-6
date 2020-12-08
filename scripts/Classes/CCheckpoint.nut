class CCheckpoint
{
	Type		= null;
	Time		= 0;
	Extra 		= null;
	
	function constructor( id )
	{
		local result = SqDatabase.Query( format( "SELECT * FROM Checkpoints WHERE UID = '%s'", id ) );

		if( result.Step() )
		{
			this.Type  = result.GetString( "Type" );

			switch( this.Type )
			{
				case "Robbery":
				this.Extra = {};
				this.Extra.rawset( "Time", 0 );
				this.Extra.rawset( "IsRobbing", 0 );
				break;

				case "EventCP":
				this.Extra = {};
				this.Extra.rawset( "Count", 0 );
				this.Extra.rawset( "Owner", null );
				this.Extra.rawset( "IsCapture", false );
				break;
			}
		}
	}

	function Register( UID, pos, type, world, color )
	{
		this.Type = type;

		if( type == "Robbery" )
		{
			this.Extra = {};
			this.Extra.rawset( "Time", 0 );
			this.Extra.rawset( "IsRobbing", 0 );
		}

		SqDatabase.Exec( format( "INSERT INTO Checkpoints ( 'UID', 'Pos', 'Size', 'Type', 'World', 'Color' ) VALUES ( '%s', '%s', '%f', '%s', '%d', '%s' )", UID, pos, 1.5, type, world, color ) );
	}
	
}
