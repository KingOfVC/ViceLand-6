SqDM <-
{
	function GetRewardOnKill( player, target, weapon, bodypart )
	{
		local wepReward = 100, xpreward = 5;
		switch( weapon )
		{
			case 0:
			case 1:
			case 2:
			case 3:
			case 4:
			case 5:
			case 6:
			case 7:
			case 8:
			case 9:
			case 10:
			xpreward = 20;
			wepReward = 2000;
			break;
			
			case 11:
			case 28:
			case 29:
			case 106:
			xpreward = 8;
			wepReward = 500;
			break;
			
			case 12:
			case 13:
			case 14:
			case 101:
			xpreward = 5;
			wepReward = 300;
			break;
			
			case 17:
			case 18:
			case 19:
			case 21:
			case 103:
			case 104:
			xpreward = 15;
			wepReward = 1500;
			break;
						
			case 20:
			case 31:
			xpreward = 10;
			wepReward = 1000;
			break;
		
			case 22:
			case 23:
			case 24:
			case 25:
			case 107:
			xpreward = 15;
			wepReward = 1700;
			break;
			
			case 26:
			case 27:
			case 100:
			case 105:
			case 108:
			case 109:
			xpreward = 15;
			wepReward = 1200;
			break;
					
			case 32:
			case 102:
			xpreward = 15;
			wepReward = 1400;
			break;
		}
		
		local getWeaponReward = ( ( wepReward * Server.DoubleEvent.WeaponDM ) == 0 ) ? wepReward : ( wepReward * Server.DoubleEvent.WeaponDM ), loseCash = 500;
		
		if( target.Data.Player.Permission.VIP.Position.tointeger() > 0 ) wepReward = wepReward * 2;

		player.Data.Stats.Cash += wepReward;
		player.Data.Stats.TotalEarn += wepReward;

		player.Data.AddXP( player, xpreward );

		if( target.Data.Player.Permission.VIP.Position.tointeger() > 0 ) loseCash = 500;

		target.Data.Stats.Cash -= loseCash;
		target.Data.Stats.TotalSpend += loseCash;		

		player.Msg( TextColor.InfoS, Lang.KillReward[ player.Data.Language ], target.Name, TextColor.InfoS, GetWeaponName( weapon ), TextColor.InfoS, player.Pos.DistanceTo( target.Pos ), TextColor.InfoS, SqInteger.ToThousands( wepReward ), TextColor.InfoS, SqInteger.ToThousands( xpreward ) );
		
		if( bodypart == 6 ) 
		{
			player.Msg( TextColor.InfoS, Lang.KillReward5[ player.Data.Language ] );

			player.Data.Stats.Cash += 500;
			player.Data.Stats.TotalEarn += 500;
		}
	
		target.Msg( TextColor.InfoS, Lang.Killed[ target.Data.Language ], player.Name, TextColor.InfoS, GetWeaponName( weapon ), TextColor.InfoS, player.Pos.DistanceTo( target.Pos ), TextColor.InfoS, SqInteger.ToThousands( loseCash ) );
			
		this.AddTeamScore( player.Team );
	}
	
	function CheckSpreeBetweenKillerAndVictim( player, target )
	{
		if( player.Data.CurrentStats.Spree % 5 == 0 )
		{
			local getReward = ( 1000 * player.Data.CurrentStats.Spree );
			local XPReward = ( player.Data.CurrentStats.Spree * 1 );
			
			player.Data.Stats.Cash += getReward;
			player.Data.Stats.TotalEarn += getReward;

			player.Data.AddXP( player, XPReward );
		
			SqCast.MsgAll( TextColor.Info, Lang.OnSpree, player.Name, TextColor.Info, player.Data.CurrentStats.Spree );
		
			player.Msg( TextColor.InfoS, Lang.OnSpreeSelf[ player.Data.Language ], player.Data.CurrentStats.Spree, TextColor.InfoS, SqInteger.ToThousands( getReward ), TextColor.InfoS, SqInteger.ToThousands( XPReward ) );
		}
		
		if( target.Data.CurrentStats.Spree > 4 )
		{
			local getReward = ( 500 * target.Data.CurrentStats.Spree );
			local XPReward = ( target.Data.CurrentStats.Spree * 1 );
			
			player.Data.Stats.Cash				+= getReward;
			player.Data.Stats.TotalEarn			+= getReward;

			player.Data.AddXP( player, XPReward );

			SqCast.MsgAll( TextColor.Info, Lang.EndSpree, player.Name, TextColor.Info, target.Name, TextColor.Info, target.Data.CurrentStats.Spree );
		
			player.Msg( TextColor.InfoS, Lang.EndSpreeSelf[ player.Data.Language ], target.Name, TextColor.InfoS, target.Data.CurrentStats.Spree, TextColor.InfoS, SqInteger.ToThousands( getReward ), TextColor.InfoS, SqInteger.ToThousands( XPReward ) );
		}
		target.Data.CurrentStats.Spree 	= 0;;
	}
	
	function CheckSpreeSelf( player )
	{
		if( player.Data.CurrentStats.Spree > 5 )
		{
			SqCast.MsgAll( TextColor.Info, Lang.EndSpreeSelf1, player.Name, TextColor.Info );
			
			player.Data.CurrentStats.Spree	= 0;
		}	
		player.Data.CurrentStats.Spree	= 0;
	}	
	
	function GetHealingPrice( player )
	{
		if( player.Data.Player.Permission.VIP.Position == "0" ) return ( player.Health * 150 );
		else return 0;
	}
	
	function IsHealing( player )
	{
		try
		{
			return player.FindTask( "Healing" );
		}
		catch( _ ) _;
	
		return null;
	}

	function ChangeArena()
	{
		if( Server.DMArena.Count > -1 ) Server.DMArena.Count --;

		switch( Server.DMArena.Count )
		{
			case 15:
			SqCast.MsgWorld( TextColor.Info, 101, Lang.DMArenaChangeArea, Server.DMArena.Count );
			break;
				
			case 10:
			SqCast.MsgWorld( TextColor.Info, 101, Lang.DMArenaChangeArea, Server.DMArena.Count );
			break;

			case 5:
			case 4:
			case 3:
			case 2:
			case 1:
			SqCast.MsgWorld( TextColor.Info, 101, Lang.DMArenaChangeArea, Server.DMArena.Count );
			break;

			case 0:
			Server.DMArena.Position ++;
			if( Server.DMArena.Position > Server.DMArena.Arena.len() ) Server.DMArena.Position = 1;

			SqForeach.Player.Active( this, function( target ) 
           	{
           		if( target.World == 101 && target.Spec.tostring() == "-1" )
           		{
           			target.Pos = Vector3.FromStr( Server.DMArena.Arena[ Server.DMArena.Position.tostring() ].Pos );
           		}
           	});

           	SqCast.MsgWorld( TextColor.Info, 101, Lang.DMArenaStartArea, Server.DMArena.Arena[ Server.DMArena.Position.tostring() ].Name );
			
           	Server.DMArena.Count = Server.DMArena.Lenght;
			break;
		}
	}

	function GetTDMBase( team )
	{
		switch( team )
		{
			case "Blue":
			if( player.Data.Area == "Blue Base" ) return true;

			if( SqVehicles.GetNearestSupplyVehicle( player.Data.InEvent.TDM.Team ) ) return true;
			break;

			case "Yellow":
			case "Blue":
			if( player.Data.Area == "Yellow Base" ) return true;

			if( SqVehicles.GetNearestSupplyVehicle( player.Data.InEvent.TDM.Team ) ) return true;
			break;
		}
	}

	function GetBodyPartName( id )
	{
		switch( id )
		{
			case 0:
			return "Body";

			case 1:
			return "Torse";

			case 2:
			return "Left Arm";

			case 3:
			return "Right Arm";

			case 4: 
			return "Left Leg";

			case 5:
			return "Right Leg";

			case 6:
			return "Head";

			case 7:
			return "Vehicle";

			default:
			return "Unknown";
		}
	}

	function isTeam( id )
	{
		switch( id )
		{
			case 1:
			case 2:
			case 3:
			case 4:
			case 5:
			case 6:
			return true;

			default:
			return false;
		}
	}

	function GetTeamTable( team )
	{
		switch( team )
		{
			case 1:
			return "Team1";

			case 2:
			return "Team2";

			case 3:
			return "Team3";

			case 4:
			return "Team4";

			case 5:
			return "Team5";

			case 6:
			return "Team6";

			default:
			return null;
		}
	}

	function AddTeamScore( team )
	{
		if( GetTeamTable( team ) )
		{
			Server.TeamDMScore[ this.GetTeamTable( team ) ].Score ++;
		}
	}

	function LoadScore()
	{
		local result = SqDatabase.Query( format( "SELECT * FROM TeamScore" ) ), count = 0;

		while( result.Step() )
		{
			Server.TeamDMScore[ result.GetString( "Team" ) ].Score = result.GetInteger( "Score" );
		}

		SqLog.Scs( "Team score has been loaded." );
	}

	function SaveTeamScore()
	{
		SqDatabase.Query( "BEGIN TRANSACTION" );

		foreach( index, value in Server.TeamDMScore )
		{
			SqDatabase.Exec( format( "UPDATE TeamScore SET Score = '%d' WHERE Team = '%s'", value.Score, index ) );
		}

		SqDatabase.Query( "END TRANSACTION" );	
	}

	function GetTeamScore()
	{
		local getMembers = {};
		local t, ta , taa, tta, tat, j , k = 0, i = 0, getStr = null;

		getMembers.rawset( i++, 
		{
			Name	= 0,
			Kills 	= 0,
		});

	    foreach( index, value in Server.TeamDMScore )
		{
			getMembers.rawset( i, 
			{
				Name	= index,
				Kills 	= value.Score,
			});

			k++;
			i++;		
		}
								
		for( j = 0; j < getMembers.len(); j++ )
		{
			for( local i = 0 ; i<getMembers.len()-1-j; i++ )
			{
				if( ( getMembers.rawin( i ) ) && ( getMembers.rawin( i + 1 ) ) )
				{
					
					if( getMembers[ i ].Kills <= getMembers[ i + 1 ].Kills )
					{
						
						t = getMembers[ i + 1 ].Name;
						taa = getMembers[ i + 1 ].Kills;

						getMembers[ i + 1 ].Name <- getMembers[ i ].Name;
						getMembers[ i + 1 ].Kills <- getMembers[ i ].Kills;

						getMembers[ i ].Name <- t;
						getMembers[ i ].Kills <- taa;
					}
				}
			}
		}

		local str = null;
		for( local i = 0, j = 1; i < k ; i++, j++ )
		{
			if( ( i+1 ) <= 10 )
			{
				if( str ) str = str + "[#F57C00], " + this.GetTeamName( getMembers[ i ].Name ) + " [#F57C00]- [#ffffff]" + getMembers[ i ].Kills;
				else str = this.GetTeamName( getMembers[ i ].Name ) + " [#F57C00]- [#ffffff]" + getMembers[ i ].Kills;
			}
		}

		return str;
	}

	function GetTeamName( team )
	{
		switch( team )
		{
			case "Team1":
			return "Business";

			case "Team2":
			return "Medic";

			case "Team3":
			return "Taxi";

			case "Team4":
			return "Haitian";

			case "Team5":
			return "Police";

			case "Team6":
			return "Biker";

			default:
			return null;
		}
	}

}


