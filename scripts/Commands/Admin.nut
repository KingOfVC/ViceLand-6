SqCommand.Create("e", "g", ["code"], 1, 1, -1, true).BindExec(this, function (player, args)
{
    try
    {
        local script = compilestring(args[0]);
        if(script)
        {
            script();
            player.Msg(Colour.Green, "Code [ %s ] executed.", args[0]);
        }
    }
    catch(e)
    {
        player.Msg(Colour.Red, "Code failed to execute, error thrown below.");
        player.Msg(Colour.Red, e);
    }

    return true;
});

SqCommand.Create("addcar", "i|i|i", ["Model", "Color1", "Color2"], 1, 3, -1, true, true ).BindExec(this, function (player, args)
{
	local color = null, color2 = null;
	if( args.rawin("Color1") ) color = args.Color1, color2 = args.Color2; 
	else color = (rand()%96), color2 = color;
	SqVehicle.Create( args.Model, 0, player.Pos, player.Angle, color, color2 ); 



});

SqCommand.Create("savecar", "g", ["code"], 0, 0, -1, true).BindExec(this, function (player, args)
{
	SqDatabase.InsertF("INSERT INTO Vehicle ( Model, Pos, Angle, Col1, Col2 ) VALUES ( '%d', '%s', '%s', '%d', '%d' );", player.Vehicle.Model, player.Vehicle.Pos.tostring(), player.Vehicle.EulerRotation.tostring(), player.Vehicle.LastPrimaryColor, player.Vehicle.LastSecondaryColor );



});