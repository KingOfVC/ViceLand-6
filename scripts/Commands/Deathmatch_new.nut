class CCmdDeathmatch
{
	function GetWeapon( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
		{
			args = { "Weapon": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( !player.Data.InEvent )
					{
						if( SqWorld.GetWorldPermission2( player, "wep" ) )
						{
							local getWeapon = split( args.Weapon, " " ), getName = null;
							
							foreach( value in getWeapon )
							{
								local wep = ( SqInteger.IsNum( value ) ) ? value.tointeger() : GetWeaponID( value );
								
								if( !SqWorld.GetPrivateWorld( player.World ) && wep == 33 ) return player.Msg( TextColor.Error, Lang.GetWepCantGetMini[ player.Data.Language ] );

								if( IsWeaponValid( wep ) )
								{
									if( !IsWeaponNatural( wep ) )
									{
										if( SqWeapon.GetValidWeaponID( wep ) )
										{
											if( wep == 30 || wep == 12 || wep == 13 || wep == 14 || wep == 15 ) player.SetWeapon( wep, 20 );
											else player.SetWeapon( wep, 9999 );
													
											if( getName ) getName = getName + ", " + GetWeaponName( wep );
											else getName = GetWeaponName( wep );
										}
										else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
							}
							
							if( getName ) player.Msg( TextColor.Sucess, Lang.GetWep[ player.Data.Language ], getName );
						}
						else player.Msg( TextColor.Error, Lang.NoPermissionWorldCmd[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.GetwepSyntax[ player.Data.Language ], stripCmd[0] );

		return true;
	}

	function GetStats( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				args = { "Victim": ( stripCmd.len() == 2 ) ? stripCmd[1] : "" };

				if( args.Victim != "" )
				{
					local target = SqPlayer.FindPlayer( args.Victim );
					if( target )
					{
						if( target.Data.IsReg )
						{
							if( target.Data.Logged )
							{
								local ratio = ( typeof( target.Data.Stats.Kills.tofloat() / target.Data.Stats.Deaths.tofloat() ) != "float" ) ? 0.0 : target.Data.Stats.Kills.tofloat() / target.Data.Stats.Deaths.tofloat();

								player.Msg( TextColor.InfoS, Lang.InfoSTarget[ player.Data.Language ], target.Name, TextColor.InfoS );
								player.Msg( TextColor.InfoS, Lang.InfoS[ player.Data.Language ], SqInteger.ToThousands( target.Data.Stats.Kills ), TextColor.InfoS, SqInteger.ToThousands( target.Data.Stats.Deaths ), TextColor.InfoS, ratio, TextColor.InfoS, target.Data.Stats.TopSpree );
								player.Msg( TextColor.InfoS, Lang.InfoS1[ player.Data.Language ], SqInteger.TimestampToDate( target.Data.DateReg ), TextColor.InfoS, target.Data.Joined, TextColor.InfoS, SqInteger.SecondToTime( player.Data.Playtime ), TextColor.InfoS, SqInteger.ToThousands( ::getExperienceAtLevel( ::getLevelAtExperience( target.Data.Stats.XP ) ) ), SqInteger.ToThousands( ::getExperienceAtLevel( ( ::getLevelAtExperience( target.Data.Stats.XP ) + 1 ) ) ), TextColor.InfoS, SqInteger.ToThousands( ::getLevelAtExperience( target.Data.Stats.XP ) ) );
								player.Msg( TextColor.InfoS, Lang.InfoS2[ player.Data.Language ], SqInteger.ToThousands( target.Data.Stats.WFWon ), TextColor.InfoS, SqInteger.ToThousands( target.Data.Stats.ReactionWon ), TextColor.InfoS, SqInteger.ToThousands( target.Data.Stats.TotalSpend ), TextColor.InfoS, SqInteger.ToThousands( target.Data.Stats.TotalEarn ) );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
				}
				
				else
				{
					local ratio = ( typeof( player.Data.Stats.Kills.tofloat() / player.Data.Stats.Deaths.tofloat() ) != "float" ) ? 0.0 : player.Data.Stats.Kills.tofloat() / player.Data.Stats.Deaths.tofloat();
					
					player.Msg( TextColor.InfoS, Lang.InfoSSelf[ player.Data.Language ] );
					player.Msg( TextColor.InfoS, Lang.InfoS[ player.Data.Language ], SqInteger.ToThousands( player.Data.Stats.Kills ), TextColor.InfoS, SqInteger.ToThousands( player.Data.Stats.Deaths ), TextColor.InfoS, ratio, TextColor.InfoS, player.Data.Stats.TopSpree );
					player.Msg( TextColor.InfoS, Lang.InfoS1[ player.Data.Language ], SqInteger.TimestampToDate( player.Data.DateReg ), TextColor.InfoS, player.Data.Joined, TextColor.InfoS, SqInteger.SecondToTime( player.Data.Playtime ), TextColor.InfoS, SqInteger.ToThousands( ::getExperienceAtLevel( ::getLevelAtExperience( player.Data.Stats.XP ) ) ), SqInteger.ToThousands( ::getExperienceAtLevel( ( ::getLevelAtExperience( player.Data.Stats.XP ) + 1 ) ) ), TextColor.InfoS, SqInteger.ToThousands( ::getLevelAtExperience( player.Data.Stats.XP ) ) );
					player.Msg( TextColor.InfoS, Lang.InfoS2[ player.Data.Language ], SqInteger.ToThousands( player.Data.Stats.WFWon ), TextColor.InfoS, SqInteger.ToThousands( player.Data.Stats.ReactionWon ), TextColor.InfoS, SqInteger.ToThousands( player.Data.Stats.TotalSpend ), TextColor.InfoS, SqInteger.ToThousands( player.Data.Stats.TotalEarn ) );				
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function GetCurrentStats( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				args = { "Victim": ( stripCmd.len() == 2 ) ? stripCmd[1] : "" };

				if( args.Victim != "" )
				{
					local target = SqPlayer.FindPlayer( args.Victim );
					if( target )
					{
						if( target.Data.IsReg )
						{
							if( target.Data.Logged )
							{
								local countTime = time() - target.Data.CurrentStats.CurrentSession;

								player.Msg( TextColor.InfoS, Lang.InfoThis[ player.Data.Language ], target.Name, TextColor.InfoS );
								player.Msg( TextColor.InfoS, Lang.InfoThisS[ player.Data.Language ], SqInteger.ToThousands( target.Data.CurrentStats.Kills ), TextColor.InfoS, SqInteger.ToThousands( target.Data.CurrentStats.Deaths ), TextColor.InfoS, target.Data.CurrentStats.Spree );
								player.Msg( TextColor.InfoS, Lang.InfoThisS1[ player.Data.Language ], SqInteger.SecondToTime( countTime ) );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
				}
				
				else
				{
					local countTime = time() - player.Data.CurrentStats.CurrentSession;
					
					player.Msg( TextColor.InfoS, Lang.InfoThisSelf[ player.Data.Language ] );
					player.Msg( TextColor.InfoS, Lang.InfoThisS[ player.Data.Language ], SqInteger.ToThousands( player.Data.CurrentStats.Kills ), TextColor.InfoS, SqInteger.ToThousands( player.Data.CurrentStats.Deaths ), TextColor.InfoS, player.Data.CurrentStats.Spree );
					player.Msg( TextColor.InfoS, Lang.InfoThisS1[ player.Data.Language ], SqInteger.SecondToTime( countTime ) );
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function Spawnwep( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
		{
			args = { "Weapon": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( !player.Data.InEvent )
					{
						if( SqWorld.GetWorldPermission2( player, "wep" ) )
						{
							local getWeapon = split( args.Weapon, " " ), getName = null, weapon = player.Data.Player.Weapons;

							foreach( index, value in weapon ) value.Spawnwep = "false";

							foreach( value in getWeapon )
							{
								local wep = ( SqInteger.IsNum( value ) ) ? value.tointeger() : GetWeaponID( value );
								
								if( IsWeaponValid( wep ) )
								{
									if( !IsWeaponNatural( wep ) )
									{
										if( SqWeapon.GetValidWeaponID( wep ) )
										{
											if( wep == 30 || wep == 12 || wep == 13 || wep == 14 || wep == 15 ) player.SetWeapon( wep, 20 );
											else player.SetWeapon( wep, 9999 );
											
											if( wep == 33 ) player.Msg( TextColor.InfoS, Lang.SpawnMinWarn[ player.Data.Language ] );
											
											SqWeapon.UpdatePlayerSpawnwep( player, wep, "true" );
											
											if( getName ) getName = getName + ", " + GetWeaponName ( wep );
											else getName = GetWeaponName( wep );
										}
										else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
							}
							
							if( getName ) player.Msg( TextColor.Sucess, Lang.GetSpawnwep[ player.Data.Language ], getName );
						}
						else player.Msg( TextColor.Error, Lang.NoPermissionWorldCmd[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.SpawnwepSyntax[ player.Data.Language ] );

		return true;
	}
	
	function PlayerDisarm( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.InEvent )
				{
					player.StripWeapons();
					
					player.Msg( TextColor.Sucess, Lang.Disarm[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function PlayerHeal( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.GetEventType( "DM" ) )
				{
					if( !SqDM.IsHealing( player ) )
					{
						if( SqWorld.GetWorldPermission2( player, "heal" ) )
						{
							if( SqMath.IsLess( player.Health, 100 ) )
							{
								if( SqMath.IsGreaterEqual( player.Data.Stats.Cash, SqDM.GetHealingPrice( player ) ) )
								{
									if( SqWorld.IsStunt( player.World ) )
									{
										local getPriceStr = ( SqDM.GetHealingPrice( player ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqDM.GetHealingPrice( player ) );
												
										player.Data.Stats.Cash -= SqDM.GetHealingPrice( player );
										player.Data.Stats.TotalSpend += SqDM.GetHealingPrice( player );
														
										player.Health = 100;
												
										player.Msg( TextColor.Sucess, Lang.HealSucess[ player.Data.Language ], getPriceStr );
									}

									else 
									{
										if( player.Data.GetEventType( "TDM" ) )
										{
											if( SqDM.TDMGetNearestSupply( player.Data.InEvent.TDM.Team ) )
											{
												player.Msg( TextColor.InfoS, Lang.Healing[ player.Data.Language ] );
														
												player.MakeTask( function( pos )
												{
													if ( this.Data == null ) this.Data = 0;

													if( pos.tostring() == player.Pos.tostring() )
													{

														if( ++this.Data > 5 )
														{															
															player.Data.Stats.Cash -= SqDM.GetHealingPrice( player );
															player.Data.Stats.TotalSpend += SqDM.GetHealingPrice( player );

															player.Health = 100;
															
															player.Msg( TextColor.Sucess, Lang.HealSucess[ player.Data.Language ], "Free" );

															this.Terminate();
														}
													}
															
													else 
													{
														player.Msg( TextColor.Error, Lang.HealFailedMove[ player.Data.Language ] );
																
														this.Terminate();
													}
												}, 500, 6, player.Pos ).SetTag( "Healing" );
											}
											else player.Msg( TextColor.Error, Lang.TDMNotNearBaseOrSupplyVehicle[ player.Data.Language ] );
										}

										else 
										{
											if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
											{
												player.Msg( TextColor.InfoS, Lang.Healing[ player.Data.Language ] );
														
												player.MakeTask( function( pos )
												{
													if ( this.Data == null ) this.Data = 0;

													if( pos.tostring() == player.Pos.tostring() )
													{

														if( ++this.Data > 5 )
														{
															local getPriceStr = ( SqDM.GetHealingPrice( player ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqDM.GetHealingPrice( player ) );
															
															player.Data.Stats.Cash -= SqDM.GetHealingPrice( player );
															player.Data.Stats.TotalSpend += SqDM.GetHealingPrice( player );

															player.Health = 100;
															
															player.Msg( TextColor.Sucess, Lang.HealSucess[ player.Data.Language ], getPriceStr );

															this.Terminate();
														}
													}
															
													else 
													{
														player.Msg( TextColor.Error, Lang.HealFailedMove[ player.Data.Language ] );
																
														this.Terminate();
													}
												}, 500, 6, player.Pos ).SetTag( "Healing" );
											}
											else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
										}
									}
								}
								else player.Msg( TextColor.Error, Lang.NeedCashToHealth[ player.Data.Language ], SqInteger.ToThousands( SqDM.GetHealingPrice( player ) ) );					
							}
							else player.Msg( TextColor.Error, Lang.HealALreadyFull[ player.Data.Language ] );					
						}
						else player.Msg( TextColor.Error, Lang.NoPermissionWorldCmd[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.HealingInProcess[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function PlayerArmour( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.InEvent )
				{
					if( !SqDM.IsHealing( player ) )
					{
						if( SqWorld.GetWorldPermission2( player, "heal" ) )
						{
							if( SqMath.IsLess( player.Armour, 100 ) )
							{
								if( player.Data.GetInventoryItem( "ArmCase" ) )
								{
									if( SqWorld.IsStunt( player.World ) )
									{
										local deduQuatity = player.Data.Player.Inventory[ "ArmCase" ].Quatity.tointeger();
							
										player.Data.Player.Inventory[ "ArmCase" ].Quatity = ( deduQuatity - 1 );
														
										player.Armour = 100;
												
										player.Msg( TextColor.Sucess, Lang.ArmSucess[ player.Data.Language ] );
									}

									else 
									{
										if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
										{
											player.Msg( TextColor.InfoS, Lang.Armoring[ player.Data.Language ] );
													
											player.MakeTask( function( pos )
											{
												if ( this.Data == null ) this.Data = 0;

												if( pos.tostring() == player.Pos.tostring() )
												{
													if( ++this.Data > 5 )
													{
														local deduQuatity = player.Data.Player.Inventory[ "ArmCase" ].Quatity.tointeger();
												
														player.Data.Player.Inventory[ "ArmCase" ].Quatity = ( deduQuatity - 1 );
																			
														player.Armour = 100;
																
														player.Msg( TextColor.Sucess, Lang.ArmSucess[ player.Data.Language ] );

														this.Terminate();
													}
												}
														
												else 
												{
													player.Msg( TextColor.Error, Lang.ArmFailedMove[ player.Data.Language ] );
															
													this.Terminate();
												}
											}, 500, 6, player.Pos ).SetTag( "Healing" );
										}
										else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
									}
								}
								else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "ArmCase" ) );
							}
							else player.Msg( TextColor.Error, Lang.ArmALreadyFull[ player.Data.Language ] );					
						}
						else player.Msg( TextColor.Error, Lang.NoPermissionWorldCmd[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.HealingInProcess[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
}
