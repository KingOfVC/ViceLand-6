class SqCast
{
	function Message(...)
	{
		vargv.insert(0, this);
		SqBroadcast.Message(format.acall(vargv));
	}

	function Msg(color, ...)
	{
		vargv.insert(0, this);
		SqBroadcast.Msg(color, ">> "+ format.acall(vargv));
	}

	function MsgG(color, ...)
	{
		vargv.insert(0, this);
		SqBroadcast.Msg(color, "*> "+ format.acall(vargv) +" <*");
	}
	
	function MsgWorld( style, world, element, ... )
	{		
		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data != null )
			{
				if( player.Data.rawin( "Language" ) )
				{
					local st = [];
					st.push( element[ player.Data.Language ] );
					foreach( a in vargv )
					{
						if( a != null ) st.push( a );
					}
					
					if( player.World == world && player.Data.Logged ) player.Msg1( style, st );
					
					st.clear();
				}
			}
		});
	}

	function MsgAll( type, element, ... )
	{		
		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data != null )
			{
				if( player.Data.rawin( "Language" ) )
				{
					local st = [];
					st.push( element[ player.Data.Language ] );
					foreach( a in vargv )
					{
						if( a != null ) st.push( a );
					}
					
					if( player.Data.Logged ) player.Msg1( type, st );
				}
			}
		});
	}

	function MsgAllWithoutStyle( element, ... )
	{		
		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data != null )
			{
				if( player.Data.rawin( "Language" ) )
				{
					local st = [];
					st.push( element[ player.Data.Language ] );
					foreach( a in vargv )
					{
						if( a != null ) st.push( a );
					}
					
					if( player.Data.Logged ) player.Msg2( st );
				}
			}
		});
	}

	function MsgAllExp( plr, type, element, ... )
	{	
		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data != null )
			{
				if( player.Data.rawin( "Language" ) )
				{
					local st = [];
					st.push( element[ player.Data.Language ] );
					foreach( a in vargv )
					{
						if( a != null ) st.push( a );
					}
					
					if( plr.ID != player.ID && player.Data.Logged ) player.Msg1( type, st );
				}
			}
		});
	}
	
	function MsgKillDeath( type, element, ... )
	{		
		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data != null )
			{
				if( player.Data.rawin( "Language" ) )
				{
					local st = [];
					st.push( element[ player.Data.Language ] );
					foreach( a in vargv )
					{
						if( a != null ) st.push( a );
					}
					
					if( player.Data.Player.CustomiseMsg.Type.Kill == "true" && player.Data.Logged ) player.Msg1( type, st );
				}
			}
		});
	}

	function MsgAdmin( type, element, ... )
	{		
		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data != null )
			{
				if( player.Data.rawin( "Language" ) )
				{
					local st = [];
					st.push( element[ player.Data.Language ] );
					foreach( a in vargv )
					{
						if( a != null ) st.push( a );
					}
					
					if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 && player.Data.Logged ) player.Msg1( type, st );
				}
			}
		});
	}

	function MsgMapper( type, element, ... )
	{		
		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data != null )
			{
				if( player.Data.rawin( "Language" ) )
				{
					local st = [];
					st.push( element[ player.Data.Language ] );
					foreach( a in vargv )
					{
						if( a != null ) st.push( a );
					}
					
					if( player.Data.Player.Permission.Mapper.Position.tointeger() > 0 && player.Data.Logged ) player.Msg1( type, st );
				}
			}
		});
	}

	function MsgManager( type, element, ... )
	{		
		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data != null )
			{
				if( player.Data.rawin( "Language" ) )
				{
					local st = [];
					st.push( element[ player.Data.Language ] );
					foreach( a in vargv )
					{
						if( a != null ) st.push( a );
					}
					
					if( player.Data.Player.Permission.Staff.Position.tointeger() > 3 && player.Data.Logged ) player.Msg1( type, st );
				}
			}
		});
	}

	function MsgGang( id, type, element, ... )
	{		
		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data != null )
			{
				if( player.Data.rawin( "Language" ) )
				{
					local st = [];
					st.push( element[ player.Data.Language ] );
					foreach( a in vargv )
					{
						if( a != null ) st.push( a );
					}
					
					if( player.Data.ActiveGang == id && player.Data.Logged ) player.Msg1( type, st );
				}
			}
		});
	}

	function MsgVIP( type, element, ... )
	{		
		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data != null )
			{
				if( player.Data.rawin( "Language" ) )
				{
					local st = [];
					st.push( element[ player.Data.Language ] );
					foreach( a in vargv )
					{
						if( a != null ) st.push( a );
					}
					
					if( player.Data.Player.Permission.VIP.Position.tointeger() > 0 && player.Data.Logged ) player.Msg1( type, st );
				}
			}
		});
	}

	function MsgStaff( type, element, ... )
	{		
		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data != null )
			{
				if( player.Data.rawin( "Language" ) )
				{
					local st = [];
					st.push( element[ player.Data.Language ] );
					foreach( a in vargv )
					{
						if( a != null ) st.push( a );
					}
					
					if( player.Data.Player.Permission.Staff.Position.tointeger() > 0 || player.Data.Player.Permission.Mapper.Position.tointeger() > 0 && player.Data.Logged )player.Msg1( type, st );
				}
			}
		});
	}

/*	function EchoMessage( text )
	{		
		text = StripCol( EscapeString2( text ) );

		SqDiscord2.ToDiscord3( 1, text );
	}
*/
	/*function EchoMessage( text )
	{		
		if( Server.EnableEcho )
		{
			text = StripCol( EscapeString2( text ) );

			local urlType, urlName;
			
			switch( Server.DiscordEchoCount )
			{
				case 0:
				urlType = "discordapp.com/api/webhooks/565026007426269194/9EdmVeE7VLOVedGsFF9kseOO7xcZpqZNC8XH_16nhGQpNIp8GiQZIKwr2zBRLxgVcafX"
				urlName = "Echo";

				Server.DiscordEchoCount ++;
				break;

				case 1:
				urlType = "discordapp.com/api/webhooks/565026135335895051/Q0WN9iO7K6u58jwZOSJBgjJCjKUT-ND51jgN2EGesPR1htd_7X1_RX1_UcTZX8SDQO8x"
				urlName = "Echo";

				Server.DiscordEchoCount ++;
				break;

				case 2:
				urlType = "discordapp.com/api/webhooks/565026243838214150/7a7vgQAGH4fX3FP6qqeP875rTca3iLzEWkHBNqEyoC4oOD-xU6deTE8t2CNsxTvQRXkR"
				urlName = "Echo";

				Server.DiscordEchoCount ++;
				break;

				case 3:
				urlType = "discordapp.com/api/webhooks/565026442480582656/mqTunAwGlgWOYL4GNd24apJ57WmZP3VnuFn3IOIjnckYWALPz4-j1ERf4LfA2Bzod2Te"
				urlName = "Echo";

				Server.DiscordEchoCount ++;
				break;

				case 4:
				urlType = "discordapp.com/api/webhooks/565026697897050112/NdFMJ1h1D6OZHFwtoX21VGg25GkLMuoaKhTQK6JsLZtHw5nWIbR7Nlp9_xPauHlnfH88"
				urlName = "Echo";

				Server.DiscordEchoCount ++;
				break;

				case 5:
				urlType = "discordapp.com/api/webhooks/565026697897050112/NdFMJ1h1D6OZHFwtoX21VGg25GkLMuoaKhTQK6JsLZtHw5nWIbR7Nlp9_xPauHlnfH88"
				urlName = "Echo";

				Server.DiscordEchoCount ++;
				break;

				case 6:
				urlType = "discordapp.com/api/webhooks/565026817103364097/TV-1hJ616Fv3LqT_y8V8gesdveJoO8cNuv8Rt9l_vJktdtzZcagfufUvv-8xzrlYSxSn"
				urlName = "Echo";

				Server.DiscordEchoCount ++;
				break;

				case 7:
				urlType = "discordapp.com/api/webhooks/565026909079994370/cotvN2KwNW8bUCZpYNN5d5HCzA4brBnsHu-2zbfz9A5WP_DBI0aZcXRIkxDzgtq4X1pq"
				urlName = "Echo";

				Server.DiscordEchoCount ++;
				break;

				case 8:
				urlType = "discordapp.com/api/webhooks/565027057617338388/WvEoZXMGT8gW5jamkZSijTQojbx1T0NkcSow7nUAOmCQ_2EZIad1Lc8YHsFOEHTBfwSv"
				urlName = "Echo";

				Server.DiscordEchoCount ++;
				break;

				case 9:
				urlType = "discordapp.com/api/webhooks/565027230636310652/Ff8mqfgNYlk01acPA4DDD0o0cG9rIFbQtjWbXxmEfeq6bYn6Yl_u2OiZx3GeHCK9VUOG"
				urlName = "Echo";

				Server.DiscordEchoCount = 0;
				break;
			}
			return system("curl -H \"Accept: application/json\" -H \"Content-type: application/json\" -X POST -d '{\"content\":\"" + text + "\", \"username\":\"" + urlName + "\"}' https://" + urlType );
		}
	}	*/

	function EchoMessage( ... )
	{
		vargv.insert( 0, this );

        local text = format.acall( vargv )

		SqDiscord2.ToDiscord3( 1, text );
	}

	function setTitle( player, text )
	{
		if( !Server.PlayerTitle.rawin( player.ID ) )
		{
			Server.PlayerTitle.rawset( player.ID, 
			{
				Text = text,
			});
			
		}
		else Server.PlayerTitle[ player.ID ].Text = text;

		SqForeach.Player.Active( this, function( plr ) 
		{
			if( plr.ID != player.ID )
			{
				plr.StreamInt( 1030 );
				plr.StreamString( player.ID + ";" + text );
				plr.FlushStream( true );
			}
		});
	}

	function SendNewsToPlayer( player )
	{
		player.StreamInt( 1060 );
		player.StreamString( "x" );
		player.FlushStream( true );

		foreach( index in ::split( Server.Updatelog, "\n" ) )
		{
			player.StreamInt( 1062 );
			player.StreamString( index );
			player.FlushStream( true );
		}
	}

	function sendAnnounceToPlayer( player, text )
	{
		player.StreamInt( 1070 );
		player.StreamString( text );
		player.FlushStream( true );
	}

	function sendAnnounceToAll( text )
	{
		SqForeach.Player.Active( this, function( plr ) 
		{
			plr.StreamInt( 1070 );
			plr.StreamString( text );
			plr.FlushStream( true );
		});
	}

	function sendAnnounceToWorld( world, text )
	{
		SqForeach.Player.Active( this, function( plr ) 
		{
			if( plr.World == world )
			{
				plr.StreamInt( 1070 );
				plr.StreamString( text );
				plr.FlushStream( true );
			}
		});
	}

	function senClientDataToPlayer( id, text )
	{
		SqForeach.Player.Active( this, function( player ) 
		{
			if(  player.Data.Logged )
			{
				player.StreamInt( id );
				player.StreamString( text );
				player.FlushStream( true );
			}
		});
	}
}

SqPlayer.newmember("Msg", function ( type, ... )
{
	vargv.insert(0, this);
	
	switch( this.Data.Player.TextStyle )
	{
		case 0:
		this.Message( type + "** " + format.acall(vargv) );
		break;
		
		case 1:
		this.Message( type  + "** pm >> " + format.acall(vargv) );
		break;
		
		case 2:
		this.Message( type + type + ": [#ffffff]" + format.acall(vargv) );
		break;
	}
});

SqPlayer.newmember("Msg1", function ( type, array )
{
	array.insert(0, this);
	
	switch( this.Data.Player.TextStyle )
	{
		case 0:
		this.Message( type + "* " + format.acall(array) );
		break;
		
		case 1:
		this.Message( type  + "*> " + format.acall(array) + type + " <*" );
		break;
		
		case 2:
		this.Message( type + ": [#ffffff]" + format.acall(array) );
		break;
	}
});

SqPlayer.newmember("Msg2", function ( array )
{
	array.insert(0, this);
	
	this.Message( format.acall(array) );
});

SqPlayer.newmember("Msg3", function ( ... )
{
	vargv.insert(0, this);
	
	this.Message( format.acall(vargv) );
});

function RGBToHex(color)
{
	return format("[#%06x]", color.RGB);
}

function GetColorFromStyle( element, style )
{
	switch( style )
	{
		case "Error":
		return element.Color.Error;
		
		case "World":
		return element.Color.World;
		break;
	
		case "Sucess":
		return element.Color.Sucess;
		break;
	
		case "Information":
		return element.Color.Info;
	
		case "Event":
		return element.Color.Event;
	
		case "Admin":
		return element.Color.Admin;
	
		case "Announcement":
		return element.Color.Ann;
	
		case "Staff":
		return element.Color.Staff;
	}
}

function GetItemColor( item )
{
	switch( item )
	{
		case "NameTag":
		return "[#b2e1e6]Weapon Name Tag";

		case "VehTag":
		return "[#b2e1e6]Vehicle Name Tag";

		case "Nuke":
		return "[#ff1a1a]Nuke Pass";
		
		case "ArmCase":
		return "[#b2e1e6]Armour Case";

		case "6435":
		return "[#aa00ff]Palm tree with light";

		case "vippass":
		return "[#b2e1e6]VIP Pass";

		case "adminpass":
		return "[#ff1a1a]Admin Pass";

		case "hiddenpass":
		return "[#aa00ff]Hidden Pass";

		case "leveluppass":
		return "[#aa00ff]Level Up Pass";

		case "santahat":
		return "[#aa00ff]Santa Hat";	

		case "crate":
		return "[#b2e1e6]Crate";

		case "worldpass":
		return "[#aa00ff]World Pass";

		case "gangpass":
		return "[#b2e1e6]Gang Creation Pass";

	}

}

/*function AutoMessage()
{
	SqForeach.Player.Active( this, function( player ) 
	{
		if( player.Data.Player.CustomiseMsg.Type.HelpMsg == "true" && player.Data.Logged ) player.Msg( HexColour.Cyan, Lang.HelpMessages[ rand() % Lang.HelpMessages.len() ] );
	});
}*/

function EndReactionTest()
{
	SqForeach.Player.Active( this, function( player ) 
	{
		if( player.Data.Player.CustomiseMsg.Type.Event == "true" && player.Data.Logged ) player.Msg( TextColor.Event, Lang.ReactionTestEnd[ player.Data.Language ] );
	});

	Server.AutoMessage.RTText = null;
}

function CheckReactionTest( player, text )
{
	if( Server.AutoMessage.RTText == text )
	{
		player.Data.Stats.Cash += Server.AutoMessage.RTPrice;

		Server.AutoMessage.RTText = null;

		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data.Player.CustomiseMsg.Type.Event == "true" && player.Data.Logged ) player.Msg( TextColor.Event, Lang.ReactionTestWin[ player.Data.Language ], player.Name, TextColor.Event, SqInteger.SecondToTime( time() - Server.AutoMessage.RTTime ) );
		});

		SqFindRoutineByTag( "EndRT" ).Terminate();
	}
}

function ReactionTestTest()
{
			Server.AutoMessage.RTText = RandString( rand()%56 ) + RandString( rand()%56 ) + RandString( rand()%56 ) + RandString( rand()%56 ) + RandString( rand()%56 ) + RandString( rand()%56 ) + RandString( rand()%56 ) + RandString( rand()%56 );
		Server.AutoMessage.RTPrice = ( rand() % 50000 );
		Server.AutoMessage.RTTime = time();

		SqForeach.Player.Active( this, function( player ) 
		{
			if( player.Data.Player.CustomiseMsg.Type.Event == "true" && player.Data.Logged ) player.Msg( TextColor.Event, Lang.ReactionTestStart[ player.Data.Language ], Server.AutoMessage.RTText, TextColor.Event, SqInteger.ToThousands( Server.AutoMessage.RTPrice ) );
		});

		SqRoutine( this, EndReactionTest, 200000, 1 ).SetTag( "EndRT" );
		
		Server.AutoMessage.State = 0;
}

function SendMessageToDiscord( text, type = true )
{
	//StaffBot.SendMessage( text );
}

Colour <- {
	Red 	= 	Color3(244,67,54),
	LPink	=	Color3(238,130,239),
	Pink 	= 	Color3(255,128,171),
	DPink 	= 	Color3(233,30,99),
	Purple 	= 	Color3(170,0,255),
	DPurple = 	Color3(124,77,255),
	Indigo 	= 	Color3(140,158,255),
	SBlue	= 	Color3(147,201,244),
	IBlue	= 	Color3(75,170,255),
	Blue 	= 	Color3(33,150,243),
	LBlue 	= 	Color3(3,169,244),
	Cyan 	= 	Color3(0,229,255),
	Aqua 	= 	Color3(0,188,212),
	GBlue	= 	Color3(131,186,179),
	Teal 	= 	Color3(0,191,165),
	DTeal	=	Color3(0,137,123),
	Green 	= 	Color3(76,175,80),
	LGreen 	= 	Color3(139,195,74),
	PGreen	=	Color3(0,200,83),
	Lime 	= 	Color3(205,220,57),
	Cream	= 	Color3(255,209,128),
	Yellow	=	Color3(255,214,0),
	LYellow = 	Color3(255,235,59),
	Amber 	= 	Color3(255,193,7),
	LOrange = 	Color3(255,152,0),
	Orange  =   Color3(245,124,0),
	DOrange = 	Color3(255,87,34),
	Brown 	=	Color3(182,96,11),
	LGrey 	= 	Color3(220,220,220),
	Grey 	= 	Color3(180,180,180),
	DGrey	= 	Color3(140,140,140),
	BGrey 	= 	Color3(144,164,174),
	White 	= 	Color3(255,255,255),
	Black	= 	Color3(0,0,0)
}

HexColour <- {
	Red 	= 	"[#f44336]",
	LPink	=	"[#ee82ef]",
	Pink 	= 	"[#ff80ab]",
	DPink 	= 	"[#e91e63]",
	Purple 	= 	"[#aa00ff]",
	DPurple = 	"[#7c4dff]",
	Indigo 	= 	"[#8c9eff]",
	SBlue	= 	"[#93c9f4]",
	IBlue	= 	"[#4baaff]",
	Blue 	= 	"[#2196f3]",
	LBlue 	= 	"[#03a9f4]",
	Cyan 	= 	"[#00e5ff]",
	Aqua 	= 	"[#00bcd4]",
	GBlue	= 	"[#83bab3]",
	Teal 	= 	"[#00bfa5]",
	DTeal	=	"[#00897b]",
	Green 	= 	"[#4caf50]",
	LGreen 	= 	"[#8bc34a]",
	PGreen	=	"[#00c853]",
	Lime 	= 	"[#cddc39]",
	Cream	= 	"[#ffd180]",
	Yellow	=	"[#ffd600]",
	LYellow = 	"[#ffeb3b]",
	Amber 	= 	"[#ffc107]",
	LOrange = 	"[#ff9800]",
	Orange  =   "[#f57c00]",
	DOrange = 	"[#ff5722]",
	Brown 	=	"[#b6600b]",
	LGrey 	= 	"[#dcdcdc]",
	Grey 	= 	"[#b4b4b4]",
	DGrey	= 	"[#8c8c8c]",
	BGrey 	= 	"[#90a4ae]",
	White 	= 	"[#ffffff]",
	Black	= 	"[#000000]"
}

IrcColour <- {
	Red      	= 	"4",
	Orange   	= 	"7",
	Yellow   	= 	"8",
	LGreen   	= 	"9",
	Green   	= 	"3",
	Brown    	= 	"5",
	Pink     	= 	"13",
	Purple   	= 	"6",
	Cyan    	= 	"11",
	Aqua     	= 	"10",
	LBlue    	= 	"12",
	Blue 		= 	"2",
	LGrey   	= 	"15",
	Grey    	= 	"14",
	White    	= 	"0",
	Black    	= 	"1",
	End         = 	"",
	Bold     	= 	"",
	Italic		= 	"",
	Reset		= 	"",
	Underline	= 	"",
}

TextColor <-
{
	Error 	= "[#F44336]",
	Event	= "[#F57C00]",
	Staff	= "[#FFD180]",
	Sucess	= "[#4CAF50]",
	Info	= "[#FFD600]",
	World	= "[#FF80AB]",
	Admin	= "[#CDDC39]",
	Ann		= "[#00E5FF]",
	Kill	= "[#E91E63]",
	InfoS	= "[#ffff00]",
	Comp 	= "[#f57c00]",
	Admin 	= "[#ffc107]",
	Staff 	= "[#03a9f4]",
	Gang 	= "[#8c9eff]",
}