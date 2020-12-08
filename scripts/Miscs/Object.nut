class SqObj
{
	function GetWorldObjectCount( world )
	{
		local getCount = 0;
		SqForeach.Object.Active(this, function(Object)
		{
			if( Object.World == world ) getCount++;
		});
		
		return getCount;
	}

	function RemoveAllObjectInWorld( world )
	{
		SqForeach.Object.Active(this, function(Object)
		{
			Object.Data.Save();
			Object.Destroy();
		});
	}
	
	function GetPlayerInsideWorld( world )
	{
		local getOldCount = 0;
		SqForeach.Player.Active(this, function(plr)
		{
			if( world == plr.World ) getOldCount ++;
		});
	}
	
	
}