class CCmdDeathmatch
{
	Cmd = null;
	
	Wep 			= null;
	We 				= null;
	Weapon			= null;
	Stats 			= null;
	CurrentStats	= null;
	SpawnWep		= null;
	Disarm			= null;
	Heal			= null;
	Armour 			= null;

	constructor( instance )
	{
		this.Cmd = instance;
		
		this.Cmd.BindFail( this, this.OnCommandFail );
		
		this.Wep				= this.Cmd.Create( "wep", "g", [ "Weapon" ], 1, 1, -1, true, true );
		this.We					= this.Cmd.Create( "we", "g", [ "Weapon" ], 1, 1, -1, true, true );		
		this.Stats				= this.Cmd.Create( "stats", "s", [ "Victim" ], 0, 1, -1, true, true );
		this.CurrentStats		= this.Cmd.Create( "currentstats", "s", [ "Victim" ], 0, 1, -1, true, true );
		this.SpawnWep			= this.Cmd.Create( "spawnwep", "g", [ "Weapon" ], 1, 1, -1, true, true );
		this.Disarm				= this.Cmd.Create( "disarm", "", [ "" ], 0, 0, -1, true, true );
		this.Heal				= this.Cmd.Create( "heal", "", [ "" ], 0, 0, -1, true, true );
		this.Armour				= this.Cmd.Create( "equiparmour", "", [ "" ], 0, 0, -1, true, true );

		this.Wep.BindExec( this.Wep, this.GetWeapon );
		this.We.BindExec( this.We, this.GetWeapon );
		this.Stats.BindExec( this.Stats, this.GetStats );	
		this.CurrentStats.BindExec( this.CurrentStats, this.GetCurrentStats );		
		this.SpawnWep.BindExec( this.SpawnWep, this.Spawnwep );				
		this.Disarm.BindExec( this.Disarm, this.PlayerDisarm );	
		this.Heal.BindExec( this.Heal, this.PlayerHeal );	
		this.Armour.BindExec( this.Armour, this.PlayerArmour );
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
				case "wep":
				case "we":
				player.Msg( TextColor.Error, Lang.GetwepSyntax[ player.Data.Language ], cmd );
				break;
				
				case "spawnwep":
				player.Msg( TextColor.Error, Lang.SpawnwepSyntax[ player.Data.Language ] );
				break;
			}
		}
	}
	
	function GetWeapon( player, args )
	{
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
									if( wep == 30 || wep == 12 || wep == 13 || wep == 14 || wep == 15 ) player.SetWeapon( wep, 20 );
									else player.SetWeapon( wep, 9999 );
											
									if( getName ) getName = getName + ", " + GetWeaponName( wep );
									else getName = GetWeaponName( wep );
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
		
		return true;
	}

	function GetStats( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( args.len() == 1 )
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
								player.Msg( TextColor.InfoS, Lang.InfoS1[ player.Data.Language ], SqInteger.TimestampToDate( target.Data.DateReg ), TextColor.InfoS, target.Data.Joined, TextColor.InfoS, SqInteger.SecondToTime( player.Data.Playtime ), TextColor.InfoS, target.Data.GetAchievementComplete() );
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
					player.Msg( TextColor.InfoS, Lang.InfoS1[ player.Data.Language ], SqInteger.TimestampToDate( player.Data.DateReg ), TextColor.InfoS, player.Data.Joined, TextColor.InfoS, SqInteger.SecondToTime( player.Data.Playtime ), TextColor.InfoS, player.Data.GetAchievementComplete() );
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function GetCurrentStats( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( args.len() == 1 )
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
								player.Msg( TextColor.InfoS, Lang.InfoThisS[ player.Data.Language ], SqInteger.ToThousands( target.Data.Stats.Kills ), TextColor.InfoS, SqInteger.ToThousands( target.Data.Stats.Deaths ), TextColor.InfoS, target.Data.CurrentStats.Spree );
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
	
	function Spawnwep( player, args )
	{
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
						
						if( getName ) player.Msg( TextColor.Sucess, Lang.GetSpawnwep[ player.Data.Language ], getName );
					}
					else player.Msg( TextColor.Error, Lang.NoPermissionWorldCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function PlayerDisarm( player, args )
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
	
	function PlayerHeal( player, args )
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
							if( SqMath.IsLess( player.Health, 100 ) )
							{
								if( SqMath.IsGreaterEqual( player.Data.Stats.Cash, SqDM.GetHealingPrice( player ) ) )
								{
									if( SqWorld.IsStunt( player.World ) )
									{
										local getPriceStr = ( SqDM.GetHealingPrice( player ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqDM.GetHealingPrice( player ) );
												
										player.Data.Stats.Cash -= SqDM.GetHealingPrice( player );
														
										player.Health = 100;
												
										player.Msg( TextColor.Sucess, Lang.HealSucess[ player.Data.Language ], getPriceStr );
									}

									else 
									{
										if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
										{

											player.Msg( TextColor.InfoS, Lang.Healing[ player.Data.Language ] );
													
											player.MakeTask( function( pos )
											{
												if( pos.tostring() == player.Pos.tostring() )
												{
													local getPriceStr = ( SqDM.GetHealingPrice( player ) == 0 ) ? "Free" : "$" + SqInteger.ToThousands( SqDM.GetHealingPrice( player ) );
													
													player.Data.Stats.Cash -= SqDM.GetHealingPrice( player );
															
													player.Health = 100;
													
													player.Msg( TextColor.Sucess, Lang.HealSucess[ player.Data.Language ], getPriceStr );

													player.FindTask( "Healing" ).Terminate();
												}
														
												else 
												{
													player.Msg( TextColor.Error, Lang.HealFailedMove[ player.Data.Language ] );
															
													player.FindTask( "Healing" ).Terminate();
												}
											}, 5000, 1, player.Pos ).SetTag( "Healing" );
										}
										else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
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

	function PlayerArmour( player, args )
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
												if( pos.tostring() == player.Pos.tostring() )
												{
													local deduQuatity = player.Data.Player.Inventory[ "ArmCase" ].Quatity.tointeger();
											
													player.Data.Player.Inventory[ "ArmCase" ].Quatity = ( deduQuatity - 1 );
																		
													player.Armour = 100;
															
													player.Msg( TextColor.Sucess, Lang.ArmSucess[ player.Data.Language ] );

													player.FindTask( "Healing" ).Terminate();
												}
														
												else 
												{
													player.Msg( TextColor.Error, Lang.ArmFailedMove[ player.Data.Language ] );
															
													player.FindTask( "Healing" ).Terminate();
												}
											}, 5000, 1, player.Pos ).SetTag( "Healing" );
										}
										else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
									}
								}
								else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], "Armour Case" );
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
