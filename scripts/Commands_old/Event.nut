class CCmdEvent
{
	Cmd					= null;
	
	Hostevent 			= null;
	Joinevent 			= null;

	constructor( instance )
	{
		this.Cmd = instance;
		
		this.Cmd.BindFail( this, this.funcFailCommand );
		
		this.Hostevent					= this.Cmd.Create( "hostevent", "s|i", [ "Type", "Price" ], 2, 2, -1, true, true );
		this.Joinevent					= this.Cmd.Create( "joinevent", "s", [ "Type" ], 1, 1, -1, true, true );

		this.Hostevent.BindExec( this.Hostevent, this.HostEvent );
		this.Joinevent.BindExec( this.Joinevent, this.JoinEvent );
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
				case "hostevent":
				player.Msg( TextColor.Error, Lang.EventHosteventSyntax[ player.Data.Language ] );
				break;

				case "joinevent":
				player.Msg( TextColor.Error, Lang.EventJoineventSyntax[ player.Data.Language ] );
				break;
			}
		}
	}

	function HostEvent( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.InEvent )
				{
					if( Server.Event.WaterFight.isEvent == 0 )
					{
						if( SqMath.IsGreaterEqual( args.Price, 150000 ) )
						{
							if( SqMath.IsGreaterEqual( player.Data.Stats.Cash, args.Price ) )
							{
								switch( args.Type )
								{
									case "waterfight":
									Server.Event.WaterFight.isEvent = 1;
									Server.Event.WaterFight.Price = args.Price;
									Server.Event.WaterFight.Host = player.Data.AccID;

									player.Data.InEvent = "WaterFight";

									player.Data.Stats.Cash -= Server.Event.WaterFight.Price;
									player.Data.Stats.TotalSpend += Server.Event.WaterFight.Price;

									SqForeach.Player.Active( this, function( plr ) 
									{
										if( plr.Data.Player.CustomiseMsg.Type.Event == "true" && plr.Data.Logged ) plr.Msg( TextColor.Event, Lang.EventWaterFightStart[ plr.Data.Language ], player.Name, TextColor.Event, SqInteger.ToThousands( Server.Event.WaterFight.Price ) );
									});		

									SqRoutine( SqEvents, SqEvents.BeginWaterFightEvent, 30000, 1 ).SetTag( "BeginWF" );
									break;

									default:
									player.Msg( TextColor.Error, Lang.EventHosteventSyntax[ player.Data.Language ] );
									break;
								}
							}
							else player.Msg( TextColor.Error, Lang.EventNotEnoughCashToHost[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.EventNeedAtleast150kToHost[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.EventWaterFightAlreadyHosted[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

		return true;
	}


	function JoinEvent( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !player.Data.InEvent )
				{
					if( Server.Event.WaterFight.isEvent > 0 )
					{
						if( Server.Event.WaterFight.isEvent == 1 )
						{
							switch( args.Type )
							{
								case "waterfight":
								player.Data.InEvent = "WaterFight";

								SqForeach.Player.Active( this, function( plr ) 
								{
									if( plr.Data.Player.CustomiseMsg.Type.Event == "true" && plr.Data.Logged ) plr.Msg( TextColor.Event, Lang.EventWaterFightJoin[ plr.Data.Language ], player.Name, TextColor.Event );
								});		

								break;

								default:
								player.Msg( TextColor.Error, Lang.EventJoineventSyntax[ player.Data.Language ] );
								break;
							}
						}
						else player.Msg( TextColor.Error, Lang.EventWaterFightStarted[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.EventWaterFightNoHosted[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.InEventCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

		return true;
	}
}