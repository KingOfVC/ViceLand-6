class CCmdLocation
{
	function SpawnLoc( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
		{
			args = { "Option": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( !player.Data.Interior )
					{
						if( !player.Data.InEvent )
						{
							if( SqWorld.GetWorldPermission2( player, "spawnloc" ) )
							{
								switch( args.Option )
								{
									case "set":
									player.Data.Player.Spawnloc.SpawnData.Pos 		= player.Pos.x + "," + player.Pos.y + "," + player.Pos.z;
									player.Data.Player.Spawnloc.SpawnData.World		= player.World.tostring();
									player.Data.Player.Spawnloc.SpawnData.Enabled 	= "1";
																				
									player.Msg( TextColor.Sucess, Lang.Spawnloc2[ player.Data.Language ] );
									player.Msg( TextColor.InfoS, Lang.SpawnlocWarning[ player.Data.Language ] );							
									break;
									
									case "off":
									if( player.Data.Player.Spawnloc.SpawnData.Enabled != "2" )
									{
										player.Data.Player.Spawnloc.SpawnData.Enabled 	= "2";
										
										player.Msg( TextColor.Sucess, Lang.SpawnlocOff[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.SpawnlocAlreadyOff[ player.Data.Language ] );
									break;
									
									default:
									if( SqLocation.GetLocation( args.Option ) )
									{
										local getLocation = SqLocation.GetLocation( args.Option )
										
										if( SqMath.IsGreaterEqual( player.Data.Stats.Cash, SqSpawn.GetlocPrice( player, getLocation.Pos ) ) )							
										{
											local getPriceStr = ( SqSpawn.GetlocPrice( player, getLocation.Pos ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqSpawn.GetlocPrice( player, getLocation.Pos ) );
										
											player.Data.Player.Spawnloc.SpawnData.Pos 		= getLocation.Pos.x + "," + getLocation.Pos.y + "," + getLocation.Pos.z;
											player.Data.Player.Spawnloc.SpawnData.World		= player.World.tostring();
											player.Data.Player.Spawnloc.SpawnData.Enabled 	= "1";
											
											player.Data.Stats.Cash -= SqSpawn.GetlocPrice( player, getLocation.Pos );
											player.Data.Stats.TotalSpend += SqSpawn.GetlocPrice( player, getLocation.Pos );
											
											player.Msg( TextColor.Sucess, Lang.SpawnlocLoc[ player.Data.Language ], args.Option, TextColor.Sucess, getPriceStr );
										}
										else player.Msg( TextColor.Error, Lang.NeedCashToSpawn[ player.Data.Language ], SqInteger.ToThousands( SqSpawn.GetlocPrice( player, getLocation.Pos ) ) );
									}
									else player.Msg( TextColor.Error, Lang.LocationNotExist[ player.Data.Language ] );
									break;
								}
							}
							else player.Msg( TextColor.Error, Lang.NoPermissionWorldCmd[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.SpawnlocSyntax[ player.Data.Language ] );

		return true;
	}
	
	function GotoLoc( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Location": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

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
								if( SqWorld.GetWorldPermission2( player, "gotoloc" ) )
								{
									if( SqLocation.GetLocation( args.Location ) )
									{
										if( SqMath.IsGreaterEqual( player.Data.Stats.Cash, SqLocation.GetDistancePrice( player, SqLocation.GetLocation( args.Location ).Pos ) ) )
										{
											if( SqWorld.IsStunt( player.World ) )
											{
												local getLocation = SqLocation.GetLocation( args.Location ), getPriceStr = ( SqLocation.GetDistancePrice( player, getLocation.Pos ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqLocation.GetDistancePrice( player, getLocation.Pos ) );
													
												player.Pos 				= getLocation.Pos;
												player.Data.Stats.Cash -= SqLocation.GetDistancePrice( player, getLocation.Pos );
												player.Data.Stats.TotalSpend += SqLocation.GetDistancePrice( player, getLocation.Pos );

												if( !player.Data.Hidden ) SqCast.MsgAll( TextColor.Info, Lang.GotolocAll, player.Name, TextColor.Info, getLocation.Name, TextColor.Info, getPriceStr );
														
												player.Msg( TextColor.Sucess, Lang.GotolocSucess[ player.Data.Language ], getLocation.Name, TextColor.Sucess, getLocation.Creator, TextColor.Sucess, getPriceStr );
											}

											else
											{
												if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
												{
													player.Msg( TextColor.InfoS, Lang.Gotoloc[ player.Data.Language ] );
													
													player.MakeTask( function( pos )
													{
														if ( this.Data == null ) this.Data = 0;

														if( pos.tostring() == player.Pos.tostring() )
														{
															if( ++this.Data > 5 )
															{
																local getLocation = SqLocation.GetLocation( args.Location ), getPriceStr = ( SqLocation.GetDistancePrice( player, getLocation.Pos ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqLocation.GetDistancePrice( player, getLocation.Pos ) );
															
																player.Pos 				= getLocation.Pos;
																player.Data.Stats.Cash -= SqLocation.GetDistancePrice( player, getLocation.Pos );
																player.Data.Stats.TotalSpend += SqLocation.GetDistancePrice( player, getLocation.Pos );

																if( !player.Data.Hidden ) SqCast.MsgAll( TextColor.Info, Lang.GotolocAll, player.Name, TextColor.Info, getLocation.Name, TextColor.Info, getPriceStr );
																
																player.Msg( TextColor.Sucess, Lang.GotolocSucess[ player.Data.Language ], getLocation.Name, TextColor.Sucess, getLocation.Creator, TextColor.Sucess, getPriceStr );

																this.Terminate();
															}
														}
														
														else 
														{
															player.Msg( TextColor.Error, Lang.TeleportFailMove[ player.Data.Language ] );
															
															this.Terminate();
														}
													}, 500, 6, player.Pos ).SetTag( "Teleport" );
												}
												else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
											}
										}
										else player.Msg( TextColor.Error, Lang.NeedCashToGotoloc[ player.Data.Language ], SqInteger.ToThousands( SqLocation.GetDistancePrice( player, SqLocation.GetLocation( args.Location ).Pos ) ) );
									}
									else player.Msg( TextColor.Error, Lang.LocationNotExist[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.NoPermissionWorldCmd[ player.Data.Language ] );
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
		else player.Msg( TextColor.Error, Lang.GotolocSyntax[ player.Data.Language ] );	
		return true;
	}
	
	function SaveLoc( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Location": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( !player.Data.Interior )
					{
						if( !player.Data.InEvent )
						{
							if( !SqAdmin.CheckMute( player.UID, player.UID2 ) )
							{
								if( !SqLocation.GetLocation( args.Location ) )
								{
									if( SqMath.IsGreaterEqual( player.Data.Stats.Cash, SqLocation.GetSavelocPrice( player ) ) )
									{
										local getPriceStr = ( SqLocation.GetSavelocPrice( player ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqLocation.GetSavelocPrice( player ) );
										
										SqLocation.SaveLocation( args.Location, player.Pos, player.Name );
									
										player.Data.Stats.Cash -= SqLocation.GetSavelocPrice( player );
										player.Data.Stats.TotalSpend += SqLocation.GetSavelocPrice( player );

										player.Msg( TextColor.Sucess, Lang.Saveloc[ player.Data.Language ], args.Location, TextColor.Sucess, getPriceStr );
									}
									else player.Msg( TextColor.Error, Lang.NeedCashToSpawn[ player.Data.Language ], SqLocation.GetSavelocPrice( player ) );
								}
								else player.Msg( TextColor.Error, Lang.LocationExist[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.MutedCantUseCmd[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.SavelocSyntax[ player.Data.Language ] );

		return true;
	}
	
	function LocInfo( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
		{
			args = { "Location": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( SqLocation.GetLocation( args.Location ) )
					{
						local getLocation = SqLocation.GetLocation( args.Location ), getPriceStr = ( SqLocation.GetDistancePrice( player, getLocation.Pos ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqLocation.GetDistancePrice( player, getLocation.Pos ) );

						player.Msg( TextColor.InfoS, Lang.LocInfo[ player.Data.Language ], getLocation.Name, TextColor.InfoS, getLocation.Creator, TextColor.InfoS, SqInteger.TimestampToDate( getLocation.DateCreate ), TextColor.InfoS, getPriceStr );
					}
					else player.Msg( TextColor.Error, Lang.LocationNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.LocinfoSyntax[ player.Data.Language ] );

		return true;
	}

	function GoTo( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Victim": stripCmd[1] };

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
								if( SqWorld.GetWorldPermission2( player, "goto" ) )
								{
									local target = SqPlayer.FindPlayer( args.Victim );
									if( target )
									{
										if( target.ID != player.ID )
										{
											if( target.Data.IsReg )
											{
												if( target.Data.Logged )
												{
													if( !target.Data.Interior )
													{
														if( !target.Data.InEvent )
														{
															if( !target.Data.AdminDuty )
															{
																if( !SqWorld.GetLockedWorldStatus( player, target.World ) )
																{
																	if( !SqWorld.GetPlayerBanInWorld( player.Data.AccID, target.World ) )
																	{
																		if( SqMath.IsGreaterEqual( player.Data.Stats.Cash, SqLocation.GetDistancePrice( player, target.Pos ) ) )
																		{
																			switch( target.Data.Settings.Teleport )
																			{
																				case "true":
																				if( SqWorld.IsStunt( player.World ) )
																				{
																					local getPriceStr = ( SqLocation.GetDistancePrice( player, target.Pos ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqLocation.GetDistancePrice( player, target.Pos ) );
																							
																					player.Pos 				= target.Pos;
																					player.Data.Stats.Cash -= SqLocation.GetDistancePrice( player, target.Pos );
																					player.Data.Stats.TotalSpend += SqLocation.GetDistancePrice( player, target.Pos );

																					if( !player.Data.Hidden ) SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoAll, player.Name, TextColor.Info, target.Name, TextColor.Info, getPriceStr );
																								
																					player.Msg( TextColor.Sucess, Lang.GotoSucess[ player.Data.Language ], target.Name, TextColor.Sucess, getPriceStr );
																					
																					if( SqWorld.GetPrivateWorld( player.World ) && player.World != target.World )
																					{
																						local world = SqWorld.World[ player.World ];
																												
																						if( world.Settings.WorldMessage != "N/A" ) player.Msg( TextColor.Sucess, Lang.WorldWelcomeMessage[ player.Data.Language ], world.Settings.WorldMessage );
																								
																						player.SetOption( SqPlayerOption.CanAttack, SToB( world.Settings.WorldKill ) );
																						player.SetOption( SqPlayerOption.DriveBy, SToB( world.Settings.WorldDriveBy ) );

																						if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.canattack ) ) player.SetOption( SqPlayerOption.CanAttack, true );
																						if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.candriveby ) ) player.SetOption( SqPlayerOption.DriveBy, true );
																						if( SqMath.IsLess( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.wep ) ) player.StripWeapons();
																					}
																					player.World  = target.World;
																				}
																					
																				else 
																				{	
																					if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
																					{
																						player.Msg( TextColor.InfoS, Lang.Goto[ player.Data.Language ] );

																						if( target.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) target.Msg( TextColor.InfoS, Lang.PlayerTriedToTele[ target.Data.Language ], player.Name, TextColor.InfoS );
																							
																						player.MakeTask( function( pos )
																						{			
																							if ( this.Data == null ) this.Data = 0;
													
																							if( target )
																							{
																								if( pos.tostring() == player.Pos.tostring() )
																								{
																									if( ++this.Data > 5 )
																									{
																										local getPriceStr = ( SqLocation.GetDistancePrice( player, target.Pos ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqLocation.GetDistancePrice( player, target.Pos ) );
																										
																										player.Pos 				= target.Pos;
																										player.Data.Stats.Cash -= SqLocation.GetDistancePrice( player, target.Pos );
																										player.Data.Stats.TotalSpend += SqLocation.GetDistancePrice( player, target.Pos );

																										if( !player.Data.Hidden ) SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoAll, player.Name, TextColor.Info, target.Name, TextColor.Info, getPriceStr );
																											
																										player.Msg( TextColor.Sucess, Lang.GotoSucess[ player.Data.Language ], target.Name, TextColor.Sucess, getPriceStr );

																										if( SqWorld.GetPrivateWorld( player.World ) && player.World != target.World )
																										{
																											local world = SqWorld.World[ player.World ];
																															
																											if( world.Settings.WorldMessage != "N/A" ) player.Msg( TextColor.Sucess, Lang.WorldWelcomeMessage[ player.Data.Language ], world.Settings.WorldMessage );
												
																											player.SetOption( SqPlayerOption.CanAttack, SToB( world.Settings.WorldKill ) );
																											player.SetOption( SqPlayerOption.DriveBy, SToB( world.Settings.WorldDriveBy ) );

																											if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.canattack ) ) player.SetOption( SqPlayerOption.CanAttack, true );
																											if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.candriveby ) ) player.SetOption( SqPlayerOption.DriveBy, true );
																											if( SqMath.IsLess( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.wep ) ) player.StripWeapons();
																										}
																										player.World  = target.World;

																										this.Terminate();
																									}
																								}
																									
																								else 
																								{
																									player.Msg( TextColor.Error, Lang.TeleportFailMove[ player.Data.Language ] );
																										
																									this.Terminate();
																								}
																							}
																							else 
																							{
																								player.Msg( TextColor.Error, Lang.TeleportFailTargetNotExist[ player.Data.Language ] )
																										
																								this.Terminate();
																							}
																						}, 500, 6, player.Pos ).SetTag( "Teleport" );
																					}
																					else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
																				}
																				break;

																				case "gang":
																				if( player.Data.ActiveGang == target.Data.ActiveGang )
																				{
																					if( SqWorld.IsStunt( player.World ) )
																					{
																						local getPriceStr = ( SqLocation.GetDistancePrice( player, target.Pos ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqLocation.GetDistancePrice( player, target.Pos ) );
																								
																						player.Pos 				= target.Pos;
																						player.Data.Stats.Cash -= SqLocation.GetDistancePrice( player, target.Pos );
																						player.Data.Stats.TotalSpend += SqLocation.GetDistancePrice( player, target.Pos );

																						if( !player.Data.Hidden ) SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoAll, player.Name, TextColor.Info, target.Name, TextColor.Info, getPriceStr );
																									
																						player.Msg( TextColor.Sucess, Lang.GotoSucess[ player.Data.Language ], target.Name, TextColor.Sucess, getPriceStr );
																						
																						if( SqWorld.GetPrivateWorld( player.World ) && player.World != target.World )
																						{
																							local world = SqWorld.World[ player.World ];
																													
																							if( world.Settings.WorldMessage != "N/A" ) player.Msg( TextColor.Sucess, Lang.WorldWelcomeMessage[ player.Data.Language ], world.Settings.WorldMessage );
																									
																							player.SetOption( SqPlayerOption.CanAttack, SToB( world.Settings.WorldKill ) );
																							player.SetOption( SqPlayerOption.DriveBy, SToB( world.Settings.WorldDriveBy ) );

																							if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.canattack ) ) player.SetOption( SqPlayerOption.CanAttack, true );
																							if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.candriveby ) ) player.SetOption( SqPlayerOption.DriveBy, true );
																							if( SqMath.IsLess( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.wep ) ) player.StripWeapons();
																						}
																						player.World  = target.World;
																					}
																						
																					else 
																					{	
																						if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
																						{
																							player.Msg( TextColor.InfoS, Lang.Goto[ player.Data.Language ] );

																							if( target.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) target.Msg( TextColor.InfoS, Lang.PlayerTriedToTele[ target.Data.Language ], player.Name, TextColor.InfoS );
																								
																							player.MakeTask( function( pos )
																							{			
																								if ( this.Data == null ) this.Data = 0;
														
																								if( target )
																								{
																									if( pos.tostring() == player.Pos.tostring() )
																									{
																										if( ++this.Data > 5 )
																										{
																											local getPriceStr = ( SqLocation.GetDistancePrice( player, target.Pos ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqLocation.GetDistancePrice( player, target.Pos ) );
																											
																											player.Pos 				= target.Pos;
																											player.Data.Stats.Cash -= SqLocation.GetDistancePrice( player, target.Pos );
																											player.Data.Stats.TotalSpend += SqLocation.GetDistancePrice( player, target.Pos );
																											
																											if( !player.Data.Hidden ) SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoAll, player.Name, TextColor.Info, target.Name, TextColor.Info, getPriceStr );
																												
																											player.Msg( TextColor.Sucess, Lang.GotoSucess[ player.Data.Language ], target.Name, TextColor.Sucess, getPriceStr );

																											if( SqWorld.GetPrivateWorld( player.World ) && player.World != target.World )
																											{
																												local world = SqWorld.World[ player.World ];
																																
																												if( world.Settings.WorldMessage != "N/A" ) player.Msg( TextColor.Sucess, Lang.WorldWelcomeMessage[ player.Data.Language ], world.Settings.WorldMessage );
													
																												player.SetOption( SqPlayerOption.CanAttack, SToB( world.Settings.WorldKill ) );
																												player.SetOption( SqPlayerOption.DriveBy, SToB( world.Settings.WorldDriveBy ) );

																												if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.canattack ) ) player.SetOption( SqPlayerOption.CanAttack, true );
																												if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.candriveby ) ) player.SetOption( SqPlayerOption.DriveBy, true );
																												if( SqMath.IsLess( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.wep ) ) player.StripWeapons();
																											}
																											player.World  = target.World;

																											this.Terminate();
																										}
																									}
																										
																									else 
																									{
																										player.Msg( TextColor.Error, Lang.TeleportFailMove[ player.Data.Language ] );
																											
																										this.Terminate();
																									}
																								}
																								else 
																								{
																									player.Msg( TextColor.Error, Lang.TeleportFailTargetNotExist[ player.Data.Language ] )
																											
																									this.Terminate();
																								}
																							}, 500, 6, player.Pos ).SetTag( "Teleport" );
																						}
																						else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
																					}
																				}
																				else player.Msg( TextColor.Error, Lang.TargetDisallowTP[ player.Data.Language ] );
																				break;

																				case "false":
																				player.Msg( TextColor.Error, Lang.TargetDisallowTP[ player.Data.Language ] );
																				break;
																			}
																		}
																		else player.Msg( TextColor.Error, Lang.NeedCashToGotoloc[ player.Data.Language ], SqInteger.ToThousands( SqLocation.GetDistancePrice( player, target.Pos ) ) );
																	}
																	else player.Msg( TextColor.Error, Lang.WorldCantEnterBanned[ player.Data.Language ] );
																}
																else player.Msg( TextColor.Error, Lang.TargetOnLockedWorld[ player.Data.Language ] );
															}
															else player.Msg( TextColor.Error, Lang.TargetAdminDuty[ player.Data.Language ] );
														}
														else player.Msg( TextColor.Error, Lang.TargetInEvent[ player.Data.Language ] );
													}
													else player.Msg( TextColor.Error, Lang.TargetInInterior[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.GotoTargetSameAsPlayer[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.NoPermissionWorldCmd[ player.Data.Language ] );
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
		else player.Msg( TextColor.Error, Lang.GotoSyntax[ player.Data.Language ] );
		return true;
	}

	function TeleportLobby( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.Interior )
				{
					if( !player.Data.GetEventType( "DM" ) )
					{
						if( !SqLocation.IsTeleporting( player ) )
						{
							if( SqWorld.IsStunt( player.World ) )
							{
								SqCast.MsgAll( TextColor.Info, Lang.GotoLobbyAll, player.Name, TextColor.Info );

								player.World 		= 100;
								player.Pos 			= Vector3.FromStr( "-1471.868164,553.079102,2008.979980" );
								player.Data.Interior = "Lobby";
							}

							else 
							{
								if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
								{
									player.Msg( TextColor.InfoS, Lang.GotoLobby[ player.Data.Language ] );
																					
									player.MakeTask( function( pos )
									{					
										if ( this.Data == null ) this.Data = 0;
										
										if( pos.tostring() == player.Pos.tostring() )
										{
											if( ++this.Data > 5 )
											{
												SqCast.MsgAll( TextColor.Info, Lang.GotoLobbyAll, player.Name, TextColor.Info );

												player.World 		= 100;
												player.Pos 			= Vector3.FromStr( "-1471.868164,553.079102,2008.979980" );
												player.Data.Interior = "Lobby";

												SqSpawn.SavePlayerSpawn( player );

												this.Terminate();		
											}							
										}
										else 
										{
											player.Msg( TextColor.Error, Lang.TeleportFailMove[ player.Data.Language ] )
																								
											this.Terminate();
										}
									}, 500, 6, player.Pos ).SetTag( "Teleport" );
								}
								else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
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
		
		return true;
	}
}