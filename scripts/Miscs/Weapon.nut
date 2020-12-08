SqWeapon <-
{
	function InitCustomWeaponName()
	{
		foreach( weapon in CustomWeapon ) SetWeaponName( weapon.ID, weapon.Weapon );
	}
	
	function GivePlayerSpawnwep( player )
	{
		local weapon = player.Data.Player.Weapons;
		
		foreach( index, value in weapon )
		{
			if( value.Spawnwep == "true" ) 
			{
				if( IsWeaponValid( index.tointeger() ) )
				{
					if( index == "30" || index == "12" || index == "13" || index == "14" || index == "15" ) player.SetWeapon( index.tointeger(), 20 );
					else player.SetWeapon( index.tointeger(), 9999 );
				}
			}
		}
	}

	function UpdatePlayerSpawnwep( player, wep, state )
	{
		local weapon = player.Data.Player.Weapons;
		
		if( !weapon.rawin( wep.tostring() ) ) player.Data.InsertWeapon( wep, state )
		else weapon[ wep.tostring() ].Spawnwep = state;
	}

	function UpdateName( player, wep, new )
	{
		local weapon = player.Data.Player.Weapons;
		
		if( !weapon.rawin( wep.tostring() ) ) 
		{
			player.Data.InsertWeapon( wep, false );
			weapon[ wep.tostring() ].Name = new;
		}
		else weapon[ wep.tostring() ].Name = new;
	}
	
	function UpdatePlayerKill( player, wep )
	{
		local weapon = player.Data.Player.Weapons;
		
		if( !weapon.rawin( wep.tostring() ) ) player.Data.InsertWeapon( wep );
		else weapon[ wep.tostring() ].Kill = ( weapon[ wep.tostring() ].Kill.tointeger() + 1 ).tostring();
	}
	
	function GetValidAmmoRange( value )
	{
		if( SqMath.IsLess( value, 9999 ) ) return true;
		if( SqMath.IsGreaterEqual( value, 1 ) ) return true;
		
		else return false;
	}

	function GetCustomWeaponName( player, wep )
	{
		local weapon = player.Data.Player.Weapons;

		if( !weapon.rawin( wep.tostring() ) ) return GetWeaponName( wep );
		else return weapon[ wep.tostring() ].Name;
	}

	function IsWeaponReplaced( player, wep, new )
	{
		local weapon = player.Data.Player.Weapons;

		if( !weapon.rawin( wep.tostring() ) ) 
		{
			player.Data.InsertWeapon( wep );

			return true;
		}

		else 
		{
			if( weapon[ wep.tostring() ].Mode.find( "Replace:" + new ) >= 0 ) return false;
			else return true;
		}
	}

	function ReplaceOrRemoveWeaponSlot( player, wep, new = null )
	{
		local weapon = player.Data.Player.Weapons;
		
		if( !weapon.rawin( wep.tostring() ) ) 
		{
			player.Data.InsertWeapon( wep, false );

			if( new ) player.Data.Player.Weapons[ wep.tostring() ].Mode = "Replace:" + new;
			else player.Data.Player.Weapons[ wep.tostring() ].Mode = "none";
		}

		else 
		{
			if( new ) player.Data.Player.Weapons[ wep.tostring() ].Mode = "Replace:" + new;
			else player.Data.Player.Weapons[ wep.tostring() ].Mode = "none";
		}
	}

	function GetValidWeaponID( id )
	{
		if( SqMath.IsGreater( id, 0 ) && SqMath.IsLess( id, 34 ) ) return true;
		if( SqMath.IsGreater( id, 99 ) && SqMath.IsLess( id, 109 ) ) return true;
		
		else return false;
	}

	function GetCustomWeaponName2( player, wep )
	{
		local weapon = player.Data.Player.Weapons;

		if( !weapon.rawin( wep.tostring() ) ) return "nullx";
		else 
		{
			if( weapon[ wep.tostring() ].Name == GetWeaponName( wep ) ) return "nullx";

			else return weapon[ wep.tostring() ].Name;
		}
	}
}

CustomWeapon <-
[
	{ "Weapon": "AK-47", "ID": 100 },
	{ "Weapon": "Magpul Masada", "ID": 101 },
	{ "Weapon": "M249", "ID": 102 },
	{ "Weapon": "Deagle", "ID": 103 },
	{ "Weapon": "Shitgun", "ID": 104 },
	{ "Weapon": "Tomgun", "ID": 105 },
	{ "Weapon": "RSASS", "ID": 106 },
	{ "Weapon": "P90", "ID": 107 },
	{ "Weapon": "M4", "ID": 108 },
]