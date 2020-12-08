class CCmdObject2
{
	Cmd			= null;
	
	Exportmap		= null;
	
	constructor( instance )
	{
		this.Cmd = instance;
		
		this.Cmd.BindFail( this, this.funcFailCommand );
		
		this.Exportmap = this.Cmd.Create( "exportmap", "", [], 0, 0, -1, true, true );

		this.Exportmap.BindExec( this.Exportmap, this.funcExportMap );
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
	
	function funcExportMap( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqAdmin.IsAllowMapping( player ) )
				{
					if( SqObj.GetWorldObjectCount( player.World ) != 0 )
					{
						local int = time();
						local txtname = "World-" + player.World + "--" + date( int ).day + "-" + ( date( int ).month+1 ) + "-" + date( int ).year + "--" + date( int ).hour + "-" + date( int ).min;
						
						player.Msg( TextColor.Sucess, Lang.StartExportObj[ player.Data.Language ] );

						::setXMLBase( txtname, player.World, player.Name, time() );

						SqForeach.Object.Active( this, function( Object )
						{
							if( Object.World == player.World )
							{
								::addXMLObjectItem( txtname, Object.ID, Object.Model, Object.Pos.x, Object.Pos.y, Object.Pos.z, Object.RotX, Object.RotY, Object.RotZ, Object.RotW );
							}
						});

						::setXMLEnd( txtname );

						player.Msg( TextColor.Sucess, Lang.StartExportObjComp[ player.Data.Language ], txtname );
					}
					else player.Msg( TextColor.Error, Lang.NoObjToExport[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );

		return true;
	}
}