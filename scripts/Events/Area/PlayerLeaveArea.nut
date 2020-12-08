SqCore.On().PlayerLeaveArea.Connect(this, function(player, area) 
{
    player.Data.Area = null;
});
