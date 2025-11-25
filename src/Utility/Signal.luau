--!strict
--!optimize 2
--!native

-- new solver HATES this module

export type Signal<T...> = {
	_head: Connection<T...>?,
	_tail: Connection<T...>?,

	connect: (self: Signal<T...>, callback: (T...) -> ()) -> Connection<T...>,
	once: (self: Signal<T...>, callback: (T...) -> ()) -> Connection<T...>,
	wait: (self: Signal<T...>, timeout: number?, onTimeout: () -> ()?) -> (T...),
	fire: (self: Signal<T...>, T...) -> (),
}

export type Connection<T...> = {
	connected: boolean,

	_signal: Signal<T...>,

	_parent: Connection<T...>?,
	_child: Connection<T...>?,

	_once: boolean,
	_callback: (T...) -> (),

	disconnect: (self: Connection<T...>) -> ()
}

export type Waiter<T...> = {
	_connection: Connection<T...>,

	_thread: thread,
	_onTimeout: () -> ()?
}

local Signal = {}

local function disconnect<T...>(self: Connection<T...>): ()
	if not self.connected then return end
	self.connected = false

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
		connected = true,

		_signal = self,

		_once = false,
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
	local connection = self:connect(callback)
	connection._once = true

	return connection
end

local function callTimeout<T...>(self: Waiter<T...>): ()
	self._connection:disconnect()

	local onTimeout = self._onTimeout
	if onTimeout then onTimeout() end

	task.spawn(self._thread)
end

local function wait<T...>(self: Signal<T...>, timeout: number?, onTimeout: () -> ()?): (T...)
	local thread = coroutine.running()
	local threadTimeout: thread? = nil

	local connection = self:once(function(...)
		if threadTimeout then task.cancel(threadTimeout) end
		task.spawn(thread, ...)
	end)

	local waiter = {
		_connection = connection,

		_thread = thread,
		_onTimeout = onTimeout
	}

	if timeout then
		threadTimeout = task.delay(timeout, callTimeout, waiter)
	end

	return coroutine.yield()
end

local function fire<T...>(self: Signal<T...>, ...: T...): ()
	local connection = self._head

	while connection do
		if connection.connected then
			task.spawn(connection._callback, ...)
			if connection._once then connection:disconnect() end
		end

		if connection == self._tail then break end
		connection = connection._child
	end
end

function Signal.new<T...>(): Signal<T...>
	return {
		connect = connect,
		once = once,
		wait = wait,
		fire = fire,
	}
end

return Signal