class CCmdJob
{
	Cmd					= null;

	PizzaPayCheck		= null;


	constructor( instance )
	{
		this.Cmd = instance;
		
		this.Cmd.BindFail( this, this.funcFailCommand );

		this.PizzaPayCheck					= this.Cmd.Create( "pizzapaycheck", "", [ "" ], 0, 0, -1, true, true );

		this.PizzaPayCheck.BindExec( this.PizzaPayCheck, this.GetPizzaPayCheck );

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

	function GetPizzaPayCheck( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( player.Data.Job.rawin( "Pizza" ) )
				{
					if( SqJob.GetPizzateriaPoint( player ) )
					{
						if( player.Data.Job[ "Pizza" ].Income != 0 )
						{
							local get_amount = player.Data.Job[ "Pizza" ].Income * Server.DoubleEvent.Pizza;

							player.Data.Stats.Cash += player.Data.Job[ "Pizza" ].Income;

							player.Data.Job[ "Pizza" ].Income = 0;

							player.Msg( TextColor.Sucess, Lang.PizzaPayCheck[ player.Data.Language ], SqInteger.ToThousands( get_amount ), TextColor.Sucess );
						}
						else player.Msg( TextColor.Error, Lang.NoPizzaIncome[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotNearPizza[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotPizzaBoi3[ player.Data.Language ] ); 
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
}