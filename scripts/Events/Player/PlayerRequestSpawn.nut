SqCore.On().PlayerRequestSpawn.Connect(this, function (player)
{	
	if( !player.Data.IsReg ) 
	{
		player.Msg( TextColor.Error, Lang.NoRegisterSpawn[ player.Data.Language ])
		SqCore.SetState( 0 );
		
		return;
	}
	
	if( !player.Data.Logged ) 
	{
		player.Msg( TextColor.Error, Lang.NoLoggedSpawn[ player.Data.Language ])
		SqCore.SetState( 0 );
		
		return;
	}
});

