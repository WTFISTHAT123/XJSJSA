--- Settings

    ORBITAL_REFUND = 1968313

    local ScriptName = "그타안전대리.COM"
    local SetRank, SetMoney = 1, nil

    GLOBAL_VALUE = 262145


    local INT_MAX = 2147483647

    util.require_natives("natives-1660775568") 
    util.toast("[ 그타안전대리.com ]\n\n- Developer: 프로젝트#7777\n\nGta5 1.64 / Build 2082")
    util.keep_running()

---

--- Functions

    local function NOTIFY(Message)
        GRAPHICS.REQUEST_STREAMED_TEXTURE_DICT("CHAR_SOCIAL_CLUB", 1)
        while not GRAPHICS.HAS_STREAMED_TEXTURE_DICT_LOADED("CHAR_SOCIAL_CLUB") do
            util.yield()
        end
        util.BEGIN_TEXT_COMMAND_THEFEED_POST(Message)
        HUD._THEFEED_SET_NEXT_POST_BACKGROUND_COLOR(140)
        HUD.END_TEXT_COMMAND_THEFEED_POST_MESSAGETEXT("CHAR_SOCIAL_CLUB", "CHAR_SOCIAL_CLUB", true, 1, ScriptName, "~c~" .. "NOTIFY")
        HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(true, false)
    end

    local function TELEPORT(X, Y, Z)
        if PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), false) == 0 then
            ENTITY.SET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), X, Y, Z)
        else
            ENTITY.SET_ENTITY_COORDS(PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), false), X, Y, Z)
        end
    end

    function IS_MPPLY(Stat)
        local Stats = {
            "MP_PLAYING_TIME",
        }

        for i = 1, #Stats do
            if Stat == Stats[i] then
                return true
            end
        end
        if string.find(Stat, "MPPLY_") then
            return true
        else
            return false
        end
    end

    function ADD_MP_INDEX(Stat)
        if not IS_MPPLY(Stat) then
            Stat = "MP" .. util.get_char_slot() .. "_" .. Stat
        end
        return Stat
    end

    local function STAT_SET_INT(Hash, Value)
        STATS.STAT_SET_INT(util.joaat("MP" .. util.get_char_slot() .. "_" .. Hash), Value, true)
    end
    local function STAT_SET_INT_MPPLY(Hash, Value)
        STATS.STAT_SET_INT(util.joaat(Hash), Value, true)
    end

    local function SET_INT_GLOBAL(Global, Value)
        memory.write_int(memory.script_global(Global), Value)
    end
    local function SET_INT_LOCAL(Script, Local, Value)
        if memory.script_local(Script, Local) ~= 0 then
            memory.write_int(memory.script_local(Script, Local), Value)
        end
    end

    function STAT_SET_INCREMENT(Stat, Value)
        STATS.STAT_INCREMENT(util.joaat(ADD_MP_INDEX(Stat)), Value, true)
    end

    local function GET_INT_GLOBAL(Global)
        return memory.read_int(memory.script_global(Global))
    end

    function GET_INT_LOCAL(Script, Local)
    if memory.script_local(Script, Local) ~= 0 then
        local Value = memory.read_int(memory.script_local(Script, Local))
        if Value ~= nil then
            return Value
        end
    end
end
    function STAT_GET_INT(Hash, Value)
        local Value = memory.alloc_int()
        STATS.STAT_GET_INT(util.joaat(Hash), Value, -1)
        return memory.read_int(Value)
    end

    local function STAT_SET_PACKED_BOOL(Stat, Value)
        STATS._SET_PACKED_STAT_BOOL(Stat, Value, util.get_char_slot())
    end

    function IA_MENU_OPEN_OR_CLOSE()
        PAD._SET_CONTROL_NORMAL(0, 244, 1)
        util.yield(200)
    end
    function IA_MENU_UP(Num)
        for i = 1, Num do
            PAD._SET_CONTROL_NORMAL(0, 172, 1)
            util.yield(200)
        end
    end
    function IA_MENU_DOWN(Num)
        for i = 1, Num do
            PAD._SET_CONTROL_NORMAL(0, 173, 1)
            util.yield(200)
        end
    end
    function IA_MENU_ENTER(Num)
        for i = 1, Num do
            PAD._SET_CONTROL_NORMAL(0, 176, 1)
            util.yield(200)
        end
    end

    local function IsInSession()
        return util.is_session_started() and not util.is_session_transition_active()
    end

    local function sell_func_423()
        local val = GET_INT_LOCAL("gb_contraband_sell", 540 + 7)
        if val then
            if val == 8 or val == 11 or val == 7 then
                local val2 = GET_INT_GLOBAL(1949955)
                if val2 <= 4 then
                    return 3
                elseif val2 <= 9 then
                    return 6
                else
                    return 10
                end
            elseif val == 1 or val == 2 or val == 10 then
                return 5
            end
        end
        return 1
    end

    local function get_sell_mission_goal()
        local val = GET_INT_LOCAL("gb_contraband_sell", 540+583)
        if val then
            local ret = sell_func_423()
            if val == 0 or val == 2 or val == 3 or val == 4 then
                return ret
            elseif val == 1 or val == 5 then
                return ret * 2
            elseif val == 6 or val == 7 then
                return ret * 3
            end
        end
        return -1
    end
---

menu.divider(menu.my_root(), ScriptName)

local MONEY_OPTIONS = menu.list(menu.my_root(), "돈 옵션", {}, "추가   ||   제거   ||   반복", function(); end)

    menu.divider(MONEY_OPTIONS, ScriptName .. "   ||   돈 추가")

        ADD_500K = menu.action(MONEY_OPTIONS, "$50만 추가", {}, "방법: 오비탈 캐넌 환불", function()
            menu.set_menu_name(ADD_500K, "$50만 추가, 상태: 추가 중")
            util.toast("[ 그타안전대리.com ] $50만 추가 중")
            SET_INT_GLOBAL(ORBITAL_REFUND, 1)
            util.yield(500)
            menu.set_menu_name(ADD_500K, "$50만 추가, 상태: 추가 완료")
            util.toast("[ 그타안전대리.com ] $50만 추가 완료")
            SET_INT_GLOBAL(ORBITAL_REFUND, 0)
            util.yield(500)
            menu.set_menu_name(ADD_500K, "$50만 추가")
        end)

        ADD_750K = menu.action(MONEY_OPTIONS, "$75만 추가", {}, "방법: 오비탈 캐넌 환불", function()
            menu.set_menu_name(ADD_750K, "$75만 추가, 상태: 추가 중")
            util.toast("[ 그타안전대리.com ] $75만 추가 중")
            SET_INT_GLOBAL(ORBITAL_REFUND, 2)
            util.yield(500)
            menu.set_menu_name(ADD_750K, "$75만 추가, 상태: 추가 완료")
            util.toast("[ 그타안전대리.com ] $75만 추가 완료")
            SET_INT_GLOBAL(ORBITAL_REFUND, 0)
            util.yield(500)
            menu.set_menu_name(ADD_750K, "$75만 추가")
        end)

        ADD_1250K = menu.action(MONEY_OPTIONS, "$125만 추가", {}, "방법: 오비탈 캐넌 환불", function()
            menu.set_menu_name(ADD_1250K, "$125만 추가, 상태: 추가 중")
            util.toast("[ 그타안전대리.com ] $125만 추가 중")
            SET_INT_GLOBAL(ORBITAL_REFUND, 1)
            util.yield(250)
            SET_INT_GLOBAL(ORBITAL_REFUND, 0)
            util.yield(250)
            menu.set_menu_name(ADD_1250K, "$125만 추가, 상태: 추가 완료")
            util.toast("[ 그타안전대리.com ] $125만 추가 완료")
            SET_INT_GLOBAL(ORBITAL_REFUND, 2)
            util.yield(250)
            SET_INT_GLOBAL(ORBITAL_REFUND, 0)
            util.yield(250)
            menu.set_menu_name(ADD_1250K, "$125만 추가")
        end)

    ---

    menu.divider(MONEY_OPTIONS, ScriptName .. "   ||   돈 반복")

        local MONEY_AMOUNT = 0
        LOOP_1250K = menu.toggle(MONEY_OPTIONS, "$125만 반복 - 오비탈", {}, "$50만 및 $75만 추가를 25초마다 반복합니다.\n\n6분 30초 동안 활성화하면 $2000만이 모입니다.\n\n반복을 활성화한 동안 다른 돈 옵션은 쓰지 마세요.", function(Toggle)
            Money_Loop = Toggle

            if Money_Loop then
                menu.trigger_commands("transactionbypass")
            end

            while Money_Loop do
                if SetMoney ~= nil then
                    if SetMoney > players.get_bank(players.user()) then
                        menu.set_menu_name(LOOP_1250K, "$125만 반복, 상태: $50만 추가 중")
                        SET_INT_GLOBAL(ORBITAL_REFUND, 1)
                        util.yield(500)
                        SET_INT_GLOBAL(ORBITAL_REFUND, 0)
                        util.yield(500)
                        menu.set_menu_name(LOOP_1250K, "$125만 반복, 상태: $50만 추가 완료")
                        util.yield(1000)
                        menu.set_menu_name(LOOP_1250K, "$125만 반복, 상태: $75만 추가 대기 중")
                        util.yield(10000)
                        menu.set_menu_name(LOOP_1250K, "$125만 반복, 상태: $75만 추가 중")
                        SET_INT_GLOBAL(ORBITAL_REFUND, 2)
                        util.yield(500)
                        SET_INT_GLOBAL(ORBITAL_REFUND, 0)
                        util.yield(500)
                        menu.set_menu_name(LOOP_1250K, "$125만 반복, 상태: $75만 추가 완료")
                        util.yield(1000)
                        menu.set_menu_name(LOOP_1250K, "$125만 반복, 상태: 총 $125만 추가 완료")
                        util.yield(10000)

                        if Money_Loop then
                            menu.set_menu_name(LOOP_1250K, "$125만 반복, 상태: $50만 추가 대기 중")
                            MONEY_AMOUNT = MONEY_AMOUNT + 125
                            menu.trigger_commands("loopstatus")
                            util.yield(1000)
                        else
                            menu.set_menu_name(LOOP_1250K, "$125만 반복 - 오비탈")
                            return 
                        end
                    else
                        menu.set_menu_name(LOOP_1250K, "$125만 반복 - 오비탈")
                        return
                    end
                else
                        menu.set_menu_name(LOOP_1250K, "$125만 반복, 상태: $50만 추가 중")
                        SET_INT_GLOBAL(ORBITAL_REFUND, 1)
                        util.yield(500)
                        SET_INT_GLOBAL(ORBITAL_REFUND, 0)
                        util.yield(500)
                        menu.set_menu_name(LOOP_1250K, "$125만 반복, 상태: $50만 추가 완료")
                        util.yield(1000)
                        menu.set_menu_name(LOOP_1250K, "$125만 반복, 상태: $75만 추가 대기 중")
                        util.yield(10000)
                        menu.set_menu_name(LOOP_1250K, "$125만 반복, 상태: $75만 추가 중")
                        SET_INT_GLOBAL(ORBITAL_REFUND, 2)
                        util.yield(500)
                        SET_INT_GLOBAL(ORBITAL_REFUND, 0)
                        util.yield(500)
                        menu.set_menu_name(LOOP_1250K, "$125만 반복, 상태: $75만 추가 완료")
                        util.yield(1000)
                        menu.set_menu_name(LOOP_1250K, "$125만 반복, 상태: 총 $125만 추가 완료")
                        util.yield(10000)

                    if Money_Loop then
                        menu.set_menu_name(LOOP_1250K, "$125만 반복, 상태: $50만 추가 대기 중")
                        MONEY_AMOUNT = MONEY_AMOUNT + 125
                        menu.trigger_commands("loopstatus")
                        util.yield(1000)
                    else
                        menu.set_menu_name(LOOP_1250K, "$125만 반복 - 오비탈")
                        menu.set_menu_name(LOOP_STATUS, "얻은 돈: $0")
                        return
                    end
                end

                util.yield()
            end

            while not Money_Loop do
                return
            end
        end)

        menu.toggle_loop(MONEY_OPTIONS, "$30만 반복 - 나이트클럽", {}, "$30만을 5초마다 반복합니다.\n\n5분 30초 동안 활성화하면 $2000만이 모입니다.\n\n사용을 위해 나이트클럽 구매가 필요하며, 나이트클럽 금고 문을 열고 활성화하세요.", function()
            SET_INT_GLOBAL(GLOBAL_VALUE + 24045, 300000)
            for i = 24022, 24041 do
                SET_INT_GLOBAL(GLOBAL_VALUE + i, 300000)
            end
            STAT_SET_INT("CLUB_POPULARITY", 1000)
            STAT_SET_INT("CLUB_PAY_TIME_LEFT", -1)  
            util.yield(4000)
        end)

        menu.toggle_loop(MONEY_OPTIONS, "$20만 반복 - 아케이드", {}, "$20만을 5초마다 반복합니다.\n\n8분 30초 동안 활성화하면 $2000만이 모입니다.\n\n사용을 위해 아케이드 구입이 필요하며, 아케이드 금고 문을 열고 활성화하세요.", function()
            SET_INT_GLOBAL(GLOBAL_VALUE + 29250, 200000) -- 1450432366
            SET_INT_GLOBAL(GLOBAL_VALUE + 29251, 200000) -- -268179742
            SET_INT_GLOBAL(GLOBAL_VALUE + 29252, 200000) -- 1798069290
            SET_INT_GLOBAL(GLOBAL_VALUE + 29253, 200000) -- 970148074
            STAT_SET_INT("ARCADE_PAY_TIME_LEFT", -1)
            util.yield(5000)
        end, function()
            SET_INT_GLOBAL(GLOBAL_VALUE + 29250, 100000) -- 1450432366
            SET_INT_GLOBAL(GLOBAL_VALUE + 29251, 5000) -- -268179742
            SET_INT_GLOBAL(GLOBAL_VALUE + 29252, 200) -- 1798069290
            SET_INT_GLOBAL(GLOBAL_VALUE + 29253, 250) -- 970148074
        end)

        menu.toggle_loop(MONEY_OPTIONS, "$5만 반복 - 사무소", {}, "$5만을 30초마다 반복합니다.\n\n35분 동안 활성화하면 $2000만이 모입니다.\n\n사용을 위해 사무소 구입이 필요하며, 사무소 금고 문을 열고 활성화하세요.", function()
            SET_INT_GLOBAL(GLOBAL_VALUE + 29260, 300000) -- 1899222198
            SET_INT_GLOBAL(GLOBAL_VALUE + 29261, 50000) -- 1899222198
            STAT_SET_INT("FIXER_PASSIVE_PAY_TIME_LEFT", -1)
        end, function()
            SET_INT_GLOBAL(GLOBAL_VALUE + 29260, 250000)
            SET_INT_GLOBAL(GLOBAL_VALUE + 29261, 50000)
        end)

    ---

    menu.divider(MONEY_OPTIONS, ScriptName .. "   ||   도구")

        menu.toggle_loop(MONEY_OPTIONS, "거래 오류 중단 방지", {"transactionbypass"}, "돈을 많이 얻어 뜨는 거래 오류 중단을 뜨지 않도록 합니다.", function()
            if GET_INT_GLOBAL(4536679) == 20 or GET_INT_GLOBAL(4536679) == 4 then
                SET_INT_GLOBAL(4536673, 0)
            end
        end)

        LOOP_STATUS = menu.action(MONEY_OPTIONS, "얻은 돈: $0만", {"loopstatus"}, "$125만 반복으로 얼마나 많은 돈을 넣었는지 알려줍니다. 돈이 들어오지 않을 때도 있으므로 정확하지는 않습니다.\n\n반복을 켜고 끌 때마다 초기화됩니다.", function()
            if MONEY_AMOUNT < 10000 then
                menu.set_menu_name(LOOP_STATUS, "얻은 돈: $"..MONEY_AMOUNT.."만")
            else
                local MONEY_AMOUNT_B, MONEY_AMOUNT_M
                MONEY_AMOUNT_B = math.floor(MONEY_AMOUNT / 10000)
                MONEY_AMOUNT_M = MONEY_AMOUNT_B * 10000 - MONEY_AMOUNT
                menu.set_menu_name(LOOP_STATUS, "얻은 돈: $"..MONEY_AMOUNT_B.."억 "..MONEY_AMOUNT_M.."만")
            end
        end)

    ---

    menu.divider(MONEY_OPTIONS, ScriptName .. "   ||   돈 설정")

        MONEY_SET = menu.text_input(MONEY_OPTIONS, "돈 입력", {"setmoney"}, "아래의 옵션들에서 사용할 돈의 액수를 입력하세요.\n\n숫자만 입력하세요.", function(Value)
            SetMoney = tonumber(Value)
        end)

        MONEY_REMOVE = menu.action(MONEY_OPTIONS, "돈 제거", {}, "가능한 설정 값: $0 ~ $20억\n\n중무장 장비를 호출하는 방식으로 돈을 제거합니다. 중무장 장비를 이미 구매한 상태로 변경하기 때문에 구매할 필요는 없습니다.", function(Value)
            if SetMoney == nil then
                notification.normal("값을 설정하지 않았습니다!")
            elseif SetMoney < 1 then
                notification.normal("입력 값은 음수일 수 없습니다!")
            elseif SetMoney > 2000000000 then
                notification.normal("입력 값은 $20억보다 클 수 없습니다!")
            else
                SET_INT_GLOBAL(GLOBAL_VALUE + 20288, SetMoney)
                menu.set_menu_name(MONEY_REMOVE, "돈 제거: $" .. SetMoney .. ", 상태: 설정 완료")
                STAT_SET_PACKED_BOOL(15382, true)
                STAT_SET_PACKED_BOOL(9461, true)
    
                menu.trigger_commands("nopimenugrey on")
                if util.is_interaction_menu_open() then
                    IA_MENU_OPEN_OR_CLOSE()
                end
                SET_INT_GLOBAL(2766485, 85) -- Renders Ballistic Equipment Services screen of the Interaction Menu
                IA_MENU_OPEN_OR_CLOSE()
                IA_MENU_ENTER(1)
                menu.set_menu_name(MONEY_REMOVE, "돈 제거: $" .. SetMoney)
            end

            while true do
                if not NETWORK.NETWORK_IS_SESSION_STARTED() then
                    menu.set_menu_name(MONEY_REMOVE, "돈 제거")
                end

                util.yield()
            end
        end)

        MONEY_LIMIT = menu.action(MONEY_OPTIONS, "돈 반복 제한", {}, "$125만 반복 [오비탈] 에 돈 제한을 겁니다.\n\n반복이 중단되는데에 최대 20초까지 걸릴 수 있습니다.\n\n값을 재설정하기 위해서는 반복을 다시 활성화하세요.", function(Value)
            if SetMoney == nil then
                notification.normal("값을 설정하지 않았습니다!")
            elseif SetMoney < 1 then
                notification.normal("입력 값은 음수일 수 없습니다!")
            elseif SetMoney > INT_MAX then
                notification.normal("입력 값은 $" .. INT_MAX .. " 보다 클 수 없습니다!")
            else
                menu.set_menu_name(MONEY_LIMIT, "돈 반복 제한: $" .. SetMoney .. ", 상태: 설정 완료")
                util.yield(500)
                menu.set_menu_name(MONEY_LIMIT, "돈 반복 제한: $" .. SetMoney)
            end
        end)
    ---

---

local SPECIAL_CARGO = menu.list(menu.my_root(), "스페셜 패키지 옵션", {}, "값 변경   ||   도구   ||   쿨타임 제거", function(); end)

    menu.divider(SPECIAL_CARGO, ScriptName .. "   ||   값 변경")

        menu.slider(SPECIAL_CARGO, "판매값 조정", {"sccargovalue"}, "스페셜 패키지를 팔았을 때 들어오는 돈을 조정합니다.\n\n최대 600만까지 가능합니다.", 0, 6000000, 0, 100000, function(Value)
            SET_INT_GLOBAL(GLOBAL_VALUE + 15788, 6000000)
        end)

    ---

    menu.divider(SPECIAL_CARGO, ScriptName .. "   ||   도구")

        menu.action(SPECIAL_CARGO, "자동 구매 완료", {}, "구매 중인 스페셜 패키지를 자동으로 구매합니다.", function()
            SET_INT_LOCAL("gb_contraband_buy", 790, 4)
        end)

        menu.action(SPECIAL_CARGO, "자동 판매 완료", {}, "판매 중인 스패셜 패키지를 자동으로 판매합니다.", function()
            SET_INT_LOCAL("gb_contraband_sell", 540 + 57, get_sell_mission_goal())
        end)

    ---

    menu.divider(SPECIAL_CARGO, ScriptName .. "   ||   쿨타임 제거")

        menu.toggle_loop(SPECIAL_CARGO, "구매", {}, "", function()
            SET_INT_GLOBAL(GLOBAL_VALUE + 15553, 0)
        end, function()
            SET_INT_GLOBAL(GLOBAL_VALUE + 15553, 300000)
        end)

        menu.toggle_loop(SPECIAL_CARGO, "판매", {}, "", function()
            SET_INT_GLOBAL(GLOBAL_VALUE + 15554, 0) -- 1291620941
        end, function()
            SET_INT_GLOBAL(GLOBAL_VALUE + 15554, 1800000)
        end)

    ---

---

local STAT_EDITOR = menu.list(menu.my_root(), "통계 옵션", {}, "플레이타임   ||   얻은 돈   ||   사용한 돈   ||   K/D", function(); end)

    menu.divider(STAT_EDITOR, ScriptName .. "   ||   플레이타임 도구")
        IS_TIME_ADDING_METHOD = menu.toggle(STAT_EDITOR, "더하는 방법", {}, "- 현재 플레이타임에서 더하는 방법입니다.\n\n플레이타임을 수정하는 방법은 24.8일까지 가능하지만\n추가하는 방법은 50,000일까지 가능합니다.",function(); end)

    menu.divider(STAT_EDITOR, ScriptName .. "   ||   플레이타임 값")
        PLAYTIME_DAY = menu.slider(STAT_EDITOR, "일", {"day_set"}, "", 0, 50000, 0, 1, function(); end)
        PLAYTIME_HOUR = menu.slider(STAT_EDITOR, "시간", {"hour_set"}, "", 0, 50000, 0, 1, function(); end)
        PLAYTIME_MIN = menu.slider(STAT_EDITOR, "분", {"min_set"}, "", 0, 50000, 0, 1, function(); end)

    menu.divider(STAT_EDITOR, ScriptName .. "   ||   플레이타임 설정")
        menu.action(STAT_EDITOR, "총 플레이타임", {}, "", function()
            if not menu.get_value(IS_TIME_ADDING_METHOD) then
                STAT_SET_INT("TOTAL_PLAYING_TIME", menu.get_value(PLAYTIME_DAY) * 86400000 + menu.get_value(PLAYTIME_HOUR) * 3600000 + menu.get_value(PLAYTIME_MIN) * 60000)
            else
                STAT_SET_INCREMENT("TOTAL_PLAYING_TIME", menu.get_value(PLAYTIME_DAY) * 86400000 + menu.get_value(PLAYTIME_HOUR) * 3600000 + menu.get_value(PLAYTIME_MIN) * 60000)
            end

            menu.trigger_commands("forcecloudsave")
            util.toast("총 플레이타임 설정을 완료했습니다 !\n\n- " .. menu.get_value(PLAYTIME_DAY) .. "일 " .. menu.get_value(PLAYTIME_HOUR) .. "시간 " .. menu.get_value(PLAYTIME_MIN) .. "분")
        end)

        menu.action(STAT_EDITOR, "Gta 온라인 플레이타임", {}, "", function()
            if not menu.get_value(IS_TIME_ADDING_METHOD) then
                STAT_SET_INT("MP_PLAYING_TIME", menu.get_value(PLAYTIME_DAY) * 86400000 + menu.get_value(PLAYTIME_HOUR) * 3600000 + menu.get_value(PLAYTIME_MIN) * 60000)
            else
                STAT_SET_INCREMENT("MP_PLAYING_TIME", menu.get_value(PLAYTIME_DAY) * 86400000 + menu.get_value(PLAYTIME_HOUR) * 3600000 + menu.get_value(PLAYTIME_MIN) * 60000)
            end

            menu.trigger_commands("forcecloudsave")
            util.toast("Gta 온라인 플레이타임 설정을 완료했습니다 !\n\n- " .. menu.get_value(PLAYTIME_DAY) .. "일 " .. menu.get_value(PLAYTIME_HOUR) .. "시간 " .. menu.get_value(PLAYTIME_MIN) .. "분")
        end)

        menu.action(STAT_EDITOR, "데스매치 플레이타임", {}, "", function()
            if not menu.get_value(IS_TIME_ADDING_METHOD) then
                STAT_SET_INT("MPPLY_TOTAL_TIME_SPENT_DEATHMAT", menu.get_value(PLAYTIME_DAY) * 86400000 + menu.get_value(PLAYTIME_HOUR) * 3600000 + menu.get_value(PLAYTIME_MIN) * 60000)
            else
                STAT_SET_INCREMENT("MPPLY_TOTAL_TIME_SPENT_DEATHMAT", menu.get_value(PLAYTIME_DAY) * 86400000 + menu.get_value(PLAYTIME_HOUR) * 3600000 + menu.get_value(PLAYTIME_MIN) * 60000)
            end

            menu.trigger_commands("forcecloudsave")
            util.toast("데스매치 플레이타임 설정을 완료했습니다 !\n\n- " .. menu.get_value(PLAYTIME_DAY) .. "일 " .. menu.get_value(PLAYTIME_HOUR) .. "시간 " .. menu.get_value(PLAYTIME_MIN) .. "분")
        end)

        menu.action(STAT_EDITOR, "레이스 플레이타임", {}, "", function()
            if not menu.get_value(IS_TIME_ADDING_METHOD) then
                STAT_SET_INT("MPPLY_TOTAL_TIME_SPENT_RACES", menu.get_value(PLAYTIME_DAY) * 86400000 + menu.get_value(PLAYTIME_HOUR) * 3600000 + menu.get_value(PLAYTIME_MIN) * 60000)
            else
                STAT_SET_INCREMENT("MPPLY_TOTAL_TIME_SPENT_RACES", menu.get_value(PLAYTIME_DAY) * 86400000 + menu.get_value(PLAYTIME_HOUR) * 3600000 + menu.get_value(PLAYTIME_MIN) * 60000)
            end

            menu.trigger_commands("forcecloudsave")
            util.toast("데스매치 플레이타임 설정을 완료했습니다 !\n\n- " .. menu.get_value(PLAYTIME_DAY) .. "일 " .. menu.get_value(PLAYTIME_HOUR) .. "시간 " .. menu.get_value(PLAYTIME_MIN) .. "분")
        end)

        menu.action(STAT_EDITOR, "생성기 플레이타임", {}, "", function()
            if not menu.get_value(IS_TIME_ADDING_METHOD) then
                STAT_SET_INT("MPPLY_TOTAL_TIME_MISSION_CREATO", menu.get_value(PLAYTIME_DAY) * 86400000 + menu.get_value(PLAYTIME_HOUR) * 3600000 + menu.get_value(PLAYTIME_MIN) * 60000)
            else
                STAT_SET_INCREMENT("MPPLY_TOTAL_TIME_MISSION_CREATO", menu.get_value(PLAYTIME_DAY) * 86400000 + menu.get_value(PLAYTIME_HOUR) * 3600000 + menu.get_value(PLAYTIME_MIN) * 60000)
            end

            menu.trigger_commands("forcecloudsave")
            util.toast("데스매치 플레이타임 설정을 완료했습니다 !\n\n- " .. menu.get_value(PLAYTIME_DAY) .. "일 " .. menu.get_value(PLAYTIME_HOUR) .. "시간 " .. menu.get_value(PLAYTIME_MIN) .. "분")
        end)

local TOOLS = menu.list(menu.my_root(), "도구 옵션", {}, "잠금 해제   ||   클라우드 저장", function(); end)

    menu.divider(TOOLS, ScriptName .. "   ||   도구")


        CLOUD_SAVE = menu.action(TOOLS, "클라우드 강제 저장", {}, "락스타 클라우드에 현재 정보를 저장해 올바르게 저장되지 않는 것을 방지합니다.", function()
            menu.set_menu_name(CLOUD_SAVE, "클라우드 강제 저장, 상태: 저장 중")
            menu.trigger_commands("forcecloudsave")
            util.yield(5000)
            menu.set_menu_name(CLOUD_SAVE, "클라우드 강제 저장, 상태: 저장 완료")
            util.toast("[ 그타안전대리.com ] 클라우드 강제 저장 성공")
            util.yield(1000)
            menu.set_menu_name(CLOUD_SAVE, "클라우드 강제 저장")
        end)

        menu.action(TOOLS, "금고로 순간 이동", {}, "나이트클럽 금고 앞으로 순간이동 합니다.\n\n[주의]\n나이트클럽 안에 있을 때만 사용하세요.", function()
            TELEPORT(-1616.3997, -3014.8787, -75.205124)
        end)

        menu.action(TOOLS, "비행기 순간 이동", {}, "나이트클럽 비행기 미션, 미리 도착지점에 순간 이동 합니다.", function()
            TELEPORT(1334.8013, 3139.134, 40.03604)
        end)

        menu.divider(TOOLS, ScriptName .. "   ||   잠금 해제")

            UNLOCK_ALL = menu.action(TOOLS, "모두 잠금 해제", {}, "모든 것을 잠금 해제하고, 모든 도전 과제를 잠금 해제합니다.", function()
                menu.show_warning(UNLOCK_ALL, CLICK_MENU, "|| " .. ScriptName .. " ||" .. "\n\n" .. "- 모두 잠금 해제를 하실건가요?", function()
                    menu.set_menu_name(UNLOCK_ALL, "모두 잠금 해제, 상태: 해제 중")
                    menu.trigger_commands("unlockall")
                    util.yield(5000)
                    menu.trigger_commands("unlockachievements")
                    menu.set_menu_name(UNLOCK_ALL, "모두 잠금 해제, 상태: 해제 완료")
                    NOTIFY("모두 잠금 해제가 완료되었습니다!")
                    util.yield(1000)
                    menu.set_menu_name(UNLOCK_ALL, "모두 잠금 해제")
                end)
            end)
