SqCore.On().CheckpointExited.Connect( this, function( player, checkpoint ) 
{
	switch( checkpoint.Data.Type )
	{
		case "LobbyExit":
		player.StreamInt( 602 );
		player.StreamString( "" );
		player.FlushStream( true );
		break;

		case "Gagjik":
		player.StreamInt( 210 );
		player.StreamString( "" );
		player.FlushStream( true );
		break;

		case "GetTop":
		player.StreamInt( 503 );
		player.StreamString( "" );
		player.FlushStream( true );
		break;
	}
});