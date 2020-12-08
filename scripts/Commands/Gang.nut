class CCmdGang
{
	Cmd					= null;
	
	Create				= null;
	Setting				= null;
	Invite				= null;
	Kick				= null;
	Leave				= null;
	Chat				= null;
	Members				= null;
	Permissions			= null;
	Addrank				= null;
	Editrank			= null;
	Editpermission		= null;
	Info 				= null;
	Viewrank			= null;
	Join				= null;
	Setrank 			= null;

	constructor( instance )
	{
		this.Cmd = instance;
		
		this.Cmd.BindFail( this, this.funcFailCommand );
		
		this.Create					= this.Cmd.Create( "creategang", "s|s|s", [ "Name", "Tag", "Founder" ], 3, 3, -1, true, true );
		this.Setting				= this.Cmd.Create( "gangsetting", "s|s|i|i", [ "Type", "Value", "G", "B" ], 1, 4, -1, true, true );
		this.Invite					= this.Cmd.Create( "ganginvite", "s|g", [ "Victim", "Rank" ], 2, 5, -1, true, true );
		this.Kick					= this.Cmd.Create( "gangkick", "s", [ "Victim" ], 1, 1, -1, true, true );
		this.Leave					= this.Cmd.Create( "gangleave", "", [ "" ], 0, 0, -1, true, true );
		this.Chat					= this.Cmd.Create( "gangchat", "g", [ "Text" ], 1, 5, -1, true, true );
		this.Members				= this.Cmd.Create( "gangmembers", "g", [ "Gang" ], 0, 5, -1, true, true );
		this.Permissions			= this.Cmd.Create( "gangpermissions", "g", [ "Gang" ], 0, 5, -1, true, true );
		this.Addrank				= this.Cmd.Create( "gangaddrank", "i|g", [ "Level", "Rank" ], 2, 5, -1, true, true );
		this.Editrank				= this.Cmd.Create( "gangeditrank", "s|s|g", [ "Type", "Type1", "Value" ], 2, 5, -1, true, true );
		this.Editpermission			= this.Cmd.Create( "gangeditpermission", "s|i", [ "Permission", "Level" ], 2, 2, -1, true, true );
		this.Info					= this.Cmd.Create( "ganginfo", "s", [ "Gang" ], 0, 1, -1, true, true );
		this.Viewrank				= this.Cmd.Create( "gangviewrank", "s", [ "Gang" ], 0, 1, -1, true, true );
		this.Join					= this.Cmd.Create( "joingang", "g", [ "Gang" ], 1, 1, -1, true, true );
		this.Setrank				= this.Cmd.Create( "gangsetplayerrank", "s|g", [ "Victim", "Rank" ], 2, 2, -1, true, true );

		this.Create.BindExec( this.Create, this.CreateGang );
		this.Setting.BindExec( this.Setting, this.GangSetting );
		this.Invite.BindExec( this.Invite, this.GangInvite );
		this.Kick.BindExec( this.Kick, this.GangKick );
		this.Leave.BindExec( this.Leave, this.LeaveGang );
		this.Chat.BindExec( this.Chat, this.GangChat );
		this.Members.BindExec( this.Members, this.ViewGangMembers );
		this.Permissions.BindExec( this.Permissions, this.ViewGangPermissions );
		this.Addrank.BindExec( this.Addrank, this.AddGangRank );
		this.Editrank.BindExec( this.Editrank, this.EditGangRank );
		this.Editpermission.BindExec( this.Editpermission, this.EditGangCmdLevel );
		this.Info.BindExec( this.Info, this.GangInfo );
		this.Viewrank.BindExec( this.Info, this.ViewRank );
		this.Join.BindExec( this.Join, this.JoinGang );
		this.Setrank.BindExec( this.Setrank, this.SetRank );		
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
				case "creategang":
				player.Msg( TextColor.Error, Lang.GangCreategangSyntax[ player.Data.Language ] );
				break;

				case "gangsetting":
				player.Msg( TextColor.Error, Lang.GangGangsettingSyntax[ player.Data.Language ] );
				break;

				case "ganginvite":
				player.Msg( TextColor.Error, Lang.GangGangInviteSyntax[ player.Data.Language ] );
				break;

				case "gangkick":
				player.Msg( TextColor.Error, Lang.GangGangKickSyntax[ player.Data.Language ] );
				break;

				case "gangchat":
				player.Msg( TextColor.Error, Lang.GangGangChatSyntax[ player.Data.Language ] );
				break;

				case "gangaddrank":
				player.Msg( TextColor.Error, Lang.GangGangAddRankSyntax[ player.Data.Language ] );
				break;

				case "gangeditrank":
				player.Msg( TextColor.Error, Lang.GangGangEditRankSyntax[ player.Data.Language ] );
				break;

				case "gangeditpermission":
				player.Msg( TextColor.Error, Lang.GangGangEditPermSyntax[ player.Data.Language ] );
				break;

				case "joingang":
				player.Msg( TextColor.Error, Lang.GangGangJoinSyntax[ player.Data.Language ] );
				break;

				case "gangsetplayerrank":
				player.Msg( TextColor.Error, Lang.GangGangSetPlrSyntax[ player.Data.Language ] );
				break;			
			}
		}
	}

	function CreateGang( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
				{
					local target = SqPlayer.FindPlayer( args.Founder );
					if( target )
					{
						if( target.Data.IsReg )
						{
							if( target.Data.Logged )
							{
								if( !SqGang.FindGang( args.Name ) )
								{
									if( SqMath.IsGreaterEqual( args.Tag.len(), 1 ) )
									{
										if( SqMath.IsLess( args.Tag.len(), 5 ) )
										{
											SqGang.Create( args.Name, args.Tag, target.Data.AccID );

											target.Data.Player.ActiveGang = SqGang.FindGang( args.Name );

											player.Msg( TextColor.Sucess, Lang.GangCeateGang[ player.Data.Language ], args.Name, TextColor.Sucess, SqGang.FindGang( args.Name ), TextColor.Sucess, target.Name );
										}
										else player.Msg( TextColor.Error, Lang.GangCreateTagMoreThan4[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.GangCreateTagLessThan1[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.GangAlreadyExist[ player.Data.Language ] );
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

	function GangSetting( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.ActiveGang != "N/A" )
				{
					if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
					{
						local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ];

						if( SqGang.GetPlayerLevel( getID, player.Data.AccID ) != "N/A" )
						{
							if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), getGang.Permissions.editsetting.tointeger() ) )
							{
								switch( args.Type )
								{
									case "description":
									if( args.rawin( "Value" ) )
									{
										SqGang.Gangs[ getID ].Description = args.Value;
										SqGang.Save( getID );

										SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnDespChang, player.Name, TextColor.Gang, args.Value );
									}
									else player.Msg( TextColor.Error, Lang.GangSetDespSyntax[ player.Data.Language ] );
									break;

									case "recruit":
									switch( getGang.IsOpen )
									{
										case "Open":
										SqGang.Gangs[ getID ].IsOpen = "Invite";
										SqGang.Save( getID );

										SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnRecChang, player.Name, TextColor.Gang,  "Invite only" );
										break;

										case "Invite":
										SqGang.Gangs[ getID ].IsOpen = "Closed";
										SqGang.Save( getID );

										SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnRecChang, player.Name, TextColor.Gang,  "Closed" );
										break;

										case "Closed":
										SqGang.Gangs[ getID ].IsOpen = "Open";
										SqGang.Save( getID );

										SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnRecChang, player.Name, TextColor.Gang,  "Open" );
										break;
									}
									break;

									case "tag":
									if( args.rawin( "Value" ) )
									{
										if( SqMath.IsGreaterEqual( args.Value.len(), 1 ) )
										{
											if( SqMath.IsLess( args.Value.len(), 5 ) )
											{
												SqGang.Gangs[ getID ].Tag = args.Value;
												SqGang.Save( getID );

												SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnTagChang, player.Name, TextColor.Gang,  args.Value );
											}
											else player.Msg( TextColor.Error, Lang.GangCreateTagMoreThan4[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.GangCreateTagLessThan1[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.GangSetTagSyntax[ player.Data.Language ] );
									break;

									case "color":
									if( args.rawin( "Value" ) && args.rawin( "G" ) && args.rawin( "B" ) )
									{
										if( SqInteger.IsNum( args.Value ) )
										{
											SqGang.Gangs[ getID ].Color = Color3( args.Value.tointeger(), args.G, args.B );
											SqGang.Save( getID );

											SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnColorChange, player.Name, TextColor.Gang );

											SqForeach.Player.Active( this, function( target ) 
											{
												if( target.Data.ActiveGang == getID ) target.Color = Color3( args.Value.tointeger(), args.G, args.B );
											});
										}
										else player.Msg( TextColor.Error, Lang.GangSettingChangeColorSyntax[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.GangSettingChangeColorSyntax[ player.Data.Language ] );
									break;

									default:
									player.Msg( TextColor.Error, Lang.GangGangsettingSyntax[ player.Data.Language ] );
									break;
								}
							}
							else player.Msg( TextColor.Error, Lang.GangNoPermission[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.GangNotMember[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.GangNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.GangNoInActiveGang[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function GangInvite( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.ActiveGang != "N/A" )
				{
					if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
					{
						local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ];

						if( SqGang.GetPlayerLevel( getID, player.Data.AccID ) != "N/A" )
						{
							if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), getGang.Permissions.invite.tointeger() ) )
							{
								local target = SqPlayer.FindPlayer( args.Victim );
								if( target )
								{
									if( target.Data.IsReg )
									{
										if( target.Data.Logged )
										{
											if( target.Data.ActiveGang != player.Data.ActiveGang )
											{
												if( !target.Data.GangInvite.rawin( player.Data.ActiveGang ) )
												{
													if( SqGang.FindRank( getID, args.Rank ) )
													{
														target.Data.GangInvite.rawset( player.Data.ActiveGang, 
														{
															Rank = args.Rank,
														});

														target.MakeTask( function()
														{
															target.Data.GangInvite.rawdelete( player.Data.ActiveGang );
														}, 100000, 1 );

														SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnInvite, player.Name, TextColor.Gang, target.Name, TextColor.Gang );

														target.Msg( TextColor.Gang, Lang.GangInvite[ target.Data.Language ], player.Name, TextColor.Gang, getGang.Name, TextColor.Gang, getGang.Name, TextColor.Gang );
													}
													else player.Msg( TextColor.Error, Lang.GangRankNotExist[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.GangTargetInvAlreadyInPending[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.GangTargetSameGang[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.GangNoPermission[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.GangNotMember[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.GangNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.GangNoInActiveGang[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function GangKick( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.ActiveGang != "N/A" )
				{
					if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
					{
						local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ];

						if( SqGang.GetPlayerLevel( getID, player.Data.ActiveGang ) != "N/A" )
						{
							if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), getGang.Permissions.kick.tointeger() ) )
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
												if( SqGang.GetPlayerLevel( getID, target.Name ) != "N/A" )
												{
													if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), SqGang.GetPlayerLevel( getID, target.Data.AccID ) ) )
													{
														SqGang.Gangs[ getID ].Members.rawdelete( target.Data.AccID );
														SqGang.Save( getID );

														SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnKick, player.Name, TextColor.Gang, target.Name, TextColor.Gang );

														player.Data.ActiveGang = "N/A";

														player.Data.Settings.Team = "Free";

														player.Color = Color3( 255, 255, 255 );

														player.Team = 255;
													}
													else player.Msg( TextColor.Error, Lang.GangCantUseOnHighLevel[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.TargetNotInGang[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.CantUseCommandSelf[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.GangNoPermission[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.GangNotMember[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.GangNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.GangNoInActiveGang[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function LeaveGang( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.ActiveGang != "N/A" )
				{
					if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
					{
						local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ];

						if( getGang.Founder != player.Data.AccID )
						{
							if( SqGang.GetPlayerLevel( getID, player.Data.AccID ) != "N/A" )
							{
								SqGang.Gangs[ getID ].Members.rawdelete( player.Data.AccID );
								SqGang.Save( getID );

								SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnLeave, player.Name, TextColor.Gang );

								player.Data.ActiveGang = "N/A";

								player.Data.Settings.Team = "Free";

								player.Color = Color3( 255, 255, 255 );

								player.Team = 255;
							}
							else player.Msg( TextColor.Error, Lang.GangNotMember[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.GangCantLeaveAsFounder[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.GangNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.GangNoInActiveGang[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function GangChat( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.ActiveGang != "N/A" )
				{
					if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
					{
						local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ];

						if( SqGang.GetPlayerLevel( getID, player.Data.AccID ) != "N/A" )
						{
							if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), getGang.Permissions.chat.tointeger() ) )
							{
								SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnChat, player.Name, args.Text );
							}
							else player.Msg( TextColor.Error, Lang.GangNoPermissionChat[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.GangNotMember[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.GangNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.GangNoInActiveGang[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function ViewGangMembers( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( args.rawin( "Gang" ) )				
				{	
					if( SqGang.FindGang( args.Gang ) )
					{
						local getID = SqGang.FindGang( args.Gang ), getGang = SqGang.Gangs[ getID ], getStr = null;

						if( getGang.Members != null )
						{
							local getMembers = {};
							local t, ta , j , k = 0, i = 0, getStr = null;

							foreach( index, value in getGang.Ranks )
							{
								getMembers.rawset( i, 
								{
									Name	= index,
									Level   = value.Level.tointeger(),
								});

								k++;
								i++;			
							}
							
							for( j = 0; j < getMembers.len(); j++ )
							{
								for( local i = 0 ; i<getMembers.len()-1-j; i++ )
								{
									if( ( getMembers.rawin( i ) ) && ( getMembers.rawin( i + 1 ) ) )
									{
										if( getMembers[ i ].Level < getMembers[ i + 1 ].Level )
										{
											t = getMembers[ i + 1 ].Name;
											ta = getMembers[ i + 1 ].Level;
											getMembers[ i + 1 ].Name <- getMembers[ i ].Name;
											getMembers[ i + 1 ].Level <- getMembers[ i ].Level;
											getMembers[ i ].Name <- t;
											getMembers[ i ].Level <- ta;
										}
									}
								}
							}

							for( local i = 0, j = 1; i < k ; i++, j++ )
							{
								if( ( getMembers.rawin( i ) ) && ( getMembers.rawin( i + 1 ) ) )
								{
									player.StreamInt( 106 );
									player.StreamString( "[#ff3322]" + getMembers[ i ].Name );
									player.FlushStream( true );

									foreach( index, value in getGang.Members )
									{
										if( getMembers[ i ].Name == value.Rank )
										{
											player.StreamInt( 106 );
											player.StreamString( SqAccount.GetNameFromID( index ) );
											player.FlushStream( true );
										}
									}
									
									player.StreamInt( 106 );
									player.StreamString( "   " );
									player.FlushStream( true );
								}
							}						
						}
					}
					else player.Msg( TextColor.Error, Lang.GangNotExist[ player.Data.Language ] );
				}

				else
				{
					if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
					{
						local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ], getStr = null;

						player.StreamInt( 105 );
						player.StreamString( "Gang members of " + getGang.Name + "$0" );
						player.FlushStream( true );
						
						if( getGang.Members != null )
						{
							local getMembers = {};
							local t, ta , j , k = 0, i = 0, getStr = null;

							foreach( index, value in getGang.Ranks )
							{
								getMembers.rawset( i, 
								{
									Name	= index,
									Level   = value.Level.tointeger(),
								});

								k++;
								i++;			
							}
							
							for( j = 0; j < getMembers.len(); j++ )
							{
								for( local i = 0 ; i<getMembers.len()-1-j; i++ )
								{
									if( ( getMembers.rawin( i ) ) && ( getMembers.rawin( i + 1 ) ) )
									{
										if( getMembers[ i ].Level < getMembers[ i + 1 ].Level )
										{
											t = getMembers[ i + 1 ].Name;
											ta = getMembers[ i + 1 ].Level;
											getMembers[ i + 1 ].Name <- getMembers[ i ].Name;
											getMembers[ i + 1 ].Level <- getMembers[ i ].Level;
											getMembers[ i ].Name <- t;
											getMembers[ i ].Level <- ta;
										}
									}
								}
							}

							for( local i = 0, j = 1; i < k ; i++, j++ )
							{
								if( ( getMembers.rawin( i ) ) && ( getMembers.rawin( i + 1 ) ) )
								{
									player.StreamInt( 106 );
									player.StreamString( "[#ff3322]" + getMembers[ i ].Name );
									player.FlushStream( true );

									foreach( index, value in getGang.Members )
									{
										if( getMembers[ i ].Name == value.Rank )
										{
											player.StreamInt( 106 );
											player.StreamString( SqAccount.GetNameFromID( index ) );
											player.FlushStream( true );
										}
									}
									
									player.StreamInt( 106 );
									player.StreamString( "   " );
									player.FlushStream( true );
								}
							}						
						}
					}
					else player.Msg( TextColor.Error, Lang.GangMembersSyntax[ player.Data.Language ] );
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function ViewGangPermissions( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.ActiveGang != "N/A" )
				{
					if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
					{
						local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ];

						if( SqGang.GetPlayerLevel( getID, player.Data.AccID ) != "N/A" )
						{
							local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ], getStr = null;

							player.StreamInt( 105 );
							player.StreamString( "Gang permissions of " + getGang.Name + "$0" );
							player.FlushStream( true );
							
							if( getGang.Members != null )
							{
								local getMembers = {};
								local t, ta , j , k = 0, i = 0, getStr = null;

								foreach( index, value in getGang.Permissions )
								{
									getMembers.rawset( i, 
									{
										Name	= index,
										Level   = value.tointeger(),
									});

									k++;
									i++;			
								}
								
								for( j = 0; j < getMembers.len(); j++ )
								{
									for( local i = 0 ; i<getMembers.len()-1-j; i++ )
									{
										if( ( getMembers.rawin( i ) ) && ( getMembers.rawin( i + 1 ) ) )
										{
											if( getMembers[ i ].Level < getMembers[ i + 1 ].Level )
											{
												t = getMembers[ i + 1 ].Name;
												ta = getMembers[ i + 1 ].Level;
												getMembers[ i + 1 ].Name <- getMembers[ i ].Name;
												getMembers[ i + 1 ].Level <- getMembers[ i ].Level;
												getMembers[ i ].Name <- t;
												getMembers[ i ].Level <- ta;
											}
										}
									}
								}

								for( local i = 0, j = 1; i < k ; i++, j++ )
								{
									if( ( getMembers.rawin( i ) ) && ( getMembers.rawin( i + 1 ) ) )
									{					
										if( getStr ) getStr = getStr + "$" + HexColour.Red + "Permission " + HexColour.White + getMembers[ i ].Name + HexColour.Red + " Level " + HexColour.White + getMembers[ i ].Level;
										else getStr = HexColour.Red + "Permission " + HexColour.White + getMembers[ i ].Name + HexColour.Red + " Level " + HexColour.White + getMembers[ i ].Level;
									}
								}
								
								if( getStr )
								{
									player.StreamInt( 106 );
									player.StreamString( getStr );
									player.FlushStream( true );
								}
							}
						}
						else player.Msg( TextColor.Error, Lang.GangNotMember[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.GangNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.GangNoInActiveGang[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}				

	function AddGangRank( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.ActiveGang != "N/A" )
				{
					if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
					{
						local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ];

						if( SqGang.GetPlayerLevel( getID, player.Data.AccID ) != "N/A" )
						{
							if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), getGang.Permissions.addrank.tointeger() ) )
							{
								if( !SqGang.FindRank( getID, args.Rank ) )
								{
									if( SqInteger.ValidHealOrArmRange( args.Level ) )
									{
										if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), args.Level ) )
										{
											SqGang.Gangs[ getID ].Ranks.rawset( args.Rank,
											{
												Level = args.Level.tostring(),
											});

											SqGang.Save( getID );

											SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnAddRank, player.Name, TextColor.Gang, args.Rank );
										}
										else player.Msg( TextColor.Error, Lang.GangLevelInvalid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.GangLevelCantOverOwnLevel[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.GangRankAlreadyExist[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.GangNoPermission[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.GangNotMember[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.GangNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.GangNoInActiveGang[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}				

	function EditGangRank( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.ActiveGang != "N/A" )
				{
					if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
					{
						local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ];

						if( SqGang.GetPlayerLevel( getID, player.Data.AccID ) != "N/A" )
						{
							if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), getGang.Permissions.addrank.tointeger() ) )
							{
								switch( args.Type ) 
								{
									case "del":
									local getFullRank = args.Type1;
									if( args.rawin( "Value" ) ) getFullRank = getFullRank + " " + args.Value;

									if( SqGang.FindRank( getID, getFullRank ) )
									{
										SqGang.Gangs[ getID ].Ranks.rawdelete( getFullRank );

										SqGang.Save( getID );

										SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnDelRank, player.Name, TextColor.Gang, getFullRank );
									}
									else player.Msg( TextColor.Error, Lang.GangRankNotExist[ player.Data.Language ] );
									break;

									case "level":
									if( args.rawin( "Value" ) )
									{
										if( SqInteger.IsNum( args.Type1 ) )
										{
											if( SqInteger.ValidHealOrArmRange( args.Type1 ) )
											{											
												if( SqGang.FindRank( getID, args.Value ) )
												{		
													if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), args.Value ) )
													{												
														SqGang.Gangs[ getID ].Ranks[ args.Value ].Level = args.Type1.tostring();													
														SqGang.Save( getID );

														player.Msg( TextColor.Gang, Lang.GangChangeRankLevel[ player.Data.Language ], args.Value TextColor.Gang, args.Type1.tointeger() );
													}
													else player.Msg( TextColor.Error, Lang.GangLevelCantOverOwnLevel[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.GangRankNotExist[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.GangLevelInvalid[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.GangNoPermission[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.GangRankSetLevelSyntax[ player.Data.Language ] );
									break;

									default:
									player.Msg( TextColor.Error, Lang.GangGangEditRankSyntax[ player.Data.Language ] );
									break;
								}
							}
							else player.Msg( TextColor.Error, Lang.GangNoPermission[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.GangNotMember[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.GangNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.GangNoInActiveGang[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}				

	function EditGangCmdLevel( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.ActiveGang != "N/A" )
				{
					if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
					{
						local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ];

						if( SqGang.GetPlayerLevel( getID, player.Data.AccID ) != "N/A" )
						{
							if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), getGang.Permissions.setcmdlevel.tointeger() ) )
							{
								switch( args.Permission ) 
								{
									case "editrank":
									if( SqInteger.ValidHealOrArmRange( args.Level ) )
									{
										if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), args.Level ) )
										{
											SqGang.Gangs[ getID ].Permissions[ args.Permission ] = args.Level.tostring();
											SqGang.Save( getID );

											player.Msg( TextColor.Sucess, Lang.GangChangePerm[ player.Data.Language ], "Editrank", TextColor.Sucess, args.Level );
										}
										else player.Msg( TextColor.Error, Lang.GangLevelInvalid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.GangLevelCantOverOwnLevel[ player.Data.Language ] );
									break;
									
									case "addrank":
									if( SqInteger.ValidHealOrArmRange( args.Level ) )
									{
										if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), args.Level ) )
										{
											SqGang.Gangs[ getID ].Permissions[ args.Permission ] = args.Level.tostring();
											SqGang.Save( getID );

											player.Msg( TextColor.Sucess, Lang.GangChangePerm[ player.Data.Language ], "Add rank", TextColor.Sucess, args.Level );
										}
										else player.Msg( TextColor.Error, Lang.GangLevelInvalid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.GangLevelCantOverOwnLevel[ player.Data.Language ] );
									break;	

									case "setcmdlevel":
									if( SqInteger.ValidHealOrArmRange( args.Level ) )
									{
										if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), args.Level ) )
										{
											SqGang.Gangs[ getID ].Permissions[ args.Permission ] = args.Level.tostring();
											SqGang.Save( getID );

											player.Msg( TextColor.Sucess, Lang.GangChangePerm[ player.Data.Language ], "Set command level", TextColor.Sucess, args.Level );
										}
										else player.Msg( TextColor.Error, Lang.GangLevelInvalid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.GangLevelCantOverOwnLevel[ player.Data.Language ] );
									break;

									case "invite":
									if( SqInteger.ValidHealOrArmRange( args.Level ) )
									{
										if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), args.Level ) )
										{
											SqGang.Gangs[ getID ].Permissions[ args.Permission ] = args.Level.tostring();
											SqGang.Save( getID );

											player.Msg( TextColor.Sucess, Lang.GangChangePerm[ player.Data.Language ], "Invite", TextColor.Sucess, args.Level );
										}
										else player.Msg( TextColor.Error, Lang.GangLevelInvalid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.GangLevelCantOverOwnLevel[ player.Data.Language ] );
									break;	

									case "chat":
									if( SqInteger.ValidHealOrArmRange( args.Level ) )
									{
										if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), args.Level ) )
										{
											SqGang.Gangs[ getID ].Permissions[ args.Permission ] = args.Level.tostring();
											SqGang.Save( getID );

											player.Msg( TextColor.Sucess, Lang.GangChangePerm[ player.Data.Language ], "Gang chat", TextColor.Sucess, args.Level );
										}
										else player.Msg( TextColor.Error, Lang.GangLevelInvalid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.GangLevelCantOverOwnLevel[ player.Data.Language ] );
									break;	

									case "editsetting":
									if( SqInteger.ValidHealOrArmRange( args.Level ) )
									{
										if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), args.Level ) )
										{
											SqGang.Gangs[ getID ].Permissions[ args.Permission ] = args.Level.tostring();
											SqGang.Save( getID );

											player.Msg( TextColor.Sucess, Lang.GangChangePerm[ player.Data.Language ], "Edit gang setting", TextColor.Sucess, args.Level );
										}
										else player.Msg( TextColor.Error, Lang.GangLevelInvalid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.GangLevelCantOverOwnLevel[ player.Data.Language ] );
									break;

									case "kick":
									if( SqInteger.ValidHealOrArmRange( args.Level ) )
									{
										if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), args.Level ) )
										{
											SqGang.Gangs[ getID ].Permissions[ args.Permission ] = args.Level.tostring();
											SqGang.Save( getID );

											player.Msg( TextColor.Sucess, Lang.GangChangePerm[ player.Data.Language ], "Kick", TextColor.Sucess, args.Level );
										}
										else player.Msg( TextColor.Error, Lang.GangLevelInvalid[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.GangLevelCantOverOwnLevel[ player.Data.Language ] );
									break;

									default:
									player.Msg( TextColor.Error, Lang.GangGangEditPermSyntax[ player.Data.Language ] );
									break;
								}
							}
							else player.Msg( TextColor.Error, Lang.GangNoPermission[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.GangNotMember[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.GangNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.GangNoInActiveGang[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function GangInfo( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( args.rawin( "Gang" ) )				
				{	
					if( SqGang.FindGang( args.Gang ) )
					{
						local getID = SqGang.FindGang( args.Gang ), getGang = SqGang.Gangs[ getID ], ratio = ( typeof( getGang.Stats.Kills.tofloat() / getGang.Stats.Deaths.tofloat() ) != "float" ) ? 0.0 : getGang.Stats.Kills.tofloat() / getGang.Stats.Deaths.tofloat();

						player.Msg( TextColor.Gang, Lang.GangInfo[ player.Data.Language ], getGang.Name, TextColor.Gang, getGang.Tag, TextColor.Gang, SqAccount.GetNameFromID( getGang.Founder ), TextColor.Gang, getGang.IsOpen, TextColor.Gang, SqGang.IsNull( getGang.Members ), TextColor.Gang, SqGang.IsNull( getGang.Ranks ) );
						if( getGang.Description != "N/A" ) player.Msg( TextColor.Gang, Lang.GangInfo1[ player.Data.Language ], getGang.Description );
						player.Msg( TextColor.Gang, Lang.GangInfo2[ player.Data.Language ], getGang.Stats.Kills, TextColor.Gang, getGang.Stats.Deaths, TextColor.Gang, ratio );
					}
					else player.Msg( TextColor.Error, Lang.GangNotExist[ player.Data.Language ] );
				}

				else
				{
					if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
					{
						local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ], ratio = ( typeof( getGang.Stats.Kills.tofloat() / getGang.Stats.Deaths.tofloat() ) != "float" ) ? 0.0 : getGang.Stats.Kills.tofloat() / getGang.Stats.Deaths.tofloat();

						player.Msg( TextColor.Gang, Lang.GangInfo[ player.Data.Language ], getGang.Name, TextColor.Gang, getGang.Tag, TextColor.Gang, SqAccount.GetNameFromID( getGang.Founder ), TextColor.Gang, getGang.IsOpen, TextColor.Gang, SqGang.IsNull( getGang.Members ), TextColor.Gang, SqGang.IsNull( getGang.Ranks ) );
						if( getGang.Description != "N/A" ) player.Msg( TextColor.Gang, Lang.GangInfo1[ player.Data.Language ], getGang.Description );
						player.Msg( TextColor.Gang, Lang.GangInfo2[ player.Data.Language ], getGang.Stats.Kills, TextColor.Gang, getGang.Stats.Deaths, TextColor.Gang, ratio );
					}
					else player.Msg( TextColor.Error, Lang.GangInfoSyntax[ player.Data.Language ] );
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function ViewRank( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.ActiveGang != "N/A" )
				{
					if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
					{
						local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ];

						if( SqGang.GetPlayerLevel( getID, player.Data.AccID ) != "N/A" )
						{
							local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ], getStr = null;

							player.StreamInt( 105 );
							player.StreamString( "Gang ranks of " + getGang.Name + "$0" );
							player.FlushStream( true );
							
							if( getGang.Members != null )
							{
								local getMembers = {};
								local t, ta , j , k = 0, i = 0, getStr = null;

								foreach( index, value in getGang.Ranks )
								{
									if( index == "Default" ) continue;

									getMembers.rawset( i, 
									{
										Name	= index,
										Level   = value.Level.tointeger(),
									});

									k++;
									i++;			
								}
								
								for( j = 0; j < getMembers.len(); j++ )
								{
									for( local i = 0 ; i<getMembers.len()-1-j; i++ )
									{
										if( ( getMembers.rawin( i ) ) && ( getMembers.rawin( i + 1 ) ) )
										{
											if( getMembers[ i ].Level < getMembers[ i + 1 ].Level )
											{
												t = getMembers[ i + 1 ].Name;
												ta = getMembers[ i + 1 ].Level;
												getMembers[ i + 1 ].Name <- getMembers[ i ].Name;
												getMembers[ i + 1 ].Level <- getMembers[ i ].Level;
												getMembers[ i ].Name <- t;
												getMembers[ i ].Level <- ta;
											}
										}
									}
								}

								for( local i = 0, j = 1; i < k ; i++, j++ )
								{
									if( ( getMembers.rawin( i ) ) && ( getMembers.rawin( i + 1 ) ) )
									{					
										if( getStr ) getStr = getStr + "$" + HexColour.Red + "Permission " + HexColour.White + getMembers[ i ].Name + HexColour.Red + " Level " + HexColour.White + getMembers[ i ].Level;
										else getStr = HexColour.Red + "Permission " + HexColour.White + getMembers[ i ].Name + HexColour.Red + " Level " + HexColour.White + getMembers[ i ].Level;
									}
								}
								
								if( getStr )
								{
									player.StreamInt( 106 );
									player.StreamString( getStr );
									player.FlushStream( true );
								}
							}
						}
						else player.Msg( TextColor.Error, Lang.GangNotMember[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.GangNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.GangNoInActiveGang[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function JoinGang( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.ActiveGang == "N/A" )
				{
					if( SqGang.FindGang( args.Gang ) )
					{
						local getID = SqGang.FindGang( args.Gang ), getGang = SqGang.Gangs[ getID ];

						if( !SqGang.FindPlayer( getID, player.Data.AccID ) )
						{
							switch( SqGang.Gangs[ getID ].IsOpen )
							{
								case "Invite":
								if( player.Data.GangInvite.rawin( getID ) )
								{
									SqGang.EditPlayer( getID, player.Data.AccID, "None" );

									SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnJoinAs, player.Name, TextColor.Gang, player.Data.GangInvite[ getID ].Rank );

									player.Color = getGang.Color;

									player.Data.ActiveGang = getID;

									player.Data.GangInvite.rawdelete( getID );
								}
								else player.Msg( TextColor.Error, Lang.GangNotInvite[ player.Data.Language ] );
								break;

								case "Open":
								SqGang.EditPlayer( getID, player.Data.AccID, "None" );

								player.Color = getGang.Color;

								player.Data.GangInvite.rawdelete( getID );

								player.Data.ActiveGang = getID;

								SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnJoin, player.Name, TextColor.Gang );
								break;

								case "Closed":
								player.Msg( TextColor.Error, Lang.GangNotOpen[ player.Data.Language ] );
								break;								
							}
						}
						else player.Msg( TextColor.Error, Lang.GangAlreadyMember[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.GangNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.GangAlreadyIn[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function SetRank( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.ActiveGang != "N/A" )
				{
					if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
					{
						local getID = player.Data.ActiveGang, getGang = SqGang.Gangs[ getID ];

						if( SqGang.GetPlayerLevel( getID, player.Data.AccID ) != "N/A" )
						{
							if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), getGang.Permissions.editrank.tointeger() ) )
							{
								local target = SqPlayer.FindPlayer( args.Victim );
								if( target )
								{
									if( target.Data.IsReg )
									{
										if( target.Data.Logged )
										{
											if( SqGang.GetPlayerLevel( getID, target.Name ) != "N/A" )
											{
												if( SqGang.FindRank( getID, args.Rank ) )
												{
													if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), SqGang.GetPlayerLevel( getID, target.Data.AccID ) ) )
													{
														if( SqMath.IsGreaterEqual( SqGang.GetPlayerLevel( getID, player.Data.AccID ), getGang.Ranks[ args.Rank ].Level.tointeger() ) )
														{
															SqGang.EditPlayer( getID, target.Data.AccID, args.Rank );

															SqCast.MsgGang( getID, TextColor.Gang, Lang.GangAnnChangePlrRank, player.Name, TextColor.Gang, target.Name, TextColor.Gang, args.Rank );
														}
														else player.Msg( TextColor.Error, Lang.GangLevelCantOverOwnLevel[ player.Data.Language ] );
													}
													else player.Msg( TextColor.Error, Lang.GangCantUseOnHighLevel[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.GangRankNotExist[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.TargetNotInGang[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.GangNoPermission[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.GangNotMember[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.GangNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.GangNoInActiveGang[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

}