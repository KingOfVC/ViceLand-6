class CCmdBlip
{
	function AddBlip( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( SqMath.IsGreaterEqual( stripCmd.len(), 2 ) )
		{
			args = { "Type": stripCmd[1], "Size": ( stripCmd.len() == 3 ) ?stripCmd[2] : "", "R": ( stripCmd.len() == 4 ) ?stripCmd[3] : "", "G": ( stripCmd.len() == 5 ) ?stripCmd[4] : "", "B": ( stripCmd.len() == 6 ) ?stripCmd[5] : "" };

			if( SqInteger.IsNum( args.Type ) )
			{
				if( player.Data.IsReg )
				{
					if( player.Data.Logged )
					{
						if( SqWorld.GetPrivateWorld( player.World ) )
						{
							if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.mapping.tointeger() ) )
							{
								try 
								{
									switch( args.Type )
									{
										case 0:
										if( args.rawin( "Size" ) && args.rawin( "R" ) && args.rawin( "G" ) && args.rawin( "B" ) )
										{
											if( SqInteger.IsFloat( args.Size ) )
											{
												if( SqInteger.IsNum( args.R ) && SqInteger.IsNum( args.G ) && SqInteger.IsNum( args.B ) )
												{
													local getColor = Color4( args.R.tointeger(), args.G.tointeger(), args.B.tointeger(), 255 );

													SqMarker.Create( 0, player.Pos, args.Size.tofloat(), player.World, getColor );

													player.Msg( TextColor.Sucess, Lang.BlipCreated[ player.Data.Language ] );
												}
												else player.Msg( TextColor.Error, Lang.BlipColorXNum[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.BlipSizeNotNum[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.BlipCreateType0Syntax[ player.Data.Language ] );
										break;

										default:
										local getColor = Color4( 0, 0, 0, 0 );

										SqMarker.Create( args.Type.tointeger(), player.Pos, 5, player.World, getColor );
										break;
									}
								}
								catch( e ) player.Msg( TextColor.Error, Lang.CreateMarkerError[ player.Data.Language ], e );
							}
							else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.WorldInvalidWorld[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.BlipAddSyntax[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.BlipAddSyntax[ player.Data.Language ] );
		return true;
	}

	function DeleteBlip( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "ID": stripCmd[1] };

			if( SqInteger.IsNum( args.ID ) )
			{
				if( player.Data.IsReg )
				{
					if( player.Data.Logged )
					{
						if( SqWorld.GetPrivateWorld( player.World ) )
						{
							if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.mapping.tointeger() ) )
							{
								if( SqMarker.rawin( args.ID.tointeger() ) )
								{
									if( SqMarker.Blips[ args.ID.tointeger() ].World == player.World )
									{
										SqMarker.Delete( args.ID.tointeger() );

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
			}
			else player.Msg( TextColor.Error, Lang.BlipDeleteSyntax[ player.Data.Language ] ); 
		}
		else player.Msg( TextColor.Error, Lang.BlipDeleteSyntax[ player.Data.Language ] );
		
		return true;
	}

	function FindBlip( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Radius": stripCmd[1] };

			if( SqInteger.IsFloat( args.Radius ) )
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
										if( blip.Pos.DistanceTo( player.Pos ) < args.Radius.tofloat() )
										{
											if( result ) result = result + HexColour.White + ", " + TextColor.Sucess + "Type " + HexColour.White + blip.SprID + TextColor.Sucess + " ID " + HexColour.White + blip.ID; 
											else result = TextColor.Sucess + "Type " + HexColour.White + blip.SprID + TextColor.Sucess + " ID " + HexColour.White + blip.ID; 
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
			}
			else player.Msg( TextColor.Error, Lang.BlipFindSyntax[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.BlipFindSyntax[ player.Data.Language ] );
		
		return true;
	}

	function GetBlipList( player, command )
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