class CCmdSound
{	
	function DoSound( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 2 )
		{
			args = { "Name": stripCmd[1] };
			
			if( player.Data.IsReg )
			{
				if( player.Data.Logged )
				{
					if( SqSound.Sounds.rawin( args.Name.tolower() ) )
					{
						local getSound = SqSound.Sounds[ args.Name.tolower() ].ID;

						PlaySound( player.World, getSound.tointeger(), player.Pos );
					}
					else player.Msg( TextColor.Error, Lang.SoundDoesNotExist[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.DoSoundSyntax[ player.Data.Language ] );
		return true;
	}

	function AddSound( player, command )
	{
		local getCommand = command, stripCmd = split( getCommand, " " ), args = {};

		if( stripCmd.len() == 3 )
		{
			args = { "Name": stripCmd[1],  "Sound": stripCmd[2] };
			
			if( SqInteger.IsNum( args.Sound ) )
			{
				if( player.Data.IsReg )
				{
					if( player.Data.Logged )
					{
						if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 || player.Data.Player.Permission.VIP.Position.tointeger() )
						{
							if( !SqSound.Sounds.rawin( args.Name.tolower() ) )
							{
								SqSound.Add( args.Name, args.Sound.tointeger(), player.Data.AccID );

								if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 ) SqCast.MsgAllExp( player, TextColor.Info, Lang.AddSoundAll, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Info, args.Name );
								else SqCast.MsgAllExp( player, TextColor.Info, Lang.AddSoundAll, player.Data.Player.Permission.VIP.Name, player.Name, TextColor.Info, args.Name );

								player.Msg( TextColor.InfoS, Lang.AddSoundSelf[ player.Data.Language ], args.Name );

								player.PlaySound( args.Sound.tointeger() );
							}
							else player.Msg( TextColor.Error, Lang.SoundExist[ player.Data.Language ] );
						}
                   		else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   		
					}
					else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
				}
				else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.AddSoundSyntax[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.AddSoundSyntax[ player.Data.Language ] );
		return true;
	}

	function DeleteSound( player, command )
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
						if( SqSound.Sounds.rawin( args.Name.tolower() ) )
						{
							SqSound.Delete( args.Name );

                            SqCast.MsgAdmin( TextColor.Staff, Lang.StaffDeleteSound, player.Data.Player.Permission.Staff.Name, player.Name, TextColor.Staff, args.Name );
						}
						else player.Msg( TextColor.Error, Lang.SoundDoesNotExist[ player.Data.Language ] );
					}
                   	else player.Msg( TextColor.Error, Lang.NoPermissionUseCmd[ player.Data.Language ] );   		
				}
				else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
			}
			else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.DelSoundSyntax[ player.Data.Language ] );
		return true;
	}

	function SoundList( player, command )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				local result = null;

				player.StreamInt( 105 );
				player.StreamString( "Sound list$" + player.World );
				player.FlushStream( true );

				foreach( index, value in SqSound.Sounds )
				{
					player.StreamInt( 107 );
					player.StreamString( HexColour.Red + "Name " + HexColour.White + index + HexColour.Red + " Sound ID " + HexColour.White + value.ID + HexColour.Red + " Added by " + HexColour.White + SqAccount.GetNameFromID( value.Creator ) );
					player.FlushStream( true );
				}
						
			}
			else player.Msg( TextColor.Error, Lang.NotLogged[ player.Data.Language ] );
		}
		else player.Msg( TextColor.Error, Lang.NotRegistered[ player.Data.Language ] );
		return true;
	}
}