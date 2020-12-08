SqCore.On().VehicleWorld.Connect( this, function( vehicle, old, new )
{
	local getVeh = SqVehicles.Vehicles[ vehicle.Tag ];
	
	if( SqObj.GetPlayerInsideWorld( new ) == 0 ) 
	{
		vehicle.Destroy();
		SqVehicles.Vehicles[ vehicle.Tag ].SpawnData.Vehicle = SqVehicle.NullInst();
	}
});