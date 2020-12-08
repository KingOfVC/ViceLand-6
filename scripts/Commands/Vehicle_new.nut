class CCmdVehicle
{
	function GetVehicle( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.Interior )
				{
					if( !player.Data.InEvent )
					{
						if( SqWorld.GetWorldPermission( player, "vehspawning" ) )
						{
							if( !player.Vehicle )
							{
								local result = null;
								
								foreach( index, value in SqVehicles.Vehicles )
								{
									if( value.Prop.Owner == player.Data.AccID )
									{
										if( result ) result = result + "$" + HexColour.Red + "Model " + HexColour.White + SqVehicles.GetVehicleNameFromModel( value.SpawnData.Model ) + HexColour.Red + " Name " + HexColour.White + value.Prop.Name + HexColour.Red + " ID " + HexColour.White + index;
										else result = HexColour.Red + "Model " + HexColour.White + SqVehicles.GetVehicleNameFromModel( value.SpawnData.Model ) + HexColour.Red + " Name " + HexColour.White + value.Prop.Name + HexColour.Red + " ID " + HexColour.White + index;
									}
								}
								
								if( result )
								{
									player.StreamInt( 205 );
									player.StreamString( result );
									player.FlushStream( true );
								}
								
								else player.Msg( TextColor.Error, Lang.VehNotOwnAny[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.VehAlreadyInVehicle[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.VehNotPermissionToSpawn[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			
		return true;
	}


	function BuyVehicle( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.InEvent )
				{
					player.StreamInt( 200 );
					player.StreamString( "" );
					player.FlushStream( true );
				}
				else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			
		return true;
	}

	function GetVehicleInfo( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.Interior )
				{
					if( player.Data.InEvent != "DM" )
					{
						if( player.Vehicle )
						{
							local getveh = SqVehicles.Vehicles[ player.Vehicle.Tag ];
							player.Msg( TextColor.InfoS, Lang.VehInfo[ player.Data.Language ], SqVehicles.GetVehicleNameFromModel( player.Vehicle.Model ), TextColor.InfoS, getveh.Prop.Locked.tostring(), TextColor.InfoS, player.Vehicle.Health );
							if( getveh.Prop.Owner != 100000 ) player.Msg( TextColor.InfoS, Lang.VehInfo1[ player.Data.Language ], SqAccount.GetNameFromID( getveh.Prop.Owner ) );
						}
						else player.Msg( TextColor.Error, Lang.VehNotInVehicle[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			
		return true;
	}

	function EditVehicleHandling( player, command )
	{		
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Type": stripCmd[1], "Value": stripCmd[2] };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( !player.Data.Interior )
					{
						if( player.Data.InEvent != "DM" )
						{
							if( player.Vehicle )
							{
								local getDiscount = ( ( 500/100 ) * Server.Discount.Vehicle.Handling ), countPrice = ( 500 - getDiscount );

								local getVeh = player.Vehicle;
									
								if( SqVehicles.Vehicles[ player.Vehicle.Tag ].Prop.Owner == player.Data.AccID )
								{
									switch( args.Type )
									{
										case "acceleration":
										switch( args.Value )
										{
											case "reset":
											if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling.rawin( "14" ) )
											{
												if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "14" ].Origin != getVeh.GetHandlingRule( 14 ).tostring() )
												{
													SqVehicles.UpdateHandling( getVeh.Tag, 14, getVeh.GetHandlingRule( 14 ), SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "14" ].Origin );
													SqVehicles.Save( getVeh.Tag );	
													
													getVeh.SetHandlingRule( 14, SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "14" ].Origin.tofloat() );
																
													player.Msg( TextColor.Sucess, Lang.EditHandlingReset[ player.Data.Language ], "Acceleration", TextColor.Sucess );
												}
												else player.Msg( TextColor.Error, Lang.VehHandlingResetDefault[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.VehHandlingResetDefault[ player.Data.Language ] );
											break;
											
											default:
											if( SqInteger.IsFloat( args.Value ) )
											{
												if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, countPrice ) )
												{

													SqVehicles.UpdateHandling( getVeh.Tag, 14, getVeh.GetHandlingRule( 14 ), args.Value );
															
													getVeh.SetHandlingRule( 14, args.Value.tofloat() );
													
													SqVehicles.Save( getVeh.Tag );
													
													player.Data.Stats.Coin -= countPrice;
													
													player.Msg( TextColor.Sucess, Lang.EditHandling[ player.Data.Language ], "Acceleration", TextColor.Sucess, args.Value.tofloat(), TextColor.Sucess, SqInteger.ToThousands( countPrice ) );
												}
												else player.Msg( TextColor.Error, Lang.VehNeedCointoEditHandling[ player.Data.Language ], SqInteger.ToThousands( countPrice ) );
											}
											else player.Msg( TextColor.Error, Lang.VehEditHandlingNoFloat[ player.Data.Language ] );
											break;
										}
										break;
										
										case "maxspeed":
										switch( args.Value )
										{
											case "reset":
											if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling.rawin( "13" ) )
											{
												if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "13" ].Origin != getVeh.GetHandlingRule( 13 ).tostring() )
												{
													SqVehicles.UpdateHandling( getVeh.Tag, 13, getVeh.GetHandlingRule( 13 ), SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "13" ].Origin );
													SqVehicles.Save( getVeh.Tag );	
													
													getVeh.SetHandlingRule( 13, SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "13" ].Origin.tofloat() );
																
													player.Msg( TextColor.Sucess, Lang.EditHandlingReset[ player.Data.Language ], "Max speed", TextColor.Sucess );
												}
												else player.Msg( TextColor.Error, Lang.VehHandlingResetDefault[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.VehHandlingResetDefault[ player.Data.Language ] );
											break;
											
											default:
											if( SqInteger.IsFloat( args.Value ) )
											{
												if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, countPrice ) )
												{

													SqVehicles.UpdateHandling( getVeh.Tag, 13, getVeh.GetHandlingRule( 13 ), args.Value );
															
													getVeh.SetHandlingRule( 13, args.Value.tofloat() );
													
													SqVehicles.Save( getVeh.Tag );
													
													player.Data.Stats.Coin -= countPrice;
													
													player.Msg( TextColor.Sucess, Lang.EditHandling[ player.Data.Language ], "Max speed", TextColor.Sucess, args.Value.tofloat(), TextColor.Sucess, SqInteger.ToThousands( countPrice ) );
												}
												else player.Msg( TextColor.Error, Lang.VehNeedCointoEditHandling[ player.Data.Language ], SqInteger.ToThousands( countPrice ) );
											}
											else player.Msg( TextColor.Error, Lang.VehEditHandlingNoFloat[ player.Data.Language ] );
											break;
										}
										break;
										
										case "traction":
										switch( args.Value )
										{
											case "reset":
											if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling.rawin( "9" ) )
											{
												if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "9" ].Origin != getVeh.GetHandlingRule( 9 ).tostring() )
												{
													SqVehicles.UpdateHandling( getVeh.Tag, 9, getVeh.GetHandlingRule( 9 ), SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "9" ].Origin );
													SqVehicles.Save( getVeh.Tag );	
													
													getVeh.SetHandlingRule( 9, SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "9" ].Origin.tofloat() );
																
													player.Msg( TextColor.Sucess, Lang.EditHandlingReset[ player.Data.Language ], "Traction", TextColor.Sucess );
												}
												else player.Msg( TextColor.Error, Lang.VehHandlingResetDefault[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.VehHandlingResetDefault[ player.Data.Language ] );
											break;
											
											default:
											if( SqInteger.IsFloat( args.Value ) )
											{
												if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, countPrice ) )
												{

													SqVehicles.UpdateHandling( getVeh.Tag, 9, getVeh.GetHandlingRule( 9 ), args.Value );
															
													getVeh.SetHandlingRule( 9, args.Value.tofloat() );
													
													SqVehicles.Save( getVeh.Tag );
													
													player.Data.Stats.Coin -= countPrice;
													
													player.Msg( TextColor.Sucess, Lang.EditHandling[ player.Data.Language ], "Traction", TextColor.Sucess, args.Value.tofloat(), TextColor.Sucess, SqInteger.ToThousands( countPrice )  );
												}
												else player.Msg( TextColor.Error, Lang.VehNeedCointoEditHandling[ player.Data.Language ], TextColor.Sucess, SqInteger.ToThousands( countPrice ) );
											}
											else player.Msg( TextColor.Error, Lang.VehEditHandlingNoFloat[ player.Data.Language ] );
											break;
										}
										break;
										
										case "brake":
										switch( args.Value )
										{
											case "reset":
											if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling.rawin( "17" ) )
											{
												if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "17" ].Origin != getVeh.GetHandlingRule( 17 ).tostring() )
												{
													SqVehicles.UpdateHandling( getVeh.Tag, 17, getVeh.GetHandlingRule( 17 ), SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "17" ].Origin );
													SqVehicles.Save( getVeh.Tag );	
													
													getVeh.SetHandlingRule( 17, SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "17" ].Origin.tofloat() );
																
													player.Msg( TextColor.Sucess, Lang.EditHandlingReset[ player.Data.Language ], "Brakes", TextColor.Sucess );
												}
												else player.Msg( TextColor.Error, Lang.VehHandlingResetDefault[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.VehHandlingResetDefault[ player.Data.Language ] );
											break;
											
											default:
											if( SqInteger.IsFloat( args.Value ) )
											{
												if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, countPrice ) )
												{

													SqVehicles.UpdateHandling( getVeh.Tag, 17, getVeh.GetHandlingRule( 17 ), args.Value );
															
													getVeh.SetHandlingRule( 17, args.Value.tofloat() );
													
													SqVehicles.Save( getVeh.Tag );
													
													player.Data.Stats.Coin -= countPrice;
													
													player.Msg( TextColor.Sucess, Lang.EditHandling[ player.Data.Language ], "Brakes", TextColor.Sucess, args.Value.tofloat(), TextColor.Sucess, SqInteger.ToThousands( countPrice ) );
												}
												else player.Msg( TextColor.Error, Lang.VehNeedCointoEditHandling[ player.Data.Language ], SqInteger.ToThousands( countPrice ) );
											}
											else player.Msg( TextColor.Error, Lang.VehEditHandlingNoFloat[ player.Data.Language ] );
											break;
										}
										break;
										
										case "suspension":
										switch( args.Value )
										{
											case "reset":
											if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling.rawin( "24" ) )
											{
												if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "24" ].Origin != getVeh.GetHandlingRule( 24 ).tostring() )
												{
													SqVehicles.UpdateHandling( getVeh.Tag, 24, getVeh.GetHandlingRule( 24 ), SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "24" ].Origin );
													SqVehicles.Save( getVeh.Tag );	
													
													getVeh.SetHandlingRule( 24, SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "24" ].Origin.tofloat() );
																
													player.Msg( TextColor.Sucess, Lang.EditHandlingReset[ player.Data.Language ], "Suspension", TextColor.Sucess, args.Value.tofloat(), TextColor.Sucess, SqInteger.ToThousands( countPrice ) )
												}
												else player.Msg( TextColor.Error, Lang.VehHandlingResetDefault[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.VehHandlingResetDefault[ player.Data.Language ] );
											break;
											
											default:
											if( SqInteger.IsFloat( args.Value ) )
											{
												if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, countPrice ) )
												{

													SqVehicles.UpdateHandling( getVeh.Tag, 24, getVeh.GetHandlingRule( 24 ), args.Value );
															
													getVeh.SetHandlingRule( 24, args.Value.tofloat() );
													
													SqVehicles.Save( getVeh.Tag );
													
													player.Data.Stats.Coin -= countPrice;
													
													player.Msg( TextColor.Sucess, Lang.EditHandling[ player.Data.Language ], "Suspension", TextColor.Sucess, args.Value.tofloat(), TextColor.Sucess, SqInteger.ToThousands( countPrice ) );
												}
												else player.Msg( TextColor.Error, Lang.VehNeedCointoEditHandling[ player.Data.Language ], SqInteger.ToThousands( countPrice ) );
											}
											else player.Msg( TextColor.Error, Lang.VehEditHandlingNoFloat[ player.Data.Language ] );
											break;
										}
										break;
										
										default:
										player.Msg( TextColor.Error, Lang.VehEditHandlingSyntax[ player.Data.Language ] );
										break;
									}
								}
								else player.Msg( TextColor.Error, Lang.VehNotOwner[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.VehNotInVehicle[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.VehEditHandlingSyntax[ player.Data.Language ] );
			
		return true;
	}

	function SellVehicle( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.Interior )
				{
					if( player.Data.InEvent != "DM" )
					{
						if( player.Vehicle )
						{
							local getVeh = player.Vehicle;
								
							if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Owner == player.Data.AccID )
							{
								local getPrice = ( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Price / 2 );

								player.Data.Stats.Coin += getPrice;
								
								player.Msg( TextColor.Sucess, Lang.VehSell[ player.Data.Language ], SqVehicles.GetVehicleNameFromModel( getVeh.Model ), TextColor.Sucess, SqInteger.ToThousands( getPrice ) );

								SqDatabase.Exec( format( "DELETE FROM Vehicles WHERE ID = '%s'", getVeh.Tag ) );
								
								SqVehicles.Vehicles[ getVeh.Tag ].SpawnData.Vehicle.Destroy();
								SqVehicles.Vehicles[ getVeh.Tag ].SpawnData.Vehicle = SqVehicle.NullInst();
								
								SqVehicles.Vehicles.rawdelete( getVeh.Tag );
							}
							else player.Msg( TextColor.Error, Lang.VehNotOwner[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.VehNotInVehicle[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			
		return true;
	}

	function ParkVehicle( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
			//	if( !player.Data.Interior )
			//	{
			//		if( !player.Data.InEvent )
				//	{
						if( player.Vehicle )
						{
							local getVeh = player.Vehicle;
								
							if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Owner == player.Data.AccID )
							{
								if( SqWorld.GetPrivateWorld( player.World ) )
								{
									if( SqWorld.GetWorldPermission( player, "vehspawning" ) )
									{
										player.Vehicle.SetSpawnPos( player.Vehicle.Pos.x,  player.Vehicle.Pos.y, player.Vehicle.Pos.z );
										player.Vehicle.SetSpawnEulerRotation( player.Vehicle.EulerRotation.x, player.Vehicle.EulerRotation.y, player.Vehicle.EulerRotation.z );
										
										SqVehicles.Vehicles[ getVeh.Tag ].SpawnData.Pos			= player.Vehicle.Pos;
										SqVehicles.Vehicles[ getVeh.Tag ].SpawnData.Rotation	= player.Vehicle.EulerRotation;
										SqVehicles.Vehicles[ getVeh.Tag ].SpawnData.World		= player.World;

										SqVehicles.Save( getVeh.Tag );

										player.Msg( TextColor.Sucess, Lang.VehPark[ player.Data.Language ] );
									}
								else player.Msg( TextColor.Error, Lang.VehNoPermissionPark[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.VehCantParkInPublic[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.VehNotOwner[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.VehNotInVehicle[ player.Data.Language ] );
			//		}
			//		else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
			//	}
			//	else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			
		return true;
	}


	function VehicleSetting( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
		{
			args = { "Type": stripCmd[1], "Value": ::GetTok( command, " ", 3, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( !player.Data.Interior )
					{
						if( player.Data.InEvent != "DM" )
						{
							if( player.Vehicle )
							{
								local getVeh = player.Vehicle;
								
								if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Owner == player.Data.AccID )
								{
									switch( args.Type )
									{
										case "name":
										if( player.Data.GetInventoryItem( "VehTag" ) )
										{
											if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
											{
												SqVehicles.Vehicles[ getVeh.Tag ].Prop.Name	= args.Value;
											
												SqVehicles.Save( getVeh.Tag );

												local deduQuatity = player.Data.Player.Inventory[ "VehTag" ].Quatity.tointeger();
												player.Data.Player.Inventory[ "VehTag" ].Quatity = ( deduQuatity - 1 );
											
												player.Msg( TextColor.Sucess, Lang.VehSettingName[ player.Data.Language ], args.Value );
											}
											else player.Msg( TextColor.Error, Lang.VehSettingNameSyntax[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "VehTag" ) );
										break;
										
										case "lock":
										switch( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Locked )
										{
											case true:
											SqVehicles.Vehicles[ getVeh.Tag ].Prop.Locked	= false;
											SqVehicles.Save( getVeh.Tag );
											
											player.Msg( TextColor.Sucess, Lang.VehSettingUnlock[ player.Data.Language ] );
											break;
											
											case false:
											SqVehicles.Vehicles[ getVeh.Tag ].Prop.Locked	= true;
											SqVehicles.Save( getVeh.Tag );
											
											player.Msg( TextColor.Sucess, Lang.VehSettingLock[ player.Data.Language ] );
											break;
										}
										break;
										
										case "radio":
										switch( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Radio )
										{
											case "off":
											SqVehicles.Vehicles[ getVeh.Tag ].Prop.Radio	= "custom";
											SqVehicles.Save( getVeh.Tag );
											
											player.Vehicle.Radio = ( 10 + player.ID );									
											player.Msg( TextColor.Sucess, Lang.VehSettingCustomRadio[ player.Data.Language ] );
											break;
											
											case "custom":
											SqVehicles.Vehicles[ getVeh.Tag ].Prop.Radio	= "off";
											SqVehicles.Save( getVeh.Tag );
											
											player.Vehicle.Radio = 0;
											player.Msg( TextColor.Sucess, Lang.VehSettingOffRadio[ player.Data.Language ] );
											break;
										}
										break;
										
										case "color1":
										if( stripCmd.len() == 3 )
										{
											if( SqStr.AreAllDigit( args.Value.tostring() ) )
											{
												SqVehicles.Vehicles[ getVeh.Tag ].SpawnData.Color1 = args.Value.tointeger();
												SqVehicles.Save( getVeh.Tag );
														
												player.Vehicle.PrimaryColor = args.Value.tointeger();
														
												player.Msg( TextColor.Sucess, Lang.VehSettingColor1[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.VehSettingCol1Syntax[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.VehSettingCol1Syntax[ player.Data.Language ] );
										break;
										
										case "color2":
										if( stripCmd.len() == 3 )
										{
											if( SqStr.AreAllDigit( args.Value.tostring() ) )
											{
												SqVehicles.Vehicles[ getVeh.Tag ].SpawnData.Color1 = args.Value.tointeger();
												SqVehicles.Save( getVeh.Tag );
														
												player.Vehicle.SecondaryColor = args.Value.tointeger();
														
												player.Msg( TextColor.Sucess, Lang.VehSettingColor2[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.VehSettingCol2Syntax[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.VehSettingCol2Syntax[ player.Data.Language ] );
										break;

										case "flying":
										if( SqVehicles.VehicleType( getVeh.Model ) == "Car" || SqVehicles.VehicleType( getVeh.Model ) == "Bike" )
										{
											if( stripCmd.len() == 3 )
											{
												if( args.Value == "reset" )
												{
													if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling.rawin( "32" ) )
													{
														if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "32" ].Origin != getVeh.GetHandlingRule( 32 ).tostring() )
														{
															SqVehicles.UpdateHandling( getVeh.Tag, 32, getVeh.GetHandlingRule( 32 ), 0 );
															SqVehicles.Save( getVeh.Tag );	
															
															getVeh.SetHandlingRule( 32, SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "32" ].Origin.tofloat() );
																		
															player.Msg( TextColor.Sucess, Lang.VehSettingDisableFlying[ player.Data.Language ] );
														}
														else player.Msg( TextColor.Error, Lang.VehSettingAlreadyXFlying[ player.Data.Language ] );
													}
													else player.Msg( TextColor.Error, Lang.VehSettingAlreadyXFlying[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.VehSettingFlyingSyntax[ player.Data.Language ] );
											}	
											
											else
											{
												if( !SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling.rawin( "32" ) ) SqVehicles.UpdateHandling( getVeh.Tag, 32, getVeh.GetHandlingRule( 32 ), 0 );

												if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Handling[ "32" ].Modify.tostring() == "0" )
												{
													if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, countPrice ) )
													{
														SqVehicles.UpdateHandling( getVeh.Tag, 32, getVeh.GetHandlingRule( 32 ), 1 );
																		
														getVeh.SetHandlingRule( 32, 1 );
																
														SqVehicles.Save( getVeh.Tag );
																
														player.Data.Stats.Coin -= countPrice;
															
														player.Msg( TextColor.Sucess, Lang.VehSettingAddFlying[ player.Data.Language ], SqInteger.ToThousands( countPrice ) );
													}
													else player.Msg( TextColor.Error, Lang.VehNeedCoinToAddFlying[ player.Data.Language ], SqInteger.ToThousands( countPrice ) );
												}
												else  player.Msg( TextColor.Error, Lang.VehSettingAlreadyFlying[ player.Data.Language ] );
											}
										}
										else player.Msg( TextColor.Error, Lang.VehSettingModOnlyCar[ player.Data.Language ] );
										break;
										
										case "armour":
										if( stripCmd.len() == 2 )
										{
											if( args.Value == "reset" )
											{
												if( SqVehicles.Vehicles[ getVeh.Tag ].SpawnData.Armour == 2000 )
												{
													SqVehicles.Vehicles[ getVeh.Tag ].SpawnData.Armour = 1000;
													SqVehicles.Save( getVeh.Tag );	
															
													player.Msg( TextColor.Sucess, Lang.VehSettingRemoveArmour[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.VehSettingNoArmour[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.VehSettingArmourSyntax[ player.Data.Language ] );
										}
										
										else
										{
											if( SqVehicles.Vehicles[ getVeh.Tag ].SpawnData.Armour != 2000 )
											{
												local countPrice = 20;
												if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, countPrice ) )
												{
													SqVehicles.Vehicles[ getVeh.Tag ].SpawnData.Armour = 2000;
													SqVehicles.Save( getVeh.Tag );
															
													player.Data.Stats.Coin -= countPrice;
													
													player.Msg( TextColor.Sucess, Lang.VehSettingAddArmour[ player.Data.Language ], SqInteger.ToThousands( countPrice ) );
												}
												else player.Msg( TextColor.Error, Lang.VehNeedCoinToAddArmour[ player.Data.Language ], SqInteger.ToThousands( countPrice ) );
											}
											else player.Msg( TextColor.Error, Lang.VehSettingAlreadyHasArmour[ player.Data.Language ] );
										}
										break;
						
										case "hydraulics":
										if( SqVehicles.VehicleType( getVeh.Model ) == "Car" || SqVehicles.VehicleType( getVeh.Model ) == "Bike" )
										{
											if( stripCmd.len() == 2 )
											{
												if( args.Value == "reset" )
												{
													if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Hydraulics )
													{
														SqVehicles.Vehicles[ getVeh.Tag ].Prop.Hydraulics = false;
														SqVehicles.Save( getVeh.Tag );	
																
														player.Msg( TextColor.Sucess, Lang.VehSettingRemoveHydraulics[ player.Data.Language ] );
													}
													else player.Msg( TextColor.Error, Lang.VehSettingNoHydraulics[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.VehSettingHydraulicsSyntax[ player.Data.Language ] );
											}
											
											else
											{
												if( !SqVehicles.Vehicles[ getVeh.Tag ].Prop.Hydraulics )
												{
													if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, countPrice ) )
													{
														SqVehicles.Vehicles[ getVeh.Tag ].Prop.Hydraulics = true;
														SqVehicles.Save( getVeh.Tag );
																
														player.Data.Stats.Coin -= countPrice;
														
														player.Msg( TextColor.Sucess, Lang.VehSettingAddHydraulics[ player.Data.Language ], SqInteger.ToThousands( countPrice ), TextColor.Sucess );
													}
													else player.Msg( TextColor.Error, Lang.VehNeedCoinToAddHydraulics[ player.Data.Language ], SqInteger.ToThousands( countPrice ) );
												}
												else player.Msg( TextColor.Error, Lang.VehSettingAlreadyHasHydraulics[ player.Data.Language ] );
											}
										}
										else player.Msg( TextColor.Error, Lang.VehSettingModOnlyCar[ player.Data.Language ] );
										break;

										break;

										default:
										player.Msg( TextColor.Error, Lang.VehSettingSyntax[ player.Data.Language ] );
										break;
									}
								}
								else player.Msg( TextColor.Error, Lang.VehNotOwner[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.VehNotInVehicle[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.VehSettingSyntax[ player.Data.Language ] );

		return true;
	}

	function EjectFromVehicle( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.Interior )
				{
					if( player.Data.InEvent != "DM" )
					{
						if( player.Vehicle )
						{
							player.Disembark();
								
							player.Msg( TextColor.Sucess, Lang.VehEject[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.VehNotInVehicle[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			
		return true;
	}

	function FixVehicle( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.Interior )
				{
					if( player.Data.InEvent != "DM" )
					{
						if( player.Vehicle )
						{
							if( !SqDM.IsHealing( player ) )
							{
								if( SqWorld.GetWorldPermission2( player, "fix" ) )
								{
									if( SqMath.IsGreaterEqual( player.Data.Stats.Cash, SqVehicles.GetHealingPrice( player, player.Vehicle.Health ) ) )
									{
										if( SqWorld.IsStunt( player.World ) )
										{
											local getPriceStr = ( SqVehicles.GetHealingPrice( player, player.Vehicle.Health ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqVehicles.GetHealingPrice( player, player.Vehicle.Health ) );
												
											player.Vehicle.Health	= SqVehicles.Vehicles[ player.Vehicle.Tag ].SpawnData.Armour;
											player.Vehicle.Fix();
													
											player.Data.Stats.Cash	-= SqVehicles.GetHealingPrice( player, player.Vehicle.Health );
											player.Data.Stats.TotalSpend += SqVehicles.GetHealingPrice( player, player.Vehicle.Health );
													
											player.Msg( TextColor.Sucess, Lang.VehFix[ player.Data.Language ] );
										}
	
										else 
										{
											player.Msg( TextColor.InfoS, Lang.VehFixing[ player.Data.Language ] );
													
											player.MakeTask( function( pos )
											{
												if ( this.Data == null ) this.Data = 0;

												if( pos.tostring() == player.Pos.tostring() )
												{
													if( player.Vehicle )
													{
														if( ++this.Data > 5 )
														{
															local getPriceStr = ( SqVehicles.GetHealingPrice( player, player.Vehicle.Health ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqVehicles.GetHealingPrice( player, player.Vehicle.Health ) );
														
															player.Vehicle.Health	= SqVehicles.Vehicles[ player.Vehicle.Tag ].SpawnData.Armour;
															player.Vehicle.Fix();
															
															player.Data.Stats.Cash	-= SqVehicles.GetHealingPrice( player, player.Vehicle.Health );
															player.Data.Stats.TotalSpend += SqVehicles.GetHealingPrice( player, player.Vehicle.Health );
															
															player.Msg( TextColor.Sucess, Lang.VehFix[ player.Data.Language ] );

															this.Terminate();
														}
													}
													
													else
													{
														player.Msg( TextColor.Error, Lang.FixVehFailedNotInVeh[ player.Data.Language ] );
														
														this.Terminate();
													}
												}
												
												else
												{
													player.Msg( TextColor.Error, Lang.FixVehFailedMove[ player.Data.Language ] );
														
													this.Terminate();
												}
											}, 500, 6, player.Pos ).SetTag( "Healing" );
										}
									}
									else player.Msg( TextColor.Error, Lang.VehFixNeedCash[ player.Data.Language ], SqInteger.ToThousands( SqVehicles.GetHealingPrice( player, player.Vehicle.Health ) ) );
								}
								else player.Msg( TextColor.Error, Lang.NoPermissionWorldCmd[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.VehFixAnotherHealInProcess[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.VehNotInVehicle[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			
		return true;
	}

	function FlipVehicle( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.Interior )
				{
					if( player.Data.InEvent != "DM" )
					{
						if( player.Vehicle )
						{
							player.Vehicle.Rotation = Quaternion( 0.0, 0.0, 0.0, 0.0 );
								
							player.Msg( TextColor.Sucess, Lang.VehFlip[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.VehNotInVehicle[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			
		return true;
	}

	function SetVehicleRadioURL( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
		{

			args = { "URL": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( !player.Data.Interior )
					{
						if( player.Data.InEvent != "DM" )
						{
							if( player.Vehicle )
							{
								local getVeh = player.Vehicle;

								if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Owner == player.Data.AccID )
								{
									local getVeh = player.Vehicle;
										
									SqVehicles.Vehicles[ getVeh.Tag ].Prop.RadioURL = args.URL;
									SqVehicles.Save( getVeh.Tag );

									SqServer.CreateRadioStreamEx( ( 15 + player.ID ), true, player.Name, args.URL );
									
									player.Vehicle.Radio = ( 15 + player.ID );
									
									player.Msg( TextColor.Sucess, Lang.VehRadioURLUpdate[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.VehNotOwner[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.VehNotInVehicle[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.VehRadioURLSyntax[ player.Data.Language ] );
			
		return true;
	}

	function DespawnVeh( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.Interior )
				{
					if( player.Data.InEvent != "DM" )
					{
						if( player.Vehicle )
						{
							local getVeh = player.Vehicle;
								
							if( SqVehicles.Vehicles[ getVeh.Tag ].Prop.Owner == player.Data.AccID )
							{
								SqVehicles.Vehicles[ getVeh.Tag ].SpawnData.World		= 123456;

								SqVehicles.Save( getVeh.Tag );

								SqVehicles.Vehicles[ getVeh.Tag ].SpawnData.Vehicle.Destroy();
								SqVehicles.Vehicles[ getVeh.Tag ].SpawnData.Vehicle = SqVehicle.NullInst();

								player.Msg( TextColor.Sucess, Lang.VehDespawn[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.VehNotOwner[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.VehNotInVehicle[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			
		return true;
	}

}