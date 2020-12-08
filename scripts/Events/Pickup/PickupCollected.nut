SqCore.On().PickupCollected.Connect( this, function( player, pickup ) 
{
	try 
	{
		local Pickup = SqPick.Pickups[ pickup.Tag ];
		
		switch( Pickup.Type )
		{
			case "Pizza":
			if( player.Vehicle )
			{
				if( player.Vehicle.Model == 178 )
				{
					if( player.Data.Job[ "Pizza" ].Stock > 0 )
					{
						local rand_reward = ( rand()%500 );
						player.Msg( TextColor.Sucess, Lang.DeliverScs[ player.Data.Language ] );
						
						player.Data.Job[ "Pizza" ].Stock --;
						
						player.Data.Job[ "Pizza" ].Income += rand_reward;
						
						SqJob.RemoveAllPizzaPickup( player );

						if( player.Data.Job[ "Pizza" ].Stock < 1 ) player.Msg( TextColor.InfoS, Lang.NoStockLeft[ player.Data.Language ] );
						else SqJob.AddPizzaPickup( player );
					}
					else player.Msg( TextColor.InfoS, Lang.NoStockLeft[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotInPizzaBoi[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotInPizzaBoi[ player.Data.Language ] );
			break;
			
			case "StartPizzaJob":
			if( !player.Vehicle )
			{
				if( !player.Data.Job.rawin( "Pizza" ) )
				{
					player.Data.Job.rawset( "Pizza",
					{
						Stock	= 0,
						Income	= 0,
					});
								
					player.Msg( TextColor.InfoS, Lang.StartAsPizzaBoy[ player.Data.Language ] );
				}
				
				else 
				{
					player.Data.Job = {};
					
					SqJob.RemoveAllPizzaPickup( player );
					
					player.Msg( TextColor.InfoS, Lang.EndPizzaBoy[ player.Data.Language ] );
				}
			}
			else player.Msg( TextColor.Error, Lang.CantEnterPickupInVehicle[ player.Data.Language ] );
			break;
			
			case "RestockPizza":
			if( player.Data.Job.rawin( "Pizza" ) )
			{
				if( player.Vehicle )
				{
					if( player.Vehicle.Model == 178 )
					{
						if( player.Data.Job[ "Pizza" ].Stock != 5 )
						{
							player.Data.Job[ "Pizza" ].Stock = 5;
					
							player.Msg( TextColor.InfoS, Lang.RestockPizza[ player.Data.Language ] );
							
							SqJob.RemoveAllPizzaPickup( player );
							
							SqJob.AddPizzaPickup( player );
						}
						else player.Msg( TextColor.Error, Lang.NoNeedStockPizza[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotInPizzaBoi2[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotInPizzaBoi2[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotPizzaBoi3[ player.Data.Language ] );
			break;
			
			default:
			if( SqPick.AllowPick( player, pickup ) )
			{
				if( Pickup.Message != "N/A" ) player.Msg( TextColor.InfoS, Lang.WorldWelcomeMessage[ player.Data.Language ], Pickup.Message );
				
				if( Pickup.Sound != "N/A" )
				{
					local stripValue = split( Pickup.Sound, " " );
						
					if( stripValue[1] == "true" ) PlaySound( pickup.World, stripValue[0].tointeger(), pickup.Pos );
					else player.PlaySound( stripValue[0].tointeger() );
				}
					
				if( Pickup.Extra != "" )
				{
					switch( Pickup.Type )
					{
						case "Health Increase":
						player.Health	+= Pickup.Extra.tointeger();
						if( SqMath.IsGreaterEqual( player.Health, 99 ) ) player.Health = 100;
						
						player.Msg( TextColor.InfoS, Lang.PickedHealInc[ player.Data.Language ], Pickup.Extra );
						break;
							
						case "Health Decrease":
						player.Health	-= Pickup.Extra.tointeger();
						
						player.Msg( TextColor.InfoS, Lang.PickedHealDec[ player.Data.Language ], Pickup.Extra );
						break;
							
						case "Weapon":
						local stripValue = split( Pickup.Extra, " " );
							
						player.SetWeapon( stripValue[0].tointeger(), stripValue[1].tointeger() );
						
						player.Msg( TextColor.InfoS, Lang.PickedWep[ player.Data.Language ], GetWeaponName( stripValue[0].tointeger() ), TextColor.InfoS, stripValue[1] );
						break;

						case "Objmovepos":
						local stripValue = split( Pickup.Extra, " " ), object1 = SqFind.Object.TagMatches( false, false, stripValue[0].tolower() );
						
						if( object1.tostring() != "-1" ) object1.MoveTo( Vector3.FromStr( stripValue[1] ), stripValue[2].tointeger() );
							
						else 
						{
							SqDatabase.Exec( format( "DELETE FROM Pickups WHERE UID = '%s'", pickup.Tag ) );

							SqPick.Pickups.rawdelete( pickup.Tag );

							pickup.Destroy();
							
							player.Msg( TextColor.Error, Lang.PickedObjNotFound[ player.Data.Language ] );
						}
						break;
							
						case "Objmoverot":
						local stripValue = split( Pickup.Extra, " " ), object1 = SqFind.Object.TagMatches( false, false, stripValue[0].tolower() );
							
						if( object1.tostring() != "-1" ) object1.RotateToEuler( Vector3.FromStr( stripValue[1] ), stripValue[2].tointeger() );
							
						else 
						{
							SqDatabase.Exec( format( "DELETE FROM Pickups WHERE UID = '%s'", pickup.Tag ) );

							SqPick.Pickups.rawdelete( pickup.Tag );

							pickup.Destroy();
							
							player.Msg( TextColor.Error, Lang.PickedObjNotFound[ player.Data.Language ] );
						}
						break;
							
						case "Cash":
						local stripValue = split( Pickup.Extra, " " )
							
						if( SqMath.IsGreaterEqual( stripValue[0].tointeger(), stripValue[1].tointeger() ) )
						{
							Pickup.Extra = ( stripValue[0].tointeger() - stripValue[1].tointeger() ) + " " +  stripValue[1];

							SqPick.Save( pickup.Tag );
								
							player.Data.Stats.Cash += stripValue[1].tointeger();
							
							player.Msg( TextColor.InfoS, Lang.PickedCash[ player.Data.Language ], SqInteger.ToThousands( stripValue[1].tointeger() ) );
						}
							
						else 
						{
							SqDatabase.Exec( format( "DELETE FROM Pickups WHERE UID = '%s'", pickup.Tag ) );

							SqPick.Pickups.rawdelete( pickup.Tag );

							pickup.Destroy();
							
							player.Msg( TextColor.Error, Lang.PickedNoCash[ player.Data.Language ] );
						}
						break;
							
						case "Teleport":
						player.Pos	= Vector3.FromStr( Pickup.Extra );
						break;

						case "Explosive":
						local stripValue = split( Pickup.Extra, " " );

						CreateExplosion( player.World, stripValue[1].tointeger(), Vector3.FromStr( stripValue[0] ), player, false );
						break;
					}
				}
			}
			else player.Msg( TextColor.Error, Lang.NoPermissionPick[ player.Data.Language ] );
			break;
		}
	}
	catch( e ) player.Msg( TextColor.Error, Lang.PickPickupError[ player.Data.Language ], e );
});