class CCmdObject
{
	Cmd       = null;
	
	AddObj    = null;
	EditObj   = null;
	FindObj   = null;
	
	constructor( instance )
	{
		this.Cmd = instance;
		
		this.Cmd.BindFail( this, this.funcFailCommand );
		
		this.AddObj  = this.Cmd.Create("addobject", "i", [ "Model" ], 1, 1, -1, true, true );
		this.EditObj = this.Cmd.Create("editobject", "i", [ "ID" ], 1, 1, -1, true, true );
		this.FindObj = this.Cmd.Create("findobject", "f", [ "Radius" ], 1, 1, -1, true, true );

		this.AddObj.BindExec( this.AddObj, this.funcAddObj );
		this.EditObj.BindExec( this.EditObj, this.funcEditObj );
		this.FindObj.BindExec( this.FindObj, this.funcFindObj );
		
	}
	
	function funcFailCommand( type, msg, payload )
	{
		local player = this.Cmd.Invoker, cmd = this.Cmd.Command;

		switch( type )
		{
			case SqCmdErr.IncompleteArgs:
			case SqCmdErr.UnsupportedArg:
			switch( cmd )
			{
				case "addobject":
				return player.Msg( Colour.Red, Lang.ObjAddSyntax[ player.Data.Language ] );
				
				case "editobject":
				return player.Msg( Colour.Red, Lang.ObjEditSyntax[ player.Data.Language ] );
			
				case "findobject":
				return player.Msg( Colour.Red, Lang.ObjFindSyntax[ player.Data.Language ] );
			}
			
			case SqCmdErr.UnsupportedArg:
			switch( cmd )
			{
				case "addobject":
				return player.Msg( Colour.Red, Lang.ObjAddNotInt[ player.Data.Language ] );
				
				case "editobject":
				return player.Msg( Colour.Red, Lang.ObjEditNotInt[ player.Data.Language ] );
			
				case "findobject":
				return player.Msg( Colour.Red, Lang.ObjFindNotInt[ player.Data.Language ] );
			}
		}
	}
	
	function funcAddObj( player, args )
	{
		if( player.Data.IsEditing == "" )
		{
			local

			getPos = Vector3( ( player.PosX + 2 ), ( player.PosY + 2 ), ( player.PosZ + 1 ) ),
			object = SqObject.Create( args.Model, player.World, getPos, 255 );
			
			object.SetTag( "Object:" + SqHash.GetMD5( "" + time() ) );			
			object.ShotReport  = true;
			object.Data        = CObject( object );
			object.Data.Register( object.Tag, player.Name );
			object.Data.IsEditing = true;
			object.Alpha = 150;
			
			player.Data.IsEditing = "Object:" + object.ID;
			player.Msg( Colour.Green, Lang.ObjAdded[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.ObjCurrentEditing[ player.Data.Language ] );
		
		return true;
	}
	
	function funcEditObj( player, args )
	{
		if( player.Data.IsEditing == "" )
		{
			if( SqFind.Object.WithID( args.ID ).tostring() != "-1" )
			{
				local object = SqFind.Object.WithID( args.ID );
				if( object.World == player.World )
				{
					if( !object.Data.IsEditing )
					{
						player.Data.IsEditing = "Object:" + object.ID;
						player.Msg( Colour.Green, Lang.ObjEditing[ player.Data.Language ] );
						object.Alpha = 150;
						object.Data.IsEditing = true;
					}
					else player.Msg( Colour.Red, Lang.ObjSomeoneEdit[ player.Data.Language ] );
				}
				else player.Msg( Colour.Red, Lang.ObjIDNotFound[ player.Data.Language ] );
			}
			else player.Msg( Colour.Red, Lang.ObjIDNotFound[ player.Data.Language ] );
		}
		else player.Msg( Colour.Red, Lang.ObjCurrentEditing[ player.Data.Language ] );
		
		return true;
	}
	
	function funcFindObj( player, args )
	{
		local result = null;
		SqForeach.Object.Active(this, function(Object)
		{
			if( Object.Pos.DistanceTo(  player.Pos ) < args.Radius )
			{
				if( result ) result = result + ", " + Object.Model + " [" + Object.ID + "]"; 
				else result = Object.Model + " [" + Object.ID + "]"; 
			}
		});
		
		if( result ) player.Msg( Colour.Green, Lang.ObjFind[ player.Data.Language ], result );
		else player.Msg( Colour.Red, Lang.ObjNotFound[ player.Data.Language ] );
		
		return true;
	}
}