class CCmdMisc
{
	function PlayerSettings( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
		{
			args = { "Type": stripCmd[1], "Option": ( stripCmd.len() == 3 ) ? stripCmd[2] : "" };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
						switch( args.Type )
						{
							case "skin":
							if( args.Option != "" )
							{
								if( SqInteger.IsNum( args.Option ) )
								{
									if( SqInteger.ValidSkin( args.Option.tointeger() ) )
									{
										if( SqWorld.IsStunt( player.World ) )
										{
											player.Data.Skin 	= args.Option.tointeger();
											player.Skin 		= args.Option.tointeger();

											player.Msg( TextColor.Sucess, Lang.SetSkin[ player.Data.Language ] );
										}

										else 
										{
											if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
											{
												player.Data.Skin 	= args.Option.tointeger();
												player.Skin 		= args.Option.tointeger();

												player.Msg( TextColor.Sucess, Lang.SetSkin[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
										}
									}
									else player.Msg( TextColor.Error, Lang.SkinIDRange[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.SkinIDNotNum[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.SettingSkinSyntax[ player.Data.Language ] );
							break;

							case "hitsound":
							if( args.Option != "" )
							{
								if( !player.Data.Settings.rawin( "Hitsound" ) ) player.Data.Settings.rawset( "Hitsound", "off" );

								switch( args.Option )
								{
									case "off":
									player.Data.Settings.Hitsound = "off";

									player.Msg( TextColor.Sucess, Lang.HitSoundOff[ player.Data.Language ] );
									break;

									default:
									if( SqInteger.IsNum( args.Option ) )
									{
										player.Data.Settings.Hitsound = args.Option;

										player.Msg( TextColor.Sucess, Lang.HitSoundOn[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.SoundNotNum[ player.Data.Language ] );
									break;
								}
							}
							else player.Msg( TextColor.Error, Lang.SettingHitsoundSyntax[ player.Data.Language ] );
							break;

							case "spec":
							if( !player.Data.Settings.rawin( "AllowSpectate" ) ) player.Data.Settings.rawset( "AllowSpectate", "true" );
							switch( player.Data.Settings.AllowSpectate )
							{
								case "true":
								player.Data.Settings.AllowSpectate = "false";

								player.Msg( TextColor.Sucess, Lang.SetDisallowSpec[ player.Data.Language ] );
								break;

								case "false":
								player.Data.Settings.AllowSpectate = "true";

								player.Msg( TextColor.Sucess, Lang.SetAllowSpec[ player.Data.Language ] );
								break;
							}
							break;

							case "team":
							if( !player.Data.Settings.rawin( "Team" ) ) player.Data.Settings.rawset( "Team", "Free" );
							switch( player.Data.Settings.Team )
							{
								case "Free":
								if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
								{
									player.Data.Settings.Team = "Gang";

									player.Team = player.Data.ActiveGang;

									player.Msg( TextColor.Sucess, Lang.SetTeamGang[ player.Data.Language ] );
								}

								else 
								{
									player.Data.Settings.Team = "Free";

									player.Msg( TextColor.Sucess, Lang.SetTeamFree[ player.Data.Language ] );
								}
								break;

								case "Gang":
								player.Data.Settings.Team = "Free";

								player.Team = 255;

								player.Msg( TextColor.Sucess, Lang.SetTeamFree[ player.Data.Language ] );
								break;
							}
							break;

							case "joinmessage":
							if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
							{
								switch( player.Data.Settings.JoinPart )
								{
									case "true":
									player.Data.Settings.JoinPart = "false";

									player.Msg( TextColor.Sucess, Lang.SetJoinPartMsgDisallow[ player.Data.Language ] );
									break;

									case "false":
									player.Data.Settings.JoinPart = "true";

									player.Msg( TextColor.Sucess, Lang.SetJoinPartMsgAllow[ player.Data.Language ] );
									break;
								}
							}
							else player.Msg( TextColor.Error, Lang.PlayerSettingSyntax[ player.Data.Language ] );
							break;

							case "showcountry":
							switch( player.Data.Settings.FakeCountry )
							{
								case "default":
								player.Data.Settings.FakeCountry = "Hidden";

								player.Msg( TextColor.Sucess, Lang.DisallowShowCountry[ player.Data.Language ] );
								break;

								case "Hidden":
								player.Data.Settings.FakeCountry = "default";

								player.Msg( TextColor.Sucess, Lang.AllowShowCountry[ player.Data.Language ] );
								break;
							}
							break;

							case "teleport":
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
							break;

							case "lobbyspawn":
							switch( player.Data.Settings.LobbySpawn )
							{
								case "Normal":
								if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
								{
									player.Data.Settings.LobbySpawn = "Admin";

									player.Msg( TextColor.Sucess, Lang.SetLobbySpawn[ player.Data.Language ], "Admin Room" );
								}

								else 
								{
									player.Data.Settings.LobbySpawn = "DM";

									player.Msg( TextColor.Sucess, Lang.SetLobbySpawn[ player.Data.Language ], "Death match" );
								}
								break;

								case "Admin":
								player.Data.Settings.LobbySpawn = "DM";

								player.Msg( TextColor.Sucess, Lang.SetLobbySpawn[ player.Data.Language ], "Death match" );
								break;

								case "DM":
								player.Data.Settings.LobbySpawn = "Normal";

								player.Msg( TextColor.Sucess, Lang.SetLobbySpawn[ player.Data.Language ], "Lobby" );
								break;
							}
							break;

							case "hud":
							switch( player.Data.Settings.Hud )
							{
								case "0":
								player.Data.Settings.Hud = "1";

								player.Msg( TextColor.Sucess, Lang.SetHudType[ player.Data.Language ], "Simple" );

								player.StreamInt( 305 );
								player.StreamString( player.Data.Settings.Hud );
								player.FlushStream( true );
								break;

								case "1":
								player.Data.Settings.Hud = "0";

								player.Msg( TextColor.Sucess, Lang.SetHudType[ player.Data.Language ], "Classic" );

								player.StreamInt( 305 );
								player.StreamString( player.Data.Settings.Hud );
								player.FlushStream( true );								
								break;
							}
							break;

							default:
							if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 ) player.Msg( TextColor.Error, Lang.PlayerSettingStaffSyntax[ player.Data.Language ] );
							else player.Msg( TextColor.Error, Lang.PlayerSettingSyntax[ player.Data.Language ] );
							break;
						}
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else 
		{
			if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 ) player.Msg( TextColor.Error, Lang.PlayerSettingStaffSyntax[ player.Data.Language ] );
			else player.Msg( TextColor.Error, Lang.PlayerSettingSyntax[ player.Data.Language ] );
		}

		return true;
	}

	function MessageSettings( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Type": stripCmd[1] };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( !player.Data.InEvent )
					{
						switch( args.Type )
						{
							case "killmessage":
							switch( player.Data.Player.CustomiseMsg.Type.Kill )
							{
								case "true":
								player.Data.Player.CustomiseMsg.Type.Kill = "false";

								player.Msg( TextColor.Sucess, Lang.DisallowKillmessage[ player.Data.Language ] );
								break;

								case "false":
								player.Data.Player.CustomiseMsg.Type.Kill = "true";

								player.Msg( TextColor.Sucess, Lang.AllowKillmessage[ player.Data.Language ] );
								break;
							}
							break;

							case "privatemessage":
							switch( player.Data.Player.CustomiseMsg.Type.PrivMsg )
							{
								case "true":
								player.Data.Player.CustomiseMsg.Type.PrivMsg = "false";

								player.Msg( TextColor.Sucess, Lang.DisallowPMmessage[ player.Data.Language ] );
								break;

								case "false":
								player.Data.Player.CustomiseMsg.Type.PrivMsg = "true";

								player.Msg( TextColor.Sucess, Lang.AllowPMmessage[ player.Data.Language ] );
								break;
							}
							break;

							case "helpmessage":
							switch( player.Data.Player.CustomiseMsg.Type.HelpMsg )
							{
								case "true":
								player.Data.Player.CustomiseMsg.Type.HelpMsg = "false";

								player.Msg( TextColor.Sucess, Lang.DisallowHelpMessage[ player.Data.Language ] );
								break;

								case "false":
								player.Data.Player.CustomiseMsg.Type.HelpMsg = "true";

								player.Msg( TextColor.Sucess, Lang.AllowHelpMessage[ player.Data.Language ] );
								break;
							}
							break;

							case "helpmessage":
							switch( player.Data.Player.TextStyle )
							{
								case 0:
								player.Data.Player.TextStyle = 1;

								player.Msg( TextColor.Sucess, Lang.ChangeTextStyle[ player.Data.Language ], 1 );
								break;

								case 1:
								player.Data.Player.TextStyle = 2;

								player.Msg( TextColor.Sucess, Lang.ChangeTextStyle[ player.Data.Language ], 2 );
								break;

								case 2:
								player.Data.Player.TextStyle = 0;

								player.Msg( TextColor.Sucess, Lang.ChangeTextStyle[ player.Data.Language ], 0 );
								break;
							}

							default:
							player.Msg( TextColor.Error, Lang.PMessageSettingSyntax[ player.Data.Language ] );
							break;
						}
					}
					else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.PMessageSettingSyntax[ player.Data.Language ] );
		
		return true;
	}

	function CheckRank( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		args = { "Victim": ( stripCmd.len() == 2 ) ? stripCmd[1] : "" };

		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( args.Victim == "" )
				{
					local getTime = ( player.Data.Player.Permission.VIP.Position == "1" ) ? " (" + SqInteger.SecondToTime( ( player.Data.Player.Permission.VIP.Duration.tointeger() - ( time() - player.Data.Player.Permission.VIP.Time.tointeger() ) ) ) + ")": "";
					
					player.Msg( TextColor.InfoS, Lang.GetPermTarget3[ player.Data.Language ] );
					player.Msg( TextColor.InfoS, Lang.GetPermTarget1[ player.Data.Language ], Server.RankName.Admin[ player.Data.Player.Permission.Staff.Position.tointeger() ], TextColor.InfoS, Server.RankName.Mapper[ player.Data.Player.Permission.Mapper.Position.tointeger() ], TextColor.InfoS, Server.RankName.VIP[ player.Data.Player.Permission.VIP.Position.tointeger() ] + getTime );
				}

				else 
				{
					local target = SqPlayer.FindPlayer( args.Victim );
					if( target )
					{
						if( target.Data.IsReg )
						{
							if( target.Data.Logged )
							{
								local getTime = ( target.Data.Player.Permission.VIP.Position == "1" ) ? " (" + SqInteger.SecondToTime( ( target.Data.Player.Permission.VIP.Duration.tointeger() - ( time() - target.Data.Player.Permission.VIP.Time.tointeger() ) ) ) + ")": "";
								
								player.Msg( TextColor.InfoS, Lang.GetPermTarget[ player.Data.Language ], target.Name, TextColor.InfoS );
								player.Msg( TextColor.InfoS, Lang.GetPermTarget1[ player.Data.Language ], Server.RankName.Admin[ target.Data.Player.Permission.Staff.Position.tointeger() ], TextColor.InfoS, Server.RankName.Mapper[ target.Data.Player.Permission.Mapper.Position.tointeger() ], TextColor.InfoS, Server.RankName.VIP[ target.Data.Player.Permission.VIP.Position.tointeger() ] + getTime );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function CheckCountry( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		args = { "Victim": ( stripCmd.len() == 2 ) ? stripCmd[1] : "" };

		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( args.Victim == "" )
				{
					player.Msg( TextColor.InfoS, Lang.OwnCountry[ player.Data.Language ], SqGeo.GetDIsplayInfo( player.IP ) );
				}

				else 
				{
					local target = SqPlayer.FindPlayer( args.Victim );
					if( target )
					{
						if( target.Data.IsReg )
						{
							if( target.Data.Logged )
							{
								if( target.Data.Settings.FakeCountry != "Hidden" )
								{
									player.Msg( TextColor.InfoS, Lang.TargetCountry[ player.Data.Language ], target.Name, TextColor.InfoS, SqGeo.GetDIsplayInfo( target.IP ) );
								}
								else player.Msg( TextColor.Error, Lang.TargetCountryHidden[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function CheckPingFPS( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		args = { "Victim": ( stripCmd.len() == 2 ) ? stripCmd[1] : "" };

		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( args.Victim == "" )
				{
					player.Msg( TextColor.InfoS, Lang.OwnFPSLimit[ player.Data.Language ], player.Ping.tostring(), TextColor.InfoS, player.FPS.tostring() );
				}

				else 
				{
					local target = SqPlayer.FindPlayer( args.Victim );
					if( target )
					{
						if( target.Data.IsReg )
						{
							if( target.Data.Logged )
							{
								player.Msg( TextColor.InfoS, Lang.TargetFPSLimit[ player.Data.Language ], target.Name, TextColor.InfoS, target.Ping.tostring(), TextColor.InfoS, target.FPS.tostring() );
							}
						else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function ShowDiscord( player, command ) { player.Msg( TextColor.InfoS, Lang.GetDiscord[ player.Data.Language ], Server.Discord ); }

	function ShowForum( player, command ) { player.Msg( TextColor.InfoS, Lang.GetForum[ player.Data.Language ], Server.Forum ); }

	function ShowOnlineAdmins( player, command )
	{		
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				local getMod = null, getAdmin = null, getSrAdmin = null, getManager = null, getOwner = null;

				SqForeach.Player.Active( this, function( plr ) 
				{
					switch( plr.Data.Player.Permission.Staff.Position.tointeger() )
					{
						case 1:
						if( getMod ) getMod = getMod + ", " + plr.Name;
						else getMod = plr.Name;
						break;

						case 2:
						if( getAdmin ) getAdmin = getAdmin + ", " + plr.Name;
						else getAdmin = plr.Name;
						break;

						case 3:
						if( getSrAdmin ) getSrAdmin = getSrAdmin + ", " + plr.Name;
						else getSrAdmin = plr.Name;
						break;

						case 4:
						if( getManager ) getManager = getManager + ", " + plr.Name;
						else getManager = plr.Name;
						break;

						case 5:
						if( getOwner ) getOwner = getOwner + ", " + plr.Name;
						else getOwner = plr.Name;
						break;
					}
				});

				if( getMod ) player.Msg( TextColor.InfoS, Lang.OnlineMod[ player.Data.Language ], getMod );
				if( getAdmin ) player.Msg( TextColor.InfoS, Lang.OnlineAdmin[ player.Data.Language ], getAdmin );
				if( getSrAdmin ) player.Msg( TextColor.InfoS, Lang.OnlineSrAdmin[ player.Data.Language ], getSrAdmin );
				if( getManager ) player.Msg( TextColor.InfoS, Lang.OnlineManager[ player.Data.Language ], getManager );
				if( getOwner ) player.Msg( TextColor.InfoS, Lang.OnlineOwner[ player.Data.Language ], getOwner );
				if( !getOwner && !getMod && !getAdmin && !getSrAdmin && !getManager ) player.Msg( TextColor.InfoS, Lang.XAdminOnline[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function ShowServerInfo( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				player.Msg( TextColor.InfoS, Lang.ServerInfo[ player.Data.Language ], Server.Version, TextColor.InfoS, Server.LastUpdate, TextColor.InfoS, SqInteger.SecondToTime( ( time() - Server.Uptime ) ) );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function ShowKeybinds( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Type": stripCmd[1] };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					switch( args.Type )
					{
						case "stunt":
						player.Msg( TextColor.InfoS, Lang.GetStuntKey[ player.Data.Language ] );
						break;

						case "vehicle":
						player.Msg( TextColor.InfoS, Lang.GetVehicleKey[ player.Data.Language ] );
						break;

						case "mapping":
						player.Msg( TextColor.InfoS, Lang.GetMappingKey[ player.Data.Language ] );
						break;

						default:
						player.Msg( TextColor.Error, Lang.GetKeybindSyntax[ player.Data.Language ] );
						break;
					}
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.GetKeybindSyntax[ player.Data.Language ] );

		return true;
	}

	function ShowCommands( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};
		
		if( stripCmd.len() == 2 )
		{
			args = { "Type": stripCmd[1] };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					switch( args.Type )
					{
						case "account":
						player.Msg( TextColor.InfoS, Lang.GetAccCmd[ player.Data.Language ] );
						break;

						case "deathmatch":
						player.Msg( TextColor.InfoS, Lang.GetDMCmd[ player.Data.Language ] );
						break;

						case "world":
						player.Msg( TextColor.InfoS, Lang.GetWorldCmd[ player.Data.Language ] );
						break;

						case "object":
						player.Msg( TextColor.InfoS, Lang.GetObjectCmd[ player.Data.Language ] );
						break;

						case "pickup":
						player.Msg( TextColor.InfoS, Lang.GetPickupCmd[ player.Data.Language ] );
						break;

						case "blip":
						player.Msg( TextColor.InfoS, Lang.GetBlipCmd[ player.Data.Language ] );
						break;

						case "vehicle":
						player.Msg( TextColor.InfoS, Lang.GetVehicleCmd[ player.Data.Language ] );
						break;

						case "misc":
						player.Msg( TextColor.InfoS, Lang.GetMiscCmd[ player.Data.Language ] );
						break;

						case "location":
						player.Msg( TextColor.InfoS, Lang.GetLocCmd[ player.Data.Language ] );
						break;

						case "gang":
						player.Msg( TextColor.InfoS, Lang.GetGangCmd[ player.Data.Language ] );
						break;

						case "item":
						player.Msg( TextColor.InfoS, Lang.GetItemCmd[ player.Data.Language ] );
						break;

						case "vip":
						player.Msg( TextColor.InfoS, Lang.GetVIPCmd[ player.Data.Language ] );
						break;

						case "anim":
						player.Msg( TextColor.InfoS, Lang.GetAnimCmd[ player.Data.Language ] );
						break;

						case "chat":
						player.Msg( TextColor.InfoS, Lang.GetChatCmd[ player.Data.Language ] );
						break;

						case "event":
						player.Msg( TextColor.InfoS, Lang.GetEventCmd[ player.Data.Language ] );
						break;						

						case "weapon":						
						player.Msg( TextColor.InfoS, Lang.GetWepCmd[ player.Data.Language ] );
						break;	
											
						case "admin":
						switch( player.Data.Player.Permission.Staff.Position.tointeger() )
						{
							case 1:
							player.Msg( TextColor.InfoS, Lang.GetModCmd[ player.Data.Language ] );
							break;

							case 2:
							player.Msg( TextColor.InfoS, Lang.GetAdminCmd[ player.Data.Language ] );
							break;

							case 3:
							player.Msg( TextColor.InfoS, Lang.GetSeniorCmd[ player.Data.Language ] );
							break;

							case 4:
							player.Msg( TextColor.InfoS, Lang.GetManCmd[ player.Data.Language ] );
							break;

							case 5:
							player.Msg( TextColor.InfoS, Lang.GetOwnerCmd[ player.Data.Language ] );
							break;

							default:
							player.Msg( TextColor.Error, Lang.GetCmdSyntax[ player.Data.Language ] );
							break;
						}
						break;

						default:
						if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 ) player.Msg( TextColor.Error, Lang.GetCmdSyntaxAdmin[ player.Data.Language ] );
						else player.Msg( TextColor.Error, Lang.GetCmdSyntax[ player.Data.Language ] );
						break;
					}
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else 
		{
			if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 ) player.Msg( TextColor.Error, Lang.GetCmdSyntaxAdmin[ player.Data.Language ] );
			else player.Msg( TextColor.Error, Lang.GetCmdSyntax[ player.Data.Language ] );
		}	
		return true;
	}

	function ReportPlayer( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};
		
		if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
		{
			args = { "Victim": stripCmd[1], "Reason": ::GetTok( command, " ", 3, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					local target = SqPlayer.FindPlayer( args.Victim );
					if( target )
					{
						if( target.Data.IsReg )
						{
							if( target.Data.Logged )
							{
								if( !player.Data.Report.find( target.Name.tolower() ) )
								{
									::SendMessageToDiscord( format( "**%s** has reported **%s** for **%s**. Victim world **%d**", player.Name, target.Name, args.Reason, target.World ), "report" );

									SqCast.MsgAdmin( TextColor.Staff, Lang.AReportAll, player.Name, TextColor.Staff, target.Name, TextColor.Staff, args.Reason, TextColor.Staff, target.World );

									player.Msg( TextColor.Sucess, Lang.ReportSend[ player.Data.Language ], target.Name, TextColor.Sucess, args.Reason );
								
									player.Data.Report.push( target.Name.tolower() );
								}
								else player.Msg( TextColor.Error, Lang.AlreadyReported[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.ReportPlrSyntax[ player.Data.Language ] );

		return true;
	}

	function NukePlayer( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};
		
		if( stripCmd.len() == 2 )
		{
			args = { "Victim": stripCmd[1] };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( !player.Data.InEvent )
					{
						if( !player.Data.Interior )
						{
							if( player.Data.GetInventoryItem( "Nuke" ) )
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
												if( !target.Data.InEvent )
												{
													if( !target.Data.Interior )
													{
														if( target.World == player.World )
														{
															local deduQuatity = player.Data.Player.Inventory[ "Nuke" ].Quatity.tointeger();
															
															player.Data.Player.Inventory[ "Nuke" ].Quatity = ( deduQuatity - 1 );

															CreateExplosion( target.World, 8, target.Pos, player, false );
															CreateExplosion( target.World, 8, target.Pos, player, false );
															CreateExplosion( target.World, 8, target.Pos, player, false );
															CreateExplosion( target.World, 8, target.Pos, player, false );
															CreateExplosion( target.World, 8, target.Pos, player, false );
															CreateExplosion( target.World, 8, target.Pos, player, false );

															SqCast.MsgAllExp( player, TextColor.Info, Lang.Nuked, target.Name, TextColor.Info, player.Name );

															target.Msg( TextColor.InfoS, Lang.NukePlr[ target.Data.Language ], player.Name, TextColor.InfoS );
															player.Msg( TextColor.InfoS, Lang.NukePlayer[ player.Data.Language ], target.Name );
														
															// cooldown
														}
														else player.Msg( TextColor.Error, Lang.WorldNotSameWorld[ player.Data.Language ] );
													}
													else player.Msg( TextColor.Error, Lang.TargetInInterior[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.TargetInEvent[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.CantNukeSelf[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "Nuke" ) );
						}
						else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NukePlrSyntax[ player.Data.Language ] ); 	
		return true;
	}

	function GetInventory( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				args = { "Victim": ( stripCmd.len() == 2 ) ? stripCmd[1] : "" };

				if( args.Victim != "" )
				{
					if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
					{
						local target = SqPlayer.FindPlayer( args.Victim );
						if( target )
						{
							if( target.Data.IsReg )
							{
								if( target.Data.Logged )
								{
									local getStr = null;
									
									foreach( index, value in target.Data.Player.Inventory )
									{
										if( value.Quatity.tointeger() > 0 )
										{
											if( getStr ) getStr = getStr + "$" + ::GetItemColor( index ) + HexColour.Red + " Quatity " + HexColour.White + value.Quatity;
											else getStr = ::GetItemColor( index ) + HexColour.Red + " Quatity " + HexColour.White + value.Quatity;
										}
									}
										
									if( getStr )
									{
										player.StreamInt( 105 );
										player.StreamString( "Inventory of " + target.Name + "$" + player.World );
										player.FlushStream( true );

										player.StreamInt( 106 );
										player.StreamString( getStr );
										player.FlushStream( true );
									}
									else player.Msg( TextColor.Error, Lang.TargetNoItem[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotPermissionViewInvent[ player.Data.Language ] );
				}
				
				else
				{
					local getStr = null;
									
					foreach( index, value in player.Data.Player.Inventory )
					{
						if( value.Quatity.tointeger() > 0 )
						{
							if( getStr ) getStr = getStr + "$" + ::GetItemColor( index ) + HexColour.Red + " Quatity " + HexColour.White + value.Quatity;
							else getStr = ::GetItemColor( index ) + HexColour.Red + " Quatity " + HexColour.White + value.Quatity;
						}
					}
										
					if( getStr )
					{
						player.StreamInt( 105 );
						player.StreamString( "Your Inventory$" + player.World );
						player.FlushStream( true );

						player.StreamInt( 106 );
						player.StreamString( getStr );
						player.FlushStream( true );
					}
					else player.Msg( TextColor.Error, Lang.NotItem[ player.Data.Language ] );
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function ChangeWeaponName( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};
		
		if( SqMath.IsGreaterEqual( stripCmd.len(), 3 ) )
		{
			args = { "Weapon": stripCmd[1], "Name": ::GetTok( command, " ", 3, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( player.Data.GetInventoryItem( "NameTag" ) )
					{
						local wep = ( SqInteger.IsNum( args.Weapon ) ) ? args.Weapon.tointeger() : GetWeaponID( args.Weapon );

						if( IsWeaponValid( wep ) )
						{
							if( !IsWeaponNatural( wep ) )
							{
								local deduQuatity = player.Data.Player.Inventory[ "NameTag" ].Quatity.tointeger();
								
								player.Data.Player.Inventory[ "NameTag" ].Quatity = ( deduQuatity - 1 );

								SqWeapon.UpdateName( player, wep, args.Name );

								player.Msg( TextColor.Sucess, Lang.ChangewepName[ player.Data.Language ], GetWeaponName( wep ), TextColor.Sucess, args.Name );
							}
							else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.GetWepNotExist[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "NameTag" ) );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.ChangeWepNameSyntax[ player.Data.Language ] );

		return true;
	}

	function EditSensitivity( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};
		
		if( stripCmd.len() == 2 )
		{
			args = { "Sens": stripCmd[1] };

			if( SqInteger.IsFloat( args.Sens ) )
			{
				if( player.Data.IsReg )
				{
					if( player.Data.Logged )
					{
						player.Data.EditSens = args.Sens.tofloat();

						player.Msg( TextColor.Sucess, Lang.EditSens1[ player.Data.Language ], args.Sens.tofloat() );
					}
					else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.EditsensSyntax[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.EditsensSyntax[ player.Data.Language ] );

		return true;
	}

	function ChangePlayerName( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};
		
		if( stripCmd.len() == 2 )
		{
			args = { "New": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( !args.New.find("@") || !args.New.find("!") || !args.New.find("?") || !args.New.find("-") || !args.New.find(",") || !args.New.find("$") || !args.New.find("%%") || !args.New.find("&") || !args.New.find("+") || !args.New.find("'") || !args.New.find("\\") || !args.New.find("|") )
					{
						if( args.New.len() < 26 )
						{
							if( player.Name.tolower() != args.New.tolower() )
							{
								if( !SqAccount.FindAccountByName( args.New ) )
								{
									try
									{
										local old = player.Name;

										player.Name = args.New;

										player.Msg( TextColor.Sucess, Lang.ChangeNameNew[ player.Data.Language ], args.New );

										SqCast.MsgAllExp( player, TextColor.Info, Lang.PlayerRename, old, TextColor.Info, args.New );

										SqCast.EchoMessage( format( "**%s** is now known as **%s**.", old, args.New ) );

										SqDatabase.Exec( format( "UPDATE Accounts SET Name = '%s' WHERE ID = '%d' ", args.New, player.Data.AccID ) );
									}
									catch( e ) player.Msg( TextColor.Error, Lang.InvalidChar[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.ChangenameNewAlreadyUsed[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.ChangenameNewAlreadySame[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.ChangenameNewTooMany[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.InvalidChar[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.ChangeNameSyntax[ player.Data.Language ] );
		
		return true;
	}

	function GetMagicStick( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				player.Msg( TextColor.Sucess, Lang.GetMagicstick[ player.Data.Language ] );

				player.SetWeapon( 109, 9999 );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function MessageLocal( player, command )
	{
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
        {
            args = { "Text": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					SqForeach.Player.Active( this, function( target ) 
                    {
                    	if( target.World == player.World )
                    	{
                    		if( target.Pos.DistanceTo( player.Pos ) < 5 )
                    		{
                    			target.Msg( TextColor.Info, Lang.MessageLocal[ target.Data.Language ], player.Name, args.Text );
                    		}
                    	}
                    });
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.MessageLocalSyntax[ player.Data.Language ] );
		
		return true;
	}

	function MessageShout( player, command )
	{
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
        {
            args = { "Text": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					SqForeach.Player.Active( this, function( target ) 
                    {
                    	if( target.World == player.World )
                    	{
                    		if( target.Pos.DistanceTo( player.Pos ) < 12 )
                    		{
                    			target.Msg( TextColor.Info, Lang.MessageShout[ target.Data.Language ], player.Name, args.Text );
                    		}
                    	}
                    });
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.MessageShoutSyntax[ player.Data.Language ] );
		
		return true;
	}


	function MessageME( player, command )
	{
        local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

        if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
        {
            args = { "Text": ::GetTok( command, " ", 2, ::NumTok( command, " " ) ) };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					SqForeach.Player.Active( this, function( target ) 
                    {
                    	if( target.World == player.World )
                    	{
                    		if( target.Pos.DistanceTo( player.Pos ) < 5 )
                    		{
                    			target.Msg( TextColor.Info, Lang.MessageME[ target.Data.Language ], player.Name, args.Text );
                    		}
                    	}
                    });
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.MessageMESyntax[ player.Data.Language ] );
		
		return true;
	}

	function Countdown( player, command )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
               	if( !SqIsRoutineWithTag( "Countdown" ) )
               	{
                	SqForeach.Player.Active( this, function( plr ) 
					{
						if( plr.World == player.World )
						{
							plr.Announce( "= 3 = 3 = 3 =", 5 );
						}
					});

                	local count = 1;
                	SqRoutine( this, function()
                	{
                		count ++;

                		switch( count )
                		{
                			case 2:
							SqForeach.Player.Active( this, function( plr ) 
							{
								if( plr.World == player.World )
								{
									plr.Announce( "= 2 = 2 = 2 =", 5 );
								}
							});
							break;

                			case 3:
							SqForeach.Player.Active( this, function( plr ) 
							{
								if( plr.World == player.World )
								{
									plr.Announce( "= 1 = 1 = 1 =", 5 );
								}
							});
							break;

                			case 4:
							SqForeach.Player.Active( this, function( plr ) 
							{
								if( plr.World == player.World )
								{
									plr.Announce( "= Go = Go = Go =", 5 );
								}
							});

						//	this.Terminate();
							break;
                		}
                	}, 1000, 0 ).SetTag( "Countdown" );
               	}
               	else player.Msg( TextColor.Error, Lang.AlreadyCD[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
        
        return true;
    }

	function GetLocation( player, command )
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
								if( !target.Data.Hidden ) player.Msg( TextColor.InfoS, Lang.TargetGetLoc[ player.Data.Language ], target.Name, TextColor.InfoS, SqWorld.GetWorldName( target.World ) );
							
								player.Msg( TextColor.InfoS, Lang.TargetGetLoc[ player.Data.Language ], target.Name, TextColor.InfoS, "Unknown", TextColor.InfoS, "Unknown" );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
				}
				
				else
				{
					player.Msg( TextColor.InfoS, Lang.GetLoc[ player.Data.Language ], SqWorld.GetWorldName( player.World ) );
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
}