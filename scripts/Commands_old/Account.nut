class CCmdAccount2
{
	Cmd 		= null;
	
	Logout	 	= null;
	
	constructor( instance )
	{
		this.Cmd = instance;
		
		this.Cmd.BindFail( this, this.funcFailCommand );
		
		this.Logout 	= this.Cmd.Create( "logout", "", [ "" ], 0, 0, -1, true, true );
		
		this.Logout.BindExec( this.Logout, this.LogoutAccount );		
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
			}
		}
	}
	
	function LogoutAccount( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
				{
					player.Data.Save();

					player.Data.Logged 	= false;

					SqCast.MsgAllExp( player, TextColor.Info, Lang.LogoutAll, player.Name );

					player.Msg( TextColor.Sucess, Lang.Logout[ player.Data.Language ] );

					SqCast.EchoMessage( format( "**%s** has logged out." ), player.Name );
				}
				else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
}
