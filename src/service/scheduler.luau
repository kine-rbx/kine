--!strict

const RunService = game:GetService("RunService")

type valueof<T> = index<T, keyof<T>>

const function literal<T>(t: T | ""): T
	return t
end

const function enforce_table<T, K, V>(t: T & { [K]: V }, k: K): index<T, K>
	if not t[k] then t[k] = {} end
	return t[k]
end

const PHASES = {
	literal "input",
	literal "react",
}

export type Phase = valueof<typeof(PHASES)>
export type Callback = (delta_time: number) -> ()

const callbacks: { [Phase]: { Callback } } = {}

const function init(): ()
	RunService.PreSimulation:Connect(function(delta_time)
		for _, phase in PHASES do
			for _, callback in enforce_table(callbacks, phase) do
				callback(delta_time)
			end
		end
	end)
end

const scheduler = {}

function scheduler.connect(phase: Phase, callback: Callback): () -> ()
	const target = enforce_table(callbacks, phase)
	table.insert(target, callback)

	return function()
		table.remove(target, table.find(target, callback))
	end
end

init()

return scheduler
