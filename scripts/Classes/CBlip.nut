class CBlip
{
	Blips = {};

	function constructor()
	{		
		local result = SqDatabase.Query( format( "SELECT * FROM Blips" ) ), count = 0;

		while( result.Step() )
		{
			this.Blips.rawset( result.GetInteger( "ID" ),
			{
				Type		= result.GetInteger( "Type" ),
				Pos 		= Vector3.FromStr( result.GetString( "Pos" ) ),
				World		= result.GetInteger( "World" ), 
				Size		= result.GetInteger( "Size" ), 
				Color		= Color4.FromStr( result.GetString( "Color" ) ),
				instance	= SqBlip.NullInst(),
			});

			count ++;
		}

		SqLog.Scs( "Total blips loaded in table: %s", SqInteger.ToThousands( count ) );
	}

	function Create( type, pos, size, world, color )
	{
		local blip = SqBlip.Create( world, pos, size, color, type ), getID = 0;

		SqDatabase.Exec( format( "INSERT INTO Blips ( 'Type', 'Pos', 'Size', 'World', 'Color' ) VALUES ( '%d', '%s', '%f', '%d', '%s' )", type, pos.tostring(), size, world, color.tostring() ) );

		getID	= SqDatabase.LastInsertRowId;

		this.Blips.rawset( getID.tointeger(),
		{
			Type		= type,
			Pos 		= pos,
			World		= world, 
			Size		= size, 
			Color		= color,
			instance	= blip,
		});

		this.Blips[ getID.tointeger() ].instance.SetTag( getID.tostring() );
	}

	function CreateForPlayer( id, type, pos, size, world, color )
	{
		local blip = SqBlip.Create( world, pos, size, color, type ), getID = id;

		this.Blips.rawset( getID.tointeger(),
		{
			Type		= type,
			Pos 		= pos,
			World		= world, 
			Size		= size, 
			Color		= color,
			instance	= blip,
		});

		this.Blips[ getID.tointeger() ].instance.SetTag( getID.tostring() );
	}

	function Delete( id )
	{
		SqDatabase.Exec( format( "DELETE FROM Blips WHERE ID = '%d'", id ) );

		this.Blips.rawdelete( id );
	}

	function GetCount( world )
	{
		local getCount = 0;
		SqForeach.Blip.Active(this, function( blip )
		{
			if( blip.World == world ) getCount++;
		});
		
		return getCount;
	}

	function RemoveAllBlipInWorld( world )
	{
		SqForeach.Blip.Active(this, function( blip )
		{
			if( blip.World == world )
			{
				this.Blips[ blip.Tag.tointeger() ].instance = SqBlip.NullInst();

				blip.Destroy();
			}
		});
	}

}