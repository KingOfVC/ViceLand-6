class CPTitle extends CContext {
    Players = null;
    IsLag = false;
    TeamESP = true;
    InLobby = false;
    Team = "255";

    function constructor(Key) {
        base.constructor();

        this.Players = {};

        this.Load();
    }

    function AddPlayer(player, text) {
        local element = GUILabel();
        local element1 = GUILabel();

        element.Alpha = 255;
		element.AddFlags( GUI_FLAG_TEXT_TAGS );
        element.Text = text;
        element.TextColour = Colour(255, 255, 255);
        element.FontSize = (GUI.GetScreenSize().Y * 0.0157407407407407);
        element.TextAlignment = GUI_ALIGN_CENTER;
        element.FontFlags = GUI_FFLAG_BOLD | GUI_FFLAG_OUTLINE;

        element1.Alpha = 255;
		element1.AddFlags( GUI_FLAG_TEXT_TAGS );
        element1.Text = "";
        element1.TextColour = Colour(255, 255, 255);
        element1.FontSize = (GUI.GetScreenSize().Y * 0.0114583333333333);
        element1.TextAlignment = GUI_ALIGN_CENTER;
        element1.FontFlags = GUI_FFLAG_BOLD | GUI_FFLAG_OUTLINE;
		element1.AddFlags( GUI_FLAG_TEXT_TAGS );

        this.Players.rawset(player, {
            Element = element,
            Element1 = element1,
            Team = "0",
            HitWarn = 0,
        });
    }

    function UpdatePlayerColor(id, r, g, b, text) {
        this.Players[id].Element.TextColour = Colour(r, g, b);
        this.Players[id].Element1.Text = text;
        this.Players[id].HitWarn = 0;
    }

    function Load() {
        for (local i = 0; i < 100; i++) {
            AddPlayer(i, "");
        }
    }

    function onScriptProcess() {
        local lplayer = World.FindLocalPlayer(), sender;
        local lpos = lplayer.Position, spos;
        local lbl, lbl2, wpts, wpts2, z1 = Vector(0, 0, 0.7), z2 = Vector(0, 0, 0.9);

        foreach(index, value in this.Players) {
            if (!this.IsLag) {
                if (sender = index && World.FindPlayer(index)) {
                    if (World.FindPlayer(index).Name.find("VL-") == null) {
                        spos = Vector((sender.Position.X), sender.Position.Y, sender.Position.Z), lbl = value.Element, lbl.Alpha = 0, lbl2 = value.Element1, lbl2.Alpha = 0;

                        if (::Distance(lpos.X, lpos.Y, lpos.Z, spos.X, spos.Y, spos.Z) < 8) {
                            if (lpos.X.tointeger() != 0 && lpos.Y.tointeger() != 0) {
                                wpts = GUI.WorldPosToScreen(spos + z1);
                                wpts2 = GUI.WorldPosToScreen(spos + z2);

                                lbl.Position = VectorScreen(wpts.X, wpts.Y);
                                lbl2.Position = VectorScreen(wpts2.X, wpts2.Y);

                                local ChatBubble_PosToScreen = GUI.WorldPosToScreen(spos);
                                if (ChatBubble_PosToScreen.Z < 1) {
                                    lbl.Alpha = 255;
                                    lbl2.Alpha = 255;
                               //     lbl.Text = World.FindPlayer(index).Name;
                                   lbl.TextAlignment = GUI_ALIGN_CENTER;
                                } else {
                                    lbl.Alpha = 0;
                                    lbl2.Alpha = 0;
                                }
                            } else {
                                lbl.Alpha = 0;
                                lbl2.Alpha = 0;
                            }

                        }

                        if (sender == lplayer) {
                            lbl.Alpha = 0;
                            lbl2.Alpha = 0;
                        }
                    } else value.Element.Text = "", value.Element1.Text = "";
                } else value.Element.Text = "", value.Element1.Text = "";
            }
        }
    }

    function onServerData(type, str) {
        switch (type) {
      /*      case 2500:
                this.IsSpec = true;
                break;

            case 2501:
                this.IsSpec = false;
                break;
        */
            case 1030:
             //   local sp = split(str, ":");

            //    this.UpdatePlayerColor(sp[0].tointeger(), sp[1].tointeger(), sp[2].tointeger(), sp[3].tointeger(), sp[4]);

                local sp = split( str, ";" );
			this.UpdatePlayerColor( sp[0].tointeger(), 255, 255, 255, ( sp.len() > 1 ) ? sp[1] : "" );

                break;

         /*   case 2503:
                this.Team = str;
                break;

            case 2504:
                switch (str) {
                    case "true":
                        return this.TeamESP = true;
                    case "false":
                        return this.TeamESP = false;
                }
                break;

            case 2505:
                foreach(index, value in this.Players) {
                    value.Element1.Alpha = 0;
                }

            case 2506:
                foreach(index, value in this.Players) {
                    value.Element1.Alpha = 255;
                }
                break;*/
        }
    }
}