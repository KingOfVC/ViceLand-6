class CPickup
{
	Pickups = {};

	function constructor()
	{
		local result = SqDatabase.Query( format( "SELECT * FROM Pickups" ) ), count = 0;

		while( result.Step() )
		{
			this.Pickups.rawset( result.GetString( "UID" ),
			{
				instance		= SqPickup.NullInst(),
				Model 			= result.GetInteger( "Model" ),
				Pos 			= Vector3.FromStr( result.GetString( "Pos" ) ),
				World 			= result.GetInteger( "World" ),
				LastEdited		= result.GetInteger( "LastEdited" ),
				LastEditTime	= result.GetString( "LastEditTime" ),
				Extra			= result.GetString( "Extra" ),
				Type			= result.GetString( "Type" ),
				Level			= result.GetInteger( "Level" ),
				Sound			= result.GetString( "Sound" ),
				Message			= result.GetString( "Message" ),
				IsEditing		= false,
			});

			count ++;
		}

		SqLog.Scs( "Total pickups loaded in table: %s", SqInteger.ToThousands( count ) );
	}	
		
	function Create( creator, model, pos, world )
	{
		local pickup = SqPickup.Create( model, world, 1, pos, 255, false ), getUID = "Pickup:" + SqHash.GetMD5( "" + time() );

		this.Pickups.rawset( getUID,
		{
			instance		= pickup,
			Model 			= model,
			Pos 			= pos,
			World 			= world,
			LastEdited		= creator,
			LastEditTime	= time(),
			Extra			= "",
			Type			= "",
			Level			= 0,
			Sound			= "N/A",
			Message			= "N/A",
			IsEditing		= false,
		});

		this.Pickups[ getUID ].instance.SetTag( getUID );

		SqDatabase.Exec( format( "INSERT INTO Pickups ( 'UID', 'Model', 'World', 'Pos', 'Type', 'LastEdited', 'LastEditTime', 'Level', 'Extra', 'Message', 'Sound' ) VALUES ( '%s', '%d', '%d', '%s', '%s', '%d', '%d', '%d', '%s', '%s', '%s' )", getUID, model, world, pos.tostring(), "", creator, time(), 0, "", "N/A", "N/A" ) );
	
		return pickup;
	}	

	function Create2( creator, model, pos, world, type )
	{
		local pickup = SqPickup.Create( model, world, 1, pos, 255, false ), getUID = "Pickup:" + SqHash.GetMD5( "" + time() );

		this.Pickups.rawset( getUID,
		{
			instance		= pickup,
			Model 			= model,
			Pos 			= pos,
			World 			= world,
			LastEdited		= creator,
			LastEditTime	= time(),
			Extra			= "",
			Type			= type,
			Level			= 0,
			Sound			= "N/A",
			Message			= "N/A",
			IsEditing		= false,
		});

		this.Pickups[ getUID ].instance.SetTag( getUID );

		SqDatabase.Exec( format( "INSERT INTO Pickups ( 'UID', 'Model', 'World', 'Pos', 'Type', 'LastEdited', 'LastEditTime', 'Level', 'Extra', 'Message', 'Sound' ) VALUES ( '%s', '%d', '%d', '%s', '%s', '%d', '%d', '%d', '%s', '%s', '%s' )", getUID, model, world, pos.tostring(), type, creator, time(), 0, "", "N/A", "N/A" ) );
	
		return pickup;
	}	
	
	function CreateForPlayer( owner, model, pos, world, type, extra )
	{
		local pickup = SqPickup.Create( model, world, 1, pos, 255, false ), getUID = "Pickup:" + SqHash.GetMD5( "" + time() );

		this.Pickups.rawset( getUID,
		{
			instance		= pickup,
			Model 			= model,
			Pos 			= pos,
			World 			= world,
			LastEdited		= owner,
			LastEditTime	= time(),
			Extra			= "",
			Type			= type,
			Level			= 0,
			Sound			= "N/A",
			Message			= "N/A",
			IsEditing		= false,
		});

		this.Pickups[ getUID ].instance.SetTag( getUID );
	
		return pickup;
	}	
	
	function Save( uid )
	{
		local pickup = this.Pickups[ uid ];

		pickup.Pos 		= pickup.instance.Pos;
		
		SqDatabase.Exec( format( "UPDATE Pickups SET Pos = '%s', Type = '%s', LastEdited = '%d', LastEditTime = '%d', Level = '%d', Extra = '%s', Message = '%s', Sound = '%s' WHERE UID = '%s'", pickup.Pos.tostring(), pickup.Type, pickup.LastEdited, time(), pickup.Level, ::EscapeString( pickup.Extra ), ::EscapeString( pickup.Message ), ::EscapeString( pickup.Sound ), uid ) );
	}

	function GetWorldPickupCount( world )
	{
		local getCount = 0;
		SqForeach.Pickup.Active(this, function( Pickup )
		{
			if( Pickup.World == world ) getCount++;
		});
		
		return getCount;
	}

	function RemoveAllPickupInWorld( pickup )
	{
		SqForeach.Pickup.Active(this, function( Pickup )
		{
			if( Pickup.World == pickup )
			{
				this.Pickups[ Pickup.Tag ].instance = SqPickup.NullInst();

				Pickup.Destroy();
			}
		});
	}
	
	function GetPlayerInsideWorld( pickup )
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
		local pickup = SqFind.Pickup.TagMatches( false, false, player.Data.IsEditing );

		if( pickup )
		{
			this.Pickups[ pickup.Tag ].IsEditing = false;
			this.Save( pickup.Tag );
				
			player.Data.IsEditing = "";
			player.Msg( TextColor.InfoS, Lang.PickSaved[ player.Data.Language ] );
		}
	}

	function AllowPick( player, pickup )
	{
		local Pickup = this.Pickups[ pickup.Tag ], allowEnter;

		if( SqWorld.GetPrivateWorld( player.World ) )
		{
			if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), Pickup.Level ) )
			{
				return true;
			}
		}

		else
		{			
			switch( Pickup.Level )
			{
				case 1:
				if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 ) allowEnter = true;
				break;

				case 2:
				if( player.Data.Player.Permission.Mapper.Position.tointeger() > 0 ) allowEnter = true;
				break;

				case 3:
				if( player.Data.Player.Permission.VIP.Position.tointeger() > 0 || player.Data.Player.Permission.Staff.Position.tointeger() > 0 || player.Data.Player.Permission.Mapper.Position.tointeger() > 0 ) allowEnter = true;
				break;

				case 4:
				if( player.Data.Player.Permission.Staff.Position.tointeger() || player.Data.Player.Permission.Mapper.Position.tointeger() > 0 ) allowEnter = true;
				break;

				case 0:
				allowEnter = true;
				break;
			}

			return allowEnter;
		}
	}
}