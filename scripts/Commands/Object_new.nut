class CCmdObject
{	
	function funcAddObj( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Model": stripCmd[1] };

			if( SqInteger.IsNum( args.Model ) )
			{
				if( player.Data.IsReg )
				{
					if( player.Data.Logged )
					{
						if( SqAdmin.IsAllowMapping( player ) )
						{
							if( player.Data.IsEditing == "" )
							{
								if( SqObj.IsPremium( player, args.Model ) )
								{
									try 
									{
										local

										getPos = " " + ( player.PosX + 2 ) + " ," + ( player.PosY + 2 ) + ", " + ( player.PosZ + 1 ),
										object = SqObj.Create( player.Data.AccID, args.Model.tointeger(), Vector3.FromStr( getPos ), player.World );
											
										object.ShotReport  	= true;
										object.Alpha 		= 150;

										SqObj.Objects[ object.Tag ].IsEditing = true;
											
										player.Data.IsEditing = object.Tag;

										player.Msg( TextColor.Sucess, Lang.ObjAdded[ player.Data.Language ], object.ID );

										if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is adding object. **Model** %d **World** %d", player.Name, object.Model, player.World ), "mapping" );
									}
									catch( e ) player.Msg( TextColor.Error, Lang.ObjectCreateError[ player.Data.Language ], e );
								}
								else player.Msg( TextColor.Error, Lang.NoItem[ player.Data.Language ], ::GetItemColor( args.Model ) );								
							}
							else player.Msg( TextColor.Error, Lang.ObjCurrentEditing[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.ObjAddSyntax[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.ObjAddSyntax[ player.Data.Language ] );

		return true;
	}
	
	function funcEditObj( player, command )
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
						if( SqAdmin.IsAllowMapping( player ) )
						{
							if( player.Data.IsEditing == "" )
							{
								if( SqInteger.GetObjectMaxID( args.ID.tointeger() ) )
								{
									if( SqFind.Object.WithID( args.ID.tointeger() ).tostring() != "-1" )
									{
										local object = SqFind.Object.WithID( args.ID.tointeger() );
										if( object.World == player.World )
										{
											if( SqObj.Objects.rawin( object.Tag ) )
											{
												if( !SqObj.Objects[ object.Tag ].IsEditing )
												{
													player.Data.IsEditing = object.Tag;

													SqObj.Objects[ object.Tag ].IsEditing = true;

													player.Msg( TextColor.Sucess, Lang.ObjEditing[ player.Data.Language ] );

													object.Alpha = 150;

													if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is editing object. **Model** %d **World** %d", player.Name, object.Model, player.World ), "mapping" );
												}
												else player.Msg( TextColor.Error, Lang.ObjSomeoneEdit[ player.Data.Language ] );
											}
											else player.Msg( TextColor.Error, Lang.ObjIDNotFound[ player.Data.Language ] );
										}
										else player.Msg( TextColor.Error, Lang.ObjIDNotFound[ player.Data.Language ] );
									}
									else player.Msg( TextColor.Error, Lang.ObjIDNotFound[ player.Data.Language ] );
								}
								else player.Msg( TextColor.Error, Lang.ObjIDNotFound[ player.Data.Language ] );
							}
							else player.Msg( TextColor.Error, Lang.ObjCurrentEditing[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.ObjEditSyntax[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.ObjEditSyntax[ player.Data.Language ] );

		return true;
	}
	
	function funcFindObj( player, command )
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
						if( SqAdmin.IsAllowMapping( player ) )
						{
							local result = null;
							SqForeach.Object.Active( this, function( Object )
							{
								if( Object.World == player.World )
								{
									if( Object.Pos.DistanceTo( player.Pos ) < args.Radius.tofloat() )
									{
										if( result ) result = result + HexColour.White + ", " + TextColor.Sucess + "Model " + HexColour.White + Object.Model + TextColor.Sucess + " ID " + HexColour.White + Object.ID; 
										else result = TextColor.Sucess + "Model " + HexColour.White + Object.Model + TextColor.Sucess + " ID " + HexColour.White + Object.ID; 
									}
								}
							});
								
							if( result ) player.Msg( TextColor.Sucess, Lang.ObjFind[ player.Data.Language ], result );
							else player.Msg( TextColor.Error, Lang.ObjNotFound[ player.Data.Language ] );
						}
						else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
					}
					else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.ObjFindSyntax[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.ObjFindSyntax[ player.Data.Language ] );

		return true;
	}
	
	function funcObjList( player, args )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqAdmin.IsAllowMapping( player ) )
				{
					local result = null;
					foreach( index, value in SqObj.Objects )
					{
						if( value.World == player.World )
						{
							if( value.instance.tostring() != "-1" )
							{
								if( result ) result = result + "$" + HexColour.Red + "Model " + HexColour.White + value.instance.Model + HexColour.Red + " ID " + HexColour.White + value.instance.ID + HexColour.Red + " Last edited " + HexColour.White + SqAccount.GetNameFromID( value.LastEdited ); 
								else result = HexColour.Red + "Model " + HexColour.White + value.instance.Model + HexColour.Red + " ID " + HexColour.White + value.instance.ID + HexColour.Red + " Last edited " + HexColour.White + SqAccount.GetNameFromID( value.LastEdited );
							}
						}
					}
						
					if( result ) 
					{
						player.StreamInt( 105 );
						player.StreamString( "Object list of " + player.World + "$" + player.World );
						player.FlushStream( true );
						
						player.StreamInt( 106 );
						player.StreamString( result );
						player.FlushStream( true );
					}
					else player.Msg( TextColor.Error, Lang.ObjNotFound[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.WorldNoPermission[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		
		return true;
	}
}