class CRound
{
	Time          = 0;
	MaxRoundTime  = 420;
	RoundProgress = -1;
	
	PM            = null;
	
	function constructor()
	{
		this.RoundProgress = 0;
	
	}

	function StartRound()
	{
		SqCast.Msg( Color.Cyan, "Round started" );
		
		this.Time = time();
		this.RoundProgress = 2;
	
	
		SqForeach.Player.Active(this, function(player)
		{
			switch( player.Data.Role )
			{
				case "PM": 
				player.Pos = Server.SpawnPoint.PM;
				player.Armour = 100;
				break;
				
				case "terror": player.Pos = Server.SpawnPoint.Terrorist; break;
				case "psy": player.Pos = Server.SpawnPoint.Psycho; break;
				case "bodyguard": player.Pos = Server.SpawnPoint.Bodyguard; break;
			}
			player.Health = 100;
		});
	}
	
	function RunRound()
	{
		/* update round time to client */
			
		if( ( time() - this.Time ) > this.MaxRoundTime ) this.EndRound( 1 );
	}

	function EndRound( reason )
	{
		switch( reason )
		{
			case 1:
			SqCast.Msg( Colour.Cyan, "Prime Minister survived!" );
			break;
			
			case 2:
			SqCast.Msg( Colour.Cyan, "Prime Minister has died!" );
			break;
		}
		
		this.RoundProgress = 0;
		if( PM != null ) 
		{
			SqForeach.Player.Active(this, function(player)
			{
				player.Spectate = PM;
			});		
		}
	}
	
	function PrepareRound()
	{
		if( ( this.Time - time() ) > 60 ) this.StartRound();
	}
	
	function PreRound()
	{
		this.Time = 0;
		this.RoundProgress = 1;
	
		SqCast.Msg( Colour.Cyan, "Round will start in 1 minute." );
	}
	
	function ProcessRound()
	{
		switch( this.RoundProgress )
		{
			case 1: this.PrepareRound(); break;
			case 2: this.RunRound(); break;
			case 0: this.PreRound(); break;
		}
	}


}

Round <- CRound();