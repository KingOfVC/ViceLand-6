class CAttDef
{
	Bases 			= {};

	State			= 0;
	Time			= 0;

	CurrentBase 	= null;
	LastBase		= null;
	ReplyBase		= 1;

	MaxTime			= 600;

	AttDef			= "red";

	function constructor()
	{
	//	this.LoadBase();
	}

	function LoadBase()
	{
		local result = SqDatabase.Query( format( "SELECT * FROM ADBases" ) );

		while( result.Step() )
		{
			this.Bases.rawset( result.GetString( "ID" ),
			{
				Name		= result.GetString( "Name" ),
				Creator		= result.GetString( "Creator" ),
				AttSpawn	= Vector3.FromStr( result.GetString( "AttSpawn" ) ),
				DefSpawn	= Vector3.FromStr( result.GetString( "DefSpawn" ) ),
				CPSpawn		= Vector3.FromStr( result.GetString( "CPSpawn" ) ),
				Prop		= result.GetString( "Prop" ),
			});
		}
	}

	function CheckStatus()
	{
		switch( this.State )
		{
			case 0:
			this.PreRound();
			break;

			case 1:
			if( SqMath.IsGreaterEqual( ( time() - this.Time ), 30 ) ) this.PrepRound();
			break;

			case 2:
			if( SqMath.IsGreaterEqual( ( time() - this.Time ), 10 ) ) this.StartRound();
			break;

			case 3:
			if( SqMath.IsGreaterEqual( ( time() - this.Time ), this.MaxTime ) ) this.EndRound( 1 );
			break;
		}
	}

	function EndRound( reason )
	{
		switch( reason )
		{
			case 1:
			SqCast.MsgWorld( TextColor.Comp, 100, Lang.ADTimeEnd );
			SqCast.MsgWorld( TextColor.Comp, 100, Lang.ADDefWon, this.GetTeamColor( this.AttDef ), this.AttDef, TextColor.Comp );
			break;

			case 2:
			SqCast.MsgWorld( TextColor.Comp, 100, Lang.ADDefWon, this.GetTeamColor( "red" ), "red", TextColor.Comp );
			break;

			case 3:
			SqCast.MsgWorld( TextColor.Comp, 100, Lang.ADDefWon, this.GetTeamColor( "blue" ), "blue", TextColor.Comp );
			break;
		}

		this.State			= 0;
		this.Time			= 0;
		this.CurrentBase 	= null;
		this.MaxTime		= 600;
		this.ReplyBase		++;

		this.AttDef			= this.SwitchTeam();

		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data.InEvent )
			{
				if( player.Data.InEvent.Event == "AD" )
				{
					player.Data.InEvent.InRound = false;
					player.Pos					= Vector3( 0,0,0 );
				}
			}
		});

		SqFindRoutineByTag( "AttDef" ).Terminate();

		if( this.ReplyBase == 3 ) this.ReplyBase = 1;

		if( SqMath.IsGreaterEqual( this.GetTeamPlayer( "blue", false ), 1 ) && SqMath.IsGreaterEqual( this.GetTeamPlayer( "red", false ), 1 ) )
		{
			SqRoutine( this, this.CheckStatus, 1000, 0 ).SetTag( "AttDef" );
		}
	}

	function PreRound()
	{
		if( this.ReplyBase == 2 )
		{
			switch( ( time() - this.Time ) )
			{
				case 10:
				SqCast.MsgWorld( TextColor.Comp, 100, Lang.ADReply, 20 );
				break;

				case 20:
				SqCast.MsgWorld( TextColor.Comp, 100, Lang.ADReply, 10 );
				break;
			}
		}
	}

	function StartRound()
	{
		local getBase = this.Bases[ this.CurrentBase ];
		local checkpoint = SqCheckpoint.Create( 100, true, getBase.CPSpawn, this.GetTeamCheckpointColor( this.AttDef ), 5.0 );

		SqCast.MsgWorld( TextColor.Comp, 100, Lang.ADStartRound, getBase.Name );

		checkpoint.SetTag( "AttDef" );
		checkpoint.Data = CCheckpoint( "EAD3417EliKik" );

		this.State	 	= 3;
		this.Time 		= time();

		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data.InEvent )
			{
				if( player.Data.InEvent.Event == "AD" )
				{
					if( player.Data.InEvent.InRound && player.Data.InEvent.InRound.Team != this.AttDef ) player.Pos = getBase.AttSpawn;
					player.SetOption( SqPlayerOption.Controllable, true );

					this.GivePlayerWeapon( player );
				}
			}
		});
	}


	function PrepRound() 
	{
	    local getBase = this.Bases[ this.CurrentBase ];

		SqCast.MsgWorld( TextColor.Comp, 100, Lang.ADStartRound1, getBase.Name, TextColor.Comp, getBase.Creator, TextColor.Comp, this.GetTeamColor( this.AttDef ), this.AttDef );

		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data.InEvent )
			{
				if( player.Data.InEvent.Event == "AD" )
				{
					player.Msg( TextColor.InfoS, 100, Lang.ADPackSelection[ player.Data.Language ] );

					player.Pos 	= getBase.DefSpawn;
					player.SetOption( SqPlayerOption.Controllable, false );
				}
			}
		});

	    this.State	 	= 2;
		this.Time 		= time();
	}

	function GetTeamColor( team )
	{
		switch( team )
		{
			case "red":
			return HexColour.Red;

			case "blue":
			return HexColour.Blue;
		}
	}

	function SwitchTeam()
	{
		switch( this.AttDef )
		{
			case "red":
			return "blue";

			case "blue":
			return "red";
		}
	}

	function GetTeamCheckpointColor( team )
	{
		switch( team )
		{
			case "red":
			return Color4( 244, 67, 54, 255 );

			case "blue":
			return Color4( 33, 150, 243, 255 );
		}
	}

	function GivePlayerWeapon( player )
	{
		switch( player.Data.Invent.WepSet )
		{
			case 0:	
			player.SetWeapon( 21, 9999 );
			player.SetWeapon( 26, 9999 );
			player.SetWeapon( 0 , 0 );
			break;

			case 1:
			player.SetWeapon( 21, 9999 );
			player.SetWeapon( 27, 9999 );
			player.SetWeapon( 12, 15 );
			player.SetWeapon( 0 , 0 );
			break;

			case 2:
			player.SetWeapon( 20, 9999 );	
        	player.SetWeapon( 11, 1 );
			player.SetWeapon( 0 , 0 );    
			break;

			case 3:
			player.SetWeapon( 21, 9999 );
			player.SetWeapon( 29, 100 );
			player.SetWeapon( 0 , 0 );
			break;

			case 4:
			player.SetWeapon( 19, 9999 );
			player.SetWeapon( 32, 9999 );
			player.SetWeapon( 0 , 0 );
			break;

			case 5:
			player.SetWeapon( 21, 9999 );
			player.SetWeapon( 28, 70 );
			player.SetWeapon( 15, 15 );	
			player.SetWeapon( 0 , 0 );
			break;

			case 6:
			player.SetWeapon( 21, 9999 );
			player.SetWeapon( 30, 15 );
			player.SetWeapon( 0 , 0 );
			break;

			case 7:
	   	 	player.SetWeapon( 21, 9999 )
			player.SetWeapon( 13, 15 );
			player.SetWeapon( 0 , 0 );
   			 break;

			case 8:
	   		player.SetWeapon( 21, 9999 )
			player.SetWeapon( 31, 200 );
			player.SetWeapon( 0 , 0 );
    		break;
    	}
	}

	function GetTeamPlayer( team, isAlive = true )
	{
		local getCount = 0;

		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data.InEvent )
			{
				if( player.Data.InEvent.Event == "AD" )
				{
					if( player.Data.InEvent.Team == team && isAlive ) getCount++;
					else getCount++;
				}
			}
		});

		return getCount;
	}
}