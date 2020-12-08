class CObject
{

	Objects		= {};
	
	function constructor()
	{		
		local result = SqDatabase.Query( format( "SELECT * FROM Objects" ) ), count = 0;

		while( result.Step() )
		{
			this.Objects.rawset( result.GetString( "UID" ).tolower(),
			{
				Model			= result.GetInteger( "Model" ),
				Pos				= Vector3.FromStr( result.GetString( "Pos" ) ),
				Rotation 		= Vector3.FromStr( result.GetString( "Euler" ) ),
				World			= result.GetInteger( "World" ),
				LastEdited		= result.GetInteger( "LastEdited" ),
				LastEditTime	= result.GetString( "LastEditTime" ),
				IsEditing		= false,
				instance     	= SqObject.NullInst(),
			});

			count ++;
		}

		SqLog.Scs( "Total objects loaded in table: %s", SqInteger.ToThousands( count ) );
	}	
		
	
	function Create( creator, model, pos, world )
	{
		local object = SqObject.Create( model, world, pos, 255 ), getUID = "Object:" + SqHash.GetMD5( "" + time() );

		getUID.tolower();

		this.Objects.rawset( getUID,
		{
			Model			= model,
			Pos				= pos,
			Rotation 		= Vector3.FromStr( "0, 0, 0" ),
			World			= world,
			LastEdited		= creator,
			LastEditTime	= time(),
			IsEditing		= false,
			instance     	= object,
		});

		this.Objects[ getUID ].instance.SetTag( getUID );

		SqDatabase.Exec( format( "INSERT INTO Objects ( 'UID', 'Model', 'World', 'Pos', 'Euler', 'LastEdited', 'LastEditTime' ) VALUES ( '%s', '%d', '%d', '%s', '%s', '%d', '%d' )", getUID, model, world, pos.tostring(), Vector3.FromStr( "0,0,0" ).tostring(), creator, time() ) );
	
		return object;
	}	

	function Save( id )
	{
		local obj = this.Objects[ id ];

		obj.Pos 		= obj.instance.Pos;
		obj.Rotation 	= obj.instance.EulerRotation;

		SqDatabase.Exec( format( "UPDATE Objects SET Pos = '%s', Euler = '%s', LastEdited = '%d', LastEditTime = '%d' WHERE UID = '%s'", obj.Pos.tostring(), obj.Rotation.tostring(), obj.LastEdited, time(), id ) );
	}

	function GetWorldObjectCount( world )
	{
		local getCount = 0;
		SqForeach.Object.Active(this, function( Object )
		{
			if( Object.World == world ) getCount++;
		});
		
		return getCount;
	}

	function RemoveAllObjectInWorld( world )
	{
		SqForeach.Object.Active(this, function( Object )
		{
			if( Object.World == world )
			{
				if( this.Objects.rawin( Object.Tag ) )
				{
					this.Objects[ Object.Tag ].instance = SqObject.NullInst();

					Object.Destroy();
				}
			}
		});
	}
	
	function GetPlayerInsideWorld( world )
	{
		local getOldCount = 0;
		SqForeach.Player.Active(this, function(plr)
		{
			if( world == plr.World ) getOldCount ++;
		});
		return getOldCount
	}
	
	function CancelEditing( player )
	{
		local object = SqFind.Object.TagMatches( false, false, player.Data.IsEditing );

		if( object )
		{
			object.Alpha	= 255;

			this.Objects[ object.Tag ].IsEditing = false;
			this.Save( object.Tag );
				
			player.Data.IsEditing = "";
			player.Msg( TextColor.InfoS, Lang.ObjSaved[ player.Data.Language ] );
		}
	}

	function IsMoving( player )
	{
		try
		{
			return player.FindTask( "Editing" );
		}
		catch( _ ) _;
	
		return null;
	}

	function IsPremium( player, obj )
	{
		if( Server.PremiumObj.find( obj.tointeger() ) >= 0 )
		{
			return player.Data.GetInventoryItem( obj.tostring() );
		}
		else return true;
	}
}