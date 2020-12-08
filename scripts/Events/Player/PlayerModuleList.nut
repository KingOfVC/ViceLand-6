SqCore.On().PlayerModuleList.Connect( this, function( player, list )
{
	SqCast.MsgManager( TextColor.Staff, Lang.GetPlayerModule, player.Name, TextColor.Staff, list );
});
