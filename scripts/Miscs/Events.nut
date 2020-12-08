SqEvents <-
{
	function BeginWaterFightEvent()
	{
		local count = 0;
		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data.InEvent == "WaterFight" )
			{
				count ++;
			}
		});

		if( count < 2 )
		{
			SqForeach.Player.Active( this, function( player ) 
			{
				if( player.Data.Player.CustomiseMsg.Type.Event == "true" && player.Data.Logged ) player.Msg( TextColor.Event, Lang.EventWaterFightCanceledNoPlr[ player.Data.Language ] );
			});

			Server.Event.WaterFight.isEvent = 0;

			if( SqAccount.FindOnlinePlayerByID( Server.Event.WaterFight.Host ) )
			{
				local player = SqAccount.FindOnlinePlayerByID( Server.Event.WaterFight.Host );

				player.Data.Stats.Cash += Server.Event.WaterFight.Price;
				player.Data.Stats.TotalSpend -= Server.Event.WaterFight.Price;

				player.Data.InEvent = null;

				player.Msg( TextColor.InfoS, Lang.EventWaterFightRefund[ player.Data.Language ] );
			}

			return;
		}

		else 
		{
			local count2 = 0;
			SqRoutine( this, function()
			{
				count2 ++;

				switch( count2 )
				{
					case 1:
					SqCast.sendAnnounceToWorld( 105, 5 );

					SqForeach.Player.Active( this, function( player ) 
					{
						if( player.Data.InEvent == "WaterFight" )
						{							

							player.Pos = Vector3(-1921.88, 774.964, 11.1652);

							player.SetOption( SqPlayerOption.Controllable, false );

							player.Immunity = 31;

							Server.Event.WaterFight.isEvent = 2;

							player.World = 105;

							player.Data.Interior = null;

							player.StripWeapons();

							player.SetWeapon( 19, 50 );
						}
					});					
					break;

					case 2:
					SqCast.sendAnnounceToWorld( 105, 4 );
					break;

					case 3:
					SqCast.sendAnnounceToWorld( 105, 3 );
					break;

					case 4:
					SqCast.sendAnnounceToWorld( 105, 2 );
					break;

					case 5:
					SqCast.sendAnnounceToWorld( 105, 1 );
					break;

					case 6:
					local count1 = 1;

					SqForeach.Player.Active( this, function( player ) 
					{
						if( player.Data.InEvent == "WaterFight" )
						{
							switch( count1 )
							{
								case 1: player.Pos = Vector3(-1921.88, 774.964, 11.1652); break;
								case 2: player.Pos = Vector3(-1915.97, 774.976, 11.1652); break;
								case 3: player.Pos = Vector3(-1909.57, 775.04, 11.1652); break;
								case 4: player.Pos = Vector3(-1906.09, 775.284, 11.1652); break;
								case 5: player.Pos = Vector3(-1905.95, 757.133, 11.1652); break;
								case 6: player.Pos = Vector3(-1911.84, 757.257, 11.1652); break;
								case 7: player.Pos = Vector3(-1919.13, 757.239, 11.1652); break;
								case 8: player.Pos = Vector3(-1921.93, 765.551, 11.1652); break;
								case 9: player.Pos = Vector3(-1906.2, 765.832, 11.1652); break;
								case 10: player.Pos = Vector3(-1911.98, 765.367, 11.1652); break;
								case 11: player.Pos = Vector3(-1918.91, 761.503, 11.1652); break;
								case 12: player.Pos = Vector3(-1909.81, 771.309, 11.1652); break;
								case 13: player.Pos = Vector3(-1909.81, 771.309, 11.1652); break;	
								default: player.Pos = Vector3(-1921.88, 774.964, 11.1652); break; 
							}

							count1 ++;

							player.SetOption( SqPlayerOption.Controllable, true );			

							player.SetOption( SqPlayerOption.CanAttack, true );	
						}
					});
					break;

					case 7:
					SqCast.sendAnnounceToWorld( 105, "Go Go Go" );

				//	this.Terminate();
					break;
				}
			}, 1000, 0 ).SetTag( "StartWF" );
		}
	}

	function CheckWaterFightEvent( player )
	{
		if( player.Data.InEvent == "WaterFight" )
		{
			player.Immunity = 0;

			player.Data.InEvent = null;
			player.Data.AddXP( player, Server.Event.WaterFight.PartXP );

			local count = 0;
			SqForeach.Player.Active( this, function( plr ) 
			{
				if( plr.Data.Player.CustomiseMsg.Type.Event == "true" && plr.Data.Logged ) plr.Msg( TextColor.Event, Lang.EventWaterFightDeath[ plr.Data.Language ], player.Name, TextColor.Event );
			
				if( plr.Data.InEvent == "WaterFight" ) count ++;
			});

			if( count == 1 ) this.EventWaterFightEvent();
		}
	}

	function EventWaterFightEvent()
	{
		local count = 0, winner = null;
		SqForeach.Player.Active( this, function( player ) 
		{
			local getPrice = Server.Event.WaterFight.Price;
			count ++;

			if( Server.Event.WaterFight.Host == player.Data.AccID ) getPrice = Server.Event.WaterFight.Price * 2;

			if( player.Data.InEvent == "WaterFight" )
			{
				winner = player;

				player.Data.Stats.Cash += getPrice;
				player.Data.Stats.TotalEarn += getPrice;

				player.Data.Stats.WFWon ++;
				player.Data.InEvent = null;

				player.Data.AddXP( player, Server.Event.WaterFight.XP );
				
				switch( player.Data.Settings.LobbySpawn )
				{
					case "Normal":
					player.World 	= 100;
					player.Pos 		= Vector3.FromStr( "-1471.868164,553.079102,2008.979980" );
					player.Data.Interior = "Lobby";
					break;

					case "Admin":
					player.World 	= 100;
					player.Pos 		= Vector3.FromStr( "-1471.868164,553.079102,2008.979980" );
					player.Data.Interior = "Lobby";
					break;

					case "DM":
					player.Data.Interior = null;

					SqSpawn.SetPlayerSpawn( player );
								
					if( SqWorld.GetPrivateWorld( player.World ) )
					{
						local world = SqWorld.World[ player.World ];
																		
						if( world.Settings.WorldSpawn != "0,0,0" && player.Data.Player.Spawnloc.SpawnData.Enabled == "2" ) player.Pos = Vector3.FromStr( world.Settings.WorldSpawn );

						player.SetOption( SqPlayerOption.CanAttack, SToB( world.Settings.WorldKill ) );
						player.SetOption( SqPlayerOption.DriveBy, SToB( world.Settings.WorldDriveBy ) );

						if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.canattack ) ) player.SetOption( SqPlayerOption.CanAttack, true );
						if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.candriveby ) ) player.SetOption( SqPlayerOption.DriveBy, true );
						if( SqMath.IsLess( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.wep ) ) player.StripWeapons();
						if( SqMath.IsLess( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.spawnloc ) && player.Data.Player.Spawnloc.SpawnData.Enabled == "1" )
						{
							player.World = 0;
							player.Msg( TextColor.InfoS, Lang.WorldMovedNoPermission[ player.Data.Language ] );
						}
					}
					break;
				}
			}

			if( player.Data.Player.CustomiseMsg.Type.Event == "true" && player.Data.Logged ) player.Msg( TextColor.Event, Lang.EventWaterFightWinner[ player.Data.Language ], winner.Name, TextColor.Event, SqInteger.ToThousands( getPrice ), TextColor.Event, SqInteger.ToThousands( Server.Event.WaterFight.XP ) );
		
		});

		if( count == 0 )
		{
			SqForeach.Player.Active( this, function( plr ) 
			{
				if( plr.Data.Player.CustomiseMsg.Type.Event == "true" && plr.Data.Logged ) plr.Msg( TextColor.Event, Lang.EventWaterFightNoWinner[ plr.Data.Language ] );
			});				
		}

		Server.Event.WaterFight.isEvent = 0;
	}

	function RectTimeout()
	{
		//if( ( ::time() - Server.ReactionText.Time ) > 200 && Server.ReactionText.Text != null )
	//	{
			SqCast.MsgAll( TextColor.Event, Lang.ReactTimeout );

			Server.ReactionText.Text = null;
	//	}
	}
	
	function RectCheck( player, text )
	{
		if( Server.ReactionText.Text == text )
		{
			local pricename = "none";

			switch( Server.ReactionText.Price.Type )
			{
				case "Crate":
				player.Data.addInventQuatity( "crate", 1 );
				pricename = "A Crate";
				break;

				case "Cash":
				player.Data.Stats.Cash += Server.ReactionText.Price.Price;
				player.Data.Stats.TotalEarn += Server.ReactionText.Price.Price;
				pricename = "$" + Server.ReactionText.Price.Price;
				break;

				case "XP":
				player.Data.AddXP( player, Server.ReactionText.Price.Price );
				pricename = Server.ReactionText.Price.Price + " XP";
				break;
			}

			SqForeach.Player.Active( this, function( plr ) 
			{
				if( plr.Data.Player.CustomiseMsg.Type.Event == "true" && plr.Data.Logged ) plr.Msg( TextColor.Event, Lang.RectWon[ plr.Data.Language ], player.Name, TextColor.Event, SqInteger.SecondToTime( ( ::time() - Server.ReactionText.Time ) ), TextColor.Event, pricename );
			});

			player.Data.Stats.ReactionWon ++;

			Server.ReactionText.Text = null;

			local getTimer = ::FindTimer( "EndRT" );

			if( getTimer ) getTimer.Terminate();
		}
	}

	function RectStart()
	{
	//	local selector = rand()%100, selector1 = ( selector%2 );
	//	if( selector1 == 1 ) Server.Reaction.Text = Server.ReactionText.Text[ rand()% Server.ReactionText.Text.len() ];
		Server.ReactionText.Text = ::RandString( rand()%56 ) + ::RandString( rand()%56 ) + ::RandString( rand()%56 ) + ::RandString( rand()%56 ) + ::RandString( rand()%56 ) + ::RandString( rand()%56 ) + ::RandString( rand()%56 ) + ::RandString( rand()%56 );
		local selectprize = ( rand()% 10 );
		local nametype = "Cash";

		switch( selectprize )
		{
			case 2:
		//	case 4:
			case 6:
			Server.ReactionText.Price.Type = "Crate";
			nametype = "A Crate";
			break;

			case 4:
			case 8:
			Server.ReactionText.Price.Type = "XP";
			Server.ReactionText.Price.Price = rand()%100;
			nametype = Server.ReactionText.Price.Price + " XP";
			break;

			default:
			local getPrice = ( rand()%99 ) + "000";
			Server.ReactionText.Price.Type = "Cash";
			Server.ReactionText.Price.Price = getPrice.tointeger();
			nametype = "$" + Server.ReactionText.Price.Price;
			break;
		} 
		
		Server.ReactionText.Time =  ::time();

		SqForeach.Player.Active( this, function( plr ) 
		{
			if( plr.Data.Player.CustomiseMsg.Type.Event == "true" && plr.Data.Logged ) plr.Msg( TextColor.Event, Lang.RectStart[ plr.Data.Language ], Server.ReactionText.Text, TextColor.Event, nametype );
		});
	}
	

}