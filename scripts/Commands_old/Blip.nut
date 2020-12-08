class CCmdBlip
{
	Cmd					= null;
	
	Add 				= null;
	Delete 				= null;
	Find 				= null;
	List 				= null;

	constructor( instance )
	{
		this.Cmd = instance;
		
		this.Cmd.BindFail( this, this.funcFailCommand );

		this.Add				= this.Cmd.Create( "addblip", "i|f|i|i|i", [ "Type", "Size", "R", "G", "B" ], 1, 5, -1, true, true );
		this.Delete				= this.Cmd.Create( "deleteblip", "i", [ "ID" ], 1, 1, -1, true, true );
		this.Find				= this.Cmd.Create( "findblip", "f", [ "Radius" ], 1, 1, -1, true, true );
		this.List				= this.Cmd.Create( "bliplist", "", [ "" ], 0, 0, -1, true, true );

		this.Add.BindExec( this.Add, this.AddBlip );
		this.Delete.BindExec( this.Delete, this.DeleteBlip );
		this.Find.BindExec( this.Find, this.FindBlip );
		this.List.BindExec( this.List, this.GetBlipList );
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
				case "addblip":
				return player.Msg( TextColor.Error, Lang.BlipAddSyntax[ player.Data.Language ] );

				case "deleteblip":
				return player.Msg( TextColor.Error, Lang.BlipDeleteSyntax[ player.Data.Language ] );

				case "findblip":
				return player.Msg( TextColor.Error, Lang.BlipFindSyntax[ player.Data.Language ] );
			}
		}
	}

	function AddBlip( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.mapping.tointeger() ) )
					{
						switch( args.Type )
						{
							case 0:
							if( args.rawin( "Size" ) && args.rawin( "R" ) && args.rawin( "G" ) && args.rawin( "B" ) )
							{
								local getColor = Color4( args.R, args.G, args.B, 255 );

								SqMarker.Create( 0, player.Pos, args.Size, player.World, getColor );

								player.Msg( TextColor.Sucess, Lang.BlipCreated[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.BlipCreateType0Syntax[ player.Data.Language ] );
							break;

							default:
							local getColor = Color4( 0, 0, 0, 0 );

							SqMarker.Create( args.Type, player.Pos, 5, player.World, getColor );
							break;
						}
					}
					else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function DeleteBlip( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.mapping.tointeger() ) )
					{
						if( SqMarker.rawin( args.ID ) )
						{
							if( SqMarker.Blips[ args.ID ].World == player.World )
							{
								SqMarker.Delete( args.ID );

								player.Msg( TextColor.Sucess, Lang.BlipDeleted[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.BlipIDXFind[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.BlipIDXFind[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function FindBlip( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.mapping.tointeger() ) )
					{
						local result = null;

						SqForeach.Blip.Active( this, function( blip )
						{
							if( blip.World == player.World )
							{
								if( blip.Pos.DistanceTo( player.Pos ) < args.Radius )
								{
									if( result ) result = result + HexColour.White + ", " + TextColor.Sucess + "Type " + HexColour.White + blip.Type + TextColor.Sucess + " ID " + HexColour.White + blip.ID; 
									else result = TextColor.Sucess + "Type " + HexColour.White + blip.Type + TextColor.Sucess + " ID " + HexColour.White + blip.ID; 
								}
							}
						});
						
						if( result ) player.Msg( TextColor.Sucess, Lang.BlipFind[ player.Data.Language ], result );
						else player.Msg( TextColor.Error, Lang.BlipIDXFind[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}

	function GetBlipList( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqWorld.GetPrivateWorld( player.World ) )
				{
					if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.mapping.tointeger() ) )
					{
						local result = null;
						foreach( index, value in SqMarker.Blips )
						{
							if( value.World == player.World )
							{
								if( result ) result = result + "$" + HexColour.Red + "Type " + HexColour.White + value.Type + HexColour.Red + " ID " + HexColour.White + index;
								else result = HexColour.Red + "Type " + HexColour.White + value.Type + HexColour.Red + " ID " + HexColour.White + index;
							}
						}
						
						if( result ) 
						{
							player.StreamInt( 105 );
							player.StreamString( "Blip list of " + player.World + "$" + player.World );
							player.FlushStream( true );
						
							player.StreamInt( 106 );
							player.StreamString( result );
							player.FlushStream( true );
						}
						else player.Msg( TextColor.Error, Lang.BlipIDXFind[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
}