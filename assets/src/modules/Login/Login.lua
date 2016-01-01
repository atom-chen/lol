local Login = class("Login",function()
	local node = util.createlua(ui.Login)
    return node.root
end)


function Login.create(...)
    local node = Login.new(...)
    return node
end

function Login:ctor()
    if not GameTCP then
        self:reloadProto()
        GameTCP = SocketTCP.create(
        GameServerIP,
        GameServerPort,false)

        GameTCP:connect()
        GameTCP:addEventListener(SocketTCP.EVENT_CONNECTED,self,self.onServerState)
        GameTCP:addEventListener(SocketTCP.EVENT_CLOSED,self,self.onServerState)
        GameTCP:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE,self,self.onServerState)
    end
end

--���¸���Э��
function Login:reloadProto()
	local proto = require("proto")
    local sproto = require("sproto")

    local host = sproto.new(proto.s2c):host "package"
    local request = host:attach(sproto.new(proto.c2s))
    SocketTCP.setHost(host,request)
end

-- ����������״̬
function Login:onServerState(eventSockct)
	if eventSockct.name == SocketTCP.EVENT_CONNECTED then
		--self:initGame()
	elseif eventSockct.name == SocketTCP.EVENT_CLOSED  then
		trace(eventSockct.name)
	elseif eventSockct.name == SocketTCP.EVENT_CONNECT_FAILURE  then
		trace(eventSockct.name..
			GameServerIP..":"..GameServerPort)
	end
end

function Login:addEvents()
    util.clickSelf(self,self.Button_3,self.onStartClick)
    util.clickSelf(self,self.Button_Register,self.onRegisterClick)
end


function Login:refresh()
	
end

function Login:resize()
end

function Login:removeEvents()
end


function Login:onLogin()
end


function Login:dispose()
end

--�����ʼ��Ϸ
function Login:onStartClick()
    util.changeUI(ui.GameRoomContr)
end

--���ע��
function Login:onRegisterClick()
    util.changeUI(ui.Register)
end


return Login