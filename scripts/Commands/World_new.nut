class CCmdWorld
{
	function funcBuyworld( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, SqWorld.GetWorldPrice( player ) ) )
					{
						if( SqWorld.World[ player.World ].Owner == 100000 )
						{
							local getPrice = ( SqWorld.GetWorldPrice( player ) == 0 ) ? "Free" : SqInteger.ToThousands( SqWorld.GetWorldPrice( player ) ) + " Vice Coin";
							
							local world = SqWorld.World[ player.World ];

							player.Msg( TextColor.Sucess, Lang.BuyWorld[ player.Data.Language ], player.World );

							if( player.Data.Event.FreeWorld.tointeger() > 0 )
							{
								player.Data.Event.FreeWorld = ( player.Data.Event.FreeWorld.tointeger() - 1 );

								world.Price				= 0;
							}
							
							else 
							{
								player.Data.Stats.Coin	-= SqWorld.GetWorldPrice( player );
								world.Price				= SqWorld.GetWorldPrice( player );
							}
					
							world.Owner 			= player.Data.AccID;
							
							world.AddOn.WorldAdmin	= "true";
							world.AddOn.WorldFPS	= "true";
							world.Settings.WorldSpawn = player.Pos.x + "," + player.Pos.y + "," + player.Pos.z;

							if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" )
							{
								player.Msg( TextColor.InfoS, Lang.Worldclaimhelp[ player.Data.Language ], TextColor.InfoS );
								player.Msg( TextColor.InfoS, Lang.Worldclaimhelp1[ player.Data.Language ], TextColor.InfoS );
								player.Msg( TextColor.InfoS, Lang.Worldclaimhelp2[ player.Data.Language ] );
							}

							SqWorld.Save( player.World );							
						}
						else player.Msg( TextColor.Error, Lang.WorldAlreadyHasOwner[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.WorldCantBuy[ player.Data.Language ], SqInteger.ToThousands( SqWorld.GetWorldPrice( player ) ) );
				}
				else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function funcWorldsetting( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
		{
			args = { "Type": stripCmd[1], "Value": ::GetTok( command, " ", 3, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( SqWorld.GetPrivateWorld( player.World ) )
					{
						if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.worldsetlevelcmd.tointeger() ) )
						{
							switch( args.Type )
							{
								case "type":
								if( SqWorld.World[ player.World ].Permissions.setworldtype.tointeger() < SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ) )
								{
									if( stripCmd.len() == 3 )
									{
										switch( args.Value )
										{
											case "normal":
											if( SqWorld.World[ player.World ].Settings.WorldType != "normal" )
											{
												SqWorld.World[ player.World ].Settings.WorldType = args.Value;
												SqWorld.Save( player.World );
												
												player.Msg( TextColor.Sucess, Lang.WorldChangeType[ player.Data.Language ], args.Value );
											}
											else player.Msg( TextColor.Error, Lang.WorldTypeAlreadyNormal[ player.Data.Language ] );
											break;
											
											case "stunt":
											if( SqWorld.World[ player.World ].Settings.WorldType != "stunt" )
											{
												SqWorld.World[ player.World ].Settings.WorldType = args.Value;
												SqWorld.Save( player.World );
												
												player.Msg( TextColor.Sucess, Lang.WorldChangeType[ player.Data.Language ], args.Value );
											}
											else player.Msg( TextColor.Error, Lang.WorldTypeAlreadyStunt[ player.Data.Language ] );
											break;
										
											default:
											player.Msg( TextColor.Error, Lang.WorldTypeSyntax[ player.Data.Language ] );
											break;
										}
									}
									else player.Msg( TextColor.Error, Lang.WorldTypeSyntax[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
								break;
								
								case "name":
								if( SqWorld.World[ player.World ].Permissions.worldsetlevelcmd.tointeger() < SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ) )
								{
									if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
									{
										SqWorld.World[ player.World ].Settings.WorldName = SQLite.EscapeString( args.Value );
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.WorldSetName[ player.Data.Language ], args.Value );
									}
									else player.Msg( TextColor.Error, Lang.WorldSetNameSyntax1[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
								break;
								
								case "welcomemessage":
								case "welcomemsg":
								if( SqWorld.World[ player.World ].Permissions.setworldmessage.tointeger() < SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ) )
								{
									if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
									{
										switch( args.Value )
										{
											case "none":
											SqWorld.World[ player.World ].Settings.WorldMessage = "N/A";
											SqWorld.Save( player.World );
										
											player.Msg( TextColor.Sucess, Lang.WorldSetWelcomeMessageRemove[ player.Data.Language ] );
											break;
											
											default:
											if( args.Value )
											{
												SqWorld.World[ player.World ].Settings.WorldMessage = args.Value;
												SqWorld.Save( player.World );

												player.Msg( TextColor.Sucess, Lang.WorldSetWelcomeMessage[ player.Data.Language ], args.Value );
											}
											else player.Msg( TextColor.Error, Lang.WorldSetWelcomeMessageSyntax[ player.Data.Language ] );
											break;
										}
									}
									else player.Msg( TextColor.Error, Lang.WorldSetWelcomeMessageSyntax[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
								break;
								
								case "spawn":
								case "worldspawn":
								if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.setworldspawn.tointeger() ) )
								{
									SqWorld.World[ player.World ].Settings.WorldSpawn = player.Pos.x + "," + player.Pos.y + "," + player.Pos.z;
									SqWorld.Save( player.World );
									
									player.Msg( TextColor.Sucess, Lang.WorldSetSpawn[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
								break;					
							
								case "worldkill":
								if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.worldkill.tointeger() ) )
								{
									switch( SqWorld.World[ player.World ].Settings.WorldKill )
									{
										case "true":
										SqWorld.World[ player.World ].Settings.WorldKill = "false";
										SqWorld.Save( player.World );
						
										SqCast.MsgWorld( TextColor.World, player.World, Lang.WorldKillOff, player.Name, TextColor.World );
									
										SqForeach.Player.Active( this, function( plr ) 
										{
											if( player.World == plr.World ) plr.SetOption( SqPlayerOption.CanAttack, false );
										});
										
										player.Msg( TextColor.Sucess, Lang.WorldkillOffAdmin[ player.Data.Language ] );
										break;
									
										case "false":
										SqWorld.World[ player.World ].Settings.WorldKill = "true";
										SqWorld.Save( player.World );
										
										SqCast.MsgWorld( TextColor.World, player.World, Lang.WorldKillOn, player.Name, TextColor.World );
									
										SqForeach.Player.Active( this, function( plr ) 
										{
											if( player.World == plr.World ) 
											{
												if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( plr.Name, player.World ), SqWorld.World[ player.World ].Permissions2.canattack ) )
												{
													plr.SetOption( SqPlayerOption.CanAttack, true );
												}
											}
										});
										
										player.Msg( TextColor.Sucess, Lang.WorldkillOnAdmin[ player.Data.Language ] );
										break;
									}
								}
								else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
								break;
								
								case "driveby":
								if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.worlddb.tointeger() ) )
								{
									switch( SqWorld.World[ player.World ].Settings.WorldDriveBy )
									{
										case "true":
										SqWorld.World[ player.World ].Settings.WorldDriveBy = "false";
										SqWorld.Save( player.World );
						
										SqCast.MsgWorld( TextColor.World, player.World, Lang.WorlddbOff, player.Name, TextColor.World );
									
										SqForeach.Player.Active( this, function( plr ) 
										{
											if( player.World == plr.World ) plr.SetOption( SqPlayerOption.DriveBy, false );
										});
										
										player.Msg( TextColor.Sucess, Lang.WorlddbOffAdmin[ player.Data.Language ] );
										break;
									
										case "false":
										SqWorld.World[ player.World ].Settings.WorldDriveBy = "true";
										SqWorld.Save( player.World );
										
										SqCast.MsgWorld( TextColor.World, player.World, Lang.WorlddbOn, player.Name, TextColor.World );
									
										SqForeach.Player.Active( this, function( plr ) 
										{
											if( player.World == plr.World ) 
											{
												if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( plr.Name, player.World ), SqWorld.World[ player.World ].Permissions2.candriveby ) )
												{
													plr.SetOption( SqPlayerOption.DriveBy, true );
												}
											}
										});
										
										player.Msg( TextColor.Sucess, Lang.WorlddbOnAdmin[ player.Data.Language ] );
										break;
									}
								}
								else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
								break;					
								
								case "fps":
								if( SqWorld.World[ player.World ].AddOn.WorldFPS == "true" )
								{
									if( SqWorld.World[ player.World ].Permissions.setfpspinglimit.tointeger() < SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ) )
									{
										if( stripCmd.len() == 3 )
										{
											if( SqInteger.IsNum( args.Value.tointeger() ) )
											{
												if( SqWorld.GetCorrectFPSValue( args.Value.tointeger() ) )
												{
													SqWorld.World[ player.World ].Settings.WorldFPS = args.Value.tostring();
													SqWorld.Save( player.World );
													
													SqCast.MsgWorld( TextColor.World, player.World, Lang.WorldFPSSet, player.Name, TextColor.World, args.Value.tointeger() );

													player.Msg( TextColor.Sucess, Lang.WorldFPSSelf[ player.Data.Language ], args.Value.tointeger() );
												}
												else player.Msg( TextColor.Error, Lang.WorldValueNotCorrect[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.WorldFPSValueNotNum[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.WorldSetFpsSyntax[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.WorldNoWorldFPS[ player.Data.Language ] );
								break;
					
								case "ping":
								if( SqWorld.World[ player.World ].AddOn.WorldFPS == "true" )
								{
									if( SqWorld.World[ player.World ].Permissions.setfpspinglimit.tointeger() < SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ) )
									{
										if( stripCmd.len() == 3 )
										{
											if( SqInteger.IsNum( args.Value.tointeger() ) )
											{
												if( SqWorld.GetCorrectPingValue( args.Value.tointeger() ) )
												{
													SqWorld.World[ player.World ].Settings.WorldFPS = args.Value.tostring();
													SqWorld.Save( player.World );
													
													SqCast.MsgWorld( TextColor.World, player.World, Lang.WorldPingSet, player.Name, TextColor.World, args.Value.tointeger() );

													player.Msg( TextColor.Sucess, Lang.WorldPingSelf[ player.Data.Language ], args.Value.tointeger() );
												}
												else player.Msg( TextColor.Error, Lang.WorldPingValueNotCorrect[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.WorldValueNotNum[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.WorldSetPingSyntax[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.WorldNoWorldFPS[ player.Data.Language ] );
								break;
								
								default: 
								player.Msg( TextColor.Error, Lang.WorldSettingSyntax1[ player.Data.Language ] );
								break;
							}
						}
						else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.WorldSettingSyntax1[ player.Data.Language ] ); 	
		return true;
	}
	
	function funcWorldkick( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
		{
			args = { "Victim": stripCmd[1], "Reason": ::GetTok( command, " ", 3, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( SqWorld.GetPrivateWorld( player.World ) )
					{
						if( SqWorld.World[ player.World ].AddOn.WorldAdmin == "true" )
						{
							if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.worldkick.tointeger() ) )
							{
								switch( args.Victim )
								{
									case "all":
									local isKicked = false;
									
									SqForeach.Player.Active( this, function( plr ) 
									{
										if( plr.World == player.World && plr.Name != player.Name )
										{	
											if( SqMath.IsLess( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.GetPlayerLevelInWorld( plr.Name, player.World ) ) )
											{
												plr.Msg( TextColor.World, player.World, Lang.WorldkickAll[ player.Data.Language ], player.Name );
												plr.Msg( TextColor.InfoS, Lang.WorldkickNotice[ player.Data.Language ], player.World );
												plr.World = 0;
												
												isKicked = true;
											}
										}
									});
									
									if( isKicked ) player.Msg( TextColor.Sucess, Lang.WorldkickAllAdmin[ player.Data.Language ] );
									else player.Msg( TextColor.Error, Lang.WorldkickAllNoPlayer[ player.Data.Language ] );
									break;
									
									default:
									if( SqPlayer.FindPlayer( args.Victim ) )
									{
										local plr = SqPlayer.FindPlayer( args.Victim );

										if( plr.ID != player.ID )
										{
											if( plr.World == player.World )
											{
												if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.GetPlayerLevelInWorld( plr.Name, player.World ) ) )
												{
													if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
													{
														SqCast.MsgWorld( TextColor.World, player.World, Lang.WorldkickAnn, player.Name, TextColor.World, plr.Name, TextColor.World, args.Reason );
													
														player.Msg( TextColor.Sucess, Lang.WorldkickAdmin[ player.Data.Language ], plr.Name, TextColor.Sucess, args.Reason );

														plr.Msg( TextColor.InfoS, Lang.WorldkickNotice[ plr.Data.Language ], player.World );
														plr.World = 0;
													}
														
													else
													{
														SqCast.MsgWorld( TextColor.World, player.World, Lang.WorldkickWithoutReason, player.Name, TextColor.World, plr.Name, TextColor.World );
															
														player.Msg( TextColor.Sucess, Lang.WorldkickAdminWithoutReason[ player.Data.Language ], plr.Name, TextColor.Sucess );
														
														plr.Msg( TextColor.InfoS, Lang.WorldkickNotice[ plr.Data.Language ], player.World );
														plr.World = 0;
													}
												}
												else player.Msg( TextColor.Error, Lang.WorldCannotUseOnHigh[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.WorldNotSameWorld[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.WorldCantSelf[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.InvalidPlayer[ player.Data.Language ] );
									break;
								}
							}
							else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.WorldNoWorldAdmin[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.WorldKickSyntax1[ player.Data.Language ] );

		return true;
	}
	
	function funcWorldban( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
		{
			args = { "Victim": stripCmd[1], "Reason": ::GetTok( command, " ", 3, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( SqWorld.GetPrivateWorld( player.World ) )
					{
						if( SqWorld.World[ player.World ].AddOn.WorldAdmin == "true" )
						{
							if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.worldban.tointeger() ) )
							{
								if( SqPlayer.FindPlayer( args.Victim ) )
								{
									local plr = SqPlayer.FindPlayer( args.Victim );
									if( plr.ID != player.ID )
									{
										if( plr.World == player.World )
										{
											if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.GetPlayerLevelInWorld( plr.Name, player.World ) ) )
											{
												if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
												{
													SqCast.MsgWorld( TextColor.World, player.World, Lang.WorldbanAnn, player.Name, TextColor.World, plr.Name, TextColor.World, args.Reason );
													
													SqWorld.AddPlayerToWorld( plr.Data.AccID, 0, player.World, "true" );
													
													player.Msg( TextColor.Sucess, Lang.WorldBanAdmin[ player.Data.Language ], plr.Name, TextColor.Sucess, args.Reason );

													plr.Msg( TextColor.InfoS, Lang.WorldbanNotice[ plr.Data.Language ], player.World );
													plr.World = 0;
												}
													
												else
												{
													SqCast.MsgWorld( TextColor.World, player.World, Lang.WorldbanWithoutReason, player.Name, TextColor.World, plr.Name, TextColor.World );
													
													SqWorld.AddPlayerToWorld( plr.Data.AccID, 0, player.World, "true" );

													player.Msg( TextColor.Sucess, Lang.WorldBanAdminWithoutReason[ player.Data.Language ], plr.Name, TextColor.Sucess );

													plr.Msg( TextColor.InfoS, Lang.WorldbanNotice[ plr.Data.Language ], player.World, TextColor.Sucess );
													plr.World = 0;
												}
											}
											else player.Msg( TextColor.Error, Lang.WorldCannotUseOnHigh[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.WorldNotSameWorld[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.WorldCantSelf[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.InvalidPlayer[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.WorldNoWorldAdmin[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.WorldBanSyntax1[ player.Data.Language ] );

		return true;
	}
	
	function funcWorldunban( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Victim": stripCmd[1] };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( SqWorld.GetPrivateWorld( player.World ) )
					{
						if( SqWorld.World[ player.World ].AddOn.WorldAdmin == "true" )
						{
							if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.worldunban.tointeger() ) )
							{
								if( SqPlayer.FindPlayer( args.Victim ) )
								{
									if( SqWorld.GetPlayerBanInWorld( plr.Name, player.World ) )
									{
										local plr = SqPlayer.FindPlayer( args.Victim );
												
										SqCast.MsgWorld( TextColor.World, player.World, Lang.WorldUnban, player.Name, TextColor.World, plr.Name );
											
										SqWorld.AddPlayerToWorld( plr.Data.AccID, 0, player.World, "false" );

										player.Msg( TextColor.Sucess, Lang.WorlunbanAdmin[ player.Data.Language ], plr.Name );
										
										plr.Msg( TextColor.InfoS, Lang.WorldunbanNotice[ plr.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.WorldUnbanPlrNotBanned[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.WorldNoWorldAdmin[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.WorldUnbanSyntax1[ player.Data.Language ] );

		return true;
	}
	
	function funcWorldsetlevel( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 3 )
		{
			args = { "Victim": stripCmd[1], "Value": stripCmd[2] };

			if( SqInteger.IsNum( args.Value ) )
			{
				if( player.Data.IsReg )
				{
					if( player.Data.Logged )
					{
						if( SqWorld.GetPrivateWorld( player.World ) )
						{
							if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.worldsetlevel.tointeger() ) )
							{
								if( SqPlayer.FindPlayer( args.Victim ) )
								{
									local plr = SqPlayer.FindPlayer( args.Victim );
									
									if( plr.World == player.World )
									{
										if( SqInteger.GetWorldCorrectValue( args.Value.tointeger() ) )
										{
											SqCast.MsgWorld( TextColor.World, player.World, Lang.WorldSetlevel, player.Name, TextColor.World, plr.Name, TextColor.World, args.Value.tointeger() );
												
											SqWorld.AddPlayerToWorld( plr.Data.AccID, args.Value, player.World )

											player.Msg( TextColor.Sucess, Lang.WorldsetlevelAdmin[ player.Data.Language ], plr.Name, TextColor.Sucess, args.Value.tointeger() );
											
											plr.Msg( TextColor.InfoS, Lang.WorldsetlevelNotice[ plr.Data.Language ], args.Value.tointeger() );
										}
										else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.WorldNotSameWorld[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.InvalidPlayer[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.WorldSetlevelSyntax1[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.WorldSetlevelSyntax1[ player.Data.Language ] );
		return true;
	}
	
	function funcWorldpermission( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 3 )
		{
			args = { "Type": stripCmd[1], "Value": stripCmd[2] };

			if( SqInteger.IsNum( args.Value ) )
			{
				if( player.Data.IsReg )
				{
					if( player.Data.Logged )
					{
						if( SqWorld.GetPrivateWorld( player.World ) )
						{
							if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.worldsetlevelcmd.tointeger() ) )
							{
								switch( args.Type )
								{
									case "setworldname":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions.setworldname = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Set world name", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
								
									case "setworldmessage":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions.setworldmessage = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Set welcome message", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
									
									case "setworldtype":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions.setworldtype = args.Value.tointeger();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Set world type", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
								
									
									case "setworldspawn":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions.setworldspawn = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Set world spawn", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
									
									case "setdriveby":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions.worlddb = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Change drive by setting", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
									
									case "worldkick":
									if( SqWorld.World[ player.World ].AddOn.WorldAdmin == "true" )
									{
										if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
										{
											SqWorld.World[ player.World ].Permissions.worldkick = args.Value.tointeger().tostring();
											SqWorld.Save( player.World );
											
											player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Kick player", TextColor.Sucess, args.Value.tointeger() );
										}
										else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.WorldNoWorldAdmin[ player.Data.Language ] );
									break;
									
									case "worldban":
									if( SqWorld.World[ player.World ].AddOn.WorldAdmin == "true" )
										{
										if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
										{
											SqWorld.World[ player.World ].Permissions.worldban = args.Value.tointeger().tostring();
											SqWorld.Save( player.World );
											
											player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Ban player", TextColor.Sucess, args.Value.tointeger() );
										}
										else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.WorldNoWorldAdmin[ player.Data.Language ] );
									break;
									
									case "worldunban":
									if( SqWorld.World[ player.World ].AddOn.WorldAdmin == "true" )
									{
										if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
										{
											SqWorld.World[ player.World ].Permissions.worldunban = args.Value.tointeger().tostring();
											SqWorld.Save( player.World );
											
											player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Unban player", TextColor.Sucess, args.Value.tointeger() );
										}
										else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.WorldNoWorldAdmin[ player.Data.Language ] );
									break;
									
									case "setworldname":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions.setworldname = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Welcome Message", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
									
									case "worldsetlevel":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions.worldsetlevel = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Set level", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
									
									case "mapping":
									if( SqWorld.World[ player.World ].AddOn.WorldAdmin == "true" )
									{
										if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
										{
											SqWorld.World[ player.World ].Permissions.mapping = args.Value.tointeger().tostring();
											SqWorld.Save( player.World );
											
											player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Pickup/Object manage", TextColor.Sucess, args.Value.tointeger() );
										}
										else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.WorldNoWorldAdmin[ player.Data.Language ] );
									break;
									
									case "vehspawning":
									if( SqWorld.World[ player.World ].AddOn.WorldAdmin == "true" )
									{
										if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
										{
											SqWorld.World[ player.World ].Permissions.vehspawning = args.Value.tointeger().tostring();
											SqWorld.Save( player.World );
											
											player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Vehicle spawning", TextColor.Sucess, args.Value.tointeger() );
										}
										else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.WorldNoWorldAdmin[ player.Data.Language ] );
									break;
									
									case "vehmanage":
									if( SqWorld.World[ player.World ].AddOn.WorldAdmin == "true" )
									{
										if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
										{
											SqWorld.World[ player.World ].Permissions.vehmanage = args.Value.tointeger().tostring();
											SqWorld.Save( player.World );
											
											player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Vehicle manage", TextColor.Sucess, args.Value.tointeger() );
										}
										else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.WorldNoWorldAdmin[ player.Data.Language ] );
									break;
									
									case "worldkill":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions.worldkill = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Enable/Disable killing", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
									
									case "worldann":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions.worldann = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Sending announcement", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
								
									case "worldsetlevelcmd":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions.worldsetlevelcmd = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Set command level", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;			

									case "setfpspinglimit":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions.setfpspinglimit = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Set FPS/Ping limit", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;		
									
									default:
									player.Msg( TextColor.Error, Lang.WorldPermissionSyntax1[ player.Data.Language ] );
									break;			
								}
							}
							else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.WorldPermissionSyntax1[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.WorldPermissionSyntax1[ player.Data.Language ] );
		return true;
	}

	function funcWorldlock( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.worldlock.tointeger() ) )
					{
						switch( SqWorld.World[ player.World ].Settings.LockWorld )
						{
							case "true":
							SqWorld.World[ player.World ].Settings.LockWorld = "false";
							SqWorld.Save( player.World );
							
							SqCast.MsgWorld( TextColor.World, player.World, Lang.WorldlockOffAll, player.Name, TextColor.World  );
							
							player.Msg( TextColor.Sucess, Lang.WorldlockOff[ player.Data.Language ] );
							break;
							
							case "false":
							SqWorld.World[ player.World ].Settings.LockWorld = "true";
							SqWorld.Save( player.World );
							
							SqCast.MsgWorld( TextColor.World, player.World, Lang.WorldlockOnAll, player.Name, TextColor.World  );
							
							player.Msg( TextColor.Sucess, Lang.WorldlockOn[ player.Data.Language ] );
							break;
						}
					}
					else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function funcWorldAnn( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
		{
			args = { "Victim": stripCmd[1], "Text": ::GetTok( command, " ", 3, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( SqWorld.GetPrivateWorld( player.World ) )
					{
						if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.worldann.tointeger() ) )
						{
							switch( args.Victim )
							{
								case "all":
								local isSended = true;
								SqCast.sendAnnounceToWorld( player.World, args.Text );		

								if( isSended ) player.Msg( TextColor.Sucess, Lang.WorldAnnAllAdmin[ player.Data.Language ], args.Text, TextColor.Sucess );
								break;
									
								default:
								if( SqPlayer.FindPlayer( args.Victim ) )
								{
									local plr = SqPlayer.FindPlayer( args.Victim );

									if( plr.World == player.World )
									{
										SqCast.sendAnnounceToPlayer( plr, args.Text );

										plr.Msg( TextColor.Sucess, Lang.WorldAnnAdmin[ player.Data.Language ], args.Text, TextColor.Sucess, plr.Name );						
									}
									else player.Msg( TextColor.Error, Lang.WorldNotSameWorld[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.InvalidPlayer[ player.Data.Language ] );
								break;
							}
						}
						else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.WorldAnnSyntax1[ player.Data.Language ] );
		
		return true;
	}

	function funcWorldGoto( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Value": stripCmd[1] };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( !player.Data.Interior )
					{
						if( !player.Data.InEvent )
						{
							if( !SqLocation.IsTeleporting( player ) )
							{
								switch( args.Value )
								{
									case "main":
									if( player.World != 0 )
									{
										if( SqWorld.IsStunt( player.World ) )
										{
											player.World = 0;

											//SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoworldAllPublic, player.Name, TextColor.Info );
																
											player.Msg( TextColor.Sucess, Lang.GotoWorldSucessPublic[ player.Data.Language ] );

											player.SetOption( SqPlayerOption.CanAttack, true );
											player.SetOption( SqPlayerOption.DriveBy, true );

											player.Data.InEvent = null;

										}

										else 
										{
											if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
											{
												player.Msg( TextColor.InfoS, Lang.GotoWorld[ player.Data.Language ] );
																			
												player.MakeTask( function( pos )
												{
													if ( this.Data == null ) this.Data = 0;

													if( pos.tostring() == player.Pos.tostring() )
													{
														if( ++this.Data > 5 )
														{
															player.World = 0;

														//	if( player.Data.InEvent.rawin( "TDM" ) ) SqCast.MsgWorld( TextColor.Event, 105, Lang.TDMPlayerLeave, player.Name, TextColor.Event );
																		
															SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoworldAllPublic, player.Name, TextColor.Info );
																			
															player.Msg( TextColor.Sucess, Lang.GotoWorldSucessPublic[ player.Data.Language ] );

															player.SetOption( SqPlayerOption.CanAttack, true );
															player.SetOption( SqPlayerOption.DriveBy, true );

															player.Data.InEvent = null;
															
															this.Terminate();
														}
													}
																	
													else 
													{
														player.Msg( TextColor.Error, Lang.WorldSwitchFailMove[ player.Data.Language ] );
																		
														this.Terminate();
													}
												}, 500, 6, player.Pos ).SetTag( "Teleport" );
											}
											else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
										}
									}
									else player.Msg( TextColor.Error, Lang.WorldSameWorld[ player.Data.Language ] );
									break;

								/*	case "dm":
									if( player.World != 0 )
									{
										if( SqWorld.IsStunt( player.World ) )
										{
											player.World = 101;

											player.Armour = 0;

											player.Data.InEvent = "DM";
															
											//SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoworldAllDM, player.Name, TextColor.Info );
																
											player.Msg( TextColor.Sucess, Lang.GotoWorldSucessDM[ player.Data.Language ] );

											player.SetOption( SqPlayerOption.CanAttack, true );

											player.Pos = Vector3.FromStr( Server.DMArena.Arena[ Server.DMArena.Position.tostring() ].Pos );	
										}

										else 
										{
											if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
											{
												player.Msg( TextColor.InfoS, Lang.GotoWorld[ player.Data.Language ] );
																			
												player.MakeTask( function( pos )
												{
													if ( this.Data == null ) this.Data = 0;

													if( pos.tostring() == player.Pos.tostring() )
													{
														if( ++this.Data > 9 )
														{
															player.World = 101;

															player.Armour = 0;

														//	if( player.Data.InEvent.rawin( "TDM" ) ) SqCast.MsgWorld( TextColor.Event, 105, Lang.TDMPlayerLeave, player.Name, TextColor.Event );

														//	SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoworldAllDM, player.Name, TextColor.Info );
																			
															player.Msg( TextColor.Sucess, Lang.GotoWorldSucessDM[ player.Data.Language ] );

															player.SetOption( SqPlayerOption.CanAttack, true );

															player.Data.InEvent = "DM";

															player.Pos = Vector3.FromStr( Server.DMArena.Arena[ Server.DMArena.Position.tostring() ].Pos );

															this.Terminate();
														}
													}
																	
													else 
													{
														player.Msg( TextColor.Error, Lang.WorldSwitchFailMove[ player.Data.Language ] );
																		
														this.Terminate();
													}
												}, 500, 10, player.Pos ).SetTag( "Teleport" );
											}
											else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
										}
									}
									else player.Msg( TextColor.Error, Lang.WorldSameWorld[ player.Data.Language ] );
									break;
									*/
								/*	case "cash":
									if( player.World != 0 )
									{
										if( SqWorld.IsStunt( player.World ) )
										{
											player.World = 102;

											player.Data.InEvent = "Cash";
															
										//	SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoworldAllGridingWorld, player.Name, TextColor.Info );
																
											player.Msg( TextColor.Sucess, Lang.EnterGrindingWorld[ player.Data.Language ] );

											player.SetOption( SqPlayerOption.CanAttack, false );

										//	player.Pos = RandSpawn[ rand()%RandSpawn.len() ];
										}

										else 
										{
											if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
											{
												player.Msg( TextColor.InfoS, Lang.GotoWorld[ player.Data.Language ] );
																			
												player.MakeTask( function( pos )
												{
													if ( this.Data == null ) this.Data = 0;

													if( pos.tostring() == player.Pos.tostring() )
													{
														if( ++this.Data > 9 )
														{
															player.World = 102;

													//		if( player.Data.InEvent.rawin( "TDM" ) ) SqCast.MsgWorld( TextColor.Event, 105, Lang.TDMPlayerLeave, player.Name, TextColor.Event );
																		
													//		SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoworldAllGridingWorld, player.Name, TextColor.Info );
																			
															player.Msg( TextColor.Sucess, Lang.EnterGrindingWorld[ player.Data.Language ] );

															player.SetOption( SqPlayerOption.CanAttack, false );

															player.Data.InEvent = "Cash";

													//		player.Pos = Vector3.FromStr( Server.DMArena.Arena[ Server.DMArena.Position.tostring() ].Pos );

															this.Terminate();
														}
													}
																	
													else 
													{
														player.Msg( TextColor.Error, Lang.WorldSwitchFailMove[ player.Data.Language ] );
																		
														this.Terminate();
													}
												}, 500, 10, player.Pos ).SetTag( "Teleport" );
											}
											else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
										}
									}
									else player.Msg( TextColor.Error, Lang.WorldSameWorld[ player.Data.Language ] );
									break;
								*/								
									default:
									if( SqInteger.IsNum( args.Value ) )
									{
										if( SqWorld.GetPrivateWorld( args.Value ) )
										{	
											if( !SqWorld.World.rawin( args.Value.tointeger() ) ) SqWorld.Register( args.Value.tointeger() );
											
											if( SqWorld.GetLockedWorldStatus( player, args.Value.tointeger() ) )
											{
												if( !SqWorld.GetPlayerBanInWorld( player.Data.AccID, args.Value.tointeger() ) )
												{
													if( player.World != args.Value.tointeger() )
													{
														if( SqWorld.IsStunt( player.World ) )
														{
															local world = SqWorld.World[ args.Value.tointeger() ];
																												
															player.World = args.Value.tointeger();

															player.Data.InEvent = null;
																
														//	SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoworldAll, player.Name, TextColor.Info, args.Value.tointeger() );
																	
															player.Msg( TextColor.Sucess, Lang.GotoWorldSucess[ player.Data.Language ], args.Value.tointeger() );

															if( world.Settings.WorldSpawn != "0,0,0" ) player.Pos = Vector3.FromStr( world.Settings.WorldSpawn );
															if( world.Settings.WorldMessage != "N/A" ) player.Msg( TextColor.Sucess, Lang.WorldWelcomeMessage[ player.Data.Language ], world.Settings.WorldMessage );
																
															player.SetOption( SqPlayerOption.CanAttack, SToB( world.Settings.WorldKill ) );
															player.SetOption( SqPlayerOption.DriveBy, SToB( world.Settings.WorldDriveBy ) );
																
															if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, args.Value.tointeger() ), world.Permissions2.canattack ) ) player.SetOption( SqPlayerOption.CanAttack, true );
															if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, args.Value.tointeger() ), world.Permissions2.candriveby ) ) player.SetOption( SqPlayerOption.DriveBy, true );
														}

														else 
														{
															if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
															{
																player.Msg( TextColor.InfoS, Lang.GotoWorld[ player.Data.Language ] );
																				
																player.MakeTask( function( pos )
																{
																	if ( this.Data == null ) this.Data = 0;

																	if( pos.tostring() == player.Pos.tostring() )
																	{
																		if( ++this.Data > 5 )
																		{
																			local world = SqWorld.World[ args.Value.tointeger() ];

																			player.World = args.Value.tointeger();

																		//	if( player.Data.InEvent.rawin( "TDM" ) ) SqCast.MsgWorld( TextColor.Event, 105, Lang.TDMPlayerLeave, player.Name, TextColor.Event );

																			player.Data.InEvent = null;
																			
																			SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoworldAll, player.Name, TextColor.Info, args.Value.tointeger() );
																				
																			player.Msg( TextColor.Sucess, Lang.GotoWorldSucess[ player.Data.Language ], args.Value.tointeger() );

																			if( world.Settings.WorldSpawn != "0,0,0" ) player.Pos = Vector3.FromStr( world.Settings.WorldSpawn );
																			if( world.Settings.WorldMessage != "N/A" ) player.Msg( TextColor.Sucess, Lang.WorldWelcomeMessage[ player.Data.Language ], world.Settings.WorldMessage );
																			
																			player.SetOption( SqPlayerOption.CanAttack, SToB( world.Settings.WorldKill ) );
																			player.SetOption( SqPlayerOption.DriveBy, SToB( world.Settings.WorldDriveBy ) );
																			
																			if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, args.Value.tointeger() ), world.Permissions2.canattack ) ) player.SetOption( SqPlayerOption.CanAttack, true );
																			if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, args.Value.tointeger() ), world.Permissions2.candriveby ) ) player.SetOption( SqPlayerOption.DriveBy, true );
																			
																			this.Terminate();
																		}
																	}
																		
																	else 
																	{
																		player.Msg( TextColor.Error, Lang.WorldSwitchFailMove[ player.Data.Language ] );
																			
																		this.Terminate();
																	}
																}, 500, 6, player.Pos ).SetTag( "Teleport" );
															}
															else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
														}
													}
													else player.Msg( TextColor.Error, Lang.WorldSameWorld[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.WorldCantEnterBanned[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.WorldIsLocked[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.WorldInvalidWorld1[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.WorldIDNotNum[ player.Data.Language ] );								
									break;
								}
							}
							else player.Msg( TextColor.Error, Lang.AlreadyTeleporting[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.WorldGotoSyntax1[ player.Data.Language ] );

		return true;
	}
	
	function funcWorldInfo( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		args = { "Value": ( stripCmd.len() == 2 ) ? stripCmd[1] : "" };

		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( args.Value == "" )
				{
					if( SqWorld.GetPrivateWorld( player.World ) )
					{
						if( !SqWorld.World.rawin( player.World ) ) SqWorld.Register( player.World );

						if( SqWorld.World[ player.World ].Owner != 100000 )
						{
							player.Msg( TextColor.InfoS, Lang.WorldInfo1[ player.Data.Language ], player.World, TextColor.InfoS, SqAccount.GetNameFromID( SqWorld.World[ player.World ].Owner ), TextColor.InfoS, SqWorld.World[ player.World ].Settings.WorldName );
							player.Msg( TextColor.InfoS, Lang.WorldInfo2[ player.Data.Language ], SqWorld.World[ player.World ].Settings.LockWorld, TextColor.InfoS, SqWorld.World[ player.World ].Settings.WorldKill, TextColor.InfoS, SqWorld.World[ player.World ].Settings.WorldDriveBy, TextColor.InfoS, SqWorld.World[ player.World ].Settings.WorldType );
								
							if( SqWorld.World[ player.World ].AddOn.WorldFPS == "true" ) player.Msg( TextColor.InfoS, Lang.WorldInfo5[ player.Data.Language ], SqWorld.World[ player.World ].Settings.WorldFPS, TextColor.InfoS, SqWorld.World[ player.World ].Settings.WorldPing );
															
							if( SqWorld.World[ player.World ].Permissions.setworldmessage.tointeger() < SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ) ) player.Msg( TextColor.InfoS, Lang.WorldInfo4[ player.Data.Language ], SqWorld.World[ player.World ].Settings.WorldMessage );
						}
						else player.Msg( TextColor.InfoS, Lang.WorldNoOwnerCanClaim[ player.Data.Language ] );
					}
					else player.Msg( TextColor.InfoS, Lang.WorldIsPublic[ player.Data.Language ], SqWorld.GetWorldName( player.World ) );
				}
					
				else
				{
					if( SqInteger.IsNum( args.Value ) )
					{
						if( SqWorld.GetPrivateWorld( args.Value.tointeger() ) )
						{
							if( !SqWorld.World.rawin( args.Value.tointeger() ) ) SqWorld.Register( args.Value.tointeger() );
								
							if( SqWorld.World[ args.Value.tointeger() ].Owner != 100000 )
							{
								player.Msg( TextColor.InfoS, Lang.WorldInfo1[ player.Data.Language ], args.Value.tointeger(), TextColor.InfoS, SqAccount.GetNameFromID( SqWorld.World[ args.Value.tointeger() ].Owner ), TextColor.InfoS, SqWorld.World[ args.Value.tointeger() ].Settings.WorldName );
								player.Msg( TextColor.InfoS, Lang.WorldInfo2[ player.Data.Language ], SqWorld.World[ args.Value.tointeger() ].Settings.LockWorld, TextColor.InfoS, SqWorld.World[ args.Value.tointeger() ].Settings.WorldKill, TextColor.InfoS, SqWorld.World[ args.Value.tointeger() ].Settings.WorldDriveBy TextColor.InfoS, SqWorld.World[ args.Value.tointeger() ].Settings.WorldType );
									
								if( SqWorld.World[ args.Value.tointeger() ].AddOn.WorldFPS == "true" ) player.Msg( TextColor.InfoS, Lang.WorldInfo5[ player.Data.Language ], SqWorld.World[ args.Value.tointeger() ].Settings.WorldFPS, TextColor.InfoS, SqWorld.World[ args.Value.tointeger() ].Settings.WorldPing );
																		
								if( SqWorld.World[ args.Value.tointeger() ].Permissions.setworldmessage.tointeger() < SqWorld.GetPlayerLevelInWorld( player.Data.AccID, args.Value.tointeger() ) ) player.Msg( TextColor.InfoS, Lang.WorldInfo4[ player.Data.Language ], SqWorld.World[ args.Value.tointeger() ].Settings.WorldMessage );
							}
							else player.Msg( TextColor.InfoS, Lang.WorldNoOwnerCanClaim[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.WorldInvalidWorld2[ player.Data.Language ] );
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

		return true;
	}
	
	function funcWorldpermission2( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 3 )
		{
			args = { "Type": stripCmd[1], "Value": stripCmd[2] };

			if( SqInteger.IsNum( args.Value ) )
			{
				if( player.Data.IsReg )
				{
					if( player.Data.Logged )
					{
						if( SqWorld.GetPrivateWorld( player.World ) )
						{
							if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.worldsetlevelcmd.tointeger() ) )
							{
								switch( args.Type )
								{
									case "goto":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions2.goto = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "/goto usage", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
								
									case "gotoloc":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions2.gotoloc = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "/gotoloc usage", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
									
									case "heal":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions2.heal = args.Value.tointeger();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "/heal usage", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
								
									
									case "spawnloc":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions2.spawnloc = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "/spawnloc usage", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
									
									case "wep":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions2.wep = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "/wep usage", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
									
									case "enterworld":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions2.enterworld = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Allow enter world", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
									
									case "canattack":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions2.canattack = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Can attack", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
									
									case "candriveby":
									if( SqWorld.GetCorrectValue( args.Value.tointeger() ) )
									{
										SqWorld.World[ player.World ].Permissions2.candriveby = args.Value.tointeger().tostring();
										SqWorld.Save( player.World );
										
										player.Msg( TextColor.Sucess, Lang.Worldsetlevelcmd[ player.Data.Language ], "Can drive by", TextColor.Sucess, args.Value.tointeger() );
									}
									else player.Msg( TextColor.Error, Lang.WorldLevelNotValid[ player.Data.Language ] );
									break;
																
									default:
									player.Msg( TextColor.Error, Lang.WorldPermissionSyntax2[ player.Data.Language ] );
									break;			
								}
							}
							else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.WorldPermissionSyntax2[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.WorldPermissionSyntax2[ player.Data.Language ] );
		
		return true;
	}

	function SellWorld( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					if( SqWorld.World[ player.World ].Owner == player.Data.AccID )
					{
						local getPrice = ( SqWorld.World[ player.World ].Price / 2 );
					
						SqWorld.World[ player.World ].Price = getPrice;
						SqWorld.World[ player.World ].Owner = 100000;
						SqWorld.Save( player.World );

						player.Data.Stats.Coin += getPrice;
						
						player.Msg( TextColor.Sucess, Lang.WorldSold[ player.Data.Language ], player.World, TextColor.Sucess, SqInteger.ToThousands( getPrice ) );
					}
					else player.Msg( TextColor.Error, Lang.WorldNotOwner[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function ModWorld( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					if( SqWorld.World[ player.World ].Owner == player.Data.AccID )
					{
						if( SqWorld.World[ player.World ].AddOn.WorldAdmin == "false" || SqWorld.World[ player.World ].AddOn.WorldFPS == "false" )
						{
							local world = SqWorld.World[ player.World ];
							player.StreamInt( 104 );
							player.StreamString( "Modify world - " + player.World + "$" + player.World + "$" + world.AddOn.WorldAdmin + "$" + world.AddOn.WorldFPS );
							player.FlushStream( true );
						}
						else player.Msg( TextColor.Error, Lang.WorldNoNeedMod[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.WorldNotOwner[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function GetNamelist( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					local world = SqWorld.World[ player.World ], getStr = null;
					player.StreamInt( 105 );
					player.StreamString( "World name list of " + player.World + "$" + player.World );
					player.FlushStream( true );
					
					if( world.NameList != null )
					{
						foreach( index, value in world.NameList )
						{
							if( getStr ) getStr = getStr + "$" + HexColour.White + SqAccount.GetNameFromID( index ) + HexColour.Red + " Level " + HexColour.White + value.Level + HexColour.Red + " Banned " + HexColour.White + value.Ban;
							else getStr = HexColour.White + SqAccount.GetNameFromID( index ) + HexColour.Red + " Level " + HexColour.White + value.Level + HexColour.Red + " Banned " + HexColour.White + value.Ban;
						}
						
						if( getStr )
						{
							player.StreamInt( 106 );
							player.StreamString( getStr );
							player.FlushStream( true );
						}
					}
				}
				else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function GetLevel( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		args = { "Victim": ( stripCmd.len() == 2 ) ? stripCmd[1] : "" };

		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					if( args.Victim != "" )
					{
						local target = SqPlayer.FindPlayer( args.Victim );
						if( target )
						{
							if( target.Data.IsReg )
							{
								if( target.Data.Logged )
								{
									if( target.World == player.World )
									{
										if( SqWorld.GetPlayerLevelInWorld( target.Data.AccID, target.World ) == 100000 ) player.Msg( TextColor.InfoS, Lang.WorldGetLevelIsOwner[ player.Data.Language ], target.Name, TextColor.InfoS );
										else player.Msg( TextColor.InfoS, Lang.WorldGetLevel[ player.Data.Language ], target.Name, TextColor.InfoS, SqWorld.GetPlayerLevelInWorld( target.Data.AccID, target.World ) );
									}
									else player.Msg( TextColor.Error, Lang.WorldNotSameWorld[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
					}
					else
					{
						if( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ) == 100000 ) player.Msg( TextColor.InfoS, Lang.WorldGetLevelIsOwnerSelf[ player.Data.Language ] );
						else player.Msg( TextColor.InfoS, Lang.WorldGetLevelSelf[ player.Data.Language ], SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ) );
					}
				}
				else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function GetPermission( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					local world = SqWorld.World[ player.World ], getStr = null;
					player.StreamInt( 105 );
					player.StreamString( "World permission list of " + player.World + "$" + player.World );
					player.FlushStream( true );
					
					if( world.Permissions != null )
					{
						foreach( index, value in world.Permissions )
						{
							if( getStr ) getStr = getStr + "$" + HexColour.White + index + HexColour.Red + " Level " + HexColour.White + value;
							else getStr = HexColour.White + index + HexColour.Red + " Level " + HexColour.White + value;
						}
						
						if( getStr )
						{
							player.StreamInt( 106 );
							player.StreamString( getStr );
							player.FlushStream( true );
						}
					}
				}
				else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function GetPermission2( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					local world = SqWorld.World[ player.World ], getStr = null;
					player.StreamInt( 105 );
					player.StreamString( "World permission2 list of " + player.World + "$" + player.World );
					player.FlushStream( true );
					
					if( world.Permissions2 != null )
					{
						foreach( index, value in world.Permissions2 )
						{
							if( getStr ) getStr = getStr + "$" + HexColour.White + index + HexColour.Red + " Level " + HexColour.White + value;
							else getStr = HexColour.White + index + HexColour.Red + " Level " + HexColour.White + value;
						}
						
						if( getStr )
						{
							player.StreamInt( 106 );
							player.StreamString( getStr );
							player.FlushStream( true );
						}
					}
				}
				else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function GetOwnedWorld( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		args = { "Victim": ( stripCmd.len() == 2 ) ? stripCmd[1] : "" };

		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( args.Victim != "" )
				{
					if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
					{
						local target = SqPlayer.FindPlayer( args.Victim );
						if( target )
						{
							if( target.Data.IsReg )
							{
								if( target.Data.Logged )
								{
									player.StreamInt( 105 );
									player.StreamString( "Owned world of " + target.Name + "$" + player.World );
									player.FlushStream( true );						

									foreach( index, value in SqWorld.World )
									{
										if( value.Owner == target.Data.AccID )
										{
											player.StreamInt( 107 );
											player.StreamString( HexColour.White + index + HexColour.Red + " Name " + HexColour.White + value.Settings.WorldName );
											player.FlushStream( true );
										}
									}
								}
								else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotPermissionViewWorld[ player.Data.Language ] );
				}

				else 
				{
					player.StreamInt( 105 );
					player.StreamString( "Your worlds$" + player.World );
					player.FlushStream( true );						

					foreach( index, value in SqWorld.World )
					{
						if( value.Owner == player.Data.AccID )
						{
							player.StreamInt( 107 );
							player.StreamString( HexColour.White + index + HexColour.Red + " Name " + HexColour.White + value.Settings.WorldName );
							player.FlushStream( true );
						}
					}
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function GiveWorld( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		args = { "Victim": ( stripCmd.len() == 2 ) ? stripCmd[1] : "" };

		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					if( SqWorld.World[ player.World ].Owner == player.Data.AccID )
					{
						if( args.Victim != "" )
						{
							local target = SqPlayer.FindPlayer( args.Victim );
							if( target )
							{
								if( target.Data.IsReg )
								{
									if( target.Data.Logged )
									{
										local world = SqWorld.World[ player.World ];
										SqWorld.World[ player.World ].Owner = target.Data.AccID;
										SqWorld.Save( player.World );

										player.Msg( TextColor.Sucess, Lang.GiveWorld[ player.Data.Language ], target.Name );

										target.Msg( TextColor.InfoS, Lang.GiveWorld2[ player.Data.Language ], player.Name, TextColor.InfoS, player.World, TextColor.InfoS );
									}
									else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.GiveWorldSyntax[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.WorldNotOwner[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
}