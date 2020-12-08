SqCore.On().PlayerKilled.Connect( this, function( victim, killer, reason, bodypart, isteamkill ) 
{
	SqSpawn.SavePlayerSpawn( victim );
	
	if( !SqWorld.IsStunt( killer.World ) )
	{
		killer.Data.Stats.Kills 				++;
		victim.Data.Stats.Deaths 				++;
		killer.Data.CurrentStats.Spree 	++;
		killer.Data.CurrentStats.Kills 	++;
		victim.Data.CurrentStats.Deaths ++;
		
		if( killer.Data.CurrentStats.Spree > killer.Data.Stats.TopSpree ) killer.Data.Stats.TopSpree = killer.Data.CurrentStats.Spree;
		
		SqWeapon.UpdatePlayerKill( victim, reason );
				
		SqDM.GetRewardOnKill( killer, victim, reason, bodypart );
		SqDM.CheckSpreeBetweenKillerAndVictim( killer, victim );

		if( SqGang.Gangs.rawin( killer.Data.ActiveGang ) ) SqGang.Gangs[ killer.Data.ActiveGang ].Stats.Kills ++, SqGang.Save( killer.Data.ActiveGang );
		if( SqGang.Gangs.rawin( victim.Data.ActiveGang ) ) SqGang.Gangs[ victim.Data.ActiveGang ].Stats.Deaths ++, SqGang.Save( victim.Data.ActiveGang );	
	
		if( victim.Data.LastHit.len() > 0 )
		{
			if( SqMath.IsLess( ( time() - victim.Data.LastHit.Time ), 10 ) )
			{
				local player = SqPlayer.FindPlayer( victim.Data.LastHit.Player );
				if( player )
				{
					if( player.ID != killer.ID )
					{
						player.Data.Stats.Cash += 200;

						player.Msg( TextColor.InfoS, Lang.KillReward2[ player.Data.Language ], TextColor.InfoS, victim.Name );

						SqCast.MsgKillDeath( TextColor.Kill, Lang.KillMessage2, killer.Name, TextColor.Kill, player.Name, TextColor.Kill, victim.Name, TextColor.Kill, SqWeapon.GetCustomWeaponName( killer, reason ), SqDM.GetBodyPartName( bodypart ), victim.Pos.DistanceTo( killer.Pos ) );
					
						SqCast.EchoMessage( format( "**%s** + **%s** killed **%s**. **[%s] [%s] [%.4fm]**", killer.Name, player.Name, victim.Name, SqWeapon.GetCustomWeaponName( killer, reason ), SqDM.GetBodyPartName( bodypart ), victim.Pos.DistanceTo( killer.Pos ) ) );
					
						SqCast.senClientDataToPlayer( 3000, killer.Name + " + " + player.Name + ";" + reason + ";" + victim.Name + ";" + killer.Color.r + ";" + killer.Color.g + ";" + killer.Color.b + ";" + victim.Color.r + ";" + victim.Color.g + ";" + victim.Color.b );
					}
					
					else 
					{
						SqCast.MsgKillDeath( TextColor.Kill, Lang.KillMessage, killer.Name, TextColor.Kill, victim.Name, TextColor.Kill, SqWeapon.GetCustomWeaponName( killer, reason ), SqDM.GetBodyPartName( bodypart ), victim.Pos.DistanceTo( killer.Pos ) );
					
						SqCast.EchoMessage( format( "**%s** killed **%s**. **[%s] [%s] [%.4fm]**", killer.Name, victim.Name, SqWeapon.GetCustomWeaponName( killer, reason ), SqDM.GetBodyPartName( bodypart ), victim.Pos.DistanceTo( killer.Pos ) ) );
					
						SqCast.senClientDataToPlayer( 3000, killer.Name + ";" + reason + ";" + victim.Name + ";" + killer.Color.r + ";" + killer.Color.g + ";" + killer.Color.b + ";" + victim.Color.r + ";" + victim.Color.g + ";" + victim.Color.b );
					}
				}

				else 
				{
					SqCast.MsgKillDeath( TextColor.Kill, Lang.KillMessage, killer.Name, TextColor.Kill, victim.Name, TextColor.Kill, SqWeapon.GetCustomWeaponName( killer, reason ), SqDM.GetBodyPartName( bodypart ), victim.Pos.DistanceTo( killer.Pos ) );
				
					SqCast.EchoMessage( format( "**%s** killed **%s**. **[%s] [%s] [%.4fm]**", killer.Name, victim.Name, SqWeapon.GetCustomWeaponName( killer, reason ), SqDM.GetBodyPartName( bodypart ), victim.Pos.DistanceTo( killer.Pos ) ) );
				
					SqCast.senClientDataToPlayer( 3000, killer.Name + ";" + reason + ";" + victim.Name + ";" + killer.Color.r + ";" + killer.Color.g + ";" + killer.Color.b + ";" + victim.Color.r + ";" + victim.Color.g + ";" + victim.Color.b );
				}
			}
			else 
			{
				SqCast.MsgKillDeath( TextColor.Kill, Lang.KillMessage, killer.Name, TextColor.Kill, victim.Name, TextColor.Kill, SqWeapon.GetCustomWeaponName( killer, reason ), SqDM.GetBodyPartName( bodypart ), victim.Pos.DistanceTo( killer.Pos ) );
			
				SqCast.EchoMessage( format( "**%s** killed **%s**. **[%s] [%s] [%.4fm]**", killer.Name, victim.Name, SqWeapon.GetCustomWeaponName( killer, reason ), SqDM.GetBodyPartName( bodypart ), victim.Pos.DistanceTo( killer.Pos ) ) );
				
				SqCast.senClientDataToPlayer( 3000, killer.Name + ";" + reason + ";" + victim.Name + ";" + killer.Color.r + ";" + killer.Color.g + ";" + killer.Color.b + ";" + victim.Color.r + ";" + victim.Color.g + ";" + victim.Color.b );
			}
		}

		else 
		{
			SqCast.MsgKillDeath( TextColor.Kill, Lang.KillMessage, killer.Name, TextColor.Kill, victim.Name, TextColor.Kill, SqWeapon.GetCustomWeaponName( killer, reason ), SqDM.GetBodyPartName( bodypart ), victim.Pos.DistanceTo( killer.Pos ) );
		
			SqCast.EchoMessage( format( "**%s** killed **%s**. **[%s] [%s] [%.4fm]**", killer.Name, victim.Name, SqWeapon.GetCustomWeaponName( killer, reason ), SqDM.GetBodyPartName( bodypart ), victim.Pos.DistanceTo( killer.Pos ) ) );
		
			SqCast.senClientDataToPlayer( 3000, killer.Name + ";" + reason + ";" + victim.Name + ";" + killer.Color.r + ";" + killer.Color.g + ";" + killer.Color.b + ";" + victim.Color.r + ";" + victim.Color.g + ";" + victim.Color.b );		
		}
	}
		
	if( victim.Data.IsEditing.tolower().find( "object" ) >= 0 ) SqObj.CancelEditing( victim );
	if( victim.Data.IsEditing.tolower().find( "Pickup" ) >= 0 ) SqPick.CancelEditing( victim );
	
	if( victim.Data.Job.rawin( "Pizza" ) )
	{
		victim.Data.Job[ "Pizza" ].Stock = 0;
		
		victim.Msg( TextColor.Error, Lang.LosePizza[ victim.Data.Language ] );
		
		SqJob.RemoveAllPizzaPickup( victim );
	}

	if( killer.Data.InEvent == "DM" ) 
	{
		killer.Health += 5;

		if( killer.Data.CurrentStats.Spree % 5 == 0 ) killer.Health += 10;

		if( killer.Health > 100 ) killer.Health = 100;
	}
	/*if( victim.Data.IsEvent )
	{
		if( victim.Data.IsEvent.Event == "AD" )
		{

			if( SqMath.IsLess( SqAD.GetTeamPlayer( "red" ), 1 ) ) SqAD.EndRound( 3 );
			if( SqMath.IsLess( SqAD.GetTeamPlayer( "blue" ), 1 ) ) SqAD.EndRound( 2 );
		}
	}*/
	SqEvents.CheckWaterFightEvent( victim );
});
