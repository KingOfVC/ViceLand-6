class CCmdMisc2
{
	Cmd 				= null;

	HP 					= null;
	Arm 				= null;
	Replacewep 			= null;
	Spree 				= null;
	LocalW 				= null;
	GetTop 				= null;
	Use 				= null;
	Unlockcrate 		= null;
	Claimcrate 			= null;
	Hide 				= null;
	Invite 				= null;
	Accept 				= null;
	Denied 				= null;
	Trade 				= null;
	Tradeaccept 		= null;
	Tradedeny 			= null;
	GiveItem 			= null;
	GiveCash 			= null;
	SetTitle    		= null;
	News 				= null;

	constructor( instance )
	{
		this.Cmd = instance;
		
		this.Cmd.BindFail( this, this.funcFailCommand );

		this.HP 				= this.Cmd.Create( "hp", "s", [ "Victim" ], 0, 1, -1, true, true );
		this.Arm 				= this.Cmd.Create( "arm", "s", [ "Victim" ], 0, 1, -1, true, true );
		this.Replacewep 		= this.Cmd.Create( "replacewep", "i", [ "Weapon" ], 1, 1, -1, true, true );
		this.Spree 				= this.Cmd.Create( "spree", "", [ "" ], 0, 0, -1, true, true );
		this.LocalW 			= this.Cmd.Create( "lw", "s|g", [ "Victim", "Text" ], 2, 2, -1, true, true );
		this.GetTop 			= this.Cmd.Create( "gettop", "", [ "" ], 0, 0, -1, true, true );
		this.Use 				= this.Cmd.Create( "use", "g", [ "Item" ], 1, 1, -1, true, true );
		this.Unlockcrate 		= this.Cmd.Create( "unlockcrate", "", [ "" ], 0, 0, -1, true, true );
		this.Claimcrate 		= this.Cmd.Create( "claimcrate", "", [ "" ], 0, 0, -1, true, true );
		this.Hide 				= this.Cmd.Create( "hide", "", [ "" ], 0, 0, -1, true, true );
		this.Invite 			= this.Cmd.Create( "invite", "s", [ "Victim" ], 1, 1, -1, true, true );
		this.Accept 			= this.Cmd.Create( "accept", "", [ "" ], 0, 0, -1, true, true );
		this.Denied 			= this.Cmd.Create( "reject", "", [ "" ], 0, 0, -1, true, true );
		this.Trade 				= this.Cmd.Create( "sendtrade", "s|i|s|s|i", [ "Item", "Quatity", "Victim", "VItem", "VQuatity" ], 5, 5, -1, true, true );
		this.Tradeaccept 		= this.Cmd.Create( "tradeaccept", "", [ "" ], 0, 0, -1, true, true );
		this.Tradedeny 			= this.Cmd.Create( "tradedeny", "", [ "" ], 0, 0, -1, true, true );
		this.GiveItem 			= this.Cmd.Create( "giveitem", "s|s|i", [ "Victim", "Item", "Quatity" ], 3, 3, -1, true, true );
		this.GiveCash 			= this.Cmd.Create( "givecash", "s|i", [ "Victim", "Coin" ], 2, 2, -1, true, true );
		this.SetTitle 			= this.Cmd.Create( "settitle", "g", [ "Text" ], 1, 1, -1, true, true );
		this.News 				= this.Cmd.Create( "updatelog", "", [ "" ], 0, 0, -1, true, true );

		this.HP.BindExec( this.HP, this.CheckArmourHealth );
		this.Arm.BindExec( this.Arm, this.CheckArmourHealth );
		this.Replacewep.BindExec( this.Replacewep, this.ReplaceWeapon );
		this.Spree.BindExec( this.Spree, this.ShowSpree );
		this.LocalW.BindExec( this.LocalW, this.LocalWhiper );
		this.GetTop.BindExec( this.GetTop, this.GetTopPlayers );
		this.Use.BindExec( this.Use, this.UseItem );
		this.Unlockcrate.BindExec( this.Unlockcrate, this.UnlockCrate );
		this.Claimcrate.BindExec( this.Claimcrate, this.ClaimCrate );
		this.Hide.BindExec( this.Hide, this.HidePlayer );
		this.Invite.BindExec( this.Invite, this.InvitePlayer );
		this.Accept.BindExec( this.Accept, this.AcceptRequest );
		this.Denied.BindExec( this.Denied, this.RejectRequest );
		this.Trade.BindExec( this.Trade, this.SendTradeOffer );
		this.Tradeaccept.BindExec( this.Tradeaccept, this.AcceptTrade );
		this.Tradedeny.BindExec( this.Tradedeny, this.RejectTrade );
		this.GiveItem.BindExec( this.GiveItem, this.GiveItemPlayer );
		this.GiveCash.BindExec( this.GiveCash, this.GiveCashPlayer );
		this.SetTitle.BindExec( this.SetTitle, this.PlayerSetTitle );
		this.News.BindExec( this.News, this.ReadNews );
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
				case "replacewep":
				player.Msg( TextColor.Error, Lang.ReplaceWepSyntax[ player.Data.Language ] );
				break;

				case "lw":
				player.Msg( TextColor.Error, Lang.LocalWhiperSyntax[ player.Data.Language ] );
				break;

				case "use":
				player.Msg( TextColor.Error, Lang.UseSyntax[ player.Data.Language ] );
				break;
			
				case "invite":
				player.Msg( TextColor.Error, Lang.InviteSyntax[ player.Data.Language ] );
				break;

				case "sendtrade":
				player.Msg( TextColor.Error, Lang.TradeSyntax[ player.Data.Language ] );
				break;

				case "giveitem":
				player.Msg( TextColor.Error, Lang.GiveitemSyntax[ player.Data.Language ] );
				break;

				case "givecash":
				player.Msg( TextColor.Error, Lang.GiveCashSyntax[ player.Data.Language ] );
				break;
		
				case "settitle":
				player.Msg( TextColor.Error, Lang.SettitleSyntax[ player.Data.Language ] );
				break;
			}
		}
	}

	function CheckArmourHealth( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( !args.rawin( "Victim" ) )
				{
					player.Msg( TextColor.InfoS, Lang.GetHPArm[ player.Data.Language ], player.Health, TextColor.InfoS, player.Armour );
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
								if( target.Data.Logged )
								{
									player.Msg( TextColor.InfoS, Lang.GetHPArm2[ player.Data.Language ], target.Name, TextColor.InfoS, target.Health, TextColor.InfoS, target.Armour );
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

	function ReplaceWeapon( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				switch( args.Weapon )
				{
					case 100:
					switch( SqWeapon.IsWeaponReplaced( player, 27, 100 ) )
					{
						case true:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 27 ), TextColor.Sucess, GetWeaponName( 100 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice[ player.Data.Language ] );

						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 27, 100 );
						break;

						case false:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 100 ), TextColor.Sucess, GetWeaponName( 27 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice1[ player.Data.Language ] );
							
						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 27 );
						break;
					}
						break;

					case 101:
					switch( SqWeapon.IsWeaponReplaced( player, 26, 101 ) )
					{
						case true:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 26 ), TextColor.Sucess, GetWeaponName( 101 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice[ player.Data.Language ] );

						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 26, 101 );
						break;

						case false:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 101 ), TextColor.Sucess, GetWeaponName( 26 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice1[ player.Data.Language ] );
							
						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 26 );
						break;
					}
					break;

					case 102:
					switch( SqWeapon.IsWeaponReplaced( player, 32, 102 ) )
					{
						case true:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 32 ), TextColor.Sucess, GetWeaponName( 102 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice[ player.Data.Language ] );

						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 32, 102 );
						break;

						case false:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 102 ), TextColor.Sucess, GetWeaponName( 32 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice1[ player.Data.Language ] );
							
						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 32 );
						break;
					}
					break;

					case 103:
					switch( SqWeapon.IsWeaponReplaced( player, 18, 103 ) )
					{
						case true:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 18 ), TextColor.Sucess, GetWeaponName( 103 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice[ player.Data.Language ] );

						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 18, 103 );
						break;

						case false:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 103 ), TextColor.Sucess, GetWeaponName( 18 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice1[ player.Data.Language ] );
							
						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 18 );
						break;
					}
					break;

					case 104:
					switch( SqWeapon.IsWeaponReplaced( player, 21, 104 ) )
					{
						case true:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 21 ), TextColor.Sucess, GetWeaponName( 104 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice[ player.Data.Language ] );

						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 21, 104 );
						break;

						case false:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 104 ), TextColor.Sucess, GetWeaponName( 21 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice1[ player.Data.Language ] );
							
						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 21 );
						break;
					}
					break;

					case 105:
					switch( SqWeapon.IsWeaponReplaced( player, 26, 105 ) )
					{
						case true:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 26 ), TextColor.Sucess, GetWeaponName( 105 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice[ player.Data.Language ] );

						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 26, 105 );
						break;

						case false:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 105 ), TextColor.Sucess, GetWeaponName( 26 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice1[ player.Data.Language ] );
							
						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 26 );
						break;
					}
					break;

					case 106:
					switch( SqWeapon.IsWeaponReplaced( player, 29, 106 ) )
					{
						case true:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 29 ), TextColor.Sucess, GetWeaponName( 106 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice[ player.Data.Language ] );

						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 29, 106 );
						break;

						case false:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 106 ), TextColor.Sucess, GetWeaponName( 29 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice1[ player.Data.Language ] );
							
						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 29 );
						break;
					}
					break;

					case 107:
					switch( SqWeapon.IsWeaponReplaced( player, 25, 107 ) )
					{
						case true:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 25 ), TextColor.Sucess, GetWeaponName( 107 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice[ player.Data.Language ] );

						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 25, 107 );
						break;

						case false:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 107 ), TextColor.Sucess, GetWeaponName( 25 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice1[ player.Data.Language ] );
							
						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 25 );
						break;
					}
					break;

					case 108:
					switch( SqWeapon.IsWeaponReplaced( player, 26, 108 ) )
					{
						case true:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 26 ), TextColor.Sucess, GetWeaponName( 108 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice[ player.Data.Language ] );

						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 26, 108 );
						break;

						case false:
						player.Msg( TextColor.Sucess, Lang.WeaponReplaced[ player.Data.Language ], GetWeaponName( 108 ), TextColor.Sucess, GetWeaponName( 26 ) );
						if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" ) player.Msg( TextColor.InfoS, Lang.ChangeNameNewNotice1[ player.Data.Language ] );
						
						SqWeapon.ReplaceOrRemoveWeaponSlot( player, 26 );
						break;
					}
					break;

					default:
					player.Msg( TextColor.Error, Lang.ReplaceWepSyntax[ player.Data.Language ] );
					break;
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function ShowSpree( player, args )
	{		
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				local getPlayers = null;

				SqForeach.Player.Active( this, function( plr ) 
				{
					if( plr.Data.CurrentStats.Spree > 4 )
					{
						if( getPlayers ) getPlayers = getPlayers + ", " + plr.Name + "[" + plr.Data.CurrentStats.Spree + "]";
						else getPlayers = plr.Name + "[" + plr.Data.CurrentStats.Spree + "]";
					}
				});

				if( getPlayers ) player.Msg( TextColor.InfoS, Lang.GetSpree[ player.Data.Language ], getPlayers );
				else player.Msg( TextColor.InfoS, Lang.XOnSpree[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function LocalWhiper( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
                local target = SqPlayer.FindPlayer( args.Victim );
                if( target )
                {
                    if( target.ID != player.ID )
                    {
                       if( target.World == player.World )
                        {
                            if( target.Pos.DistanceTo( player.Pos ) < 5 )
                            {
								SqForeach.Player.Active( this, function( target1 ) 
				                {
				                    if( target1.World == player.World )
				                    {
				                    	if( target1.Pos.DistanceTo( player.Pos ) < 5 )
				                    	{
				                    		if( player.ID != target1.ID && target.ID != target1.ID )
				                    		{
				                    			target1.Msg( TextColor.Info, Lang.LocalWhiper1[ target1.Data.Language ], player.Name, TextColor.Info, target.Name );
				                    		}
				                    	}
				                   }
				                });

								target.Msg( TextColor.Info, Lang.LocalWhiperRec[ target.Data.Language ], player.Name, args.Text );
									
								player.Msg( TextColor.Info, Lang.LocalWhiperSender[ player.Data.Language ], player.Name, target.Name, args.Text );
                            }
                            else player.Msg( TextColor.Error, Lang.TargetNotNear[ player.Data.Language ] );
                        }
                        else player.Msg( TextColor.Error, Lang.WorldNotSameWorld[ player.Data.Language ] );
                    }
                    else player.Msg( TextColor.Error, Lang.CantUseCommandSelf[ player.Data.Language ] );
                }
                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

        return true;
    }

	function GetTopPlayers( player, args )
	{		
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				player.StreamInt( 500 );
				player.StreamString( "" );
				player.FlushStream( true );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function UseItem( player, args )
	{		
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				switch( args.Item )
				{
					case "vippass":
					if( player.Data.GetInventoryItem( "vippass" ) )
					{
						if( player.Data.Player.Permission.VIP.Position != "2" )
						{
							local decItem = player.Data.Player.Inventory[ "vippass" ].Quatity.tointeger();

							if( player.Data.Player.Permission.VIP.Position == "0" )
							{
								player.Data.Player.Permission.VIP.Position 		= "1";
				        	    player.Data.Player.Permission.VIP.Duration 		= "2592000";
				        	    player.Data.Player.Permission.VIP.Time  		= time().tostring();
				        	    player.Data.Player.Permission.VIP.Name 			= "Temporary";
				        	}

				        	else 
				        	{
				        		player.Data.Player.Permission.VIP.Duration 		= ( player.Data.Player.Permission.VIP.Duration.tointeger() + 2592000 );
				        	}

				        	local getTime = ( ( player.Data.Player.Permission.VIP.Time.tointeger() - time() ) - player.Data.Player.Permission.VIP.Duration.tointeger() );
			        	    
			        	    player.Data.Player.Inventory[ "vippass" ].Quatity = ( decItem - 1 );

			        	    player.Msg( TextColor.InfoS, Lang.UsedVIPPass[ player.Data.Language ] );
	        	   			player.Msg( TextColor.InfoS, Lang.SetVIPTarget1[ player.Data.Language ], SqInteger.SecondToTime( player.Data.Player.Permission.VIP.Duration.tointeger() ) );
			        	}
			        	else player.Msg( TextColor.Error, Lang.CantUseVIPPass[ player.Data.Language ] );
		        	}
		        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "vippass" ) );
	        	    break;

	        	    case "nukepass":
	        	    player.Msg( TextColor.Error, Lang.UseCmdInstead[ player.Data.Language ], "/nuke", TextColor.Error );                                        
	        	    break;

	        	    case "weapontag":
	        	    player.Msg( TextColor.Error, Lang.UseCmdInstead[ player.Data.Language ], "/changewepname", TextColor.Error );                                        
	        	    break;

	        	    case "vehiclenametag":
	        	    player.Msg( TextColor.Error, Lang.UseCmdInstead[ player.Data.Language ], "/vehsetting", TextColor.Error );                                 
	        	    break;

	        	    case "worldpass":
					if( player.Data.GetInventoryItem( "worldpass" ) )
					{
						local decItem = player.Data.Player.Inventory[ "worldpass" ].Quatity.tointeger();

						player.Data.Event.FreeWorld = ( player.Data.Event.FreeWorld.tointeger() + 1 );

						player.Msg( TextColor.InfoS, Lang.UsedWorldPass[ player.Data.Language ] );

						player.Data.Player.Inventory[ "worldpass" ].Quatity = ( decItem - 1 );
					}
		        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "worldpass" ) );
	        	    break;

					case "adminpass":
					if( player.Data.GetInventoryItem( "adminpass" ) )
					{
						if( player.Data.Player.Permission.Staff.Position.tointeger() == 0 )
						{
							local decItem = player.Data.Player.Inventory[ "adminpass" ].Quatity.tointeger();

							player.Data.Player.Permission.Staff.Position 		= "1";
				        	player.Data.Player.Permission.Staff.Duration 		= "604800";
				        	player.Data.Player.Permission.Staff.Time  			= time().tostring();
				        	player.Data.Player.Permission.Staff.Name 			= "Temporary Moderator";

				        	local getTime = ( ( player.Data.Player.Permission.Staff.Time.tointeger() - time() ) - player.Data.Player.Permission.Staff.Duration.tointeger() );
			        	    
			        	    player.Data.Player.Inventory[ "adminpass" ].Quatity = ( decItem - 1 );

			        	    player.Msg( TextColor.InfoS, Lang.UsedAdminPass[ player.Data.Language ] );
	        	   			player.Msg( TextColor.InfoS, Lang.AdminPassExpiredDate[ player.Data.Language ], SqInteger.SecondToTime( 604800 ) );
			        	}
			        	else player.Msg( TextColor.Error, Lang.CantUseAdminPass[ player.Data.Language ] );
		        	}
		        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "adminpass" ) );
	        	    break;

					case "hiddenpass":
					if( player.Data.GetInventoryItem( "hiddenpass" ) )
					{
						local decItem = player.Data.Player.Inventory[ "hiddenpass" ].Quatity.tointeger();

						player.Data.Hidden = true;

						player.SetOption( SqPlayerOption.ShowMarkers, false );

						player.Msg( TextColor.InfoS, Lang.UsedHiddenPass[ player.Data.Language ] );

						player.Data.Player.Inventory[ "hiddenpass" ].Quatity = ( decItem - 1 );
					}
		        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "hiddenpass" ) );
	        	    break;

	        	    case "santahat":
					if( player.Data.GetInventoryItem( "santahat" ) )
					{
						player.SetWeapon( 110, 1 );

						player.Msg( TextColor.InfoS, Lang.EquipSantaHat[ player.Data.Language ] );
					}
		        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "santahat" ) );
	        	    break;

	        	    case "leveluppass":
					if( player.Data.GetInventoryItem( "leveluppass" ) )
					{
						player.Msg( TextColor.InfoS, Lang.UseLevelUp[ player.Data.Language ] );

						player.Data.AddXP( player, ::getExperienceAtLevel( ( ::getLevelAtExperience( player.Data.Stats.XP ) + 1 ) ) );
					}
		        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "leveluppass" ) );
	        	    break;

	        	    default:
					player.Msg( TextColor.Error, Lang.UseSyntax[ player.Data.Language ] );
					break;
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function UnlockCrate( player, args )
	{		
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.GetInventoryItem( "crate" ) )
				{
					local generate_id = ( rand() % 170 );

					player.Data.Player.Inventory[ "crate" ].Quatity = ( player.Data.Player.Inventory[ "crate" ].Quatity.tointeger() - 1 );

					switch( generate_id )
					{
						case 47:
						player.Data.GetInventoryItem( "adminpass" );

						player.Data.Player.Inventory[ "adminpass" ].Quatity = ( player.Data.Player.Inventory[ "adminpass" ].Quatity.tointeger() + 1 );

						SqCast.MsgAllExp( player, TextColor.Info, Lang.UnlockCrateAll, player.Name, TextColor.Info, ::GetItemColor( "adminpass" ) );
					
						player.Msg( TextColor.Sucess, Lang.UnlockCrate[ player.Data.Language ], ::GetItemColor( "adminpass" ) );

						SqCast.EchoMessage( format( "**%s** opened an crate and found **%s**.", player.Name, ::StripCol( ::GetItemColor( "adminpass" ) ) ) );

						return;
						break;

						case 69:
						case 23:
						case 67:
						player.Data.GetInventoryItem( "vippass" );

						player.Data.Player.Inventory[ "vippass" ].Quatity = ( player.Data.Player.Inventory[ "vippass" ].Quatity.tointeger() + 1 );

						SqCast.MsgAllExp( player, TextColor.Info, Lang.UnlockCrateAll, player.Name, TextColor.Info, ::GetItemColor( "vippass" ) );
					
						player.Msg( TextColor.Sucess, Lang.UnlockCrate[ player.Data.Language ], ::GetItemColor( "vippass" ) );

						return;
						break;

						case 77:
						case 5:
						case 67:
						player.Data.GetInventoryItem( "Nuke" );

						player.Data.Player.Inventory[ "Nuke" ].Quatity = ( player.Data.Player.Inventory[ "Nuke" ].Quatity.tointeger() + 1 );

						SqCast.MsgAllExp( player, TextColor.Info, Lang.UnlockCrateAll, player.Name, TextColor.Info, ::GetItemColor( "Nuke" ) );
					
						player.Msg( TextColor.Sucess, Lang.UnlockCrate[ player.Data.Language ], ::GetItemColor( "Nuke" ) );

						SqCast.EchoMessage( format( "**%s** opened an crate and found **%s**.", player.Name, ::StripCol( ::GetItemColor( "Nuke" ) ) ) );

						return;
						break;

						default:
						if( ( generate_id > 0 ) && ( generate_id < 10 ) )
						{
							player.Data.GetInventoryItem( "worldpass" );

							player.Data.Player.Inventory[ "worldpass" ].Quatity = ( player.Data.Player.Inventory[ "worldpass" ].Quatity.tointeger() + 1 );

							SqCast.MsgAllExp( player, TextColor.Info, Lang.UnlockCrateAll, player.Name, TextColor.Info, ::GetItemColor( "worldpass" ) );
						
							player.Msg( TextColor.Sucess, Lang.UnlockCrate[ player.Data.Language ], ::GetItemColor( "worldpass" ) );

							SqCast.EchoMessage( format( "**%s** opened an crate and found **%s**.", player.Name, ::StripCol( ::GetItemColor( "worldpass" ) ) ) );

							return;
						}

						if( ( generate_id > 10 ) && ( generate_id < 20 ) )
						{
							player.Data.GetInventoryItem( "hiddenpass" );

							player.Data.Player.Inventory[ "hiddenpass" ].Quatity = ( player.Data.Player.Inventory[ "hiddenpass" ].Quatity.tointeger() + 1 );

							SqCast.MsgAllExp( player, TextColor.Info, Lang.UnlockCrateAll, player.Name, TextColor.Info, ::GetItemColor( "hiddenpass" ) );
						
							player.Msg( TextColor.Sucess, Lang.UnlockCrate[ player.Data.Language ], ::GetItemColor( "hiddenpass" ) );

							SqCast.EchoMessage( format( "**%s** opened an crate and found **%s**.", player.Name, ::StripCol( ::GetItemColor( "hiddenpass" ) ) ) );

							return;
						}

						if( ( generate_id > 50 ) && ( generate_id < 60 ) )
						{
							player.Data.GetInventoryItem( "NameTag" );

							player.Data.Player.Inventory[ "NameTag" ].Quatity = ( player.Data.Player.Inventory[ "NameTag" ].Quatity.tointeger() + 1 );

							SqCast.MsgAllExp( player, TextColor.Info, Lang.UnlockCrateAll, player.Name, TextColor.Info, ::GetItemColor( "NameTag" ) );
						
							player.Msg( TextColor.Sucess, Lang.UnlockCrate[ player.Data.Language ], ::GetItemColor( "NameTag" ) );

							SqCast.EchoMessage( format( "**%s** opened an crate and found **%s**.", player.Name, ::StripCol( ::GetItemColor( "NameTag" ) ) ) );

							return;
						}

						if( ( generate_id > 59 ) && ( generate_id < 70 ) )
						{
							player.Data.GetInventoryItem( "VehTag" );

							player.Data.Player.Inventory[ "VehTag" ].Quatity = ( player.Data.Player.Inventory[ "VehTag" ].Quatity.tointeger() + 1 );

							SqCast.MsgAllExp( player, TextColor.Info, Lang.UnlockCrateAll, player.Name, TextColor.Info, ::GetItemColor( "VehTag" ) );
						
							player.Msg( TextColor.Sucess, Lang.UnlockCrate[ player.Data.Language ], ::GetItemColor( "VehTag" ) );

							SqCast.EchoMessage( format( "**%s** opened an crate and found **%s**.", player.Name, ::StripCol( ::GetItemColor( "VehTag" ) ) ) );

							return;
						}

						if( ( generate_id > 84 ) && ( generate_id < 100 ) )
						{
							player.Data.GetInventoryItem( "ArmCase" );

							player.Data.Player.Inventory[ "ArmCase" ].Quatity = ( player.Data.Player.Inventory[ "ArmCase" ].Quatity.tointeger() + 1 );

							SqCast.MsgAllExp( player, TextColor.Info, Lang.UnlockCrateAll, player.Name, TextColor.Info, ::GetItemColor( "ArmCase" ) );
						
							player.Msg( TextColor.Sucess, Lang.UnlockCrate[ player.Data.Language ], ::GetItemColor( "ArmCase" ) );

							SqCast.EchoMessage( format( "**%s** opened an crate and found **%s**.", player.Name, ::StripCol( ::GetItemColor( "ArmCase" ) ) ) );

							return;
						}

						if( ( generate_id > 120 ) && ( generate_id < 135 ) )
						{
							player.Data.GetInventoryItem( "leveluppass" );

							player.Data.Player.Inventory[ "leveluppass" ].Quatity = ( player.Data.Player.Inventory[ "leveluppass" ].Quatity.tointeger() + 1 );

							SqCast.MsgAllExp( player, TextColor.Info, Lang.UnlockCrateAll, player.Name, TextColor.Info, ::GetItemColor( "leveluppass" ) );
						
							player.Msg( TextColor.Sucess, Lang.UnlockCrate[ player.Data.Language ], ::GetItemColor( "leveluppass" ) );

							SqCast.EchoMessage( format( "**%s** opened an crate and found **%s**.", player.Name, ::StripCol( ::GetItemColor( "leveluppass" ) ) ) );

							return;
						}

						else 
						{
							local random_coin = ( rand() % 100 ), textCoin = "[#b2e1e6]" + random_coin + " Vice Coin";

							player.Data.Stats.Coin += random_coin;
							SqCast.MsgAllExp( player, TextColor.Info, Lang.UnlockCrateAll, player.Name, TextColor.Info, textCoin );
						
							player.Msg( TextColor.Sucess, Lang.UnlockCrate[ player.Data.Language ], textCoin );

							SqCast.EchoMessage( format( "**%s** opened an crate and found **%s**.", player.Name, textCoin ) );

							return;
						}
						break;
					}
				}
		        else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "crate" ) );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function ClaimCrate( player, args )
	{		
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( ( time() - player.Data.Event.FreeCrate.tointeger() ) > 86400 )
				{
					player.Data.GetInventoryItem( "crate" );

					player.Data.Player.Inventory[ "crate" ].Quatity = ( player.Data.Player.Inventory[ "crate" ].Quatity.tointeger() + 1 );

					player.Data.Event.FreeCrate	= time().tostring();				
					
					player.Msg( TextColor.Sucess, Lang.RecCrate[ player.Data.Language ] );

					if( player.Data.Player.Permission.VIP.Position.tointeger() > 0 )
					{
						player.Data.Player.Inventory[ "crate" ].Quatity = ( player.Data.Player.Inventory[ "crate" ].Quatity.tointeger() + 1 );

						player.Msg( TextColor.Sucess, Lang.RecCrate2[ player.Data.Language ] );
					}
				}
				else 
				{
					local getTime = ( 86400 - ( time() - player.Data.Event.FreeCrate.tointeger() )  );

					player.Msg( TextColor.Error, Lang.WaitClaim[ player.Data.Language ], SqInteger.SecondToTime( getTime ) );
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function HidePlayer( player, args )
	{		
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.GetInventoryItem( "hiddenpass" ) )
				{
					local decItem = player.Data.Player.Inventory[ "hiddenpass" ].Quatity.tointeger();

					player.Data.Hidden = true;

					player.SetOption( SqPlayerOption.ShowMarkers, false );

					player.Msg( TextColor.InfoS, Lang.UsedHiddenPass[ player.Data.Language ] );

					player.Data.Player.Inventory[ "hiddenpass" ].Quatity = ( decItem - 1 );
				}
		        else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "hiddenpass" ) );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function InvitePlayer( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
            	if( !player.Data.Interior )
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
			                       	if( target.World != player.World )
			                       	{
										if( !target.Data.AdminDuty )
										{
					                       	if( !target.Data.WorldInvite )
					                       	{
					                       		player.Msg( TextColor.Sucess, Lang.AskTargetToJoinWorld[ player.Data.Language ], target.Name, TextColor.Sucess );

					                       		target.Msg( TextColor.InfoS, Lang.RequestJoinWorld[ player.Data.Language ], player.Name, TextColor.InfoS, SqWorld.GetWorldName( player.World ), TextColor.InfoS );

					                       		target.WorldInvite = {}
					                       		target.WorldInvite.rawset( "Data", 
					                       		{
					                       				World 	= player.World,
					                       				Pos 	= player.Pos,
					                       		});

												target.MakeTask( function()
												{
														target.Data.WorldInvite = null;
												}, 5000, 1 );
					                       	}
					                       	else player.Msg( TextColor.Error, Lang.TargetHasPendingInvite[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.TargetAdminDuty[ player.Data.Language ] );
			                       	}
			                      	else player.Msg( TextColor.Error, Lang.TargetOnSameWorld[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
	                    }
	                    else player.Msg( TextColor.Error, Lang.CantUseCommandSelf[ player.Data.Language ] );
	                }
	                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.InIntCantUseCmd[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

        return true;
    }

    function AcceptRequest( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
	            if( player.Data.WorldInvite )
	            {
	            	player.World 	 = player.Data.WorldInvite.Data.World;
	            	player.Pos 		 = player.Data.WorldInvite.Data.Pos;

	            	player.Data.Interior = null;

	            	player.Msg( TextColor.Sucess, Lang.AcceptJoinWorldRequest[ player.Data.Language ] );

	            	switch( player.World )
	            	{
	            		case 0:
	            		case 1:
	            		player.SetOption( SqPlayerOption.CanAttack, true );
						player.SetOption( SqPlayerOption.DriveBy, true );

						player.Data.InEvent = null;
						break;

						case 101:
						player.World = 101;

						player.Armour = 0;

						player.Data.InEvent = "DM";
																
						player.SetOption( SqPlayerOption.CanAttack, true );

						player.Pos = Vector3.FromStr( Server.DMArena.Arena[ Server.DMArena.Position.tostring() ].Pos );	
						break;

						case 102:
						player.World = 102;

						player.Data.InEvent = "Cash";
															
						player.SetOption( SqPlayerOption.CanAttack, false );
						break;

						case 103:
						// TBA
						break;

						default:
						if( SqWorld.GetPrivateWorld( player.World ) )
						{	
							local world = SqWorld.World[ player.World ];

							player.Data.InEvent = null;
																																		
							if( world.Settings.WorldSpawn != "0,0,0" ) player.Pos = Vector3.FromStr( world.Settings.WorldSpawn );
							if( world.Settings.WorldMessage != "N/A" ) player.Msg( TextColor.Sucess, Lang.WorldWelcomeMessage[ player.Data.Language ], world.Settings.WorldMessage );
																	
							player.SetOption( SqPlayerOption.CanAttack, SToB( world.Settings.WorldKill ) );
							player.SetOption( SqPlayerOption.DriveBy, SToB( world.Settings.WorldDriveBy ) );
																	
							if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.canattack ) ) player.SetOption( SqPlayerOption.CanAttack, true );
							if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), world.Permissions2.candriveby ) ) player.SetOption( SqPlayerOption.DriveBy, true );
	            		}
	            		break;
	            	}

	            	player.Data.WorldInvite = null;
	            }
	            else player.Msg( TextColor.Error, Lang.NotInvitePending[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

        return true;
    }

    function RejectRequest( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
            	if( player.Data.WorldInvite )
            	{
            		player.Msg( TextColor.Sucess, Lang.RejectJoinWorldRequest[ player.Data.Language ] );

            		player.Data.WorldInvite = null;
            	}
            	else player.Msg( TextColor.Error, Lang.NotInvitePending[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

        return true;
    }

	function SendTradeOffer( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
            	if( !player.Data.TradeInvite )
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
									if( !target.Data.AdminDuty )
									{
						                if( !target.Data.TradeInvite )
						                {
						                	local pass = null;

											switch( args.Item )
											{
												case "vippass":
												if( player.Data.GetInventoryItem2( "vippass" ) >= args.Quatity )
												{
													pass = "vippass";
									        	}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "vippass" ) );
								        	    break;

												case "crate":
												if( player.Data.GetInventoryItem2( "crate" ) >= args.Quatity )
												{
													pass = "crate";
									        	}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "crate" ) );
								        	    break;

												case "armourcase":
												if( player.Data.GetInventoryItem2( "ArmCase" ) >= args.Quatity )
												{
													pass = "ArmCase";
									        	}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "ArmCase" ) );
								        	    break;

								        	    case "nukepass":
												if( player.Data.GetInventoryItem( "Nuke" ) >= args.Quatity )
												{
													pass = "Nuke";
									        	}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "Nuke" ) );
								        	    break;

								        	    case "weapontag":
												if( player.Data.GetInventoryItem2( "NameTag" ) >= args.Quatity )
												{
													pass = "NameTag";
									        	}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "NameTag" ) );
								        	    break;

								        	    case "vehiclenametag":
												if( player.Data.GetInventoryItem2( "VehTag" ) >= args.Quatity )
												{
													pass = "VehTag";
									        	}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "VehTag" ) );
								        	    break;

								        	    case "worldpass":
												if( player.Data.GetInventoryItem2( "worldpass" ) >= args.Quatity )
												{
													pass = "worldpass";
												}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "worldpass" ) );
								        	    break;

												case "adminpass":
												if( player.Data.GetInventoryItem2( "adminpass" ) >= args.Quatity )
												{
													pass = "adminpass";
									        	}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "adminpass" ) );
								        	    break;

												case "hiddenpass":
												if( player.Data.GetInventoryItem2( "hiddenpass" ) >= args.Quatity )
												{
													pass = "hiddenpass";
												}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "hiddenpass" ) );
								        	    break;

												case "gangpass":
												if( player.Data.GetInventoryItem2( "gangpass" ) >= args.Quatity )
												{
													pass = "gangpass";
												}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "gangpass" ) );
								        	    break;

												case "leveluppass":
												if( player.Data.GetInventoryItem2( "leveluppass" ) >= args.Quatity )
												{
													pass = "leveluppass";
												}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "leveluppass" ) );
								        	    break;


								        	    default:
												player.Msg( TextColor.Error, Lang.InvalidItem[ player.Data.Language ] );
												break;
											}

											local thisItem = null;
											if( pass )
											{
												switch( args.VItem )
												{
													case "vippass":
													thisItem = "vippass";
													break;

									        	    case "nukepass":
													thisItem = "Nuke";
													break;
									        	    case "weapontag":
													thisItem = "NameTag";
													break;

									        	    case "vehiclenametag":
													thisItem = "VehTag";
													break;

									        	    case "worldpass":
													thisItem = "worldpass";
													break;

													case "adminpass":
													thisItem = "adminpass";
													break;

													case "hiddenpass":
													thisItem = "hiddenpass";
													break;

													case "crate":
													thisItem = "crate";
													break;

													case "armourcase":
													thisItem = "ArmCase";
													break;

													case "gangpass":
													thisItem = "gangpass";
													break;

													case "leveluppass":
													thisItem = "leveluppass";
													break;

									        	    default:
													return player.Msg( TextColor.Error, Lang.InvalidItem[ player.Data.Language ] );
													break;
												}

												player.Msg( TextColor.Sucess, Lang.SendTradeOffer[ player.Data.Language ], target.Name, TextColor.Sucess );

												target.Msg( TextColor.InfoS, Lang.SendTradeOffer2[ target.Data.Language ], player.Name, TextColor.InfoS, GetItemColor( pass ), args.Quatity, TextColor.InfoS, GetItemColor( thisItem ), args.VQuatity );
												target.Msg( TextColor.InfoS, Lang.SendTradeOffer3[ target.Data.Language ], TextColor.InfoS, TextColor.InfoS );

												player.Data.TradeInvite = true;

												target.Data.TradeInvite = {};
												target.Data.TradeInvite.rawset( "Invite",
												{
													Player 		= player.Name,
													Item 		= pass,
													Quatity		= args.Quatity,
													TargetItem  = thisItem,
													TargetQuatity 	= args.VQuatity,
												});

												target.MakeTask( function()
												{
													if( target.Data.TradeInvite )
													{
														target.Data.TradeInvite = null;
														player.Data.TradeInvite = null;

														player.Msg( TextColor.Sucess, Lang.SendTradeOfferTimeout[ player.Data.Language ], target.Name, TextColor.Sucess );

														target.Msg( TextColor.Sucess, Lang.SendTradeOfferTimeout2[ target.Data.Language ], player.Name, TextColor.Sucess );
													}
												}, 30000, 1 );
											}
					                    }
					                    else player.Msg( TextColor.Error, Lang.TargetHasPendingTradeInvite[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.TargetAdminDuty[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
						}
	                  else player.Msg( TextColor.Error, Lang.CantUseCommandSelf[ player.Data.Language ] );
	                }
	                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
	            }
	            else player.Msg( TextColor.Error, Lang.TradePendingWaiting[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

        return true;
    }

	function AcceptTrade( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
            	if( player.Data.canTrade() )
            	{
		            local target = SqPlayer.FindPlayer( player.Data.TradeInvite.Invite.Player );
		            if( target )
		            {
						if( target.Data.GetInventoryItem2( player.Data.TradeInvite.Invite.Item ) >= target.Data.TradeInvite.Invite.Quatity )
						{
							if( player.Data.GetInventoryItem2( player.Data.TradeInvite.Invite.TargetItem ) >= player.Data.TradeInvite.Invite.TargetQuatity )
							{
								local decItem = player.Data.Player.Inventory[ player.Data.TradeInvite.Invite.Item ].Quatity.tointeger();
								local decItem2 = target.Data.Player.Inventory[ player.Data.TradeInvite.Invite.TargetItem ].Quatity.tointeger();
								local decItem4 = player.Data.Player.Inventory[ player.Data.TradeInvite.Invite.Item ].Quatity.tointeger();
								local decItem3 = target.Data.Player.Inventory[ player.Data.TradeInvite.Invite.TargetItem ].Quatity.tointeger();

								player.Data.Player.Inventory[ player.Data.TradeInvite.Invite.Item ].Quatity = ( decItem + player.Data.TradeInvite.Invite.Quatity );
								target.Data.Player.Inventory[ player.Data.TradeInvite.Invite.TargetItem ].Quatity = ( decItem2 + player.Data.TradeInvite.Invite.TargetQuatity );

								player.Data.Player.Inventory[ player.Data.TradeInvite.Invite.TargetItem ].Quatity = ( decItem3 - player.Data.TradeInvite.Invite.TargetQuatity );
								target.Data.Player.Inventory[ player.Data.TradeInvite.Invite.Item ].Quatity = ( decItem4 - player.Data.TradeInvite.Invite.Quatity );

								SqCast.MsgAll( TextColor.Info, Lang.TradeScsAll, player.Name, TextColor.Info, ::GetItemColor( player.Data.TradeInvite.Invite.Item ), player.Data.TradeInvite.Invite.Quatity, TextColor.Info );
								SqCast.MsgAll( TextColor.Info, Lang.TradeScsAll, target.Name, TextColor.Info, ::GetItemColor( player.Data.TradeInvite.Invite.TargetItem ), player.Data.TradeInvite.Invite.TargetQuatity, TextColor.Info );
								
								player.Data.TradeInvite = null;
								target.Data.TradeInvite = null;

								player.Msg( TextColor.Sucess, Lang.TradeSucs[ player.Data.Language ] );

								target.Msg( TextColor.Sucess, Lang.TradeSucs[ target.Data.Language ] );
							}
							else 
							{
								player.Msg( TextColor.Error, Lang.TradeCancelDonthaveItem3[ player.Data.Language ], ::GetItemColor( player.Data.TradeInvite.Invite.TargetItem ) );
								target.Msg( TextColor.Error, Lang.TradeCancelDonthaveItem4[ target.Data.Language ], player.Name, ::GetItemColor( target.Data.TradeInvite.Invite.TargetItem ), TextColor.Error );

								player.Data.TradeInvite = null;
								target.Data.TradeInvite = null;
							}
						}
						else 
						{
							target.Msg( TextColor.Error, Lang.TradeCancelDonthaveItem3[ target.Data.Language ], ::GetItemColor( player.Data.TradeInvite.Invite.Item ) );
							player.Msg( TextColor.Error, Lang.TradeCancelDonthaveItem4[ player.Data.Language ], target.Name, ::GetItemColor( player.Data.TradeInvite.Invite.Item ), TextColor.Error );

							player.Data.TradeInvite = null;
							target.Data.TradeInvite = null;
						}
					}
					else 
					{
						player.Msg( TextColor.Error, Lang.TradeTargetNotFound[ player.Data.Language ] );

						player.Data.TradeInvite = null;
					}
	            }
	            else player.Msg( TextColor.Error, Lang.NoPendingTrade[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

        return true;
    }

	function RejectTrade( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
            	if( typeof( player.Data.TradeInvite ) == "table" )
            	{
		            local target = SqPlayer.FindPlayer( player.Data.TradeInvite.Invite.Player );
		            if( target )
		            {
						target.Msg( TextColor.InfoS, Lang.TradeCancelManual[ target.Data.Language ], player.Name, TextColor.InfoS );
						player.Msg( TextColor.Sucess, Lang.TradeCancelManual2[ player.Data.Language ] );

						player.Data.TradeInvite = null;
						target.Data.TradeInvite = null;
					}
					else 
					{
						player.Msg( TextColor.Error, Lang.TradeCancelManual2[ player.Data.Language ]  );

						player.Data.TradeInvite = null;
					}
	            }
	            else player.Msg( TextColor.Error, Lang.NoPendingTrade[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

        return true;
    }

	function GiveItemPlayer( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
            	if( !player.Data.TradeInvite )
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
									if( !target.Data.AdminDuty )
									{
						                if( !target.Data.TradeInvite )
						                {
						                	local pass = null;

											switch( args.Item )
											{
												case "vippass":
												if( player.Data.GetInventoryItem2( "vippass" ) >= args.Quatity )
												{
													pass = "vippass";
									        	}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "vippass" ) );
								        	    break;

												case "crate":
												if( player.Data.GetInventoryItem2( "crate" ) >= args.Quatity )
												{
													pass = "crate";
									        	}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "crate" ) );
								        	    break;

												case "armourcase":
												if( player.Data.GetInventoryItem2( "ArmCase" ) >= args.Quatity )
												{
													pass = "ArmCase";
									        	}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "ArmCase" ) );
								        	    break;

								        	    case "nukepass":
												if( player.Data.GetInventoryItem( "Nuke" ) >= args.Quatity )
												{
													pass = "Nuke";
									        	}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "Nuke" ) );
								        	    break;

								        	    case "weapontag":
												if( player.Data.GetInventoryItem2( "NameTag" ) >= args.Quatity )
												{
													pass = "NameTag";
									        	}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "NameTag" ) );
								        	    break;

								        	    case "vehiclenametag":
												if( player.Data.GetInventoryItem2( "VehTag" ) >= args.Quatity )
												{
													pass = "VehTag";
									        	}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "VehTag" ) );
								        	    break;

								        	    case "worldpass":
												if( player.Data.GetInventoryItem2( "worldpass" ) >= args.Quatity )
												{
													pass = "worldpass";
												}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "worldpass" ) );
								        	    break;

												case "adminpass":
												if( player.Data.GetInventoryItem2( "adminpass" ) >= args.Quatity )
												{
													pass = "adminpass";
									        	}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "adminpass" ) );
								        	    break;

												case "hiddenpass":
												if( player.Data.GetInventoryItem2( "hiddenpass" ) >= args.Quatity )
												{
													pass = "hiddenpass";
												}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "hiddenpass" ) );
								        	    break;

												case "gangpass":
												if( player.Data.GetInventoryItem2( "gangpass" ) >= args.Quatity )
												{
													pass = "gangpass";
												}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "gangpass" ) );
								        	    break;

												case "leveluppass":
												if( player.Data.GetInventoryItem2( "leveluppass" ) >= args.Quatity )
												{
													pass = "leveluppass";
												}
									        	else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( "leveluppass" ) );
								        	    break;

								        	    default:
												player.Msg( TextColor.Error, Lang.InvalidItem[ player.Data.Language ] );
												break;
											}

											local thisItem = null;
											if( pass )
											{
												switch( args.Item )
												{
													case "vippass":
													thisItem = "vippass";
													break;

									        	    case "nukepass":
													thisItem = "Nuke";
													break;
									        	    case "weapontag":
													thisItem = "NameTag";
													break;

									        	    case "vehiclenametag":
													thisItem = "VehTag";
													break;

									        	    case "worldpass":
													thisItem = "worldpass";
													break;

													case "adminpass":
													thisItem = "adminpass";
													break;

													case "hiddenpass":
													thisItem = "hiddenpass";
													break;

													case "crate":
													thisItem = "crate";
													break;

													case "armourcase":
													thisItem = "ArmCase";
													break;

													case "gangpass":
													thisItem = "gangpass";
													break;

													case "leveluppass":
													thisItem = "leveluppass";
													break;

									        	    default:
													return player.Msg( TextColor.Error, Lang.InvalidItem[ player.Data.Language ] );
													break;
												}

												target.Data.addInventQuatity( thisItem, args.Quatity );
												player.Data.remInventQuatity( thisItem, args.Quatity );

												player.Msg( TextColor.Sucess, Lang.GiveItem[ player.Data.Language ], ::GetItemColor( thisItem ), args.Quatity, TextColor.Sucess, target.Name );

												target.Msg( TextColor.Sucess, Lang.GiveItem2[ target.Data.Language ], ::GetItemColor( thisItem ), args.Quatity, TextColor.Sucess, player.Name );
											}
					                    }
					                    else player.Msg( TextColor.Error, Lang.TargetHasPendingTradeInvite[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.TargetAdminDuty[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
						}
	                  	else player.Msg( TextColor.Error, Lang.CantUseCommandSelf[ player.Data.Language ] );
	                }
	                else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
	            }
	            else player.Msg( TextColor.Error, Lang.TradePendingWaiting[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

        return true;
    }

	function GiveCashPlayer( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
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
								if( !target.Data.AdminDuty )
								{
									if( SqMath.IsGreaterEqual( args.Coin.tointeger(), 0 ) )
									{
										if( SqMath.IsGreaterEqual( player.Data.Stats.Cash, args.Coin.tointeger() ) )
										{
											if( SqMath.IsLess( args.Coin.tointeger(), 5000000 ) )
											{
												player.Data.Stats.Cash	-= args.Coin;
												target.Data.Stats.Cash 	+= args.Coin;
												
												player.Msg( TextColor.Sucess, Lang.GiveCash[ player.Data.Language ], SqInteger.ToThousands( args.Coin ), TextColor.Sucess, target.Name );

												target.Msg( TextColor.Sucess, Lang.GiveCash2[ target.Data.Language ], SqInteger.ToThousands( args.Coin ), TextColor.Sucess, player.Name );
											}
											else player.Msg( TextColor.Error, Lang.SellCoinExeeded[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.NotEnoughGiveCash[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.NotEnoughGiveCash[ player.Data.Language ] );								
								}
								else player.Msg( TextColor.Error, Lang.TargetAdminDuty[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
					}
	                else player.Msg( TextColor.Error, Lang.CantUseCommandSelf[ player.Data.Language ] );
	            }
	            else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

        return true;
    }

	function PlayerSetTitle( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
            	switch( args.Text )
            	{
            		case "none":         		
            		SqCast.setTitle( player, "" );

            		player.Data.Title = "none";

            		player.Msg( TextColor.Sucess, Lang.RemoveTitle[ player.Data.Language ] );
            		break;

            		default:
            		SqCast.setTitle( player, args.Text );

            		player.Data.Title = args.Text;

            		player.Msg( TextColor.Sucess, Lang.SetTitleScs[ player.Data.Language ], args.Text, TextColor.Sucess );
            		break;
            	}
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

        return true;
    }

	function ReadNews( player, args )
    {
        if( player.Data.IsReg )
        {
            if( player.Data.Logged )
            {
				player.StreamInt( 6010 );
				player.StreamString( "x" );
				player.FlushStream( true );
            }
            else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
        }
        else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

        return true;
    }

}