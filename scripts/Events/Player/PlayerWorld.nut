SqCore.On().PlayerWorld.Connect( this, function( player, old, new, secondary )
{
	local new1 = 0;
	local old1 = 0;

	if( new == 1 ) new1 = 0;
	if( old == 1 ) old1 = 0;

	if( !player.Data.SpawnProtection )
	{
		if( SqWorld.GetPrivateWorld( new ) )
		{
			if( !SqWorld.World.rawin( new ) ) SqWorld.Register( new );
		}

		if( new == 1 ) player.World = 0;
		
		if( new == 100 ) 
		{
			player.SetOption( SqPlayerOption.CanAttack, false );

			player.StreamInt( 300 );
			player.StreamString( Server.DMArena.Arena[ Server.DMArena.Position.tostring() ].Name );
			player.FlushStream( true );
		}
		else 
		{
		    player.StreamInt( 301 );
			player.StreamString( Server.DMArena.Arena[ Server.DMArena.Position.tostring() ].Name );
			player.FlushStream( true );

		/*	player.StreamInt( 302 );
			player.StreamString( Server.DMArena.Arena[ Server.DMArena.Position.tostring() ].Name );
			player.FlushStream( true );
		*/
		}

	//	if( new != 101 ) player.Data.InEvent = null;
		
		if( player.Data.IsEditing.find( "Object" ) >= 0 ) SqObj.CancelEditing( player );
		if( player.Data.IsEditing.find( "Pickup" ) >= 0 ) SqPick.CancelEditing( player );

		if( SqObj.GetPlayerInsideWorld( old ) == 0 ) 
		{
			local tim = SqRoutine( this, function()
			{
				if( SqObj.GetPlayerInsideWorld( old ) == 0 )
				{
					if( SqObj.GetWorldObjectCount( old ) > 0 ) SqObj.RemoveAllObjectInWorld( old );	
					if( SqPick.GetWorldPickupCount( old ) > 0 ) SqPick.RemoveAllPickupInWorld( old );	
					if( SqVehicles.GetWorldVehicleCount( old1 ) > 0 ) SqVehicles.RemoveAllVehicleInWorld( old1 );	
					if( SqMarker.GetCount( old ) > 0 ) SqMarker.RemoveAllBlipInWorld( old );
				}
			}, 60000, 1 );

			tim.Quiet = false;
		}
		
		if( player.Data.InEvent != "Cash" ) SqJob.DestroyJob( player );
		
		if( SqObj.GetWorldObjectCount( new ) == 0 )
		{
			try 
			{
				foreach( index, value in SqObj.Objects )
				{
					if( value.World == new )
					{
						local object = SqObject.Create( value.Model, value.World, value.Pos, 255 );
						
						value.instance = object;
						
						object.ShotReport = true;
						object.RotateByEuler( value.Rotation, 0 );
						object.SetTag( index );

						value.instance = object;
					}
				}
			}
			catch( e ) player.Msg( TextColor.Error, Lang.SpawnObjectError[ player.Data.Language ], e );
		}
		
		if( SqPick.GetWorldPickupCount( new ) == 0 )
		{
			try 
			{
				foreach( index, value in SqPick.Pickups )
				{
					if( value.World == new )
					{
						local pickup = SqPickup.Create( value.Model, value.World, 1, value.Pos, 255, false );

						value.instance = pickup;
						
						value.instance.SetTag( index );
					}
				}
			}
			catch( e ) player.Msg( TextColor.Error, Lang.SpawnPickupError[ player.Data.Language ], e );	
		}
		
		if( SqVehicles.GetWorldVehicleCount( new1 ) == 0 && new != "123456" )
		{
			try 
			{
				foreach( index, value in SqVehicles.Vehicles )
				{
					if( value.SpawnData.Vehicle.tostring() == "-1" )
					{
						if( value.SpawnData.World == new1 )
						{
							value.SpawnData.Vehicle 				= SqVehicle.Create( value.SpawnData.Model, value.SpawnData.World, value.SpawnData.Pos, 0, value.SpawnData.Color1, value.SpawnData.Color2 );
							value.SpawnData.Vehicle.EulerRotation	= value.SpawnData.Rotation;
							value.SpawnData.Vehicle.Radio 			= ( value.Prop.Radio == "off" ) ? 0 : 255;
							if( value.SpawnData.Vehicle.Health == 2000 ) value.SpawnData.Vehicle.Health += 1000;

							value.SpawnData.Vehicle.SetTag( index );

							foreach( index1, value1 in value.Prop.Handling ) value.SpawnData.Vehicle.SetHandlingRule( index1.tointeger(), value1.Modify.tointeger() );
						}
					}
				}
			}
			catch( e ) player.Msg( TextColor.Error, Lang.SpawnVehicleError[ player.Data.Language ], e );
		}

		if( SqMarker.GetCount( new ) == 0 )
		{
			try 
			{
				foreach( index, value in SqMarker.Blips )
				{
					if( value.World == new )
					{
						value.instance = SqBlip.Create( value.World, value.Pos, value.Size, value.Color, value.Type );
						value.instance.SetTag( index.tostring() );
					}
				}
			}
			catch( e ) player.Msg( TextColor.Error, Lang.CreateMarkerError[ player.Data.Language ], e );	
		}

		/*if( old == 100 )
		{
			player.Data.IsEvent = null;

			if( SqMath.IsLess( SqAD.GetTeamPlayer( "red" ), 1 ) ) SqAD.EndRound( 3 );
			if( SqMath.IsLess( SqAD.GetTeamPlayer( "blue" ), 1 ) ) SqAD.EndRound( 2 );
		}*/
	}
});