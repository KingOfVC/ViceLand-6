class CHandler
{
	Handlers = null;

	function constructor()
	{
		this.Handlers = {};
	}

	function Create( Key, Handler )
	{
		this.Handlers.rawset( Key, Handler );
	}

	function Get( Key )
	{
		return this.Handlers.rawget( Key );
	}

	function Remove( Key )
	{
		this.Handlers.rawdelete( Key );
	}
}