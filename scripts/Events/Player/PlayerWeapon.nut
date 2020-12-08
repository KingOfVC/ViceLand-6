SqCore.On().PlayerWeapon.Connect( this, function( player, old, new )
{
	local weapon = player.Data.Player.Weapons;
		
	if( weapon.rawin( new.tostring() ) )
	{
		if( weapon[ new.tostring() ].Mode.find( "Replace" ) >= 0 ) player.SetWeapon( split( weapon[ new.tostring() ].Mode, ":")[1].tointeger(), 9999 );
	}

	if( SqWorld.GetPrivateWorld( player.World ) && new == 33 ) player.SetWeapon( 33, 0 );

	if( ( player.Data.InEvent == "DM" ) && ( new == 33 || new == 30 || new == 101 || new == 107 ) ) player.SetWeapon( new, 0 );

	if( player.Data.Settings.Hud == "1" )
	{
		player.StreamInt( 304 );
		player.StreamString( new + "/" + SqWeapon.GetCustomWeaponName2( player, new ) );
		player.FlushStream( true );
	}
});
