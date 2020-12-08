SqCore.On().PlayerEmbarked.Connect(this, function ( player, vehicle, slot )
{	
	local getVeh = SqVehicles.Vehicles[ vehicle.Tag ];
	
	if( getVeh.Prop.Owner == player.Data.AccID && slot == 0 && getVeh.Prop.Radio =="off" && getVeh.Prop.RadioURL != "N/A" )
	{
		getVeh.SpawnData.Vehicle.Radio = ( 15 + player.ID );
		SqServer.CreateRadioStreamEx( ( 15 + player.ID ), true, player.Name, getVeh.Prop.RadioURL );
	}
});