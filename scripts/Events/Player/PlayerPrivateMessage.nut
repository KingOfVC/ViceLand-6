SqCore.On().PlayerPrivateMessage.Connect(this, function (player, target, message )
{
	if( player.Data.Logged )
	{
		if( !target.Data.AdminDuty )
		{
			if( player.Data.Chat.RepeatMessage.find( message.tolower() ) == null )
			{
				if( SqMath.IsGreaterEqual( ( time() - player.Data.Chat.Time ), 3 ) )
				{
					if( !SqAdmin.CheckMute( player.UID, player.UID2 ) )
					{
						if( player.Data.Player.CustomiseMsg.Type.PrivMsg == "true" )
						{
							target.Msg( TextColor.InfoS, Lang.PMTarget[ target.Data.Language ], player.Name, message );

							SqCast.MsgManager( TextColor.Staff, Lang.ReadPM, player.Name, TextColor.Staff, message, TextColor.Staff, target.Name );

							SqCore.SetState( 0 );
						}

						else 
						{
							player.Msg( TextColor.Error, Lang.PMBlocked[ player.Data.Language ])
							SqCore.SetState( 0 );
						}
					}

					else 
					{
						player.Msg( TextColor.Error, Lang.MutedCantPM[ player.Data.Language ])
						SqCore.SetState( 0 );
					}
				}
				else 
				{
					player.Msg( TextColor.Error, Lang.ChatCooldown[ player.Data.Language ])
					SqCore.SetState( 0 );
				}
			}
			else
			{
				player.Msg( TextColor.Error, Lang.DontRepeat[ player.Data.Language ] );
				SqCore.SetState( 0 );
			}
		}
		else
		{
			player.Msg( TextColor.Error, Lang.TargetOnDutyCantPM[ player.Data.Language ] );
			SqCore.SetState( 0 );
		}
	}
	else 
	{
		player.Msg( TextColor.Error, Lang.NotLoggedCantPM[ player.Data.Language ])
		SqCore.SetState( 0 );
	}
});