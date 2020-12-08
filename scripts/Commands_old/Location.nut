class CCmdLocation2
{
	Cmd = null;
	
	Nogoto 		= null;

	constructor( instance )
	{
		this.Cmd = instance;
		
		this.Cmd.BindFail( this, this.OnCommandFail );
		
		this.Nogoto		= this.Cmd.Create( "nogoto", "", [ "" ], 0, 0, -1, true, true );

		this.Nogoto.BindExec( this.Nogoto, this.funcNogoto );
	}

	function OnCommandFail( type, msg, payload )
	{
		local player = this.Cmd.Invoker, cmd = this.Cmd.Command;
		
		switch( type )
		{
			case SqCmdErr.IncompleteArgs:
			case SqCmdErr.UnsupportedArg:
			switch( cmd )
			{
		}
		}
	}
	
	function funcNogoto( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.Settings.rawin( "Teleport" ) ) player.Data.Settings.rawset( "Teleport", "true" );
				switch( player.Data.Settings.Teleport )
				{
					case "true":
					if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
					{
						player.Data.Settings.Teleport = "gang";

						player.Msg( TextColor.Sucess, Lang.SetGangTP[ player.Data.Language ] );
					}

					else 
					{
						player.Data.Settings.Teleport = "false";

						player.Msg( TextColor.Sucess, Lang.SetDisallowTP[ player.Data.Language ] );
					}
					break;

					case "gang":
					player.Data.Settings.Teleport = "false";

					player.Msg( TextColor.Sucess, Lang.SetDisallowTP[ player.Data.Language ] );
					break;

					case "false":
					player.Data.Settings.Teleport = "true";

					player.Msg( TextColor.Sucess, Lang.SetAllowTP[ player.Data.Language ] );
					break;
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function GotoLoc( player, args )
	{
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
													
											SqCast.MsgAll( TextColor.Info, Lang.GotolocAll, player.Name, TextColor.Info, getLocation.Name );
													
											player.Msg( TextColor.Sucess, Lang.GotolocSucess[ player.Data.Language ], getLocation.Name, TextColor.Sucess, getLocation.Creator, TextColor.Sucess, getPriceStr );
										}

										else
										{
											if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
											{
												player.Msg( TextColor.InfoS, Lang.Gotoloc[ player.Data.Language ] );
												
												player.MakeTask( function( pos )
												{
													if( pos.tostring() == player.Pos.tostring() )
													{
														local getLocation = SqLocation.GetLocation( args.Location ), getPriceStr = ( SqLocation.GetDistancePrice( player, getLocation.Pos ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqLocation.GetDistancePrice( player, getLocation.Pos ) );
													
														player.Pos 				= getLocation.Pos;
														player.Data.Stats.Cash -= SqLocation.GetDistancePrice( player, getLocation.Pos );
														
														SqCast.MsgAll( TextColor.Info, Lang.GotolocAll, player.Name, TextColor.Info, getLocation.Name );
														
														player.Msg( TextColor.Sucess, Lang.GotolocSucess[ player.Data.Language ], getLocation.Name, TextColor.Sucess, getLocation.Creator, TextColor.Sucess, getPriceStr );

														player.FindTask( "Teleport" ).Terminate();
													}
													
													else 
													{
														player.Msg( TextColor.Error, Lang.TeleportFailMove[ player.Data.Language ] );
														
														player.FindTask( "Teleport" ).Terminate();
													}
												}, 5000, 1, player.Pos ).SetTag( "Teleport" );
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
		
		return true;
	}
	
	function SaveLoc( player, args )
	{
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
		
		return true;
	}
	
	function LocInfo( player, args )
	{
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
		
		return true;
	}

	function GoTo( player, args )
	{
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
														if( target.Data.Settings.Teleport == "true" )
														{
															if( !target.Data.AdminDuty )
															{
																if( !SqWorld.GetLockedWorldStatus( player, target.World ) )
																{
																	if( !SqWorld.GetPlayerBanInWorld( player.Data.AccID, target.World ) )
																	{
																		if( SqMath.IsGreaterEqual( player.Data.Stats.Cash, SqLocation.GetDistancePrice( player, target.Pos ) ) )
																		{
																			if( SqWorld.IsStunt( player.World ) )
																			{
																				local getPriceStr = ( SqLocation.GetDistancePrice( player, target.Pos ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqLocation.GetDistancePrice( player, target.Pos ) );
																					
																				player.Pos 				= target.Pos;
																				player.Data.Stats.Cash -= SqLocation.GetDistancePrice( player, target.Pos );
																						
																				SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoAll, player.Name, TextColor.Info, target.Name );
																						
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
																						if( target )
																						{
																							if( pos.tostring() == player.Pos.tostring() )
																							{
																								local getPriceStr = ( SqLocation.GetDistancePrice( player, target.Pos ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqLocation.GetDistancePrice( player, target.Pos ) );
																							
																								player.Pos 				= target.Pos;
																								player.Data.Stats.Cash -= SqLocation.GetDistancePrice( player, target.Pos );
																								
																								SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoAll, player.Name, TextColor.Info, target.Name );
																								
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

																								player.FindTask( "Teleport" ).Terminate();
																							}
																							
																							else 
																							{
																								player.Msg( TextColor.Error, Lang.TeleportFailMove[ player.Data.Language ] );
																								
																								player.FindTask( "Teleport" ).Terminate();
																							}
																						}
																						else 
																						{
																							player.Msg( TextColor.Error, Lang.TeleportFailTargetNotExist[ player.Data.Language ] )
																								
																							player.FindTask( "Teleport" ).Terminate();
																						}
																					}, 5000, 1, player.Pos ).SetTag( "Teleport" );
																				}
																				else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
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
														else player.Msg( TextColor.Error, Lang.TargetDisallowTP[ player.Data.Language ] );
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
		
		return true;
	}

	function TeleportLobby( player, args )
	{
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
							if( SqWorld.IsStunt( player.World ) )
							{
								SqCast.MsgAll( TextColor.Info, Lang.GotoLobbyAll, player.Name, TextColor.Info );

								player.World 		= 100;
								player.Pos 			= Vector3( 1384.020020, 372.897003, 27.975599 );
								player.Data.Interior = "Lobby";
							}

							else 
							{
								if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
								{
									player.Msg( TextColor.InfoS, Lang.GotoLobby[ player.Data.Language ] );
																					
									player.MakeTask( function( pos )
									{															
										if( pos.tostring() == player.Pos.tostring() )
										{
											SqCast.MsgAll( TextColor.Info, Lang.GotoLobbyAll, player.Name, TextColor.Info );

											player.World 		= 100;
											player.Pos 			= Vector3( 1384.020020, 372.897003, 27.975599 );
											player.Data.Interior = "Lobby";

											player.FindTask( "Teleport" ).Terminate();									
										}
										else 
										{
											player.Msg( TextColor.Error, Lang.TeleportFailTargetNotExist[ player.Data.Language ] )
																								
											player.FindTask( "Teleport" ).Terminate();
										}
									}, 5000, 1, player.Pos ).SetTag( "Teleport" );
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