SqCore.On().PlayerMessage.Connect( this, function( player, message ) 
{
	if( player.Data.Logged )
	{
		if( !SqAdmin.CheckMute( player.UID, player.UID2 ) )
		{
			if ( message.slice( 0, 1 ) == "!" )
			{
				if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
				{
					SqCast.MsgGang( player.Data.ActiveGang, TextColor.Gang, Lang.GangAnnChat, player.Name, message.slice( 1 ) );
					
					SqCore.SetState( 0 );
				}
			}

			else if ( message.slice( 0, 1 ) == "'" )
			{
                if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
                {
                    SqCast.MsgAdmin( TextColor.Staff, Lang.AAdminChat3, player.Data.Player.Permission.Staff.Name, player.Name, message.slice( 1 ) );			
                        
               //     StaffBot.SendMessage( format( "**%s** %s: %s", player.Data.Player.Permission.Staff.Name, player.Name, message.slice( 1 ) ) );
               		
               		SqCore.SetState( 0 );
                }
			}

			else 
			{
				if( player.Data.AdminDuty )
				{
					SqCast.MsgAllWithoutStyle( Lang.onChatGang, player.Data.Player.Permission.Staff.Name, RGBToHex( player.Color ), player.Name, "[#ff3322]" + message );
					
					SqCast.EchoMessage( format( "%s **%s**: %s ", player.Data.Player.Permission.Staff.Name, player.Name, message ) );

					SqCore.SetState( 0 );
				}

				else 
				{
					SqEvents.RectCheck( player, message );

					if( player.Data.Chat.RepeatMessage.find( message.tolower() ) == null )
					{
						if( player.Data.Player.Permission.VIP.Position.tointeger() > 0 ) 
						{
							if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
							{
								SqCast.MsgAllWithoutStyle( Lang.onChatGang, SqGang.Gangs[ player.Data.ActiveGang ].Tag, RGBToHex( player.Color ), player.Name, message );

								SqCast.EchoMessage( format( "%s **%s**: %s ", SqGang.Gangs[ player.Data.ActiveGang ].Tag, player.Name, message ) );
									
								player.Data.Chat.RepeatMessage 	= message.tolower();
								player.Data.Chat.Time 		= time();

								CheckReactionTest( player, message );

								SqCore.SetState( 0 );
							}

							else 
							{
								SqCast.MsgAllWithoutStyle( Lang.onChat, HexColour.White, player.Name, message );

								SqCast.EchoMessage( format( "**%s**: %s ", player.Name, message ) );

								player.Data.Chat.RepeatMessage 	= message.tolower();
								player.Data.Chat.Time 		= time();

								CheckReactionTest( player, message );

								SqCore.SetState( 0 );
							}
						}

						else 
						{
							if( SqGang.Gangs.rawin( player.Data.ActiveGang ) )
							{
								SqCast.MsgAllWithoutStyle( Lang.onChatGang, SqGang.Gangs[ player.Data.ActiveGang ].Tag, RGBToHex( player.Color ), player.Name, StripCol( message ) );

								SqCast.EchoMessage( format( "%s **%s**: %s ", SqGang.Gangs[ player.Data.ActiveGang ].Tag, player.Name, message ) );
									
								player.Data.Chat.RepeatMessage 	= message.tolower();
								player.Data.Chat.Time 		= time();

								CheckReactionTest( player, message );

								SqCore.SetState( 0 );
							}

							else 
							{
								SqCast.MsgAllWithoutStyle( Lang.onChat, HexColour.White, player.Name, StripCol( message ) );

								SqCast.EchoMessage( format( "**%s**: %s ", player.Name, message ) );
									
								player.Data.Chat.RepeatMessage 	= message.tolower();
								player.Data.Chat.Time 		= time();

								CheckReactionTest( player, message );

								SqCore.SetState( 0 );
							}
						}
					}

					else
					{
						player.Msg( TextColor.Error, Lang.DontRepeat[ player.Data.Language ] );
						SqCore.SetState( 0 );
					}
				}
			}
		}
		
		else 
		{
			player.Msg( TextColor.Error, Lang.MutedCantTalk[ player.Data.Language ] );
			SqCore.SetState( 0 );
		}

	}
	else 
	{
		player.Msg( TextColor.Error, Lang.NotLoggedCantTalk[ player.Data.Language ] );
		SqCore.SetState( 0 );
	}
});
