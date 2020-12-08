class CKeybind
{
	Keybind = {}

	function constructor()
	{
		local result = SqDatabase.Query("SELECT * FROM Vehicles");
		
	/*	while( result.Step() ) 
		{
			Keybind.rawset( result.GetString( "Type" ), 
			{
				VitualKey = result.GetString( "Key" ),
			});
		}*/
	}

	function Load() 
	{
		foreach( index, value in this.Keybind )
		{
			local key = SqKeybind.Create( true, value.VitualKey, 0, 0 );
			key.SetTag( index );
		}
	}

}