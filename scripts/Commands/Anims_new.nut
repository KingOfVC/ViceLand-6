class CCmdAnim
{	
	function DoAnim( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Name": stripCmd[1] };
			
			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( SqAnim.Anims.rawin( args.Name.tolower() ) )
					{
						if( SqMath.IsGreaterEqual( ( time() - player.Data.Cooldown ), 10 ) )
						{
							local getAnim = SqAnim.Anims[ args.Name.tolower() ].Anim, stripValue = split( getAnim, "," );

							player.SetAnimation( stripValue[1].tointeger(), stripValue[0].tointeger() );
						}
						else player.Msg( TextColor.Error, Lang.HPCooldownCantUseCmd[ player.Data.Language ] );					
					}
					else player.Msg( TextColor.Error, Lang.AnimDoesNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.DoAnimSyntax[ player.Data.Language ] );
		return true;
	}

	function AddAnim( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 4 )
		{
			args = { "Name": stripCmd[1],  "Anim": stripCmd[2], "Group": stripCmd[3] };
			
			if( SqInteger.IsNum( args.Anim ) && SqInteger.IsNum( args.Group ) )
			{
				if( player.Data.IsReg )
				{
					if( player.Data.Logged )
					{
						if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 || player.Data.Player.Permission.VIP.Position.tointeger() )
						{
							if( !SqAnim.Anims.rawin( args.Name.tolower() ) )
							{
								local getAnim = args.Anim + ", " + args.Group;

								SqAnim.Add( args.Name, getAnim, player.Data.AccID );

								if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 ) SqCast.MsgAllExp( player, TextColor.Info, Lang.AddAnimAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Info, args.Name );
								else SqCast.MsgAllExp( player, TextColor.Info, Lang.AddAnimAll, player.Data.Player.Permission.VIP.Name, player.Name, TextColor.Info, args.Name );

								player.Msg( TextColor.InfoS, Lang.AddAnimSelf[ player.Data.Language ], args.Name );
							}
							else player.Msg( TextColor.Error, Lang.AnimExist[ player.Data.Language ] );
						}
                   		else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   		
					}
					else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.AddAnimSyntax[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.AddAnimSyntax[ player.Data.Language ] );
		return true;
	}

	function DeleteAnim( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Name": stripCmd[1] };
			
			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 )
					{
						if( SqAnim.Anims.rawin( args.Name.tolower() ) )
						{
							SqAnim.Delete( args.Name );

                            SqCast.MsgAdmin( TextColor.Staff, Lang.StaffDeleteAnim, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, args.Name );
						}
						else player.Msg( TextColor.Error, Lang.AnimDoesNotExist[ player.Data.Language ] );
					}
                   	else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   		
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.DelAnimSyntax[ player.Data.Language ] );
		return true;
	}

	function AnimList( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				local result = null;

				player.StreamInt( 105 );
				player.StreamString( "Anim list$" + player.World );
				player.FlushStream( true );

				foreach( index, value in SqAnim.Anims )
				{
					player.StreamInt( 107 );
					player.StreamString( HexColour.Red + "Name " + HexColour.White + index + HexColour.Red + " Added by " + HexColour.White + SqAccount.GetNameFromID( value.Creator ) );
					player.FlushStream( true );
				}
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		return true;
	}
}