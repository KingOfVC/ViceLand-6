class CCmdAccount
{	
	function funcRegister( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Password": stripCmd[1] };

			if( !player.Data.IsReg )
			{
				if( args.Password.len() > 5 )
				{
					player.Data.Register( args.Password );
				}
				else player.Msg( TextColor.Error, Lang.PasswordNotLonger[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.AlreadyRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.RegisterSyntax[ player.Data.Language ] );
		
		return true;
	}
	
	function funcLogin( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Password": stripCmd[1] };

			if( player.Data.IsReg )
			{
				if( !player.Data.Logged )
				{
					if( player.Data.Password == SqHash.GetSHA256( args.Password ).tolower() )
					{
						player.Data.Login();
					}
					else player.Msg( TextColor.Error, Lang.WrongPassword[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.AlreadyLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.LoginSyntax[ player.Data.Language ] );

		return true;
	}

	function funcChangePass( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 3 )
		{
			args = { "OldPassword": stripCmd[1], "NewPassword": stripCmd[2] };

			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( player.Data.Password == SqHash.GetSHA256( args.OldPassword ).tolower() )
					{
						if( args.NewPassword.len() > 5 )
						{
							player.Data.Password = SqHash.GetSHA256( args.NewPassword ).tolower();
							player.Msg( TextColor.Sucess, Lang.PasswordChanged[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.NewPasswordNotLonger[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.WrongOldPassword[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.ChangepassSyntax[ player.Data.Language ] );

		return true;
	}
	
	function GetCashCoin( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		args = { "Victim": ( stripCmd.len() == 2 ) ? stripCmd[1] : "" };

		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( args.Victim != "" )
				{
					if( player.Data.Player.Permission.Staff.Position.tointeger() > 1 )
					{
						local target = SqPlayer.FindPlayer( args.Victim );
						if( target )
						{
							if( target.Data.IsReg )
							{
								if( target.Data.Logged )
								{
									player.Msg( TextColor.InfoS, Lang.Cash[ player.Data.Language ], target.Name, TextColor.InfoS, SqInteger.ToThousands( target.Data.Stats.Cash ), TextColor.InfoS, SqInteger.ToThousands( target.Data.Stats.Coin ) )
								}
								else player.Msg( TextColor.Error, Lang.TargetNotLogged[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.TargetNotRegistered[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.TargetNotOnline[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotPermissionViewCash[ player.Data.Language ] );
				}
				
				else
				{
					player.Msg( TextColor.InfoS, Lang.CashOwn[ player.Data.Language ], SqInteger.ToThousands( player.Data.Stats.Cash ), TextColor.InfoS, SqInteger.ToThousands( player.Data.Stats.Coin ) )
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function BuyCoin( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Coin": stripCmd[1] };

			if( SqInteger.IsNum( args.Coin ) )
			{
				if( player.Data.IsReg )
				{
					if( player.Data.Logged )
					{
						if( SqLocation.VerifyBL( player.Data.Interior ) )
						{
							if( SqMath.IsGreaterEqual( args.Coin.tointeger(), 0 ) )
							{
								if( SqMath.IsGreaterEqual( player.Data.Stats.Cash, ( Server.Coin.StartPrice * args.Coin.tointeger() ) ) )
								{
									if( SqMath.IsLess( args.Coin.tointeger(), 101 ) )
									{
										player.Data.Stats.Cash	-= ( Server.Coin.StartPrice * args.Coin.tointeger() );
										player.Data.Stats.Coin	+= args.Coin.tointeger();
										player.Data.Stats.TotalSpend += ( Server.Coin.StartPrice * args.Coin.tointeger() );
										
										player.Msg( TextColor.Sucess, Lang.BuyCoin[ player.Data.Language ], args.Coin.tointeger(), TextColor.Sucess, "$" + SqInteger.ToThousands( ( Server.Coin.StartPrice * args.Coin.tointeger() ) ) );
							
										Server.Coin.ChangeRate	++;
										
									//	if( Server.Coin.ChangeRate % 10 == 0 ) Server.Coin.StartPrice = ( Server.Coin.StartPrice * 2 );
									}
									else player.Msg( TextColor.Error, Lang.BuyCoinExeeded[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.NeedCashBuyCoin[ player.Data.Language ], "$" + SqInteger.ToThousands( ( Server.Coin.StartPrice * args.Coin.tointeger() ) ) );
							}
							else player.Msg( TextColor.Error, Lang.InvalidAmount[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.NotInBank[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.BuycoinSyntax[ player.Data.Language ] );				
		}
		else player.Msg( TextColor.Error, Lang.BuycoinSyntax[ player.Data.Language ] );

		return true;
	}

	function SellCoin( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Coin": stripCmd[1] };

			if( SqInteger.IsNum( args.Coin ) )
			{
				if( player.Data.IsReg )
				{
					if( player.Data.Logged )
					{
						if( SqLocation.VerifyBL( player.Data.Interior ) )
						{
							if( SqMath.IsGreaterEqual( args.Coin.tointeger(), 0 ) )
							{
								if( SqMath.IsGreaterEqual( player.Data.Stats.Coin, args.Coin.tointeger() ) )
								{
									if( SqMath.IsLess( args.Coin.tointeger(), 101 ) )
									{
										local getValue = ( ( Server.Coin.StartPrice * args.Coin.tointeger() ) / 2 );
										
										player.Data.Stats.Cash	+= getValue;
										player.Data.Stats.Coin	-= args.Coin.tointeger();
										player.Data.Stats.TotalEarn += getValue;
										
										player.Msg( TextColor.Sucess, Lang.SellCoin[ player.Data.Language ], args.Coin.tointeger(), TextColor.Sucess, "$" + SqInteger.ToThousands( getValue ) );				
									}
									else player.Msg( TextColor.Error, Lang.SellCoinExeeded[ player.Data.Language ], "$" + SqInteger.ToThousands( ( Server.Coin.StartPrice * args.Coin.tointeger() ) ) );
								}
								else player.Msg( TextColor.Error, Lang.NeedCoinToSell[ player.Data.Language ], ( args.Coin.tointeger() - player.Data.Stats.Coin ) );
							}
							else player.Msg( TextColor.Error, Lang.InvalidAmount[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.NotInBank[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.SellcoinSyntax[ player.Data.Language ] );				
		}
		else player.Msg( TextColor.Error, Lang.SellcoinSyntax[ player.Data.Language ] );

		return true;
	}
	
	function CoinPrice( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqLocation.VerifyBL( player.Data.Interior ) )
				{
					local getSellValue = ( ( Server.Coin.StartPrice * 1 ) / 2 ), getBuyValue = ( Server.Coin.StartPrice * 1 );
			
					player.Msg( TextColor.InfoS, Lang.CoinInfo[ player.Data.Language ] );
					player.Msg( TextColor.InfoS, Lang.CoinInfo1[ player.Data.Language ], SqInteger.ToThousands( getBuyValue ), TextColor.InfoS, SqInteger.ToThousands( getSellValue ) );
				}
				else player.Msg( TextColor.Error, Lang.NotInBank[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
}
