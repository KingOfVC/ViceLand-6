class CAdmin
{
	UID 	= {};
	UID2	= {};

	function constructor()
	{		
		this.LoadUID1();
		this.LoadUID2();
	}

	function LoadUID1()
	{
		local result = SqDatabase.Query( format( "SELECT * FROM UID1Info" ) ), count = 0;

		while( result.Step() )
		{
			this.UID.rawset( result.GetString( "UID" ),
			{
				Ban				= SqWorld.ConvertToJSON( result.GetString( "Ban" ) ),
				Mute 			= SqWorld.ConvertToJSON( result.GetString( "Mute" ) ),
				Alias 			= SqWorld.ConvertToJSON( result.GetString( "Alias" ) ),
				AllowedInstance	= result.GetInteger( "AllowedInstance" ),
				Comment			= result.GetInteger( "Comment" ),
			});

			count ++;
		}

		SqLog.Scs( "Total UID1 loaded in table: %s", SqInteger.ToThousands( count ) );
	}

	function LoadUID2()
	{
		local result = SqDatabase.Query( format( "SELECT * FROM UID2Info" ) ), count = 0;

		while( result.Step() )
		{
			this.UID2.rawset( result.GetString( "UID" ),
			{
				Ban				= SqWorld.ConvertToJSON( result.GetString( "Ban" ) ),
				Mute 			= SqWorld.ConvertToJSON( result.GetString( "Mute" ) ),
				Alias 			= SqWorld.ConvertToJSON( result.GetString( "Alias" ) ),
				AllowedInstance	= result.GetInteger( "AllowedInstance" ),
				Comment			= result.GetInteger( "Comment" ),
			});

			count ++;
		}

		SqLog.Scs( "Total UID2 loaded in table: %s", SqInteger.ToThousands( count ) );
	}

	function Join( player )
	{
		if( this.UID.rawin( player.UID ) )
		{
			try 
			{
				if( this.UID[ player.UID ].Ban != null )
				{
					if( this.UID[ player.UID ].Ban.Duration.tointeger() == 5000000 )
					{
						player.Msg3( TextColor.Error, Lang.Kickban[0], this.UID[ player.UID ].Ban.Admin, TextColor.Error, this.UID[ player.UID ].Ban.Reason, TextColor.Error, SqInteger.TimestampToDate( this.UID[ player.UID ].Ban.Time.tointeger() ) );
						
						player.Msg3( TextColor.Error, Lang.UnbanForum[0], Server.Forum );
						
						player.Kick();

						return true;
					}

					else 
					{
						if( this.UID[ player.UID ].Ban.Duration.tointeger() > ( time() - this.UID[ player.UID ].Ban.Time.tointeger() ) )
						{
							player.Msg3( TextColor.Error, Lang.Kickban[0], this.UID[ player.UID ].Ban.Admin, TextColor.Error, this.UID[ player.UID ].Ban.Reason, TextColor.Error, SqInteger.TimestampToDate( this.UID[ player.UID ].Ban.Time.tointeger() ) );

							player.Msg3( TextColor.Error, Lang.KickbanTimered1[0], SqInteger.SecondToTime( ( this.UID[ player.UID ].Ban.Duration.tointeger() - ( time() - this.UID[ player.UID ].Ban.Time.tointeger() ) ) ) );
							
							player.Kick();

							return true;
						}

						else this.UID[ player.UID ].Ban = null;
					}
				}

				if( this.UID[ player.UID ].Mute != null )
				{
					if( this.UID[ player.UID ].Mute != null )
					{
						if( this.UID[ player.UID ].Mute.Duration.tointeger() == 5000000 )
						{
							player.Msg3( TextColor.Error, Lang.MuteNotice[0], this.UID[ player.UID ].Mute.Admin, TextColor.Error, this.UID[ player.UID ].Mute.Reason, TextColor.Error, SqInteger.TimestampToDate( this.UID[ player.UID ].Mute.Time.tointeger() ) );
						
							player.Msg3( TextColor.Error, Lang.UnmuteForum[0], Server.Forum );
						}

						else 
						{
							if( this.UID[ player.UID ].Mute.Duration.tointeger() > ( time() - this.UID[ player.UID ].Mute.Time.tointeger() ) )
							{
								player.Msg3( TextColor.Error, Lang.MuteNotice[0], this.UID[ player.UID ].Mute.Admin, TextColor.Error, this.UID[ player.UID ].Mute.Reason, TextColor.Error, SqInteger.TimestampToDate( this.UID[ player.UID ].Mute.Time.tointeger() ) );

								player.Msg3( TextColor.Error, Lang.UnmuteDuration[0], SqInteger.SecondToTime( ( this.UID[ player.UID ].Mute.Duration.tointeger() - ( time() - this.UID[ player.UID ].Mute.Time.tointeger() ) ) ) );
								
	                           	player.MakeTask( function()
	                            {  
	                                SqAdmin.UID[ player.UID ].Mute = null;
	                                                            
	                              	this.Terminate();

	                                SqCast.MsgAll( TextColor.Admin, Lang.AUnmuteTimered, player.Name );

	                                EchoBot.SendMessage( format( "Auto unmuted **%s**", target.Name ) );
	                            }, ( SqAdmin.UID[ player.UID ].Mute.Duration.tointeger() * 1500 ), 1 ).SetTag( "Mute" );
							}
							else this.UID[ player.UID ].Mute = null;						
						}
					}
				}
			}
			catch( _ ) _;
		}
		else 
		{
			SqDatabase.Exec( format( "INSERT INTO UID1Info ( 'UID', 'Ban', 'Mute', 'Comment', 'AllowedInstance', 'Alias' ) VALUES ( '%s', '%s', '%s', '%s', '%d', '%s' )", player.UID, "N/A", "N/A", "N/A", 2, "N/A" ) );

			this.UID.rawset( player.UID,
			{
				Ban				= null,
				Mute 			= null,
				Alias 			= {},
				AllowedInstance	= 2,
				Comment			= "N/A",
			});

			this.UID[ player.UID ].Alias.rawset( player.Name, 
			{
				UsedTimes	= "1",
				LastUsed	= time().tostring(),
			});
		}

		if( this.UID2.rawin( player.UID2 ) )
		{
			try 
			{
				if( this.UID2[ player.UID2 ].Ban != null )
				{
					if( this.UID2[ player.UID2 ].Ban.Duration.tointeger() == 5000000 )
					{
						player.Msg3( TextColor.Error, Lang.Kickban[0], this.UID2[ player.UID2 ].Ban.Admin, TextColor.Error, this.UID2[ player.UID2 ].Ban.Reason, TextColor.Error, SqInteger.TimestampToDate( this.UID2[ player.UID2 ].Ban.Time.tointeger() ) );
						
						player.Msg3( TextColor.Error, Lang.UnbanForum[0], Server.Forum );
						
						player.Kick();

						return true;
					}

					else 
					{
						if( this.UID2[ player.UID2 ].Ban.Duration.tointeger() > ( time() - this.UID2[ player.UID2 ].Ban.Time.tointeger() ) )
						{
							player.Msg3( TextColor.Error, Lang.Kickban[0], this.UID2[ player.UID2 ].Ban.Admin, TextColor.Error, this.UID2[ player.UID2 ].Ban.Reason, TextColor.Error, SqInteger.TimestampToDate( this.UID2[ player.UID2 ].Ban.Time.tointeger() ) );

							player.Msg3( TextColor.Error, Lang.KickbanTimered1[0], SqInteger.SecondToTime( ( this.UID2[ player.UID2 ].Ban.Duration.tointeger() - ( time() - this.UID2[ player.UID2 ].Ban.Time.tointeger() ) ) ) );
							
							player.Kick();

							return true;
						}

						else this.UID2[ player.UID2 ].Ban = null;
					}
				}

				if( this.UID2[ player.UID2 ].Mute != null )
				{
					if( this.UID2[ player.UID2 ].Mute != null )
					{
						if( this.UID2[ player.UID2 ].Mute.Duration.tointeger() == 5000000 )
						{
							player.Msg3( TextColor.Error, Lang.MuteNotice[0], this.UID2[ player.UID2 ].Mute.Admin, TextColor.Error, this.UID2[ player.UID2 ].Mute.Reason, TextColor.Error, SqInteger.TimestampToDate( this.UID2[ player.UID2 ].Mute.Time.tointeger() ) );
						
							player.Msg3( TextColor.Error, Lang.UnmuteForum[0], Server.Forum );
						}

						else 
						{
							if( this.UID2[ player.UID2 ].Mute.Duration.tointeger() > ( time() - this.UID2[ player.UID2 ].Mute.Time.tointeger() ) )
							{
								player.Msg3( TextColor.Error, Lang.MuteNotice[0], this.UID2[ player.UID2 ].Mute.Admin, TextColor.Error, this.UID2[ player.UID2 ].Mute.Reason, TextColor.Error, SqInteger.TimestampToDate( this.UID2[ player.UID2 ].Mute.Time.tointeger() ) );

								player.Msg3( TextColor.Error, Lang.UnmuteDuration[0], SqInteger.SecondToTime( ( this.UID2[ player.UID2 ].Mute.Duration.tointeger() - ( time() - this.UID2[ player.UID2 ].Mute.Time.tointeger() ) ) ) );
								
	                           	player.MakeTask( function()
	                            {  
	                                SqAdmin.UID2[ player.UID2 ].Mute = null;
	                                                            
	                              	this.Terminate();

	                            }, ( SqAdmin.UID2[ player.UID2 ].Mute.Duration.tointeger() * 1500 ), 1 ).SetTag( "Mute" );
							}
							else this.UID2[ player.UID2 ].Mute = null;						
						}
					}
				}
			}
			catch( _ ) _;
		}
		else 
		{
			SqDatabase.Exec( format( "INSERT INTO UID2Info ( 'UID', 'Ban', 'Mute', 'Comment', 'AllowedInstance', 'Alias' ) VALUES ( '%s', '%s', '%s', '%s', '%d', '%s' )", player.UID2, "N/A", "N/A", "N/A", 2, "N/A" ) );

			this.UID2.rawset( player.UID2,
			{
				Ban				= null,
				Mute 			= null,
				Alias 			= {},
				AllowedInstance	= 2,
				Comment			= "N/A",
			});

			this.UID2[ player.UID2 ].Alias.rawset( player.Name, 
			{
				UsedTimes	= "1",
				LastUsed	= time().tostring(),
			});
		}		
	}

	function AddAlias( player )
	{
		local findUID = false, findUID2 = false;

		if( this.UID[ player.UID ].Alias == null ) this.UID[ player.UID ].Alias = {};

		foreach( index, value in this.UID[ player.UID ].Alias )
		{
			if( index.tolower() == player.Name.tolower() )
			{
				value.UsedTimes	= ( value.UsedTimes.tointeger() + 1 );
				value.LastUsed	= time().tostring();
				findUID		= true;
			} 
		}

		if( !findUID )
		{
			this.UID[ player.UID ].Alias.rawset( player.Name, 
			{
				UsedTimes	= "1",
				LastUsed	= time().tostring(),
			});
		}

		if( this.UID2[ player.UID2 ].Alias == null ) this.UID2[ player.UID2 ].Alias = {};
		
		foreach( index, value in this.UID2[ player.UID2 ].Alias )
		{
			if( index.tolower() == player.Name.tolower() )
			{
				value.UsedTimes	= ( value.UsedTimes.tointeger() + 1 );
				value.LastUsed	= time().tostring();
				findUID2	= true;
			} 
		}

		if( !findUID2 )
		{
			this.UID2[ player.UID2 ].Alias.rawset( player.Name, 
			{
				UsedTimes	= "1",
				LastUsed	= time().tostring(),
			});
		}
	}

	function CheckMute( uid1, uid2 )
	{
		if( this.UID[ uid1 ].Mute != null ) return true;
		if( this.UID2[ uid2 ].Mute != null ) return true;		
	}

	function Save( uid1, uid2 )
	{
		local getUID1 = ( uid1 == false ) ? "" : this.UID[ uid1 ];
		local getUID2 = ( uid2 == false ) ? "" : this.UID2[ uid2 ];

		try 
		{
			SqDatabase.Exec( format( "UPDATE UID1Info SET Ban = '%s', Mute = '%s', AllowedInstance = '%d', Alias = '%s' WHERE UID = '%s'", ::EscapeString( SqWorld.ConvertFromJson( getUID1.Ban ) ), ::EscapeString( SqWorld.ConvertFromJson( getUID1.Mute ) ), getUID1.AllowedInstance, SqWorld.ConvertFromJson( getUID1.Alias ), uid1 ) );
			SqDatabase.Exec( format( "UPDATE UID2Info SET Ban = '%s', Mute = '%s', AllowedInstance = '%d', Alias = '%s' WHERE UID = '%s'", ::EscapeString( SqWorld.ConvertFromJson( getUID2.Ban ) ), ::EscapeString( SqWorld.ConvertFromJson( getUID2.Mute ) ), getUID2.AllowedInstance, SqWorld.ConvertFromJson( getUID2.Alias ), uid2 ) );	
		}
		catch( e ) 
		{
			SqLog.Err( "An error occurred while saving uid info: " + e );
		//	SqLog.Err( "Field 1 " + SqWorld.ConvertFromJson( getUID1.Ban ) + ", " SqWorld.ConvertFromJson( getUID1.Mute ) + ", " + getUID1.AllowedInstance + ", " + SqWorld.ConvertFromJson( getUID1.Alias ) + ", " + uid1 );
		//	SqLog.Err( "Field 2 " + SqWorld.ConvertFromJson( getUID2.Ban ) + ", " SqWorld.ConvertFromJson( getUID2.Mute ) + ", " + getUID2.AllowedInstance + ", " + SqWorld.ConvertFromJson( getUID2.Alias ) + ", " + uid2 );
		}
	}

	function GetDuration( duration )
	{
		local ban_time = null, duration_type = null;
		
		try 
		{
			switch( duration.len() )
			{
				case 2:
				ban_time = duration.slice(0,1);
				duration_type = duration.slice(1,2);
				break;

				case 3:
				ban_time = duration.slice(0,2);
				duration_type = duration.slice(2,3);
				break;

				case 4:
				ban_time = duration.slice(0,3);
				duration_type = duration.slice(3,4);
				break;
			}
			 
			switch( duration_type )
			{
				case "d":
				ban_time = ban_time.tointeger() * 86400;
				break;

				case "w":
				ban_time = ban_time.tointeger() * 604800;
				break;

				case "y":
				ban_time = ban_time.tointeger() * 31536000;
				break;

				case "m":
				ban_time = ban_time.tointeger() * 60;
				break;

				case "h":
				ban_time = ban_time.tointeger() * 3600;
				break;

			//	default:
			//	return null;
			}
		}
		catch( _ ) _;

		return ban_time;
	}

	function AddMute( victim, admin, reason, duration )
	{
		this.UID[ victim.UID ].Mute = {};

		this.UID[ victim.UID ].Mute.rawset( "Admin", admin );
		this.UID[ victim.UID ].Mute.rawset( "Reason", reason );
		this.UID[ victim.UID ].Mute.rawset( "Duration", duration.tostring() );
		this.UID[ victim.UID ].Mute.rawset( "Time", time().tostring() );

		this.UID2[ victim.UID2 ].Mute = {};

		this.UID2[ victim.UID2 ].Mute.rawset( "Admin", admin );
		this.UID2[ victim.UID2 ].Mute.rawset( "Reason", reason );
		this.UID2[ victim.UID2 ].Mute.rawset( "Duration", duration.tostring() );
		this.UID2[ victim.UID2 ].Mute.rawset( "Time", time().tostring() );
	}

	function AddBan( victim, admin, reason, duration )
	{
		this.UID[ victim.UID ].Ban = {};

		this.UID[ victim.UID ].Ban.rawset( "Admin", admin );
		this.UID[ victim.UID ].Ban.rawset( "Reason", reason );
		this.UID[ victim.UID ].Ban.rawset( "Duration", duration.tostring() );
		this.UID[ victim.UID ].Ban.rawset( "Time", time().tostring() );

		this.UID2[ victim.UID2 ].Ban = {};

		this.UID2[ victim.UID2 ].Ban.rawset( "Admin", admin );
		this.UID2[ victim.UID2 ].Ban.rawset( "Reason", reason );
		this.UID2[ victim.UID2 ].Ban.rawset( "Duration", duration.tostring() );
		this.UID2[ victim.UID2 ].Ban.rawset( "Time", time().tostring() );
	}

	function IsAllowMapping( player )
	{
		if( SqWorld.GetPrivateWorld( player.World ) )
		{
			if( SqMath.IsGreaterEqual( SqWorld.GetPlayerLevelInWorld( player.Data.AccID, player.World ), SqWorld.World[ player.World ].Permissions.mapping.tointeger() ) )
			{
				return true;
			}
		}

		else 
		{
			if( player.Data.Player.Permission.Mapper.Position.tointeger() > 0 ) return true;
		}
	}

	function IsTimedMuted( player )
	{
		try
		{
			return player.FindTask( "Mute" );
		}
		catch( _ ) _;
	
		return null;
	}

	function ForceVehicleCommand( player )
	{
		if( player.Vehicle )
		{
			if( player.Data.Player.Permission.Mapper.Position.tointeger() > 4 ) return true;
	
			else 
			{
				if( SqVehicles.Vehicles[ player.Vehicle.Tag ].Prop.Owner == player.Data.AccID ) return true;
			}
		}
	}
}