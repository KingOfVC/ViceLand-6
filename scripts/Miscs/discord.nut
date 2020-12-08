class EchoDiscord extends SqDiscord.Session
{
	function constructor() 
	{
		base.constructor();
		
		base.Bind(SqDiscordEvent.Ready, this, onReady);
    	base.Bind(SqDiscordEvent.Message, this, onMessage);
	}
	
	function onReady() 
	{
	   this.SetActivity( Server.Name + " [0/100]" );	
	}
	
	function onLoaded() 
	{
		SqLog.Scs("Sucessfully connected to Discord. (Echo)");
	}
	
	function onMessage(channelID, author, authorNick, authorID, roles, message)
	{
		if( author != "Purple" && author != "MoMo" )
		{
		    if( channelID == Server.DiscordBot.EchoBot.Channel )
			{
				local
				cmds = ( message == "" ) ? "" : split( message.slice( 1 ), " " )[0],
	    		arr = split( message," " ).len() > 1 ? message.slice( message.find( " " ) + 1 ) : null;

				if ( message.slice( 0, 1 ) == "!" )
				{
					if ( arr == null ) ::onDiscordCommand( author, authorNick, cmds, null );
					else ::onDiscordCommand( author, authorNick, cmds, arr );
				}
			}
		}
	}
	
	function SendMessage( text )
	{
		if( Server.EnableEcho ) SqCast.EchoMessage( text ); //this.Message( Server.DiscordBot.EchoBot.Channel.tostring(), text );
	}
}

// Create an instance of our Session
EchoBot <- EchoDiscord();

function onDiscordCommand( author, nick, cmds, arr )
{
	switch( cmds )
	{
		case "players":
        local result = null, getCount = 0;
        SqForeach.Player.Active( this, function( target ) 
        {
            if( result ) result = result + ", " + target.Name;
            else result = target.Name;

            getCount ++;
        });

        if( result ) SqCast.EchoMessage( format( "**Players online** %s", result ) ), SqCast.EchoMessage( format( "**Total players** %d", getCount ) )
        else SqCast.EchoMessage( format( "**No player online T_T**" ) );
        break;

        case "say":
        if( arr )
        {
            local nick2 = ( nick == "" ) ? author : nick;

        	SqCast.MsgAll( TextColor.Info, Lang.onDiscordChat, HexColour.White, StripCol( nick2 ), arr );

        	SqCast.EchoMessage( format( "**%s** [Discord]: %s", nick2, arr ) ); 
    	}
    	else SqCast.EchoMessage( format( "**Syntax,** !say [text] " ) ); 
        break;

        case "dmstats":
        if( arr )
        {
            local target = SqPlayer.FindPlayer( arr );
            if( target )
            {
                if( target.Data.IsReg )
                {
                    if( target.Data.Logged )
                    {
						local ratio = ( typeof( target.Data.Stats.Kills.tofloat() / target.Data.Stats.Deaths.tofloat() ) != "float" ) ? 0.0 : target.Data.Stats.Kills.tofloat() / target.Data.Stats.Deaths.tofloat();
                    	                    
						local header = SqDiscord.EmbedAuthor();
                        header.SetName( "Deathmatch stats" );

                        local embed = SqDiscord.Embed();
                        embed.SetTitle( target.Name + " (ID " + target.Data.AccID + ")" );
                        embed.SetColor( 6959775 );
	
                        local embedField1 = SqDiscord.EmbedField();
                        embedField1.SetName( "Kills" );
                        embedField1.SetValue( SqInteger.ToThousands( target.Data.Stats.Kills ) );
                        embedField1.SetInline( true );
                            
                        local embedField2 = SqDiscord.EmbedField();
                        embedField2.SetName( "Assists" );
                        embedField2.SetValue( 0 );
                        embedField2.SetInline( true );

                        local embedField3 = SqDiscord.EmbedField();
                        embedField3.SetName( "Deaths" );
                        embedField3.SetValue( SqInteger.ToThousands( target.Data.Stats.Deaths ) );
                        embedField3.SetInline( true );
	
	                    local embedField4 = SqDiscord.EmbedField();
                        embedField4.SetName( "Ratio" );
                        embedField4.SetValue( ratio );
                        embedField4.SetInline( true );

						local embedField5 = SqDiscord.EmbedField();
                        embedField5.SetName( "Highest killing streak" );
                        embedField5.SetValue( target.Data.Stats.TopSpree );
                        embedField5.SetInline( true );

                        embed.SetAuthor( header );

                        embed.AddField( embedField1 );
                        embed.AddField( embedField2 );
                        embed.AddField( embedField3 );
                        embed.AddField( embedField4 );
                        embed.AddField( embedField5 );
                     
                        EchoBot.MessageEmbed( Server.DiscordBot.EchoBot.Channel, embed );
					
					}
                	else SqCast.EchoMessage( format( "**Error,** Target player is not logged." ) ); 
                }
                else SqCast.EchoMessage( format( "**Error,** Target player is not registered." ) ); 
            }

            else 
            {
            	if( SqAccount.FindAccountByName( arr ) )
                {
					local q = SqDatabase.Query( format( "SELECT * FROM Accounts INNER JOIN PlayerData ON Accounts.ID = PlayerData.ID WHERE Lower(Name) = '%s'", arr.tolower() ) );
					
					if( q.Step() )
					{
						local ratio = ( typeof( q.GetFloat( "Kills" ) / q.GetFloat( "Deaths" ) ) != "float" ) ? 0.0 : q.GetFloat( "Kills" ) / q.GetFloat( "Deaths" );

						local header = SqDiscord.EmbedAuthor();
                        header.SetName( "Deathmatch stats" );

                        local embed = SqDiscord.Embed();
                        embed.SetTitle( q.GetString( "Name" ) + " (ID " + q.GetInteger( "ID" ) + ")" );
                        embed.SetColor( 6959775 );
	
                        local embedField1 = SqDiscord.EmbedField();
                        embedField1.SetName( "Kills" );
                        embedField1.SetValue( SqInteger.ToThousands( q.GetFloat( "Kills" ) ) );
                        embedField1.SetInline( true );
                            
                        local embedField2 = SqDiscord.EmbedField();
                        embedField2.SetName( "Assists" );
                        embedField2.SetValue( 0 );
                        embedField2.SetInline( true );

                        local embedField3 = SqDiscord.EmbedField();
                        embedField3.SetName( "Deaths" );
                        embedField3.SetValue( SqInteger.ToThousands( q.GetFloat( "Deaths" ) ) );
                        embedField3.SetInline( true );
	
	                    local embedField4 = SqDiscord.EmbedField();
                        embedField4.SetName( "Ratio" );
                        embedField4.SetValue( ratio );
                        embedField4.SetInline( true );

						local embedField5 = SqDiscord.EmbedField();
                        embedField5.SetName( "Highest killing streak" );
                        embedField5.SetValue( q.GetFloat( "HighestSpree" ) );
                        embedField5.SetInline( true );

                        embed.SetAuthor( header );

                        embed.AddField( embedField1 );
                        embed.AddField( embedField2 );
                        embed.AddField( embedField3 );
                        embed.AddField( embedField4 );
                        embed.AddField( embedField5 );
                     
                        EchoBot.MessageEmbed( Server.DiscordBot.EchoBot.Channel, embed );
					}
               	}
               	else SqCast.EchoMessage( format( "**Error,** Target player account not found." ) ); 
            }
        }
        else SqCast.EchoMessage( format( "**Syntax,** !dmstats [player/full name]" ) ); 
        break;

        case "playerinfo":
        if( arr )
        {
            local target = SqPlayer.FindPlayer( arr );
            if( target )
            {
                if( target.Data.IsReg )
                {
                    if( target.Data.Logged )
                    {	
                    	local totalWorld = 0, totalVehicle = 0;
						local getTime = ( target.Data.Player.Permission.VIP.Position == "1" ) ? " (" + SqInteger.SecondToTime( ( target.Data.Player.Permission.VIP.Duration.tointeger() - ( time() - target.Data.Player.Permission.VIP.Time.tointeger() ) ) ) + ")": "";
								
                    	foreach( index, value in SqWorld.World )
                    	{
                    		if( value.Owner == target.Data.AccID ) totalWorld ++;
                    	}

                    	foreach( index, value in SqVehicles.Vehicles )
                    	{
                    		if( value.Prop.Owner == target.Data.AccID ) totalVehicle ++;
                    	}

                        local embed = SqDiscord.Embed();
                        embed.SetTitle( target.Name + " (ID " + target.Data.AccID + ")" );
                        embed.SetColor( 6959775 );
                            
                        local embedField1 = SqDiscord.EmbedField();
                        embedField1.SetName( "Staff" );
                        embedField1.SetValue( Server.RankName.Admin[ target.Data.Player.Permission.Staff.Position.tointeger() ] );
                        embedField1.SetInline( true );
                            
                        local embedField2 = SqDiscord.EmbedField();
                        embedField2.SetName( "Mapper" );
                        embedField2.SetValue( Server.RankName.Mapper[ target.Data.Player.Permission.Mapper.Position.tointeger() ] );
                        embedField2.SetInline( true );

                        local embedField3 = SqDiscord.EmbedField();
                        embedField3.SetName( "VIP" );
                        embedField3.SetValue( Server.RankName.VIP[ target.Data.Player.Permission.VIP.Position.tointeger() ] + getTime );
                        embedField3.SetInline( true );

                        local embedField4 = SqDiscord.EmbedField();
                        embedField4.SetName( "Date registered" );
                        embedField4.SetValue( SqInteger.TimestampToDate( target.Data.DateReg ) );
                        embedField4.SetInline( true );

                        local embedField5 = SqDiscord.EmbedField();
                        embedField5.SetName( "Last seen" );
                        embedField5.SetValue( "now" );
                        embedField5.SetInline( true );

                        local embedField6 = SqDiscord.EmbedField();
                        embedField6.SetName( "Total playtime" );
                        embedField6.SetValue( SqInteger.SecondToTime( target.Data.Playtime ) );
                        embedField6.SetInline( true );

                        local embedField7 = SqDiscord.EmbedField();
                        embedField7.SetName( "Total world(s) owned" );
                        embedField7.SetValue( totalWorld );
                        embedField7.SetInline( true );

                        local embedField8 = SqDiscord.EmbedField();
                        embedField8.SetName( "Total vehicle(s) owned" );
                        embedField8.SetValue( totalVehicle );
                        embedField8.SetInline( true );

                        local footer = SqDiscord.EmbedAuthor();
                        footer.SetName("Player info" );

                        embed.SetAuthor( footer );

                        embed.AddField( embedField1 );
                        embed.AddField( embedField2 );
                        embed.AddField( embedField3 );
                        embed.AddField( embedField4 );
                        embed.AddField( embedField5 );
                        embed.AddField( embedField6 );
                        embed.AddField( embedField7 );
                        embed.AddField( embedField8 );
                     
                        EchoBot.MessageEmbed( Server.DiscordBot.EchoBot.Channel, embed );           
                    }
                	else SqCast.EchoMessage( format( "**Error,** Target player is not logged." ) ); 
                }
                else SqCast.EchoMessage( format( "**Error,** Target player is not registered." ) ); 
            }

            else 
            {
            	if( SqAccount.FindAccountByName( arr ) )
                {
					local q = SqDatabase.Query( format( "SELECT * FROM Accounts INNER JOIN PlayerData ON Accounts.ID = PlayerData.ID WHERE Lower(Name) = '%s'", arr.tolower() ) );
					
					if( q.Step() )
					{
                    	local totalWorld = 0, totalVehicle = 0;
                    	local perms = ::json_decode( q.GetString( "Permission" ) );
						local getTime = ( perms.VIP.Position == "1" ) ? " (" + SqInteger.SecondToTime( ( perms.VIP.Duration.tointeger() - ( time() - perms.VIP.Time.tointeger() ) ) ) + ")": "";

                    	foreach( index, value in SqWorld.World )
                    	{
                    		if( value.Owner == q.GetInteger( "ID" ) ) totalWorld ++;
                    	}

                    	foreach( index, value in SqVehicles.Vehicles )
                    	{
                    		if( value.Prop.Owner == q.GetInteger( "ID" ) ) totalVehicle ++;
                    	}

                        local embed = SqDiscord.Embed();
                        embed.SetTitle( q.GetString( "Name" ) + " (ID " + q.GetInteger( "ID" ) + ")" );
                        embed.SetColor( 6959775 );
                            
                        local embedField1 = SqDiscord.EmbedField();
                        embedField1.SetName( "Staff" );
                        embedField1.SetValue( Server.RankName.Admin[ perms.Staff.Position.tointeger() ] );
                        embedField1.SetInline( true );
                            
                        local embedField2 = SqDiscord.EmbedField();
                        embedField2.SetName( "Mapper" );
                        embedField2.SetValue( Server.RankName.Mapper[ perms.Mapper.Position.tointeger() ] );
                        embedField2.SetInline( true );

                        local embedField3 = SqDiscord.EmbedField();
                        embedField3.SetName( "VIP" );
                        embedField3.SetValue( Server.RankName.VIP[ perms.VIP.Position.tointeger() ] + getTime );
                        embedField3.SetInline( true );

                        local embedField4 = SqDiscord.EmbedField();
                        embedField4.SetName( "Date registered" );
                        embedField4.SetValue( SqInteger.TimestampToDate( q.GetInteger( "DateReg" ) ) );
                        embedField4.SetInline( true );

                        local embedField5 = SqDiscord.EmbedField();
                        embedField5.SetName( "Last seen" );
                        embedField5.SetValue( SqInteger.TimestampToDate( q.GetInteger( "LastLogin" ) ) );
                        embedField5.SetInline( true );

                        local embedField6 = SqDiscord.EmbedField();
                        embedField6.SetName( "Total playtime" );
                        embedField6.SetValue( SqInteger.SecondToTime( q.GetInteger( "Playtime" ) ) );
                        embedField6.SetInline( true );

                        local embedField7 = SqDiscord.EmbedField();
                        embedField7.SetName( "Total world(s) owned" );
                        embedField7.SetValue( totalWorld );
                        embedField7.SetInline( true );

                        local embedField8 = SqDiscord.EmbedField();
                        embedField8.SetName( "Total vehicle(s) owned" );
                        embedField8.SetValue( totalVehicle );
                        embedField8.SetInline( true );

                        local footer = SqDiscord.EmbedAuthor();
                        footer.SetName("Player info" );

                        embed.SetAuthor( footer );

                        embed.AddField( embedField1 );
                        embed.AddField( embedField2 );
                        embed.AddField( embedField3 );
                        embed.AddField( embedField4 );
                        embed.AddField( embedField5 );
                        embed.AddField( embedField6 );
                        embed.AddField( embedField7 );
                        embed.AddField( embedField8 );
                     
                        EchoBot.MessageEmbed( Server.DiscordBot.EchoBot.Channel, embed );                   
                    }
               	}
               	else SqCast.EchoMessage( format( "**Error,** Target player account not found." ) ); 
            }
        }
        else SqCast.EchoMessage( format( "**Syntax,** !playerinfo [player/full name]" ) ); 
        break;

        case "serverinfo":
		
		local embed = SqDiscord.Embed();
        embed.SetTitle( Server.Name );
        embed.SetColor( 16711680 );

		local embedField1 = SqDiscord.EmbedField();
        embedField1.SetName( "IP" );
        embedField1.SetValue( "51.68.230.244:5112" );
        embedField1.SetInline( true );

		local embedField2 = SqDiscord.EmbedField();
		embedField2.SetName( "Uptime" );
        embedField2.SetValue( SqInteger.SecondToTime( ( time() - Server.Uptime ) ) );
        embedField2.SetInline( true );
		
        embed.AddField( embedField1 );
        embed.AddField( embedField2 );
		
		EchoBot.MessageEmbed( Server.DiscordBot.EchoBot.Channel, embed );                   
        break;

        case "cmds":
        SqCast.EchoMessage( format( "**Commands (!)** players, say, dmstats, playerinfo, serverinfo" ) );
        break;

        default:
       	SqCast.EchoMessage( format( "**Error**, Unknown command, use !cmds to check available commands." ) );
       	break;
    }
}