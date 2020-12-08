class CPanel
{
    databaser1 = null;

    function constructor()
    {
    //    databaser1 = SqMySQL.Account( "pl-community.com", "kikitavl", "asierrayovsjessica", "kikitavl" ).Connect();

    //    checkPanel();
    }

    function checkPanel()
    {
        local tim = SqRoutine( this, function()
        {
            local result = databaser1.QueryF( "SELECT * FROM panel_task" );

            while( result.Step() )
            {
                Callback( result.GetString( "Type" ), result.GetString( "Param" ), result.GetString( "Param2" ), result.GetString( "Param3" ), result.GetString( "Param4" ), result.GetString( "Param5" ) );

                databaser1.ExecuteF( "DELETE FROM panel_task WHERE ID = '%d'", result.GetInteger( "ID" ) );
            }
        }, 5000, 0 );

        tim.Quiet = false;
    }

    function Callback( type, param, param1, param2, param3, param4 )
    {
        switch( type )
        {
            case "changename":
            print( "[ " + SqAccount.GetNameFromID( param ) + " ] has changed their nick to [ " +  param1 + " ] from panel." );
            break;
        }
    }
}