SqCore.On().VehicleRespawn.Connect( this, function( vehicle )
{
	try 
	{
		if( SqVehicles.Vehicles.rawin( vehicle.Tag ) )
		{
			local getVeh = SqVehicles.Vehicles[ vehicle.Tag ];

			if( SqFind.Vehicle.WithID( vehicle.ID ) )
			{
				vehicle.Pos 			= getVeh.SpawnData.Pos;
				vehicle.EulerRotation	= getVeh.SpawnData.Rotation;

				if( getVeh.Prop.Owner != 1000 && getVeh.SpawnData.World != vehicle.World ) vehicle.World = getVeh.SpawnData.World;
				if( getVeh.SpawnData.Armour == 2000 && SqFind.Vehicle.WithID( vehicle.ID ) ) vehicle.Health += 1000;
			}
		}
	}
	catch( _ ) _;
});