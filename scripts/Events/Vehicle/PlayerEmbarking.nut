SqCore.On().PlayerEmbarking.Connect(this, function ( player, vehicle, slot )
{	
	if( SqVehicles.Vehicles[ vehicle.Tag ].Prop.Locked && SqVehicles.Vehicles[ vehicle.Tag ].Prop.Owner != player.Data.AccID )
	{
		player.Msg( TextColor.Error, Lang.VehLocked[ player.Data.Language ] )
		SqCore.SetState( 0 );
	}
	
	if( SqVehicles.Vehicles[ vehicle.Tag ].Prop.Name == "VL-Pizzateria" && !player.Data.Job.rawin( "Pizza" ) ) SqCore.SetState( 0 );

	else SqCore.SetState( 1 );
	
});
