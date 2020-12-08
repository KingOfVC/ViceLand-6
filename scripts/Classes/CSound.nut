class CSound
{
	Sounds = {};

	function constructor()
	{
		local result = SqDatabase.Query( format( "SELECT * FROM Sounds1" ) ), count = 0;

		while( result.Step() )
		{
			this.Sounds.rawset( result.GetString( "Name" ), 
			{
				ID 			= result.GetInteger( "ID" ),
				Creator		= result.GetInteger( "Creator" ), 
				CreateDate	= result.GetInteger( "CreateDate" ), 
			});

			count ++;
		}

		SqLog.Scs( "Total sounds loaded in table: %s", SqInteger.ToThousands( count ) );
	}

	function Add( name, sound, creator )
	{
		this.Sounds.rawset( name.tolower(), 
		{
			ID	 		= sound,
			Creator		= creator, 
			CreateDate	= time(), 
		});

		SqDatabase.Exec( format( "INSERT INTO Sounds1 ( 'Name', 'ID', 'Creator', 'CreateDate' ) VALUES ( '%s', '%d', '%d', '%d' )", name.tolower(), sound, creator, time() ) );
	}

	function Delete( name )
	{
		SqDatabase.Exec( format( "DELETE FROM Sounds1 WHERE Lower(Name) = '%s'", name.tolower() ) );

		this.Sounds.rawdelete( name.tolower() );
	}
}