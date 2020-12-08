SqCore.On().PlayerEnterArea.Connect(this, function(player, area) 
{
    player.Data.Area = area;
});
