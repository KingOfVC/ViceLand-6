class CCmdVehicle2
{
	Cmd					= null;
	
	Editvehhandling		= null;
	CreateAVehicle 		= null;
	CreateAVehicle2 	= null;

	constructor( instance )
	{
		this.Cmd = instance;
		
		this.Cmd.BindFail( this, this.funcFailCommand );

		this.Editvehhandling	= this.Cmd.Create( "editvehhandling", "s|g", [ "Type", "Value" ], 2, 2, -1, true, true );
		this.CreateAVehicle		= this.Cmd.Create( "spawnveh", "s", [ "Vehicle" ], 1, 1, -1, true, true );
		this.CreateAVehicle2	= this.Cmd.Create( "spawnveh2", "s|i|i|s", [ "Vehicle", "Color1", "Color2", "Team" ], 4, 4, -1, true, true );

		
		this.Editvehhandling.BindExec( this.Editvehhandling, this.EditVehicleHandling );
		this.CreateAVehicle.BindExec( this.CreateAVehicle, this.SpawnVehicle );
		this.CreateAVehicle2.BindExec( this.CreateAVehicle2, this.SpawnVehicle2 );
	}


	function funcFailCommand( type, msg, payload )
	{
		local player = this.Cmd.Invoker, cmd = this.Cmd.Command;

		switch( type )
		{
			case SqCmdErr.IncompleteArgs:
			case SqCmdErr.UnsupportedArg:
			switch( cmd )
			{
				case "editvehhandling":
				return player.Msg( TextColor.Error, Lang.VehEditHandlingSyntax[ player.Data.Language ] );

				case "spawnveh":
				return player.Msg( TextColor.Error, Lang.ASpawnvehSyntax[ player.Data.Language ] );

				case "spawnveh2":
				return player.Msg( TextColor.Error, Lang.ASpawnvehSyntax[ player.Data.Language ] );

			}
		}
	}

	function EditVehicleHandling( player, args )
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
			
		return true;
	}

    function SpawnVehicle( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
                if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                {
                	try 
                	{
	                    local veh = ( SqInteger.IsNum( args.Vehicle ) ) ? args.Vehicle.tointeger() : SqVehicles.GetVehicleModelFromName( args.Vehicle );

	                    if( SqVehicles.GetValidModel( veh ) )
	                    {
	                        local getVeh = SqVehicles.CreateAdmin( veh.tointeger(), player.World, player.Pos, player.Angle );
	                            
	                        player.Embark( getVeh );

	                        SqCast.MsgAdmin( TextColor.Staff, Lang.ASpawnVeh, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, SqVehicles.GetVehicleNameFromModel( veh ) );
	                    }
	                    else player.Msg( TextColor.Error, Lang.InvalidVehModel[ player.Data.Language ] );
	                }
					catch( e ) player.Msg( TextColor.Error, Lang.CreateVehicleError[ player.Data.Language ], e );
                }
                else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        
        return true;
    }

    function SpawnVehicle2( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
                if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                {
                	try 
                	{
	                    local veh = ( SqInteger.IsNum( args.Vehicle ) ) ? args.Vehicle.tointeger() : SqVehicles.GetVehicleModelFromName( args.Vehicle );

	                    if( SqVehicles.GetValidModel( veh ) )
	                    {
	                        local getVeh = SqVehicles.CreateAdmin2( veh.tointeger(), player.World, player.Pos, player.Angle, args.Color1, args.Color2, args.Team );
	                            
	                        player.Embark( getVeh );

	                        SqCast.MsgAdmin( TextColor.Staff, Lang.ASpawnVeh, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, SqVehicles.GetVehicleNameFromModel( veh ) );
	                    }
	                    else player.Msg( TextColor.Error, Lang.InvalidVehModel[ player.Data.Language ] );
	                }
					catch( e ) player.Msg( TextColor.Error, Lang.CreateVehicleError[ player.Data.Language ], e );
                }
                else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        
        return true;
    }
}