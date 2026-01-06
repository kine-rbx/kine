--!strict
--!native

export type Signal<T...> = {
	_head: Connection<T...>?,
	_tail: Connection<T...>?,

	read connect: (self: Signal<T...>, callback: (T...) -> ()) -> Connection<T...>,
	read once: (self: Signal<T...>, callback: (T...) -> ()) -> Connection<T...>,
	read fire: (self: Signal<T...>, T...) -> (),
	read reset: (self: Signal<T...>) -> ()
}

export type Connection<T...> = {
	active: boolean,

	read _signal: Signal<T...>,
	read _callback: (T...) -> (),

	_parent: Connection<T...>?,
	_child: Connection<T...>?,

	read disconnect: (self: Connection<T...>) -> ()
}

local freeThread: thread? = nil

local function run<T...>(callback: (T...) -> (), ...: T...)
	local thread = freeThread
	freeThread = nil
	callback(...)
	freeThread = thread
end

local function runner(): ()
	while true do
		run(coroutine.yield() :: any)
	end
end

local Signal = {}

local function disconnect<T...>(self: Connection<T...>): ()
	if not self.active then return end
	self.active = false

	local signal = self._signal
	local parent = self._parent
	local child = self._child

	if parent then
		parent._child = child
	elseif signal._head == self then
		signal._head = child
	end

	if child then
		child._parent = parent
	else
		signal._tail = parent
	end
end

local function connect<T...>(self: Signal<T...>, callback: (T...) -> ()): Connection<T...>
	local connection: Connection<T...> = {
		active = true,

		_signal = self,
		_callback = callback,

		disconnect = disconnect
	}

	local tail = self._tail
	if tail then
		connection._parent = tail
		tail._child = connection
	end

	self._tail = connection
	if not self._head then self._head = connection end

	return connection
end

local function once<T...>(self: Signal<T...>, callback: (T...) -> ()): Connection<T...>
	local connection: Connection<T...>
	connection = self:connect(function(...)
		connection:disconnect()
		callback(...)
	end)

	return connection
end

local function fire<T...>(self: Signal<T...>, ...: T...): ()
	local tail = self._tail
	local connection = self._head

	while connection do
		if connection.active then
			if not freeThread then freeThread = task.spawn(runner) end
			task.spawn(freeThread :: thread, connection._callback, ...)
		end

		if connection == tail then break end
		connection = connection._child
	end
end

local function reset<T...>(self: Signal<T...>): ()
	self._head = nil
	self._tail = nil
end

function Signal.new<T...>(): Signal<T...>
	return {
		_connections = {},

		connect = connect,
		once = once,
		fire = fire,
		reset = reset
	}
end

return Signal
