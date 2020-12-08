SqCore.On().PlayerCreated.Connect(this, function (player, header, payload)
{
	local disallowPlay = SqAdmin.Join( player );
	
	player.Pos = Vector3( 998.525940,146.518936,90.116692 );
	player.CameraPosition( Vector3( 998.525940,146.518936,90.116692 ), Vector3( 536.416382,-616.541626,169.366913 ) );
    player.Tag = format("(%i) %s" player.ID, player.Name);
    player.Data = CPlayer(player);
	
	//if( !disallowPlay ) player.Data.LoadAccount();

	player.Announce("Slow download? Download server files from https://vl.kingofvc.best/vlstore.zip", 1 );
	
	Server.PlayerCount ++;
	//EchoBot.SetActivity( Server.Name + " ["+ Server.PlayerCount + "/100]" );

	player.MakeTask( function()
	{
		try
		{
			if( player.Spawned )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					if( World[ player.World ].AddOn.WorldFPS )
					{
						if( World[ player.World ].Settings.WorldFPS != "0" && SqMath.IsLess( player.FPS, World[ player.World ].Settings.WorldFPS ) && SqMath.IsLess( World[ player.World ].GetPlayerLevelInWorld( player.Name ), World[ player.ID ].Permissions.setfpspinglimit ) )
						{
							player.Data.PFPSWarn ++;
							
							switch( player.Data.PFPSWarn )
							{
								case 4:
								SqCast.MsgWorld( TextColor.World, player.World, Lang.WorldKickDueFPS, player.Name, TextColor.World, player.FPS + "/" + World[ player.World ].Settings.WorldFPS );
													
								player.Msg( TextColor.InfoS, Lang.WorldKickDueToFPS[ player.Data.Language ], player.FPS + "/" + World[ player.World ].Settings.WorldFPS );
							
								player.World			= 0;
								player.Data.PFPSWarn	= 0;
								break;
								
								case 3:
								player.Msg( TextColor.Error, Lang.WorldFPSFinalWarn[ player.Data.Language ], player.FPS + "/" + World[ player.World ].Settings.WorldFPS, TextColor.Error );
								break;
								
								case 1:
								case 2:
								player.Msg( TextColor.Error, Lang.WorldFPSFirst[ player.Data.Language ], player.FPS + "/" + World[ player.World ].Settings.WorldFPS, TextColor.Error );
								break;
							}
						}
					}
					
					if( World[ player.World ].AddOn.WorldPing )
					{
						if( World[ player.World ].Settings.WorldPing != "0" && SqMath.IsGreaterEqual( player.Ping, World[ player.World ].Settings.WorldPing ) && SqMath.IsLess( World[ player.World ].GetPlayerLevelInWorld( player.Name ), World[ player.ID ].Permissions.setfpspinglimit ) )
						{
							player.Data.PFPSWarn ++;
							
							switch( player.Data.PFPSWarn )
							{
								case 4:
								SqCast.MsgWorld( TextColor.World, player.World, Lang.WorldKickDuePing, player.Name, TextColor.World, player.Ping + "/" + World[ player.World ].Settings.WorldPing );
													
								player.Msg( TextColor.InfoS, Lang.WorldKickDueToPing[ player.Data.Language ], player.Ping + "/" + World[ player.World ].Settings.WorldPing );
							
								player.World			= 0;
								player.Data.PFPSWarn	= 0;
								break;
								
								case 3:
								player.Msg( TextColor.Error, Lang.WorldPingFinalWarn[ player.Data.Language ], player.Ping + "/" + World[ player.World ].Settings.WorldPing, TextColor.Error );
								break;
								
								case 1:
								case 2:
								player.Msg( TextColor.Error, Lang.WorldPingFirst[ player.Data.Language ], player.Ping + "/" + World[ player.World ].Settings.WorldPing, TextColor.Error );
								break;
							}
						}
					}
				}
		
			}
		}
		catch( _ ) _;
	
	}, 10000, 0 );

	player.MakeTask( function()
	{
		if( player.Data.Logged )
		{
			if( player.Spawned )
			{
				if( player.Spec.tostring() == "-1" )
				{
					if( !player.Data.AdminDuty )
					{
						if( player.Data.Afk.LastPos.tostring() == player.Pos.tostring() && player.WeaponSlot != 8 )
						{
							player.Data.Afk.Count ++;

							if( player.Data.Afk.Count > 60 )
							{
								player.Data.OldTitle = player.Data.Title;

                        		SqCast.setTitle( player, "AFK" );
							}
						}
						else
						{
							player.Data.Afk.LastPos = player.Pos;
							player.Data.Afk.Count 	= 0;

                        	SqCast.setTitle( player, ( player.Data.OldTitle == "none" ) ? "" : player.Data.OldTitle );
						}
					}
				}
			}
		}
	}, 1000, 0 );
});

