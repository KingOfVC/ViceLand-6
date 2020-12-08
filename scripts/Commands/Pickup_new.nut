class CCmdPickup
{	
	function Addpickup( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};
		
		if( stripCmd.len() == 2 )
		{
			args = { "Model": stripCmd[1] };

			if( SqInteger.IsNum( args.Model ) )
			{
				if( player.Data.IsReg )
				{
					if( player.Data.Logged )
					{
						if( SqAdmin.IsAllowMapping( player ) )
						{
							if( player.Data.IsEditing == "" )
							{
								if( SqObj.IsPremium( player, args.Model ) )
								{
									try 
									{
										local
										getPos = player.Pos,
										pickup = SqPick.Create( player.Data.AccID, args.Model.tointeger(), getPos, player.World );

										SqPick.Pickups[ pickup.Tag ].IsEditing = true;
										pickup.Alpha = 150;

										player.Data.IsEditing = pickup.Tag;
										player.Msg( TextColor.Sucess, Lang.PickupAdd[ player.Data.Language ], pickup.ID );

										if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** added pickup. **Model** %d **World** %d", player.Name, pickup.Model.tointeger(), player.World ), "mapping" );
									}
									catch( e ) player.Msg( TextColor.Error, Lang.PickupCreateError[ player.Data.Language ], e );
								}
								else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( args.Model ) );								
							}
							else player.Msg( TextColor.Error, Lang.ObjCurrentEditing[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.AddPickupSyntax[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.AddPickupSyntax[ player.Data.Language ] );

		return true;
	}

	function Findpickup( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};
		
		if( stripCmd.len() == 2 )
		{
			args = { "Radius": stripCmd[1] };

			if( SqInteger.IsFloat( args.Radius ) )
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
									if( Pickup.Pos.DistanceTo( player.Pos ) < args.Radius.tofloat() )
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
			}
			else player.Msg( TextColor.Error, Lang.FindPickupSyntax[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.FindPickupSyntax[ player.Data.Language ] );
		
		return true;
	}
	
	function Pickuplist( player, command )
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
							if( result ) result = result + "$" + HexColour.Red + "Model " + HexColour.White + value.instance.Model + HexColour.Red + " ID " + HexColour.White + value.instance.ID + HexColour.Red + " Type " + HexColour.White + value.Type + HexColour.Red + " Last edited " + HexColour.White + SqAccount.GetNameFromID( value.LastEdited );
							else result = HexColour.Red + "Model " + HexColour.White + value.instance.Model + HexColour.Red + " ID " + HexColour.White + value.instance.ID + HexColour.Red + " Type " + HexColour.White + value.Type + HexColour.Red + " Last edited " + HexColour.White + SqAccount.GetNameFromID( value.LastEdited );
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
	
	function Editpickup( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};
		
		if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
		{
			args = { "ID": stripCmd[1], "Type": stripCmd[2], "Value": ( stripCmd.len() > 3 ) ? ::GetTok( command, " ", 4, ::NumTok( command, " " ) ) : "" };

			if( SqInteger.IsNum( args.ID ) )
			{
				if( player.Data.IsReg )
				{
					if( player.Data.Logged )
					{
						if( SqAdmin.IsAllowMapping( player ) )
						{
							if( player.Data.IsEditing == "" )
							{
								if( SqInteger.GetPickupMaxID( args.ID.tointeger() ) )
								{
									if( SqFind.Pickup.WithID( args.ID.tointeger() ).tostring() != "-1" )
									{
										local pickup = SqFind.Pickup.WithID( args.ID.tointeger() );
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

													if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is editing pickup pos. **Model** %d **World** %d", player.Name, pickup.Model, player.World ), "mapping" );
													break;
														
													case "type":
													if( args.Value != "" )
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
																
																if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is changing pickup type to %s. **Model** %d **World** %d", player.Name, args.Value, pickup.Model, player.World ), "mapping" );
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
																
																if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is changing pickup type to %s. **Model** %d **World** %d", player.Name, args.Value, pickup.Model, player.World ) , "mapping" );
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
																
																if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is changing pickup type to %s. **Model** %d **World** %d", player.Name, args.Value, pickup.Model, player.World ), "mapping" );
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
															
																if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is changing pickup type to %s. **Model** %d **World** %d", player.Name, args.Value, pickup.Model, player.World ), "mapping" );
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
															
																if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is changing pickup type to %s. **Model** %d **World** %d", player.Name, args.Value, pickup.Model, player.World ), "mapping" );
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
															
																if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is changing pickup type to %s. **Model** %d **World** %d", player.Name, args.Value, pickup.Model, player.World ), "mapping" );
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
															
																if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is changing pickup type to %s. **Model** %d **World** %d", player.Name, args.Value, pickup.Model, player.World ), "mapping" );
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
															
																if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is changing pickup type to %s. **Model** %d **World** %d", player.Name, args.Value, pickup.Model, player.World ), "mapping" );
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
															
																if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** removed pickup type. **Model** %d **World** %d", player.Name, pickup.Model, player.World ), "mapping" );
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
													if( args.Value != "" )
													{

														switch( args.Value )
														{
															case "disable":
															SqPick.Pickups[ pickup.Tag ].Message		= "N/A";
															SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
															SqPick.Save( pickup.Tag );
																
															player.Msg( TextColor.Sucess, Lang.PickupEditMsgDisable[ player.Data.Language ] );

															if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** removed pickup message. **Model** %d **World** %d", player.Name, pickup.Model, player.World ), "mapping" );
															break;
																
															default:
															local stripValue = split( args.Value, " " );
															if( stripValue.len() > 0 )
															{
																SqPick.Pickups[ pickup.Tag ].Message		= args.Value;
																SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
																SqPick.Save( pickup.Tag );
																		
																player.Msg( TextColor.Sucess, Lang.PickupEditMsg[ player.Data.Language ], args.Value );
															
																if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is changing pickup message to %s. **Model** %d **World** %d", player.Name, args.Value, pickup.Model, player.World ), "mapping" );
															}
															break;
														}
													}
													else player.Msg( TextColor.Error, Lang.PickupEditMsgSyntax[ player.Data.Language ] );
													break;
														
													case "sound":
													if( args.Value != "" )
													{
														local stripValue = split( args.Value, " " );
															
														switch( stripValue[0] )
														{
															case "disable":
															SqPick.Pickups[ pickup.Tag ].Sound		= "N/A";
															SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
															SqPick.Save( pickup.Tag );
															player.Msg( TextColor.Sucess, Lang.DisablePickupSound[ player.Data.Language ] );

															if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** disabled pickup sound. **Model** %d **World** %d", player.Name, pickup.Model, player.World ), "mapping" );
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

																		if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is changing pickup sound. **Sound ID** %d **Is 3D** %s **Model** %d **World** %d", player.Name, stripValue[0].tointeger(), stripValue[1], pickup.Model, player.World ), "mapping" );
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
														if( args.Value != "" )
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
																	
																		if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is editing pickup property. **Type** %s **New Value** %s **Model** %d **World** %d", player.Name, SqPick.Pickups[ pickup.Tag ].Type, stripValue[0], pickup.Model, player.World ), "mapping" );
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
														if( args.Value != "" )
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
																	
																		if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is editing pickup property. **Type** %s **New Value** %s **Model** %d **World** %d", player.Name, SqPick.Pickups[ pickup.Tag ].Type, stripValue[0], pickup.Model, player.World ), "mapping" );
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
														if( args.Value != "" )
														{
															local stripValue = split( args.Value, " " );
																
															if( stripValue.len() == 2 )
															{
																local wep = ( SqStr.AreAllDigit( stripValue[0].tostring() ) ) ? stripValue[0].tointeger() : GetWeaponID( stripValue[0] );
																
																if( wep != -1 )
																{
																	if( !IsWeaponNatural( wep ) )
																	{
																		if( SqWeapon.GetValidWeaponID( wep ) )
																		{
																			if( SqWeapon.GetValidAmmoRange( stripValue[1].tointeger() ) )
																			{
																				SqPick.Pickups[ pickup.Tag ].Extra	= stripValue[0] + " " + stripValue[1];
																				SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
																				SqPick.Save( pickup.Tag );
																					
																				player.Msg( TextColor.Sucess, Lang.PickupEditWepWithAmmo[ player.Data.Language ], GetWeaponName( wep ), TextColor.Sucess, stripValue[1] );
																			
																				if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is editing pickup property. **Type** %s **New Value** %s **Model** %d **World** %d", player.Name, SqPick.Pickups[ pickup.Tag ].Type, args.Value, pickup.Model, player.World ), "mapping" );
																			}
																			else player.Msg( TextColor.Error, Lang.WeaponAmmoInvalidValue[ player.Data.Language ] );
																		}
																		else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );																
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
														if( args.Value != "" )
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
																					
																					if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is editing pickup property. **Type** %s **New Value** %s **Model** %d **World** %d", player.Name, SqPick.Pickups[ pickup.Tag ].Type, args.Value, pickup.Model, player.World ), "mapping" );
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
														if( args.Value != "" )
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
																			
																				if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is editing pickup property. **Type** %s **New Value** %s **Model** %d **World** %d", player.Name, SqPick.Pickups[ pickup.Tag ].Type, args.Value, pickup.Model, player.World ), "mapping" );
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
														if( args.Value != "" )
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
																				
																					if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is editing pickup property. **Type** %s **New Value** %s **Model** %d **World** %d", player.Name, SqPick.Pickups[ pickup.Tag ].Type, args.Value, pickup.Model, player.World ), "mapping" );
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
														if( args.Value != "" )
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
																	
																		if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is editing pickup property. **Type** %s **New Value** %s **Model** %d **World** %d", player.Name, SqPick.Pickups[ pickup.Tag ].Type, args.Value, pickup.Model, player.World ), "mapping" );
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
														if( args.Value != "" )
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
																		
																			if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is editing pickup property. **Type** %s **New Value** %s **Model** %d **World** %d", player.Name, SqPick.Pickups[ pickup.Tag ].Type, args.Value, pickup.Model, player.World ), "mapping" );
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
													if( args.Value != "" )
													{
														local stripValue = split( args.Value, " " );
														if( SqInteger.IsNum( stripValue[0].tostring() ) )
														{
															if( SqWorld.GetPrivateWorld( player.World ) )
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

															else 
															{
																switch( stripValue[0].tointeger() )
																{
																	case 1:
																	if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
																	{
																		SqPick.Pickups[ pickup.Tag ].Level		= 1;
																		SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
																		SqPick.Save( pickup.Tag );
																								
																		player.Msg( TextColor.Sucess, Lang.PickupLevel[ player.Data.Language ], "Admin Only" );
																	}
																	else player.Msg( TextColor.Error, Lang.PickupLevelNoPermission[ player.Data.Language ] );
																	break;

																	case 2:
																	SqPick.Pickups[ pickup.Tag ].Level		= 2;
																	SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
																	SqPick.Save( pickup.Tag );
																								
																	player.Msg( TextColor.Sucess, Lang.PickupLevel[ player.Data.Language ], "Mapper Only" );
																	break;

																	case 3:
																	SqPick.Pickups[ pickup.Tag ].Level		= 3;
																	SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
																	SqPick.Save( pickup.Tag );
																								
																	player.Msg( TextColor.Sucess, Lang.PickupLevel[ player.Data.Language ], "Admin & VIP & Mapper Only" );
																	break;

																	case 4:
																	SqPick.Pickups[ pickup.Tag ].Level		= 4;
																	SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
																	SqPick.Save( pickup.Tag );
																								
																	player.Msg( TextColor.Sucess, Lang.PickupLevel[ player.Data.Language ], "Admin & Mapper Only" );
																	break;

																	case 0:
																	SqPick.Pickups[ pickup.Tag ].Level		= 0;
																	SqPick.Pickups[ pickup.Tag ].LastEdited	= player.Data.AccID;
																	SqPick.Save( pickup.Tag );
																								
																	player.Msg( TextColor.Sucess, Lang.PickupLevel[ player.Data.Language ], "Everyone" );
																	break;

																	default:
																	player.Msg( TextColor.Error, Lang.PickupLevelPublicWorldSyntax[ player.Data.Language ] );
																	break;
																}
															}
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
								else player.Msg( TextColor.Error, Lang.PickupIDNotFound[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.ObjCurrentEditing[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.EditPickupSyntax[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.EditPickupSyntax[ player.Data.Language ] );
		
		return true;
	}
}