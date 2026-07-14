--!strict
--!native
--!optimize 2

export type Signal<T...> = {
	_head: Connection<T...> | false,
	_tail: Connection<T...> | false,

	read connect: (Signal<T...>, callback: (T...) -> ()) -> Connection<T...>,
	read once: (Signal<T...>, callback: (T...) -> ()) -> Connection<T...>,
	read fire: (Signal<T...>, T...) -> (),
	read reset: (Signal<T...>) -> (),
}

export type Connection<T...> = {
	active: boolean,

	read _signal: Signal<T...>,
	read _callback: (T...) -> (),

	_parent: Connection<T...> | false,
	_child: Connection<T...> | false,

	read disconnect: (Connection<T...>) -> (),
}

local free_thread: thread? = nil

const function run<T...>(callback: (T...) -> (), ...: T...): ()
	const thread = free_thread
	free_thread = nil
	callback(...)
	free_thread = thread
end

const function runner<T...>(): ()
	while true do
		(run :: (T...) -> ())(coroutine.yield())
	end
end

const signal = {}

const function disconnect<T...>(self: Connection<T...>): ()
	if not self.active then return end
	self.active = false

	const signal = self._signal
	const parent = self._parent
	const child = self._child

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

	self._parent = false
	self._child = false
end

const function connect<T...>(self: Signal<T...>, callback: (T...) -> ()): Connection<T...>
	const connection: Connection<T...> = {
		active = true,

		_signal = self,
		_callback = callback,

		_parent = false,
		_child = false,

		disconnect = disconnect,
	}

	const tail = self._tail
	if tail then
		connection._parent = tail
		tail._child = connection
	else
		self._head = connection
	end

	self._tail = connection
	return connection
end

const function once<T...>(self: Signal<T...>, callback: (T...) -> ()): Connection<T...>
	local connection: Connection<T...>
	connection = self:connect(function(...)
		connection:disconnect()
		callback(...)
	end)

	return connection
end

const function fire<T...>(self: Signal<T...>, ...: T...): ()
	const tail = self._tail
	local connection = self._head

	while connection do
		if connection.active then
			if not free_thread then free_thread = task.spawn(runner) end
			task.spawn(free_thread :: thread, connection._callback, ...)
		end

		if connection == tail then break end
		connection = connection._child
	end
end

const function reset<T...>(self: Signal<T...>): ()
	local connection = self._tail

	self._head = false
	self._tail = false

	while connection do
		connection.active = false
		connection = connection._parent
	end
end

function signal.new<T...>(): Signal<T...>
	return {
		_head = false,
		_tail = false,

		connect = connect,
		once = once,
		fire = fire,
		reset = reset,
	}
end

return signal
