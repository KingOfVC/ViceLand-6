SqCore.On().CheckpointEntered.Connect( this, function( player, checkpoint ) 
{
	switch( checkpoint.Data.Type )
	{

		case "TowerUp":
		player.Pos = Vector3( 574.144653,-627.138489,220.006989 );  
		break;

		case "TowerLow":
		player.Pos = Vector3(  571.679626,-624.604614,23.234364 );  
		break;

		case "NukeUp":
		player.Pos = Vector3( 864.137146,-1532.394409,40.102432 );  
		break;

		case "NukeDown":
		player.Pos = Vector3( 860.612061,-1522.878418,19.049084 );  
		break;

		case "ResIn":
		player.Pos = Vector3( 794.299561,-1121.994141,21.337440 );  
		break;

		case "ResOut":
		player.Pos = Vector3( 793.979248,-1113.228271,21.347721 );  
		break;

		case "DromeUp":
		player.Pos = Vector3( 387.079437,-900.331909,288.335999 );  
		break;

		case "DromeDown":
		player.Pos = Vector3( 391.610901,-898.235291,18.708946 );  
		break;
		
		case "LobbyExit":
		player.StreamInt( 600 );
		player.StreamString( "" );
		player.FlushStream( true );
		break;

		case "Gagjik":
		player.StreamInt( 211 );
		player.StreamString( "" );
		player.FlushStream( true );
		break;

		case "EnterDM":
		player.Data.Interior	= null;

		player.World = 101;

		player.Armour = 0;

		player.Data.InEvent = "DM";
															
		SqCast.MsgAllExp( player, TextColor.Info, Lang.GotoworldAllDM, player.Name, TextColor.Info );
																
		player.Msg( TextColor.Sucess, Lang.GotoWorldSucessDM[ player.Data.Language ] );

		player.SetOption( SqPlayerOption.CanAttack, true );

		player.Pos = Vector3.FromStr( Server.DMArena.Arena[ Server.DMArena.Position.tostring() ].Pos );

		SqWeapon.GivePlayerSpawnwep( player );
		break;

		case "EnterCash":
		player.Data.Interior	= null;

		player.World = 102;

		player.Data.InEvent = "Cash";
																															
		player.Msg( TextColor.Sucess, Lang.EnterGrindingWorld[ player.Data.Language ] );

		player.SetOption( SqPlayerOption.CanAttack, false );

		player.Pos		= RandSpawn[ rand()%RandSpawn.len() ];
		break;

		case "Robbery":
		if( player.Data.Job.len() == 0 )
		{
			if( !player.Vehicle )
			{
				if( SqMath.IsGreaterEqual( ( time() - checkpoint.Data.Extra.Time ), 120 ) )
				{
					if( !checkpoint.Data.Extra.IsRobbing )
					{
						checkpoint.Data.Extra.IsRobbing = true;

						player.Msg( TextColor.InfoS, Lang.JobRobStarting[ player.Data.Language ] );

						player.MakeTask( function( pos )
						{					
							if ( this.Data == null ) this.Data = 0;
												
							this.Data ++;
							if( pos.DistanceTo( player.Pos ) < 2 )
							{
							/*	player.StreamInt( 303 );
								player.StreamString( this.Data );
								player.FlushStream( true );*/

								if( this.Data > 19 )
								{
									local get_amount = ( time() - checkpoint.Data.Extra.Time ) * Server.DoubleEvent.Robbery.MP;

									if( get_amount > 50000 ) get_amount = Server.DoubleEvent.Robbery.MaxCash;

									checkpoint.Data.Extra.Time 		= time();
									checkpoint.Data.Extra.IsRobbing = false;

									player.Data.Stats.Cash += get_amount;

									player.Msg( TextColor.InfoS, Lang.JobRobSucess[ player.Data.Language ], SqInteger.ToThousands( get_amount ) );
									
								/*	player.StreamInt( 304 );
									player.StreamString( "" );
									player.FlushStream( true );*/


									this.Terminate();		
								}
							}
							else 
							{
								checkpoint.Data.Extra.IsRobbing = false;

								player.Msg( TextColor.Error, Lang.JobRobFailedMove[ player.Data.Language ] );
								
							/*	player.StreamInt( 304 );
								player.StreamString( "" );
								player.FlushStream( true );*/

								
								this.Terminate();
							}
						}, 500, 20, player.Pos ).SetTag( "Robbery" );
					}
					else player.Msg( TextColor.Error, Lang.JobRobFailedSomeoneRobbing[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.JobRobFailedRobbed[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.JobRobFailedInVehicle[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.JobRobFailedOnJob[ player.Data.Language ] );
		break;

		case "GetTop":
		player.StreamInt( 500 );
		player.StreamString( "" );
		player.FlushStream( true );
		break;

	/*	case "EventCP":
		if( !player.Vehicle )
		{
			if( !checkpoint.Data.Extra.IsRobbing )
			{
				checkpoint.Data.Extra.IsRobbing = true;

				player.Msg( TextColor.InfoS, Lang.EventStartCapture[ player.Data.Language ] );

				player.MakeTask( function( pos )
				{					
					if ( this.Data == null ) this.Data = 0;
												
					this.Data ++;
					if( pos.DistanceTo( player.Pos ) < 2 )
					{
						if( this.Data > 19 )
						{
							checkpoint.Data.Extra.IsRobbing = false;

							this.Terminate();		

							if( Server.TDM.rawin( player.Data.TeamID ) )
							{
								SqCast.MsgWorld( TextColor.Event, 105, Lang.EventCPCapture, Server.TDM[ player.Data.TeamID ].TeamName );

								Server.TDM[ player.Data.TeamID ].TeamScore += 20;	
							}
						}
					}
					else 
					{
						checkpoint.Data.Extra.IsRobbing = false;

						player.Msg( TextColor.Error, Lang.EventCPFailedMove[ player.Data.Language ] );
								
						this.Terminate();
					}
				}, 500, 20, player.Pos ).SetTag( "Robbery" );
			}
		}
		else */
	}
});