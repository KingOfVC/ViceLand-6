SqCore.On().PlayerKeyPress.Connect(this, function (player, key)
{
	if( player.Data.IsEditing.find( ":" ) >= 0 )
	{	
		local stripType = split( player.Data.IsEditing, ":" );
		
		switch( stripType[0].tolower() )
		{
			case "object":
			local 
			object = SqFind.Object.TagMatches( false, false, player.Data.IsEditing );

			switch( key.Tag )
			{
				case "Up":
				case "Down":
				case "Left":
				case "Right":
				case "Forward":
				case "Backward":
				player.MakeTask( function()
				{
					if( object.tostring() != "-1" )
					{
						switch( key.Tag )
						{
							case "Up":
							switch( player.Data.EditingMode )
							{
								case "XYZ":
								local origin = object.Pos;
								object.Pos = Vector3( origin.x, origin.y, origin.z + player.Data.EditSens );
								break;
								
								case "Angle":
								object.RotateByEulerZ = player.Data.EditSens;
								break;
								
								case "Sens":
								player.Data.EditSens += 0.1;
								player.Msg( TextColor.InfoS, Lang.EditSensPlus[ player.Data.Language ], player.Data.EditSens );
								break;
							}
							break;
							
							case "Down":
							switch( player.Data.EditingMode )
							{
								case "XYZ":
								local origin = object.Pos;
								object.Pos = Vector3( origin.x, origin.y, origin.z - player.Data.EditSens );
								break;
								
								case "Angle":
								object.RotateByEulerZ = -player.Data.EditSens;
								break;
								
								case "Sens":
								player.Data.EditSens -= 0.1;
								player.Msg( TextColor.InfoS, Lang.EditSensMinus[ player.Data.Language ], player.Data.EditSens );
								break;
							}
							break;
							
							case "Left":
							switch( player.Data.EditingMode )
							{
								case "XYZ":
								object.PosX += player.Data.EditSens;
								break;
								
								case "Angle":
								object.RotateByEulerX = player.Data.EditSens;
								break;
							}
							break;
							
							case "Right":
							switch( player.Data.EditingMode )
							{
								case "XYZ":
								object.PosX -= player.Data.EditSens;
								break;
								
								case "Angle":
								object.RotateByEulerX = -player.Data.EditSens;
								break;
							}
							break;
							
							case "Forward":
							switch( player.Data.EditingMode )
							{
								case "XYZ":
								object.PosY += player.Data.EditSens;
								break;
								
								case "Angle":
								object.RotateByEulerY = player.Data.EditSens;
								break;
							}
							break;
							
							case "Backward":
							switch( player.Data.EditingMode )
							{
								case "XYZ":
								object.PosY -= player.Data.EditSens;
								break;
								
								case "Angle":
								object.RotateByEulerY = -player.Data.EditSens;
								break;
							}
							break;
						}
					}
					else 
					{
						this.Terminate();
						player.Data.IsEditing = "";
					}
				}, 100, 0 ).SetTag( "Editing" );
				break;
				
				case "Delete":
				if( !SqObj.IsMoving( player ) )
				{
					SqDatabase.Exec( format( "DELETE FROM Objects WHERE Lower(UID) = '%s'", object.Tag.tolower() ) );

					SqObj.Objects.rawdelete( object.Tag );
						
					if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** deleted object. **Model** %d **World** %d", player.Name, object.Model, player.World ), "mapping" );
					
					object.Destroy();
					
					player.Data.IsEditing = "";
					player.Msg( TextColor.InfoS, Lang.ObjDeleted[ player.Data.Language ] );
				}
				break;
					
				case "Backspace":
				if( !SqObj.IsMoving( player ) )
				{
					object.Alpha          = 255;
					SqObj.Objects[ object.Tag ].IsEditing = false;
					SqObj.Save( object.Tag );
						
					player.Data.IsEditing = "";
					player.Msg( TextColor.InfoS, Lang.ObjSaved[ player.Data.Language ] );
				}
				break;
					
				case "Clone":
				if( !SqObj.IsMoving( player ) )
				{
					try 
					{
						object.Alpha          = 255;
						SqObj.Objects[ object.Tag ].IsEditing = false;
						SqObj.Save( object.Tag );
							
						local object1 = SqObj.Create( player.Data.AccID, object.Model, object.Pos, player.World );
										
						object1.ShotReport  	= true;
						object1.Alpha 			= 150;

						object1.RotateByEuler( object.EulerRotation, 0 );
								
						SqObj.Objects[ object1.Tag ].IsEditing = true;
										
						player.Data.IsEditing = object1.Tag;
						player.Msg( TextColor.Sucess, Lang.ObjClone[ player.Data.Language ], object1.ID );

						if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is cloning object. **Model** %d **World** %d", player.Name, object.Model, player.World ), "mapping" );
					}
					catch( e ) player.Msg( TextColor.Error, Lang.CloneObjectError[ player.Data.Language ], e );
				}
				break;
			}
			break;
				
			case "pickup":
			local pickup = SqFind.Pickup.TagMatches( false, false, player.Data.IsEditing );

			switch( key.Tag )
			{
				case "Up":
				case "Down":
				case "Left":
				case "Right":
				case "Forward":
				case "Backward":
				player.MakeTask( function()
				{
					if( pickup.tostring() != "-1" )
					{
						switch( key.Tag )
						{
							case "Up":
							switch( player.Data.EditingMode )
							{
								case "XYZ":
								local origin = pickup.Pos;
								pickup.Pos = Vector3( origin.x, origin.y, origin.z + player.Data.EditSens );
								break;
										
								case "Sens":
								player.Data.EditSens += 0.1;
								player.Msg( TextColor.InfoS, Lang.EditSensPlus[ player.Data.Language ], player.Data.EditSens );
								break;
							}
							break;
									
							case "Down":
							switch( player.Data.EditingMode )
							{
								case "XYZ":
								local origin = pickup.Pos;
								pickup.Pos = Vector3( origin.x, origin.y, origin.z - player.Data.EditSens );
								break;
																	
								case "Sens":
								player.Data.EditSens -= 0.1;
								player.Msg( TextColor.InfoS, Lang.EditSensMinus[ player.Data.Language ], player.Data.EditSens );
								break;
							}
							break;
									
							case "Left":
							switch( player.Data.EditingMode )
							{
								case "XYZ":
								pickup.PosX += player.Data.EditSens;
								break;
							}
							break;
									
							case "Right":
							switch( player.Data.EditingMode )
							{
								case "XYZ":
								pickup.PosX -= player.Data.EditSens;
								break;
							}
							break;
									
							case "Forward":
							switch( player.Data.EditingMode )
							{
								case "XYZ":
								pickup.PosY += player.Data.EditSens;
								break;
							}
							break;
									
							case "Backward":
							switch( player.Data.EditingMode )
							{
								case "XYZ":
								pickup.PosY -= player.Data.EditSens;
								break;
							}
							break;
						}
					}
					else 
					{
						this.Terminate();
						player.Data.IsEditing = "";
					}
				}, 100, 0 ).SetTag( "Editing" );
				break; 
			
				case "Delete":
				if( !SqObj.IsMoving( player ) )
				{
					SqDatabase.Exec( format( "DELETE FROM Pickups WHERE Lower(UID)= '%s'", pickup.Tag.tolower() ) );

					SqPick.Pickups.rawdelete( pickup.Tag );

					pickup.Destroy();
							
					player.Data.IsEditing = "";
					player.Msg( TextColor.InfoS, Lang.PickupDel[ player.Data.Language ] );
				}
				break;
							
				case "Backspace":
				if( !SqObj.IsMoving( player ) )
				{
					pickup.Alpha          = 255;
					SqPick.Pickups[ pickup.Tag ].IsEditing = false;

					SqPick.Save( pickup.Tag );
								
					player.Data.IsEditing = "";
					player.Msg( TextColor.InfoS, Lang.PickSaved[ player.Data.Language ] );
				}
				break;
			}
			break;
		}
	}
	
	switch( key.Tag )
	{
		case "F2":
		switch( player.Data.EditingMode )
		{
			case "XYZ":
			player.Data.EditingMode = "Angle";
			player.Msg( TextColor.InfoS, Lang.ChangeEditType[ player.Data.Language ], "Angle" );
			break;
					
			case "Angle":
			if( player.Data.IsEditing.find( ":" ) >= 0 )
			{	
				player.Data.EditingMode = "Sens";
				player.Msg( TextColor.InfoS, Lang.ChangeEditType[ player.Data.Language ], "Sensitivity Adjust" );
				player.Msg( TextColor.InfoS, Lang.ChangeEditTypeTips[ player.Data.Language ] );
			}

			else 
			{
				player.Data.EditingMode = "XYZ";
				player.Msg( TextColor.InfoS, Lang.ChangeEditType[ player.Data.Language ], "XYZ" );
			}
			break;
					
			case "Sens":
			player.Data.EditingMode = "XYZ";
			player.Msg( TextColor.InfoS, Lang.ChangeEditType[ player.Data.Language ], "XYZ" );
			break;
		}
		break;

		case "F4":
		player.Data.AutoSpawn = false;
		player.Msg( TextColor.Sucess, Lang.F4Pressed[ player.Data.Language ] );
		break;
	}

	if( player.Vehicle )
	{
		if( SqVehicles.Vehicles[ player.Vehicle.Tag ].Prop.Hydraulics )
		{
			switch( key.Tag )
			{
				case "Numleft":
				case "H":
				player.Vehicle.RelTurnSpeed = Vector3( 0.0, 0.035, 0.0 );
				break;

				case "Numright":
				case  "K":
				player.Vehicle.RelTurnSpeed = Vector3( 0.0, -0.035, 0.0 );
				break

				case "Numdown":
				case "J":
				player.Vehicle.RelTurnSpeed = Vector3( 0.06, 0.0, 0.0 );
				break;

				case "Numup":
				case "U":
				player.Vehicle.RelTurnSpeed = Vector3( -0.06, 0.0, 0.0 );
				break;
			}
		}
				
		if( SqWorld.IsStunt( player.World ) )
		{
			switch( key.Tag )
			{
				case "Boost":
				player.Vehicle.RelSpeed = Vector3( ( player.Vehicle.RelSpeed.x * 1.25 ), ( player.Vehicle.RelSpeed.y * 1.25 ), ( player.Vehicle.RelSpeed.z * 1.25 ) );
				break;

				case "Fix":
				player.Vehicle.Fix();
				break;

				case "Stop":
				player.Vehicle.RelSpeed = Vector3( 0,0,0 );
				break;

				case "Flip":
				if( player.Vehicle.Rotation.x < 0.7 )
				{			
					player.Vehicle.EulerRotation = Vector3( 1, 0, 0 );	
					player.Vehicle.Fix();
				}		
				break;

				case "Boost2":
			    player.Vehicle.RelSpeedZ += 0.50;
			    break;
			}
		}
	}

});
