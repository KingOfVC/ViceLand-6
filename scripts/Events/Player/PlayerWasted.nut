SqCore.On().PlayerWasted.Connect( this, function( player, reason ) 
{
	SqSpawn.SavePlayerSpawn( player );
	
	SqDM.CheckSpreeSelf( player );
	
	if( reason == 70 ) 
	{
		SqCast.MsgKillDeath( TextColor.Kill, Lang.DeathMessageSuicide, player.Name, TextColor.Kill );
		
		SqCast.EchoMessage( format( "**%s** has commited suicide.", player.Name ) );
	}
	else 
	{
		SqCast.MsgKillDeath( TextColor.Kill, Lang.DeathMessage, player.Name, TextColor.Kill );
		
		SqCast.EchoMessage( format( "**%s** has died.", player.Name ) );
	}
	
	SqCast.senClientDataToPlayer( 3010, player.Name + ";" + reason + ";" + player.Color.r + ";" + player.Color.g + ";" + player.Color.b );

	if( player.Data.IsEditing.tolower().find( "Object" ) >= 0 ) SqObj.CancelEditing( player );
	if( player.Data.IsEditing.tolower().find( "Pickup" ) >= 0 ) SqPick.CancelEditing( player );
	
	if( player.Data.Job.rawin( "Pizza" ) )
	{
		player.Data.Job[ "Pizza" ].Stock = 0;
		
		player.Msg( TextColor.Error, Lang.LosePizza[ player.Data.Language ] );
		
		SqJob.RemoveAllPizzaPickup( player );
	}

	SqEvents.CheckWaterFightEvent( player );
/*	if( player.Data.IsEvent )
	{
		if( player.Data.IsEvent.Event == "AD" )
		{

			if( SqMath.IsLess( SqAD.GetTeamPlayer( "red" ), 1 ) ) SqAD.EndRound( 3 );
			if( SqMath.IsLess( SqAD.GetTeamPlayer( "blue" ), 1 ) ) SqAD.EndRound( 2 );
		}
	}*/
});
