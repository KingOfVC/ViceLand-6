SqCore.On().PlayerDestroyed.Connect(this, function ( player, reason, payload )
{
	SqSpawn.SavePlayerSpawn( player );

	if( player.Data.IsEditing.tolower().find( "Object" ) >= 0 ) SqObj.CancelEditing( player );
	if( player.Data.IsEditing.tolower().find( "Pickup" ) >= 0 ) SqPick.CancelEditing( player );

	/*if( player.Data.IsEvent )
	{
		if( player.Data.IsEvent.Event == "AD" )
		{

			if( SqMath.IsLess( SqAD.GetTeamPlayer( "red" ), 1 ) ) SqAD.EndRound( 3 );
			if( SqMath.IsLess( SqAD.GetTeamPlayer( "blue" ), 1 ) ) SqAD.EndRound( 2 );
		}
	}*/	
	
	if( player.Data.Logged )
	{
		if( player.Data.Settings.JoinPart == "true" )
		{
			switch( reason )
			{
				case SqPartReason.Timeout:
				SqCast.MsgAllExp( player, TextColor.Info, Lang.PlayerTimeredOut, player.Name, TextColor.Info );

				SqCast.EchoMessage( format( "**%s** has lost connect with the server.", player.Name ) );
				break;

				case SqPartReason.Kick:
				case SqPartReason.AntiCheat:
				SqCast.MsgAllExp( player, TextColor.Info, Lang.PlayerKickedOut, player.Name, TextColor.Info );

				SqCast.EchoMessage( format( "**%s** has been kicked from the server.", player.Name ) );
				break;

				case SqPartReason.Crash:
				SqCast.MsgAllExp( player, TextColor.Info, Lang.PlayerGameCrashed, player.Name, TextColor.Info );

				SqCast.EchoMessage( format( "**%s** game crashed.", player.Name ) );
				break;

				default:
				SqCast.MsgAllExp( player, TextColor.Info, Lang.PlayerPart, player.Name, TextColor.Info );

				SqCast.EchoMessage( format( "**%s** has left the server.", player.Name ) );
				break;
			}
		}
	}

	player.Data.Save();

	if( player.Data.LastHit.len() > 0 )
	{
		if( SqMath.IsLess( ( time() - player.Data.LastHit.Time ), 5 ) )
		{
			SendMessageToDiscord( format( "**%s** was hitted by **%s** less than 5 seconds ago.", player.Name, player.Data.LastHit.Player ), "report" );
			
			SqCast.MsgAdmin( TextColor.Staff, Lang.HitReport, player.Name, TextColor.Staff, player.Data.LastHit.Player, TextColor.Staff );
		}
	}

	player.World = 100;
	player.Data.InEvent = null;

	if( player.Data.Logged ) SqAdmin.Save( player.UID, player.UID2 );

	SqForeach.Player.Active( this, function( player ) 
	{
		player.StreamInt( 1031 );
		player.StreamString( player.ID.tostring() );
		player.FlushStream( true );
	});

	SqEvents.CheckWaterFightEvent( player );

	if( Server.PlayerTitle.rawin( player.ID ) ) Server.PlayerTitle.rawdelete( player.ID );

	Server.PlayerCount --;
//	EchoBot.SetActivity( Server.Name + " ["+ Server.PlayerCount + "/100]" );
});
