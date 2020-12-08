SqCore.On().PlayerKeyRelease.Connect(this, function (player, key)
{
	switch( key.Tag )
	{
		case "Up":
		case "Down":
		case "Left":
		case "Right":
		case "Forward":
		case "Backward":
		try 
		{
		  player.FindTask( "Editing" ).Terminate();
		} 
		catch(_) _;			
		break;
	}
});	