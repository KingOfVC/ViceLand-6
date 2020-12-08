class CCmdWorld
{
	Cmd              = null;
	
	Buyworld         = null;
	Worldsetting     = null;
	Worldkick        = null;
	Worldban         = null;
	Worldunban       = null;
	Worldsetlevel    = null;
	Worldpermission  = null;
	Worldlock        = null;
	WorldAnn         = null;
	WorldGoto        = null;
	WorldInfo		 = null;
	
	constructor( instance )
	{
		this.Cmd = instance;
		
		this.Cmd.BindFail( this, this.funcFailCommand );
		
		this.Buyworld        = this.Cmd.Create("claimworld", "", [], 0, 0, -1, true, true );
		this.Worldsetting    = this.Cmd.Create("worldsetting", "s|g", [ "Type", "Value" ], 1, 2, -1, true, true );
		this.Worldkick       = this.Cmd.Create("worldkick", "s|g", [ "Victim", "Reason" ], 1, 2, -1, true, true );
		this.Worldban        = this.Cmd.Create("worldban", "s|g", [ "Victim", "Reason" ], 1, 2, -1, true, true );
		this.Worldunban      = this.Cmd.Create("worldunban", "s", [ "Victim" ], 1, 1, -1, true, true );
		this.Worldsetlevel   = this.Cmd.Create("worldsetlevel", "s|i", [ "Victim", "Value" ], 2, 2, -1, true, true );
		this.Worldpermission = this.Cmd.Create("worldpermission", "s|i", [ "Type", "Value" ], 2 2, -1, true, true );
		this.Worldlock       = this.Cmd.Create("worldlock", "s", [ "Value" ], 0, 0, -1, true, true );
		this.WorldAnn        = this.Cmd.Create("worldann", "s|i|g", [ "Victim", "Style", "Text" ], 3, 3, -1, true, true );
		this.WorldGoto       = this.Cmd.Create("gotoworld", "i", [ "Value" ], 1, 1, -1, true, true );
		this.WorldInfo       = this.Cmd.Create("worldinfo", "i", [ "Value" ], 0, 1, -1, true, true );

		this.Buyworld.BindExec( this.Buyworld, this.funcBuyworld );
		this.Worldsetting.BindExec( this.Worldsetting, this.funcWorldsetting );
		this.Worldkick.BindExec( this.Worldkick, this.funcWorldkick );
		this.Worldban.BindExec( this.Worldban, this.funcWorldban );
		this.Worldunban.BindExec( this.Worldunban, this.funcWorldunban );
		this.Worldsetlevel.BindExec( this.Worldsetlevel, this.funcWorldsetlevel );
		this.Worldpermission.BindExec( this.Worldpermission, this.funcWorldpermission );
		this.Worldlock.BindExec( this.Worldlock, this.funcWorldlock );
		this.WorldAnn.BindExec( this.WorldAnn, this.funcWorldAnn );
		this.WorldGoto.BindExec( this.WorldGoto, this.funcWorldGoto );
		this.WorldInfo.BindExec( this.WorldInfo, this.funcWorldInfo );
	}
	
	/*function funcFailCommand( type, msg, payload )
	{
		local player = this.Cmd.Invoker, cmd = this.Cmd.Command;

		switch( type )
		{
			case SqCmdErr.IncompleteArgs:
			case SqCmdErr.UnsupportedArg:
			switch( cmd )
			{
				case "worldsetting":
				player.Msg( Colour.Red, Lang.WorldSettingSyntax1[ player.Data.Language ] );
				break;
				
				case "worldkick":
				player.Msg( Colour.Red, Lang.WorldKickSyntax1[ player.Data.Language ] );
				break;
				
				case "worldban":
				player.Msg( Colour.Red, Lang.WorldBanSyntax1[ player.Data.Language ] );
				break;
				
				case "worldunban":
				player.Msg( Colour.Red, Lang.WorldUnbanSyntax1[ player.Data.Language ] );
				break;
				
				case "worldsetlevel":
				player.Msg( Colour.Red, Lang.WorldSetlevelSyntax1[ player.Data.Language ] );
				break;
				
				case "worldpermission":
				player.Msg( Colour.Red, Lang.WorldPermissionSyntax1[ player.Data.Language ] );
				break;
				
				case "worldann":
				player.Msg( Colour.Red, Lang.WorldAnnSyntax1[ player.Data.Language ] );
				break;
				
				case "gotoworld":
				player.Msg( Colour.Red, Lang.WorldGotoSyntax1[ player.Data.Language ] );
				break;

				case "worldinfo":
				player.Msg( Colour.Red, Lang.WorldInfoSyntax1[ player.Data.Language ] );
				break;
			}
		}
	}*/
	
		function funcFailCommand( type, msg, payload )
	{
		local player = this.Cmd.Invoker, cmd = this.Cmd.Command;
		
		switch( type )
		{
			case SqCmdErr.EmptyCommand:
			player.Msg( Colour.Red, msg );
			break;
			
			case SqCmdErr.InvalidCommand:
			player.Msg( Colour.Red, msg );
			break;

			case SqCmdErr.UnknownCommand:
			player.Msg( Colour.Red, msg );
			break;

			case SqCmdErr.MissingExecuter:
			player.Msg( Colour.Red, msg );
			break;
			
			case SqCmdErr.IncompleteArgs:
			player.Msg( Colour.Red, msg );
			break;
	
			case SqCmdErr.ExtraneousArgs:
			player.Msg( Colour.Red, msg );
			break;

			case SqCmdErr.UnsupportedArg:
			player.Msg( Colour.Red, msg );
			break;
		}
	}

	function funcBuyworld( player, args )
	{
		if( SqWorld.GetPrivateWorld( player.World ) )
		{
			if( World[ player.World ].Owner == "N/A" )
			{
				World[ player.World ].Owner = player.Name;
				World[ player.World ].Save();
				
				player.Msg( Colour.Green, Lang.WorldOwnWorld[ player.Data.Language ] );
			}
			else player.Msg( Colour.Red, Lang.WorldAlreadyHasOwner[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.WorldInvalidWorld[ player.Data.Language ] );
	
		return true;
	}
	
	function funcWorldsetting( player, args )
	{
		if( SqWorld.GetPrivateWorld( player.World ) )
		{
			if( SqMath.IsGreaterEqual( World[ player.World ].GetPlayerLevelInWorld( player.Name ), World[ player.World ].Permissions.worldsetlevelcmd.tointeger() ) )
			{
				switch( args.Type )
				{
				//	case "Type":
				
					case "name":
					if( World[ player.World ].Permissions.worldsetlevelcmd.tointeger() < World[ player.World ].GetPlayerLevelInWorld( player.Name ) )
					{
						if( args.len() == 2 )
						{
							World[ player.World ].Settings.WorldName = args.Value;
							World[ player.World ].Save();
							
							player.Msg( Colour.Green, Lang.WorldSetName[ player.Data.Language ], args.Value );
						}
						else player.Msg( Colour.Red, Lang.WorldSetNameSyntax1[ player.Data.Language ] );
					}
					else player.Msg( Colour.Red, Lang.WorldNoPermission[ player.Data.Language ] );
					break;
					
					case "welcomemessage":
					case "welcomemsg":
					if( World[ player.World ].Permissions.setworldmessage.tointeger() < World[ player.World ].GetPlayerLevelInWorld( player.Name ) )
					{
						if( args.len() == 2 )
						{
							switch( args.Value )
							{
								case "none":
								World[ player.World ].Settings.WorldMessage = "N/A";
								World[ player.World ].Save();
							
								player.Msg( Colour.Green, Lang.WorldSetWelcomeMessageRemove[ player.Data.Language ] );
								break;
								
								default:
								if( args.Value )
								{
									World[ player.World ].Settings.WorldMessage = args.Value;
									World[ player.World ].Save();

									player.Msg( Colour.Green, Lang.WorldSetWelcomeMessage[ player.Data.Language ], args.Value );
								}
								else player.Msg( Colour.Red, Lang.WorldSetWelcomeMessageSyntax[ player.Data.Language ] );
								break;
							}
						}
						else player.Msg( Colour.Red, Lang.WorldSetWelcomeMessageSyntax[ player.Data.Language ] );
					}
					else player.Msg( Colour.Red, Lang.WorldNoPermission[ player.Data.Language ] );
					break;
					
					case "spawn":
					case "worldspawn":
					if( SqMath.IsGreaterEqual( World[ player.World ].GetPlayerLevelInWorld( player.Name ), World[ player.World ].Permissions.setworldspawn.tointeger() ) )
					{
						World[ player.World ].Settings.WorldSpawn = player.Pos.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.WorldSetSpawn[ player.Data.Language ] );
					}
					else player.Msg( Colour.Red, Lang.WorldNoPermission[ player.Data.Language ] );
					break;					
				
					case "worldkill":
					if( SqMath.IsGreaterEqual( World[ player.World ].GetPlayerLevelInWorld( player.Name ), World[ player.World ].Permissions.worldkill.tointeger() ) )
					{
						switch( World[ player.World ].Settings.WorldKill )
						{
							case "true":
							World[ player.World ].Settings.WorldKill = "false";
							World[ player.World ].Save();
			
							SqCast.MsgWorld( Colour.LPink, player.World, Lang.WorldKillOff, player.Name );
						
							SqForeach.Player.Active( this, function( plr ) 
							{
								if( player.World == plr.World ) player.SetOption( SqPlayerOption.CanAttack, false );
							});
							
							player.Msg( Colour.Green, Lang.WorldkillOffAdmin[ player.Data.Language ] );
							break;
						
							case "false":
							World[ player.World ].Settings.WorldKill = "true";
							World[ player.World ].Save();
							
							SqCast.MsgWorld( Colour.LPink, player.World, Lang.WorldKillOn, player.Name );
						
							SqForeach.Player.Active( this, function( plr ) 
							{
								if( player.World == plr.World ) player.SetOption( SqPlayerOption.CanAttack, true );
							});
							
							player.Msg( Colour.Green, Lang.WorldkillOnAdmin[ player.Data.Language ] );
							break;
						}
					}
					else player.Msg( Colour.Red, Lang.WorldNoPermission[ player.Data.Language ] );
					break;					
					default: 
					player.Msg( Colour.Red, Lang.WorldSettingSyntax1[ player.Data.Language ] );
					break;
				}
			}
			else player.Msg( Colour.Red, Lang.WorldNoPermission[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.WorldInvalidWorld[ player.Data.Language ] );
		
		return true;
	}
	
	function funcWorldkick( player, args )
	{
		if( SqWorld.GetPrivateWorld( player.World ) )
		{
			if( SqMath.IsGreaterEqual( World[ player.World ].GetPlayerLevelInWorld( player.Name ), World[ player.World ].Permissions.worldkick.tointeger() ) )
			{
				switch( args.Victim )
				{
					case "all":
					local isKicked = false;
					
					SqForeach.Player.Active( this, function( plr ) 
					{
						if( plr.World == player.World && plr.Name != player.Name )
						{							
							plr.Msg( Colour.LPink, player.World, Lang.WorldkickAll[ player.Data.Language ], player.Name );
							plr.Msg( Colour.Yellow, Lang.WorldkickNotice[ player.Data.Language ], player.World );
							plr.World = 0;
							
							isKicked = true;
						}
					});
					
					if( isKicked ) player.Msg( Colour.Green, Lang.WorldkickAllAdmin[ player.Data.Language ] );
					else player.Msg( Colour.Red, Lang.WorldkickAllNoPlayer[ player.Data.Language ] );
					break;
					
					default:
					if( SqPlayer.FindPlayer( args.Victim ) )
					{
						local plr = SqPlayer.FindPlayer( args.Victim );

						if( plr.World == player.World )
						{
							if( args.len() == 2 )
							{
								SqCast.MsgWorld( Colour.LPink, player.World, Lang.WorldkickAnn, player.Name, plr.Name, args.Reason );
							
								player.Msg( Colour.Green, Lang.WorldkickAdmin[ player.Data.Language ], plr.Name, args.Reason );

								plr.Msg( Colour.Yellow, Lang.WorldkickNotice[ plr.Data.Language ], player.World );
								plr.World = 0;
							}
							
							else
							{
								SqCast.MsgWorld( Colour.LPink, player.World, Lang.WorldkickWithoutReason, player.Name, plr.Name );
								
								player.Msg( Colour.Green, Lang.WorldkickAdminWithoutReason[ player.Data.Language ], plr.Name );
							
								plr.Msg( Colour.Yellow, Lang.WorldkickNotice[ plr.Data.Language ], player.World );
								plr.World = 0;
							}
						}
						else player.Msg( Colour.Red, Lang.WorldNotSameWorld[ player.Data.Language ] );
					}
					else player.Msg( Colour.Red, Lang.InvalidPlayer[ player.Data.Language ] );
					break;
				}
			}
			else player.Msg( Colour.Red, Lang.WorldNoPermission[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.WorldInvalidWorld[ player.Data.Language ] );
		
		return true;
	}
	
	function funcWorldban( player, args )
	{
		if( SqWorld.GetPrivateWorld( player.World ) )
		{
			if( SqMath.IsGreaterEqual( World[ player.World ].GetPlayerLevelInWorld( player.Name ), World[ player.World ].Permissions.worldban.tointeger() ) )
			{
				if( SqPlayer.FindPlayer( args.Victim ) )
				{
					local plr = SqPlayer.FindPlayer( args.Victim );

					if( plr.World == player.World )
					{
						if( args.len() == 2 )
						{
							SqCast.MsgWorld( Colour.LPink, player.World, Lang.WorldbanAnn, player.Name, plr.Name, args.Reason );
							
							World[ player.World ].AddPlayerToWorld( plr.Name, 0, "true" )
							
							player.Msg( Colour.Green, Lang.WorldBanAdmin[ player.Data.Language ], plr.Name, args.Reason );

							plr.Msg( Colour.Yellow, Lang.WorldbanNotice[ plr.Data.Language ], player.World );
							plr.World = 0;
						}
							
						else
						{
							SqCast.MsgWorld( Colour.LPink, player.World, Lang.WorldbanWithoutReason, player.Name, plr.Name );
							
							World[ player.World ].AddPlayerToWorld( plr.Name, 0, "true" )

							player.Msg( Colour.Green, Lang.WorldBanAdminWithoutReason[ player.Data.Language ], plr.Name );

							plr.Msg( Colour.Yellow, Lang.WorldbanNotice[ plr.Data.Language ], player.World );
							plr.World = 0;
						}
					}
					else player.Msg( Colour.Red, Lang.WorldNotSameWorld[ player.Data.Language ] );
				}
				else player.Msg( Colour.Red, Lang.InvalidPlayer[ player.Data.Language ] );
			}
			else player.Msg( Colour.Red, Lang.WorldNoPermission[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.WorldInvalidWorld[ player.Data.Language ] );
		
		return true;
	}
	
	function funcWorldunban( player, args )
	{
		if( SqWorld.GetPrivateWorld( player.World ) )
		{
			if( SqMath.IsGreaterEqual( World[ player.World ].GetPlayerLevelInWorld( player.Name ), World[ player.World ].Permissions.worldunban.tointeger() ) )
			{
				if( SqPlayer.FindPlayer( args.Victim ) )
				{
					if( World[ player.World ].GetPlayerBanInWorld( plr.Name ) )
					{
						local plr = SqPlayer.FindPlayer( args.Victim );
								
						SqCast.MsgWorld( Colour.LPink, player.World, Lang.WorldUnban, player.Name, plr.Name );
							
						World[ player.World ].AddPlayerToWorld( plr.Name, 0, "false" )

						player.Msg( Colour.Green, Lang.WorlunbanAdmin[ player.Data.Language ], plr.Name );
						
						plr.Msg( Colour.Yellow, Lang.WorldunbanNotice[ plr.Data.Language ] );
					}
					else player.Msg( Colour.Red, Lang.WorldUnbanPlrNotBanned[ player.Data.Language ] );
				}
				else
				{
					if( World[ player.World ].GetPlayerBanInWorld( args.Victim ) )
					{
						SqCast.MsgWorld( Colour.LPink, player.World, Lang.WorldUnban, player.Name, args.Victim );
						
						player.Msg( Colour.Green, Lang.WorldunbanAdmin[ player.Data.Language ], args.Victim );

						World[ player.World ].NameList[ World[ player.World ].FindWorldPlayer( args.Victim ) ].Ban = "false";	
						World[ player.World ].Save();
					}
					else player.Msg( Colour.Red, Lang.WorldUnbanPlrNotBanned[ player.Data.Language ] );
				}
			}
			else player.Msg( Colour.Red, Lang.WorldNoPermission[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.WorldInvalidWorld[ player.Data.Language ] );
		
		return true;
	}
	
	function funcWorldsetlevel( player, args )
	{
		if( SqWorld.GetPrivateWorld( player.World ) )
		{
			if( SqMath.IsGreaterEqual( World[ player.World ].GetPlayerLevelInWorld( player.Name ), World[ player.World ].Permissions.worldsetlevel.tointeger() ) )
			{
				if( SqPlayer.FindPlayer( args.Victim ) )
				{
					local plr = SqPlayer.FindPlayer( args.Victim );
					
					if( plr.World == player.World )
					{
						if( SqWorld.GetCorrectValue( args.Value ) )
						{
							SqCast.MsgWorld( Colour.LPink, player.World, Lang.WorldSetlevel, player.Name, plr.Name, args.Value );
								
							World[ player.World ].AddPlayerToWorld( plr.Name, args.Value )

							player.Msg( Colour.Green, Lang.WorldsetlevelAdmin[ player.Data.Language ], plr.Name, args.Value );
							
							plr.Msg( Colour.Yellow, Lang.WorldsetlevelNotice[ plr.Data.Language ], args.Value );
						}
						else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					}
					else player.Msg( Colour.Red, Lang.WorldNotSameWorld[ player.Data.Language ] );
				}
				else player.Msg( Colour.Red, Lang.InvalidPlayer[ player.Data.Language ] );
			}
			else player.Msg( Colour.Red, Lang.WorldNoPermission[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.WorldInvalidWorld[ player.Data.Language ] );
		
		return true;
	}
	
	function funcWorldpermission( player, args )
	{
		if( SqWorld.GetPrivateWorld( player.World ) )
		{
			if( SqMath.IsGreaterEqual( World[ player.World ].GetPlayerLevelInWorld( player.Name ), World[ player.World ].Permissions.worldsetlevelcmd.tointeger() ) )
			{
				switch( args.Type )
				{
					case "setworldname":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].setworldname = args.Value.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Set world name", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;
				
					case "setworldmessage":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].setworldmessage = args.Value.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Set welcome message", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;
					
					case "setworldtype":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].setworldtype = args.Value;
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Set world type", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;
				
					
					case "setworldspawn":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].setworldspawn = args.Value.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Set world spawn", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;
					
					case "worldkick":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].worldkick = args.Value.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Kick player", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;
					
					case "worldban":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].worldban = args.Value.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Ban player", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;
					
					case "worldunban":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].worldunban = args.Value.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Unban player", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;
					
					case "setworldname":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].setworldname = args.Value.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Welcome Message", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;
					
					case "worldsetlevel":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].worldsetlevel = args.Value.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Set level", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;
					
					case "mapping":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].mapping = args.Value.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Pickup/Object manage", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;
					
					case "vehspawning":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].vehspawning = args.Value.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Vehicle spawning", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;
					
					case "vehmanage":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].vehmanage = args.Value.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Vehicle manage", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;
					
					case "worldkill":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].worldkill = args.Value.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Enable/Disable killing", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;
					
					case "worldann":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].worldann = args.Value.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Sending announcement", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;
				
					case "worldsetlevelcmd":
					if( SqWorld.GetCorrectValue( args.Value ) )
					{
						World[ player.World ].worldsetlevelcmd = args.Value.tostring();
						World[ player.World ].Save();
						
						player.Msg( Colour.Green, Lang.Worldsetlevelcmd[ player.Data.Language ], "Set command level", args.Value );
					}
					else player.Msg( Colour.Red, Lang.WorldLevelNotValid[ player.Data.Language ] );
					break;			

					default:
					player.Msg( Colour.Red, Lang.WorldSetlevelSyntax1[ player.Data.Language ] );
					break;			
				}
			}
			else player.Msg( Colour.Red, Lang.WorldNoPermission[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.WorldInvalidWorld[ player.Data.Language ] );
		
		return true;
	}

	function funcWorldlock( player, args )
	{
		if( SqWorld.GetPrivateWorld( player.World ) )
		{
			if( SqMath.IsGreaterEqual( World[ player.World ].GetPlayerLevelInWorld( player.Name ), World[ player.World ].Permissions.worldlock.tointeger() ) )
			{
				switch( World[ player.World ].Settings.LockWorld )
				{
					case "true":
					World[ player.World ].Settings.LockWorld = "false";
					World[ player.World ].Save();
					
					SqCast.MsgWorld( Colour.LPink, player.World, Lang.WorldlockOffAll );
					
					player.Msg( Colour.Green, Lang.WorldlockOff[ player.Data.Language ] );
					break;
					
					case "false":
					World[ player.World ].Settings.LockWorld = "true";
					World[ player.World ].Save();
					
					SqCast.MsgWorld( Colour.LPink, player.World, Lang.WorldlockOnAll );
					
					player.Msg( Colour.Green, Lang.WorldlockOn[ player.Data.Language ] );
					break;
				}
			}
			else player.Msg( Colour.Red, Lang.WorldNoPermission[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.WorldInvalidWorld[ player.Data.Language ] );
		
		return true;
	}

	function funcWorldAnn( player, args )
	{
		if( SqWorld.GetPrivateWorld( player.World ) )
		{
			if( SqMath.IsGreaterEqual( World[ player.World ].GetPlayerLevelInWorld( player.Name ), World[ player.World ].Permissions.worldann.tointeger() ) )
			{
				switch( args.Victim )
				{
					case "all":
					local isSended = false;
					SqForeach.Player.Active( this, function( plr ) 
					{
						if( plr.World == player.World )
						{
							plr.Announce( args.Style, args.Text );
							isSended = true;
						}
					});
					
					if( isSended ) player.Msg( Colour.Green, Lang.WorldAnnAllAdmin[ player.Data.Language ], args.Text );
					break;
					
					default:
					if( SqPlayer.FindPlayer( args.Victim ) )
					{
						local plr = SqPlayer.FindPlayer( args.Victim );

						if( plr.World == player.World )
						{
							plr.Announce( args.Style, args.Text );
							plr.Msg( Colour.Green, Lang.WorldAnnAdmin[ player.Data.Language ], args.Text, plr.Name );						
						}
						else player.Msg( Colour.Red, Lang.WorldNotSameWorld[ player.Data.Language ] );
					}
					else player.Msg( Colour.Red, Lang.InvalidPlayer[ player.Data.Language ] );
					break;
				}
			}
			else player.Msg( Colour.Red, Lang.WorldNoPermission[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.WorldInvalidWorld[ player.Data.Language ] );
		
		return true;
	}

	function funcWorldGoto( player, args )
	{
		if( SqWorld.GetPrivateWorld( args.Value ) )
		{
			if( !World.rawin( args.Value ) ) World.rawset( args.Value, CWorld( args.Value ) );
			
			if( World[ args.Value ].Settings.LockWorld == "false" && SqMath.IsGreaterEqual( World[ player.World ].GetPlayerLevelInWorld( player.Name ), World[ args.Value ].Permissions.worldlock.tointeger() ) )
			{
				if( !World[ args.Value ].GetPlayerBanInWorld( player.Name ) )
				{
					if( player.World != args.Value )
					{
						if( World[ args.Value ].Owner == "N/A" ) player.Msg( Colour.Yellow, Lang.WorldNoOwnerCanClaim[ player.Data.Language ] );
					
						if( World[ args.Value ].Settings.WorldMessage != "N/A" ) player.Msg( Colour.Yellow, Lang.WorldWelcomeMessage[ player.Data.Language ], World[ args.Value ].Settings.WorldMessage );
						
						player.World = args.Value;
						player.Pos = Vector3.FromStr( World[ args.Value ].Settings.WorldSpawn );
						player.SetOption( SqPlayerOption.CanAttack, SToB( World[ args.Value ].Settings.WorldKill ) );
					}
					else player.Msg( Colour.Red, Lang.WorldSameWorld[ player.Data.Language ] );
				}
				else player.Msg( Colour.Red, Lang.WorldCantEnterBanned[ player.Data.Language ] );
			}
			else player.Msg( Colour.Red, Lang.WorldIsLocked[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.WorldInvalidWorld[ player.Data.Language ] );
		
		return true;
	}
	
	function funcWorldInfo( player, args )
	{
		if( args.len() == 0 )
		{
			if( SqWorld.GetPrivateWorld( player.World ) )
			{
				if( !World.rawin( player.World ) ) World.rawset( player.World, CWorld( player.World ) );
				
				if( World[ player.World ].Owner != "N/A" )
				{
					player.Msg( Colour.Green, Lang.WorldInfo1[ player.Data.Language ], player.World, World[ player.World ].Owner, World[ player.World ].Settings.WorldName );
					player.Msg( Colour.Green, Lang.WorldInfo2[ player.Data.Language ], World[ player.World ].Settings.LockWorld, World[ player.World ].Settings.WorldKill, World[ player.World ].Settings.WorldType );
					
					if( World[ player.World ].Permissions.setworldmessage.tointeger() < World[ player.World ].GetPlayerLevelInWorld( player.Name ) ) player.Msg( Colour.Green, Lang.WorldInfo3[ player.Data.Language ], World[ player.World ].Settings.WorldMessage );
				}
				else player.Msg( Colour.Yellow, Lang.WorldNoOwnerCanClaim[ player.Data.Language ] );
			}
			else player.Msg( Colour.Red, Lang.WorldInvalidWorld[ player.Data.Language ] );
		}
		
		else
		{
			if( SqWorld.GetPrivateWorld( args.Value ) )
			{
				if( !World.rawin( args.Value ) ) World.rawset( args.Value, CWorld( args.Value ) );
				
				if( World[ args.Value ].Owner != "N/A" )
				{
					player.Msg( Colour.Green, Lang.WorldInfo1[ player.Data.Language ], args.Value, World[ args.Value ].Owner, World[ args.Value ].Settings.WorldName );
					player.Msg( Colour.Green, Lang.WorldInfo2[ player.Data.Language ], World[ args.Value ].Settings.LockWorld, World[ args.Value ].Settings.WorldKill, World[ args.Value ].Settings.WorldType );
					
					if( World[ args.Value ].Permissions.setworldmessage.tointeger() < World[ args.Value ].GetPlayerLevelInWorld( player.Name ) ) player.Msg( Colour.Green, Lang.WorldInfo3[ player.Data.Language ], World[ args.Value ].Settings.WorldMessage );
				}
				else player.Msg( Colour.Yellow, Lang.WorldNoOwnerCanClaim[ player.Data.Language ] );
			}
			else player.Msg( Colour.Red, Lang.WorldInvalidWorld[ player.Data.Language ] );
		}
		return true;
	}
}