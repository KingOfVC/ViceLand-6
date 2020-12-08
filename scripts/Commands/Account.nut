class CCmdAccount
{
	Cmd = null;
	
	Register = null;
	Login = null;
	Changepass = null;
	
	constructor( instance )
	{
		this.Cmd = instance;
		
		this.Cmd.BindFail( this, this.funcFailCommand );
		
		this.Register = this.Cmd.Create("register", "s", [ "Password" ], 1, 1, -1, true, true );
		this.Login = this.Cmd.Create("login", "s", [ "Password" ], 1, 1, -1, true, true );
		this.Changepass = this.Cmd.Create("changepass", "s|s", [ "OldPassword", "NewPassword" ], 2, 2, -1, true, true );

		this.Register.BindExec( this.Register, this.funcRegister );
		this.Login.BindExec( this.Login, this.funcLogin );
		this.Changepass.BindExec( this.Changepass, this.funcChangePass );
		
	}
	
	function funcFailCommand( type, msg, payload )
	{
		local player = this.Cmd.Invoker, cmd = this.Cmd.Command;
		
		switch( type )
		{
			case SqCmdErr.EmptyCommand:
			player.Msg( Colour.Red, msg );
			break;
			
			case SqCmdErr.InvalidCommand:
			player.Msg( Colour.Red, msg );
			break;

			case SqCmdErr.UnknownCommand:
			player.Msg( Colour.Red, msg );
			break;

			case SqCmdErr.MissingExecuter:
			player.Msg( Colour.Red, msg );
			break;
			
			case SqCmdErr.IncompleteArgs:
			player.Msg( Colour.Red, msg );
			break;
	
			case SqCmdErr.ExtraneousArgs:
			player.Msg( Colour.Red, msg );
			break;

			case SqCmdErr.UnsupportedArg:
			player.Msg( Colour.Red, msg );
			break;
		}
	}
	
	function funcRegister( player, args )
	{
		if( player.Authority == -1 )
		{
			if( args.Password.len() > 5 )
			{
				player.Data.Register( args.Password );
			}
			else player.Msg( Colour.Red, Lang.PasswordNotLonger[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.AlreadyRegistered[ player.Data.Language ] );
		
		return true;
	}
	
	function funcLogin( player, args )
	{
		if( player.Authority == 0 )
		{
			if( player.Data.Logged == false )
			{
				if( player.Data.Password == SqHash.GetWhirlpool( args.Password ) )
				{
					player.Data.Login();
				}
				else player.Msg( Colour.Red, Lang.WrongPassword[ player.Data.Language ] );
			}
			else player.Msg( Colour.Red, Lang.AlreadyLogged[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.NotRegistered[ player.Data.Language ] );
	
		return true;
	}

	function funcChangePass( player, args )
	{
		if( player.Authority == -1 )
		{
			if( player.Data.Logged == true )
			{
				if( player.Data.Password == SqHash.GetWhirlpool( args.OldPassword ) )
				{
					if( args.NewPassword.len() > 5 )
					{
						player.Data.Password = SqHash.GetWhirlpool( args.NewPassword );
						player.Msg( Colour.Green, Lang.PasswordChanged[ player.Data.Language ] );
					}
					else player.Msg( Colour.Red, Lang.NewPasswordNotLonger[ player.Data.Language ] );
				}
				else player.Msg( Colour.Red, Lang.WrongOldPassword[ player.Data.Language ] );
			}
			else player.Msg( Colour.Red, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
	
}
