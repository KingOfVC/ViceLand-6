class CAnim
{
	Anims = {};

	function constructor()
	{
		local result = SqDatabase.Query( format( "SELECT * FROM Anims" ) ), count = 0;

		while( result.Step() )
		{
			this.Anims.rawset( result.GetString( "Name" ), 
			{
				Anim 		= result.GetString( "Anim" ),
				Creator		= result.GetInteger( "Creator" ), 
				CreateDate	= result.GetInteger( "CreateDate" ), 
			});

			count ++;
		}

		SqLog.Scs( "Total anims loaded in table: %s", SqInteger.ToThousands( count ) );
	}

	function Add( name, anim, creator )
	{
		this.Anims.rawset( name.tolower(), 
		{
			Anim 		= anim,
			Creator		= creator, 
			CreateDate	= time(), 
		});

		SqDatabase.Exec( format( "INSERT INTO Anims ( 'Name', 'Anim', 'Creator', 'CreateDate' ) VALUES ( '%s', '%s', '%d', '%d' )", name.tolower(), anim, creator, time() ) );
	}

	function Delete( name )
	{
		SqDatabase.Exec( format( "DELETE FROM Anims WHERE Lower(Name) = '%s'", name.tolower() ) );

		this.Anims.rawdelete( name.tolower() );
	}
}