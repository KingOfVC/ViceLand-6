SqCore.On().PlayerHealth.Connect(this, function (player, old, new )
{
	if( old > new ) player.Data.Cooldown = time();
});