class CCmdPickup
{
	Cmd			= null;
	
	AddPickup		= null;
	EditPickup		= null;
	FindPickup		= null;
	PickupList		= null;
	
	constructor( instance )
	{
		this.Cmd = instance;
		
		this.Cmd.BindFail( this, this.funcFailCommand );
		
		this.AddPickup  = this.Cmd.Create( "addpickup", "i", [ "Model" ], 1, 1, -1, true, true );
		this.EditPickup = this.Cmd.Create( "editpickup", "i|s|g", [ "ID", "Type", "Value" ], 2, 6, -1, true, true );
		this.FindPickup = this.Cmd.Create( "findpickup", "f", [ "Radius" ], 1, 1, -1, true, true );
		this.PickupList = this.Cmd.Create( "pickuplist", "", [], 0, 0, -1, true, true );

		this.AddPickup.BindExec( this.AddPickup, this.Addpickup );
		this.EditPickup.BindExec( this.EditPickup, this.Editpickup );
		this.FindPickup.BindExec( this.FindPickup, this.Findpickup );
		this.PickupList.BindExec( this.PickupList, this.Pickuplist );
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
				case "addpickup":
				return player.Msg( TextColor.Error, Lang.AddPickupSyntax[ player.Data.Language ] );
				
				case "editpickup":
				return player.Msg( TextColor.Error, Lang.EditPickupSyntax[ player.Data.Language ] );
			
				case "findpickup":
				return player.Msg( TextColor.Error, Lang.FindPickupSyntax[ player.Data.Language ] );
			}
		}
	}
	
	function Addpickup( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqAdmin.IsAllowMapping( player ) )
				{
					if( player.Data.IsEditing == "" )
					{
						local
						getPos = Vector3( ( player.PosX + 2 ), ( player.PosY + 2 ), ( player.PosZ + 1 ) ),
						pickup = SqPick.Create( player.Data.AccID, args.Model, getPos, player.World );

						SqPick.Pickups[ pickup.Tag ].IsEditing = true;
						pickup.Alpha = 150;
							
						player.Data.IsEditing = pickup.Tag;
						player.Msg( TextColor.Sucess, Lang.PickupAdd[ player.Data.Language ], pickup.ID );
					}
					else player.Msg( TextColor.Error, Lang.ObjCurrentEditing[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function Findpickup( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqAdmin.IsAllowMapping( player ) )
				{
					local result = null;
					SqForeach.Pickup.Active( this, function( Pickup )
					{
						if( Pickup.World == player.World )
						{
							if( Pickup.Pos.DistanceTo( player.Pos ) < args.Radius )
							{
								if( result ) result = result + HexColour.White + ", " + TextColor.Sucess + "Model " + HexColour.White + Pickup.Model + TextColor.Sucess + " ID " + HexColour.White + Pickup.ID; 
								else result = TextColor.Sucess + "Model " + HexColour.White + Pickup.Model + TextColor.Sucess + " ID " + HexColour.White + Pickup.ID; 
							}
						}
					});
						
					if( result ) player.Msg( TextColor.Sucess, Lang.PickupList[ player.Data.Language ], result );
					else player.Msg( TextColor.Error, Lang.PickupXFind[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function Pickuplist( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqAdmin.IsAllowMapping( player ) )
				{
					local result = null;
					foreach( index, value in SqPick.Pickups )
					{
						if( value.World == player.World )
						{
							if( result ) result = result + "$" + HexColour.Red + "Model " + HexColour.White + Pickup.Model + HexColour.Red + " ID " + HexColour.White + value.instance.ID + HexColour.Red + " Type " + HexColour.White + value.Type + HexColour.Red + " Last edited " + HexColour.White + SqAccount.GetNameFromID( value.LastEdited );
							else result = HexColour.Red + "Model " + HexColour.White + Pickup.Model + HexColour.Red + " ID " + HexColour.White + value.instance.ID + HexColour.Red + " Type " + HexColour.White + value.Type + HexColour.Red + " Last edited " + HexColour.White + SqAccount.GetNameFromID( value.LastEdited );
						}
					}
						
					if( result ) 
					{
						player.StreamInt( 105 );
						player.StreamString( "Pickup list of " + player.World + "$" + player.World );
						player.FlushStream( true );
						
						player.StreamInt( 106 );
						player.StreamString( result );
						player.FlushStream( true );
					}
					else player.Msg( TextColor.Error, Lang.PickupXFind[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function Editpickup( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqAdmin.IsAllowMapping( player ) )
				{
					if( player.Data.IsEditing == "" )
					{
						if( SqFind.Pickup.WithID( args.ID ).tostring() != "-1" )
						{
							local pickup = SqFind.Pickup.WithID( args.ID );
							if( pickup.World == player.World )
							{
								if( !SqPick.Pickups[ pickup.Tag ].IsEditing )
								{
									switch( args.Type )
									{
										case "pos":
										player.Data.IsEditing = pickup.Tag;
										player.Data.EditingMode = "XYZ";
										SqPick.Pickups[ pickup.Tag ].LastEdited = player.Data.AccID;
											
										pickup.Alpha = 150;
										SqPick.Pickups[ pickup.Tag ].IsEditing = true;
											
										player.Msg( TextColor.Sucess, Lang.PickupEditPos[ player.Data.Language ] );
										break;
											
										case "type":
										if( args.len() == 3 )
										{
											switch( args.Value )
											{
												case "health increase":
												if( SqPick.Pickups[ pickup.Tag ].Type != "Health Increase" )
												{
													SqPick.Pickups[ pickup.Tag ].Type 		= "Health Increase";
													SqPick.Pickups[ pickup.Tag ].Extra 		= "";
													SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
													SqPick.Save( pickup.Tag );
													
													player.Msg( TextColor.Sucess, Lang.PickupEditType[ player.Data.Language ], "Health Increase" );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditTypeSame[ player.Data.Language ], "health increase" );
												break;

												case "health decrease":
												if( SqPick.Pickups[ pickup.Tag ].Type != "Health Decrease" )
												{
													SqPick.Pickups[ pickup.Tag ].Type 		= "Health Decrease";
													SqPick.Pickups[ pickup.Tag ].Extra 		= "";
													SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
													SqPick.Save( pickup.Tag );
													
													player.Msg( TextColor.Sucess, Lang.PickupEditType[ player.Data.Language ], "Health Decrease" );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditTypeSame[ player.Data.Language ], "health decrease" );
												break;
													
												case "weapon":
												if( SqPick.Pickups[ pickup.Tag ].Type != "Weapon" )
												{
													SqPick.Pickups[ pickup.Tag ].Type 		= "Weapon";
													SqPick.Pickups[ pickup.Tag ].Extra 		= "";
													SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
													SqPick.Save( pickup.Tag );
													
													player.Msg( TextColor.Sucess, Lang.PickupEditType[ player.Data.Language ], "Weapon" );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditTypeSame[ player.Data.Language ], "weapon" );
												break;
													
												case "objmovepos":
												if( SqPick.Pickups[ pickup.Tag ].Type != "Objmovepos" )
												{
													SqPick.Pickups[ pickup.Tag ].Type 		= "Objmovepos";
													SqPick.Pickups[ pickup.Tag ].Extra 		= "";
													SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
													SqPick.Save( pickup.Tag );
													
													player.Msg( TextColor.Sucess, Lang.PickupEditType[ player.Data.Language ], "Object moving (Position)" );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditTypeSame[ player.Data.Language ], "Object moving (Position)" );
												break;
													
												case "objmoverot":
												if( SqPick.Pickups[ pickup.Tag ].Type != "Objmoverot" )
												{
													SqPick.Pickups[ pickup.Tag ].Type 		= "Objmoverot";
													SqPick.Pickups[ pickup.Tag ].Extra 		= "";
													SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
													SqPick.Save( pickup.Tag );
													
													player.Msg( TextColor.Sucess, Lang.PickupEditType[ player.Data.Language ], "Object moving (Rotation)" );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditTypeSame[ player.Data.Language ], "Object moving (Rotation)" );
												break;
													
												case "cash":
												if( SqPick.Pickups[ pickup.Tag ].Type != "Cash" )
												{
													SqPick.Pickups[ pickup.Tag ].Type 		= "Cash";
													SqPick.Pickups[ pickup.Tag ].Extra 		= "";
													SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
													SqPick.Save( pickup.Tag );
													
													player.Msg( TextColor.Sucess, Lang.PickupEditType[ player.Data.Language ], "Cash" );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditTypeSame[ player.Data.Language ], "Cash" );
												break;
													
												case "teleport":
												if( SqPick.Pickups[ pickup.Tag ].Type != "Teleport" )
												{
													SqPick.Pickups[ pickup.Tag ].Type 		= "Teleport";
													SqPick.Pickups[ pickup.Tag ].Extra 		= "";
													SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
													SqPick.Save( pickup.Tag );
													
													player.Msg( TextColor.Sucess, Lang.PickupEditType[ player.Data.Language ], "Teleport" );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditTypeSame[ player.Data.Language ], "Teleport" );
												break;
													
												case "explosive":
												if( SqPick.Pickups[ pickup.Tag ].Type != "Teleport" )
												{
													SqPick.Pickups[ pickup.Tag ].Type 		= "Explosive";
													SqPick.Pickups[ pickup.Tag ].Extra 		= "";
													SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
													SqPick.Save( pickup.Tag );
													
													player.Msg( TextColor.Sucess, Lang.PickupEditType[ player.Data.Language ], "Explosive" );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditTypeSame[ player.Data.Language ], "Explosive" );
												break;
													
												case "remove":
												if( SqPick.Pickups[ pickup.Tag ].Type != "" )
												{
													SqPick.Pickups[ pickup.Tag ].Type 		= "";
													SqPick.Pickups[ pickup.Tag ].Extra 		= "";
													SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
													SqPick.Save( pickup.Tag );
													
													player.Msg( TextColor.Sucess, Lang.PickupEditTypeRemove[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditTypeRemoveSame[ player.Data.Language ] );
												break;
													
												default:
												player.Msg( TextColor.Error, Lang.PickupEditTypeSyntax[ player.Data.Language ] );
												break;
											}
										}
										else player.Msg( TextColor.Error, Lang.PickupEditTypeSyntax[ player.Data.Language ] );
										break;
											
										case "msg":
										if( args.len() == 3 )
										{
											switch( args.Value )
											{
												case "disable":
												SqPick.Pickups[ pickup.Tag ].Message		= "N/A";
												SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
												SqPick.Save( pickup.Tag );
													
												player.Msg( TextColor.Sucess, Lang.PickupEditMsgDisable[ player.Data.Language ] );
												break;
													
												default:
												SqPick.Pickups[ pickup.Tag ].Message		= args.Value;
												SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
												SqPick.Save( pickup.Tag );
														
												player.Msg( TextColor.Sucess, Lang.PickupEditMsg[ player.Data.Language ], args.Value );
												break;
											}
										}
										else player.Msg( TextColor.Error, Lang.PickupEditMsgSyntax[ player.Data.Language ] );
										break;
											
										case "sound":
										if( args.len() == 3 )
										{
											local stripValue = split( args.Value, " " );
												
											switch( stripValue[0] )
											{
												case "disable":
												SqPick.Pickups[ pickup.Tag ].Sound		= "N/A";
												SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
												SqPick.Save( pickup.Tag );
												player.Msg( TextColor.Sucess, Lang.DisablePickupSound[ player.Data.Language ] );
												break;
														
												default:
												if( stripValue.len() == 2 )
												{
													if( SqInteger.IsNum( stripValue[0] ) )
													{
														switch( stripValue[1] )
														{
															case "true":
															case "false":
															SqPick.Pickups[ pickup.Tag ].Sound		= stripValue[0] + " " + stripValue[1];
															SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
															SqPick.Save( pickup.Tag );
																	
															player.PlaySound( stripValue[0].tointeger() );
															if( stripValue[1] == "true" ) player.Msg( TextColor.Sucess, Lang.PickupEditSound3D[ player.Data.Language ], stripValue[0] );
															else player.Msg( TextColor.Sucess, Lang.PickupEditSound2D[ player.Data.Language ], stripValue[0] );
															break;
																	
															default:
															player.Msg( TextColor.Error, Lang.PickupEditSoundSyntax[ player.Data.Language ] );
															break;
														}
													}
													else player.Msg( TextColor.Error, Lang.PickupEditSoundNotNum[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditSoundSyntax[ player.Data.Language ] );
											}
										}
										else player.Msg( TextColor.Error, Lang.PickupEditSoundSyntax[ player.Data.Language ] );
										break;
											
										case "prop":
										switch( SqPick.Pickups[ pickup.Tag ].Type )
										{
											case "Health Increase":
											if( SqMath.IsGreaterEqual( args.len(), 3 ) )
											{
												local stripValue = split( args.Value, " " );
														
												if( stripValue.len() == 1 )
												{
													if( SqInteger.IsNum( stripValue[0] ) )
													{
														if( SqInteger.ValidHealOrArmRange( stripValue[0].tointeger() ) )
														{
															SqPick.Pickups[ pickup.Tag ].Extra	= stripValue[0].tostring();
															SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
															SqPick.Save( pickup.Tag );
																	
															player.Msg( TextColor.Sucess, Lang.PickupEditHealInc[ player.Data.Language ], stripValue[0] );
														}
														else player.Msg( TextColor.Error, Lang.PickupEditHealWrongRange[ player.Data.Language ] );
													}
													else player.Msg( TextColor.Error, Lang.PickupEditHealIncXNum[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditHealSyntax[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.PickupEditHealSyntax[ player.Data.Language ] );
											break;
													
											case "Health Decrease":
											if( SqMath.IsGreaterEqual( args.len(), 3 ) )
											{
												local stripValue = split( args.Value, " " );

												if( stripValue.len() == 1 )
												{
													if( SqInteger.IsNum( stripValue[0] ) )
														{
														if( SqInteger.ValidHealOrArmRange( stripValue[0].tointeger() ) )
														{
															SqPick.Pickups[ pickup.Tag ].Extra	= stripValue[0].tostring();
															SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
															SqPick.Save( pickup.Tag );
																
															player.Msg( TextColor.Sucess, Lang.PickupEditHealDec[ player.Data.Language ], stripValue[0] );
														}
														else player.Msg( TextColor.Error, Lang.PickupEditHealWrongRange[ player.Data.Language ] );
													}
													else player.Msg( TextColor.Error, Lang.PickupEditHealIncXNum[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditHealSyntax[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.PickupEditHealSyntax[ player.Data.Language ] );
											break;
													
											case "Weapon":
											if( SqMath.IsGreaterEqual( args.len(), 3 ) )
											{
												local stripValue = split( args.Value, " " );
													
												if( stripValue.len() == 2 )
												{
													local wep = ( SqStr.AreAllDigit( stripValue[0].tostring() ) ) ? stripValue[0].tointeger() : GetWeaponID( stripValue[0] );
													
													if( wep != -1 )
													{
														if( !IsWeaponNatural( wep ) )
														{
															if( SqWeapon.GetValidAmmoRange( stripValue[1].tointeger() ) )
															{
																SqPick.Pickups[ pickup.Tag ].Extra	= stripValue[0] + " " + stripValue[1];
																SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
																SqPick.Save( pickup.Tag );
																	
																player.Msg( TextColor.Sucess, Lang.PickupEditWepWithAmmo[ player.Data.Language ], GetWeaponName( wep ), TextColor.Sucess, stripValue[1] );
															}
															else player.Msg( TextColor.Error, Lang.WeaponAmmoInvalidValue[ player.Data.Language ] );
														}
														else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
													}
													else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditWepSyntax[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.PickupEditWepSyntax[ player.Data.Language ] );
												break;
													
											case "Objmovepos":
											if( SqMath.IsGreaterEqual( args.len(), 3 ) )
											{
												local stripValue = split( args.Value, " " );
													
												if( stripValue.len() == 3 )
												{
													if( SqStr.AreAllDigit( stripValue[0].tostring() ) && SqStr.AreAllDigit( stripValue[1].tostring() ) )
													{
														local object1 = SqFind.Object.WithID( stripValue[0].tointeger() ), object2 = SqFind.Object.WithID( stripValue[1].tointeger() );
															
														if( object1.tostring() != "-1" )
														{
															if( object2.tostring() != "-1" )
															{
																if( SqStr.AreAllDigit( stripValue[2].tostring() ) )
																{
																	if( SqInteger.ValidSecond( stripValue[2] ) )
																	{
																		SqPick.Pickups[ pickup.Tag ].Extra	= object1.Tag + " " + object2.Pos + " " + stripValue[2];
																		SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
																		SqPick.Save( pickup.Tag );
																			
																		player.Msg( TextColor.Sucess, Lang.PickupEditObjMove[ player.Data.Language ] );
																	}
																	else player.Msg( TextColor.Error, Lang.PickupEditInvalidSecond[ player.Data.Language ] );
																}
																else player.Msg( TextColor.Error, Lang.PickupTimeNotNum[ player.Data.Language ] );
															}
															else player.Msg( TextColor.Error, Lang.Object2NotFound[ player.Data.Language ] );
														}
														else player.Msg( TextColor.Error, Lang.Object1NotFound[ player.Data.Language ] );
													}
													else player.Msg( TextColor.Error, Lang.PickupEditObjNotNum[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditObjmoveSyntax[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.PickupEditObjmoveSyntax[ player.Data.Language ] );
											break;
													
											case "Objmoverot":
											if( SqMath.IsGreaterEqual( args.len(), 3 ) )
											{
												local stripValue = split( args.Value, " " );
													
												if( stripValue.len() == 3 )
												{
													if( SqStr.AreAllDigit( stripValue[0].tostring() ) && SqStr.AreAllDigit( stripValue[1].tostring() ) )
													{
														local object1 = SqFind.Object.WithID( stripValue[0].tointeger() ), object2 = SqFind.Object.WithID( stripValue[1].tointeger() );
															
														if( object1.tostring() != "-1" )
														{
															if( object2.tostring() != "-1" )
															{
																if( SqInteger.ValidSecond( stripValue[2] ) )
																{
																	SqPick.Pickups[ pickup.Tag ].Extra	= object1.Tag + " " + object2.EulerRotation + " " + stripValue[2];
																	SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
																	SqPick.Save( pickup.Tag );
																		
																	player.Msg( TextColor.Sucess, Lang.PickupEditObjRot[ player.Data.Language ] );
																}
																else player.Msg( TextColor.Error, Lang.PickupEditInvalidSecond[ player.Data.Language ] );
															}
															else player.Msg( TextColor.Error, Lang.Object2NotFound[ player.Data.Language ] );
														}
														else player.Msg( TextColor.Error, Lang.Object1NotFound[ player.Data.Language ] );
													}
													else player.Msg( TextColor.Error, Lang.PickupEditObjNotNum[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditObjmoveSyntax[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.PickupEditObjmoveSyntax[ player.Data.Language ] );
											break;
													
											case "Cash":
											if( SqMath.IsGreaterEqual( args.len(), 3 ) )
											{
												local stripValue = split( args.Value, " " );
													
												if( stripValue.len() == 2 )
												{
													if( SqStr.AreAllDigit( stripValue[0].tostring() ) && SqStr.AreAllDigit( stripValue[1].tostring() ) )
													{
														if( SqMath.IsGreaterEqual( stripValue[0].tointeger(), 0 ) && SqMath.IsGreaterEqual( stripValue[1].tointeger(), 0 ) )
														{
															if( SqMath.IsGreaterEqual( player.Data.Stats.Cash, stripValue[0].tointeger() ) )
															{
																if( SqMath.IsLess( stripValue[0].tointeger(), 1000000 ) && SqMath.IsLess( stripValue[1].tointeger(), 1000000 ) )
																{
																	if( SqMath.IsGreaterEqual( stripValue[0].tointeger(), stripValue[1].tointeger() ) )
																	{
																		SqPick.Pickups[ pickup.Tag ].Extra	= stripValue[0] + " " + stripValue[1];
																		SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
																		SqPick.Save( pickup.Tag );

																		player.Data.Stats.Cash -= stripValue[0].tointeger();
																		player.Msg( TextColor.Sucess, Lang.PickupEditCash[ player.Data.Language ], SqInteger.ToThousands( stripValue[0] ) );
																	}
																	else player.Msg( TextColor.Error, Lang.PickupCashPickupValueWrong[ player.Data.Language ] );
																}
																else player.Msg( TextColor.Error, Lang.PickupCashValueCantMoreThan1m[ player.Data.Language ] );
															}
															else player.Msg( TextColor.Error, Lang.PickupCashNotEnoughCash[ player.Data.Language ] );
														}
														else player.Msg( TextColor.Error, Lang.PickupCashValueLessThan0[ player.Data.Language ] );
													}
													else player.Msg( TextColor.Error, Lang.PickupCashValueLessXNum[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditCashSyntax[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.PickupEditCashSyntax[ player.Data.Language ] );
											break;
													
											case "Teleport":
											if( SqMath.IsGreaterEqual( args.len(), 3 ) )
											{
												local stripValue = split( args.Value, " " );
												
												if( stripValue.len() == 1 )
												{
													if( SqStr.AreAllDigit( stripValue[0].tostring() ) )
													{
														local object1 = SqFind.Object.WithID( stripValue[0].tointeger() );
															
														if( object1.tostring() != "-1" )
														{
															SqPick.Pickups[ pickup.Tag ].Extra	= object1.Pos.tostring();
															SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
															SqPick.Save( pickup.Tag );
																		
															player.Msg( TextColor.Sucess, Lang.PickupTeleport[ player.Data.Language ] );
														}
														else player.Msg( TextColor.Error, Lang.Object1NotFound[ player.Data.Language ] );
													}
													else player.Msg( TextColor.Error, Lang.PickupEditObjNotNum[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditTeleSyntax[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.PickupEditTeleSyntax[ player.Data.Language ] );
											break;
													
											case "Explosive":
											if( SqMath.IsGreaterEqual( args.len(), 3 ) )
											{
												local stripValue = split( args.Value, " " );
												
												if( stripValue.len() == 2 )
												{
													if( SqStr.AreAllDigit( stripValue[0].tostring() ) )
													{
														local object1 = SqFind.Object.WithID( stripValue[0].tointeger() );
															
														if( object1.tostring() != "-1" )
														{
															if( SqStr.AreAllDigit( stripValue[1].tostring() ) )
															{
																SqPick.Pickups[ pickup.Tag ].Extra	= object1.Pos.tostring() + " " +  stripValue[1];
																SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
																SqPick.Save( pickup.Tag );

																CreateExplosion( player.World, stripValue[1].tointeger(), object1.Pos, player, false );

																player.Msg( TextColor.Sucess, Lang.PickupExplosive[ player.Data.Language ] );
															}
															else player.Msg( TextColor.Error, Lang.ExpIDNotNum[ player.Data.Language ] );
														}
														else player.Msg( TextColor.Error, Lang.Object1NotFound[ player.Data.Language ] );
													}
													else player.Msg( TextColor.Error, Lang.PickupEditObjNotNum[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.PickupEditTeleSyntax[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.PickupEditExpSyntax[ player.Data.Language ] );
											break;

											default:
											player.Msg( TextColor.Error, Lang.PickupEditDontHaveType[ player.Data.Language ] );
											break;
										}
										break;
											
										case "level":
										if( args.len() == 3 )
										{
											local stripValue = split( args.Value, " " );
											if( SqStr.AreAllDigit( stripValue[0].tostring() ) )
											{
												if( SqWorld.GetCorrectValue( stripValue[0].tointeger() ) )
												{
													SqPick.Pickups[ pickup.Tag ].Level		= stripValue[0].tointeger();
													SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
													SqPick.Save( pickup.Tag );
																			
													player.Msg( TextColor.Sucess, Lang.PickupLevel[ player.Data.Language ], stripValue[0] );
												}
												else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.LevelXNum[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.EditpickupLevelSyntax[ player.Data.Language ] );
										break;
									}
								}
								else player.Msg( TextColor.Error, Lang.PickupsomeEdit[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.PickupIDNotFound[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.PickupIDNotFound[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.ObjCurrentEditing[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
}