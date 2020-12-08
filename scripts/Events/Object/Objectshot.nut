SqCore.On().ObjectShot.Connect( this, function( player, object, weapon )
{
	if( player.Weapon == 109 )
	{
		if( player.Data.IsReg )
		{
			if( player.Data.Logged )
			{
				if( SqAdmin.IsAllowMapping( player ) )
				{
					if( player.Data.IsEditing == "" )
					{
						if( SqObj.Objects.rawin( object.Tag ) )
						{
							if( !SqObj.Objects[ object.Tag ].IsEditing )
							{
								player.Data.IsEditing = object.Tag;

								SqObj.Objects[ object.Tag ].IsEditing = true;

								player.Msg( TextColor.Sucess, Lang.ObjEditingWithModel[ player.Data.Language ], object.Model, TextColor.Sucess, object.ID );

								object.Alpha = 150;

								if( !SqWorld.GetPrivateWorld( player.World ) ) ::SendMessageToDiscord( format( "**%s** is editing object. **Model** %d **World** %d", player.Name, object.Model, player.World ), "mapping" );
							}
						}
					}
				}
				else 
				{
					player.Msg( TextColor.InfoS, Lang.ObjGetModel[ player.Data.Language ], object.Model );
				}
			}
		}
	}
});