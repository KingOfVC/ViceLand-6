/* ------------------------------------------------------------------------------------------------
 * Enumeration used to have a standard set of user authority levels across the script.
*/
enum IrcAuthority
{
    // Unregistered user with least privileges
    Guest = 0,
    // Registered user with normal privileges
    User = 1,
    // Regular user with high visits and activity
    Addict = 2,
    // Regular user with bonus features and privileges
    Subscriber = 3,
    // First level of staff with minimal privileges
    Intern = 4,
    // Second level of staff with moderate privileges
    Moderator = 5,
    // Third level of staff with maximum privileges
    Administrator = 6,
    // Highest privileged user with access to everything
    SystemOperator = 7
}

/* ------------------------------------------------------------------------------------------------
 * Class responsible for managing an IRC session session.
*/
class MyIRC extends SqIRC.Session
{
    /* --------------------------------------------------------------------------------------------
     * List of people who can send commands.
    */
    m_Staff = null;

    /* --------------------------------------------------------------------------------------------
     * Base constructor.
    */
    function constructor(name)
    {
        // Validate the name
        if (typeof(name) != "string")
        {
            SqLog.Err("Unknown or unsupported argument type");
            SqLog.Inf("=> Expected: (string) Got: (%s)", typeof(name));
            // Construction failed
            throw "Invalid IRC session name";
        }
        // Forward the call to the base session constructor.
        base.constructor();
        // Tell the session to clean the nicks before giving them to us
        base.SetOption(SqIrcOpt.StripNicks);
        // Bind to the session events
        base.Bind(SqIrcEvent.Connect,       this, onConnect);
        base.Bind(SqIrcEvent.Nick,          this, onNick);
        base.Bind(SqIrcEvent.Quit,          this, onQuit);
        base.Bind(SqIrcEvent.Join,          this, onJoin);
        base.Bind(SqIrcEvent.Part,          this, onPart);
        base.Bind(SqIrcEvent.Mode,          this, onMode);
        base.Bind(SqIrcEvent.Umode,         this, onUmode);
        base.Bind(SqIrcEvent.Topic,         this, onTopic);
        base.Bind(SqIrcEvent.Kick,          this, onKick);
        base.Bind(SqIrcEvent.Channel,       this, onChannel);
        base.Bind(SqIrcEvent.PrivMsg,       this, onPrivMsg);
        base.Bind(SqIrcEvent.Notice,        this, onNotice);
        base.Bind(SqIrcEvent.ChannelNotice, this, onChannelNotice);
        base.Bind(SqIrcEvent.Invite,        this, onInvite);
        //base.Bind(SqIrcEvent.CtcpReq,       this, onCtcpReq);
        //base.Bind(SqIrcEvent.CtcpRep,       this, onCtcpRep);
        //base.Bind(SqIrcEvent.CtcpAction,    this, onCtcpAction);
        base.Bind(SqIrcEvent.Unknown,       this, onUnknown);
        base.Bind(SqIrcEvent.Numeric,       this, onNumeric);
        // Save the name used in identifying where the output came from.
        this.Tag = name;
        // Initialize the staff to an empty table
        m_Staff = { /* ... */ };
    }

    function onConnect(event, origin, params)
    {
        // Specify that the IRC session was successfully connected
        SqLog.Scs(SqStr.Center('-', 72, " IRC CONNECTED "));
        // Output various other information about the connection
    /*    SqLog.Inf("Server:  %s:%d", this.Server, this.Port);
        SqLog.Inf("Nick:    %s", this.Nick);
        SqLog.Inf("User:    %s", this.User);
        SqLog.Inf("Name:    %s", this.Name);*/
        // Now that we're connected to a network we can join channels
        if (base.CmdJoin("#chakke", "tumama") != 0)
        {
            SqLog.Err("Unable to join channel: %s", session.ErrStr); 
        }
    }

    function onNick(event, origin, params)
    {
        SqLog.Inf("%s is now known as %s", origin, params[0]);
    }

    function onQuit(event, origin, params)
    {
        if (params.len() >= 1)
        {
            SqLog.Inf("%s has quit (%s)", origin, params[0]);
        }
        else
        {
            SqLog.Inf("%s has quit", origin);
        }
    }

    function onJoin(event, origin, params)
    {
        SqLog.Inf("%s joined %s", origin, params[0]);
    }

    function onPart(event, origin, params)
    {
        if (params.len() >= 2)
        {
            SqLog.Inf("%s left %s (%s)", origin, params[0], params[1]);
        }
        else
        {
            SqLog.Inf("%s left %s (Leaving...)", origin, params[0]);
        }
    }

    function onMode(event, origin, params)
    {
        if (params.len() >= 2)
        {
            SqLog.Inf("%s set modes %s on %s", origin, params[1], params[0]);
        }
        else
        {
            SqLog.Inf("%s changed modes on %s", origin, params[0]);
        }
    }

    function onUmode(event, origin, params)
    {
        if (params.len() >= 2)
        {
            SqLog.Inf("%s set modes %s for %s", origin, params[1], this.Nick);
        }
        else
        {
            SqLog.Inf("%s changed modes for %s", origin, this.Nick);
        }
    }

    function onTopic(event, origin, params)
    {
        SqLog.Inf("%s changed topic on %s", origin, params[0]);
        // Show the topic if one was specified
        if (params.len() >= 2)
        {
            SqLog.Inf("New topic is: %s", origin, params[1]);
        }
    }

    function onKick(event, origin, params)
    {
        if (params.len() >= 3)
        {
            SqLog.Inf("%s kicked %s from %s (%s)", origin, params[1], params[0], params[2]);
        }
        else if (params.len() >= 2)
        {
            SqLog.Inf("%s kicked %s from %s", origin, params[1], params[0]);
        }
        else
        {
            SqLog.Inf("%s kicked someone from %s", origin, params[0]);
        }
    }

    function onChannel(event, origin, params)
    {
        if (params.len() >= 1)
        {
            // Is this a command?
            if (params[1][0] == '.')
            {
                g_Ircmd.Run({"origin" : origin, "channel" : params[0]}, params[1].slice(1));
            }
            else
            {
           //     SqLog.Inf("%s said on %s : %s", origin, params[0], params[1]);
            }
        }
        else
        {
          //  SqLog.Inf("%s said something on %s", origin, params[0]);
        }
    }

    function onPrivMsg(event, origin, params)
    {
        if (params.len() >= 1)
        {
            // Is this a command?
            if (params[1][0] == '.')
            {
                g_Ircmd.Run({"origin" : origin, "channel" : origin}, params[1].slice(1));
            }
            else
            {
                SqLog.Inf("%s said to %s : %s", origin, params[0], params[1]);
            }
        }
        else
        {
            SqLog.Inf("%s said something to %s", origin, params[0]);
        }
    }

    function onNotice(event, origin, params)
    {
        if (params.len() >= 1)
        {
            SqLog.Inf("%s sent notice to %s : %s", origin, params[0], params[1]);
        }
        else
        {
            SqLog.Inf("%s sent a notice to %s", origin, params[0]);
        }
    }

    function onChannelNotice(event, origin, params)
    {
        if (params.len() >= 1)
        {
            SqLog.Inf("%s sent notice on %s : %s", origin, params[0], params[1]);
        }
        else
        {
            SqLog.Inf("%s sent a notice on %s", origin, params[0]);
        }
    }

    function onInvite(event, origin, params)
    {
        if (params.len() >= 2)
        {
            SqLog.Inf("%s invited %s on %s" origin, params[0], params[1]);
        }
        else
        {
            SqLog.Inf("%s invited %s" origin, params[0]);
        }
    }

    function onCtcpReq(event, origin, params)
    {
        // Not yet implemented...
    }

    function onCtcpRep(event, origin, params)
    {
        // Not yet implemented...
    }

    function onCtcpAction(event, origin, params)
    {
        // Not yet implemented...
    }

    function onUnknown(event, origin, params)
    {
        //SqLog.Inf("Unknown event received from %s" origin);
    }

    function onNumeric(event, origin, params)
    {
        switch (event)
        {
            case SqIrcRFC.RPL_CHANNELMODEIS:
            {
                print("Received RPL_CHANNELMODEIS from server");
                foreach (idx, val in params)
                {
                    printf("=> Arg %d contains: '%s'", idx, val);
                }
            } break;
            case SqIrcRFC.RPL_UMODEIS:
            {
                print("Received RPL_UMODEIS from server");
                foreach (idx, val in params)
                {
                    printf("=> Arg %d contains: '%s'", idx, val);
                }
            } break;
        }
    }

    // Staff list
    function SetStaff(name, level)
    {
        m_Staff.rawset(name.tostring(), level.tointeger());
    }

    function GetStaff(name)
    {
        name  = name.tostring();

        if (m_Staff.rawin(name))
        {
            return m_Staff.rawget(name);
        }

        return IrcAuthority.Guest;
    }

    function RemoveStaff(name)
    {
        name  = name.tostring();

        if (m_Staff.rawin(name))
        {
            n_Staff.rawdelete(name);
        }
    }
}



// Create an uninitialized instance of our IRC manager
g_Irc <- MyIRC("SquirrelBot");



/* ------------------------------------------------------------------------------------------------
 * The main IRC related command manager.
*/
g_Ircmd <- SqCmd.Manager();

/* ------------------------------------------------------------------------------------------------
 * Bind a function to handle command errors.
*/
g_Ircmd.BindFail(this, function(type, msg, payload) {
    // Retrieve the origin of the invocation
    local origin = g_Ircmd.Invoker.origin;
    // See if the invoker even exists
    if (typeof(origin) != "string" || origin.len() <= 0)
    {
        return; // No one to report!
    }
    // Identify the error type
    switch (type)
    {
        // The command failed for unknown reasons
        case SqCmdErr.Unknown:
        {
            g_Irc.CmdMsg(origin, "Unable to execute the command for reasons unknown");
            g_Irc.CmdMsg(origin, "=> Please contact the owner: no_email@to.me");
        } break;
        // The command failed to execute because there was nothing to execute
        case SqCmdErr.EmptyCommand:
        {
            g_Irc.CmdMsg(origin, "Cannot execute an empty command");
        } break;
        // The command failed to execute because the command name was invalid after processing
        case SqCmdErr.InvalidCommand:
        {
            g_Irc.CmdMsg(origin, "The specified command name is invalid");
        } break;
        // The command failed to execute because there was a syntax error in the arguments
        case SqCmdErr.SyntaxError:
        {
            g_Irc.CmdMsg(origin, "There was a syntax error in one of the command arguments");
        } break;
        // The command failed to execute because there was no such command
        case SqCmdErr.UnknownCommand:
        {
            g_Irc.CmdMsg(origin, "The specified command does no exist");
        } break;
        // The command failed to execute because the it's currently suspended
        case SqCmdErr.ListenerSuspended:
        {
            g_Irc.CmdMsg(origin, "The requested command is currently suspended");
        } break;
        // The command failed to execute because the invoker does not have the proper authority
        case SqCmdErr.InsufficientAuth:
        {
            g_Irc.CmdMsg(origin, "You don't have the proper authority to execute this command");
        } break;
        // The command failed to execute because there was no callback to handle the execution
        case SqCmdErr.MissingExecuter:
        {
            g_Irc.CmdMsg(origin, "The specified command is not being processed");
        } break;
        // The command was unable to execute because the argument limit was not reached
        case SqCmdErr.IncompleteArgs:
        {
            g_Irc.CmdMsgF(origin, "The specified command requires at least %d arguments", payload);
        } break;
        // The command was unable to execute because the argument limit was exceeded
        case SqCmdErr.ExtraneousArgs:
        {
            g_Irc.CmdMsgF(origin, "The specified command can allows up to %d arguments", payload);
        } break;
        // Command was unable to execute due to argument type mismatch
        case SqCmdErr.UnsupportedArg:
        {
            g_Irc.CmdMsgF(origin, "Argument %d requires a different type than the one you specified", payload);
        } break;
        // The command arguments contained more data than the internal buffer can handle
        case SqCmdErr.BufferOverflow:
        {
            g_Irc.CmdMsg(origin, "An internal error occurred and the execution was aborted");
            g_Irc.CmdMsg(origin, "=> Please contact the owner: no_email@to.me");
        } break;
        // The command failed to complete execution due to a runtime exception
        case SqCmdErr.ExecutionFailed:
        {
            g_Irc.CmdMsg(origin, "The command failed to complete the execution properly");
            g_Irc.CmdMsg(origin, "=> Please contact the owner: no_email@to.me");
        } break;
        // The command completed the execution but returned a negative result
        case SqCmdErr.ExecutionAborted:
        {
            g_Irc.CmdMsg(origin, "The command execution was aborted and therefore had no effect");
        } break;
        // The post execution callback failed to execute due to a runtime exception
        case SqCmdErr.PostProcessingFailed:
        {
            g_Irc.CmdMsg(origin, "The command post-processing stage failed to complete properly");
            g_Irc.CmdMsg(origin, "=> Please contact the owner: no_email@to.me");
        } break;
        // The callback that was supposed to deal with the failure also failed due to a runtime exception
        case SqCmdErr.UnresolvedFailure:
        {
            g_Irc.CmdMsg(origin, "Unable to resolve the failures during command execution");
            g_Irc.CmdMsg(origin, "=> Please contact the owner: no_email@to.me");
        } break;
        // Something bad happened and no one knows what
        default:
            g_Irc.CmdMsgF(origin, "Command failed to execute because [%s]", msg);
    }
});

/* ------------------------------------------------------------------------------------------------
 * Bind a function to handle command authority inspection.
*/
g_Ircmd.BindAuth(this, function(invoker, command) {
    // Is the command something that we can check against?
    if (typeof(command) != "SqCmdListener")
    {
        return true; // Not our kind? Not our problem!
    }
    // The specified invoker must be a table with 2 elements 'origin' and 'channel'
    else if (typeof(invoker) != "table" || !invoker.rawin("origin") || !invoker.rawin("channel"))
    {
        return false; // Missing information
    }
    // Is the specified invoker something of a known type?
    else if (typeof(invoker.origin) != "string" || typeof(invoker.channel) != "string")
    {
        return false; // What is this thing?
    }
    // Use the default authority system to make the call
    return (g_Irc.GetStaff(invoker.origin) >= command.Authority);
});



/* ------------------------------------------------------------------------------------------------
 * Global table used to scope IRC commands.
*/
_Ircmd <- { /* ... */ }


/* ------------------------------------------------------------------------------------------------
 * Evaluate a piece of code on the server.
*/
_Ircmd.Eval <- g_Ircmd.Create("eval", "g", ["code"], 1, 1, IrcAuthority.SystemOperator, true, true);

// ------------------------------------------------------------------------------------------------
_Ircmd.Eval.Help = "Evaluate the specified code";

// ------------------------------------------------------------------------------------------------
_Ircmd.Eval.BindExec(_Ircmd.Eval, function(invoker, args)
{
    // Attempt to compile and execute the specified code
    try
    {
        ::compilestring(args.code)();
    }
    catch (e)
    {
        g_Irc.CmdMsg(invoker.origin, e.tostring());
    }
    // Specify that this command was successfully executed
    return true;
});



/* ------------------------------------------------------------------------------------------------
 * Say a certain message on the server.
*/
_Ircmd.Say <- g_Ircmd.Create("say", "g", ["text"], 1, 1, 0, true, true);

// ------------------------------------------------------------------------------------------------
_Ircmd.Say.Help = "Say the specified message";

// ------------------------------------------------------------------------------------------------
_Ircmd.Say.BindExec(_Ircmd.Say, function(invoker, args)
{
    try 
    {
        local getData = json_decode( args.text ), getText = "";

        if( getData.User.find( "Echo" ) >= 0 ) return;

        if( getData.Text.find( "players" ) >= 0 )
        {
            local result = null, getCount = 0;
            SqForeach.Player.Active( this, function( target ) 
            {
                if( result ) result = result + ", " + target.Name;
                else result = target.Name;

                getCount ++;
            });

            if( result ) SqCast.EchoMessage( format( "**Players online** %s", result ) ), SqCast.EchoMessage( format( "**Total players** %d", getCount ) )
            else SqCast.EchoMessage( format( "**No player online T_T**" ) );
        }

        else SqCast.MsgAll( TextColor.Info, Lang.onDiscordChat, HexColour.White, StripIRCCol( getData.User ), getData.Text );
    }
    catch( _ ) _;

    return true;
});

function StripIRCCol( text )
{
    try {
    local a, z = text.len(), l;
    local coltrig = false, comtrig = false, num = 0, output = "";
    for ( a = 0; a < z; a++ )
    {
        l = text[ a ];
        if ( l == 3 ) { coltrig = !coltrig; num = 0; comtrig = false; }
        else if ( coltrig && num < 2 && l < 58 && 47 < l ) { num++; }
        else if ( coltrig && !comtrig && l == 44 ) { comtrig = true; num = 0; }
        else { num = 2; comtrig = false; output += l.tochar(); }
    }
    return output;
    }
    catch(e) return text;
}
/* ------------------------------------------------------------------------------------------------
 * Say a certain message on the server with the /me command.
*/
_Ircmd.Me <- g_Ircmd.Create("me", "g", ["text"], 1, 1, IrcAuthority.Moderator, true, true);

// ------------------------------------------------------------------------------------------------
_Ircmd.Me.Help = "Say the specified /me message";

// ------------------------------------------------------------------------------------------------
_Ircmd.Me.BindExec(_Ircmd.Me, function(invoker, args)
{
        // Say the message back to to the origin
        g_Irc.CmdMe(invoker.channel, args.text);
        // Specify that this command was successfully executed
        return true;
});



/* ------------------------------------------------------------------------------------------------
 * Retrieve the modes of a certain user or channel.
*/
_Ircmd.Mode <- g_Ircmd.Create("mode", "s", ["name"], 1, 1, IrcAuthority.User, true, true);

// ------------------------------------------------------------------------------------------------
_Ircmd.Mode.Help = "Retrieve the modes of a user or channel";

// ------------------------------------------------------------------------------------------------
_Ircmd.Mode.BindExec(_Ircmd.Mode, function(invoker, args)
{
        // Say the raw MODE <#channel/nick> command to retrieve the modes of a user/channel
        g_Irc.SendRaw("MODE " + args.name);
        // Specify that this command was successfully executed
        return true;
});