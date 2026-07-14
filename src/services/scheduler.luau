--!strict

const RunService = game:GetService("RunService")

const plugin_root = script:FindFirstAncestor("kine")
const signal = require(plugin_root.common.signal)

type valueof<T> = index<T, keyof<T>>

export type Signal = signal.Signal<number>
export type Connection = signal.Connection<number>

const function literal<T>(t: T | ""): T
	return t
end

const PHASES = {
	literal "INPUT",
	literal "REACT",
}

export type Phase = valueof<typeof(PHASES)>

const signals: { [Phase]: Signal } = {}

const function run_phase(phase: Phase, delta_time: number): ()
	signals[phase]:fire(delta_time)
end

const scheduler = {}

function scheduler.on(phase: Phase, callback: (delta_time: number) -> ()): Connection
	return assert(signals[phase], "attempt to connect to unknown scheduler phase"):connect(callback)
end

do
	for _, phase in PHASES do
		signals[phase] = signal.new()
	end

	RunService.Heartbeat:Connect(function(delta_time: number)
		run_phase("INPUT", delta_time)
	end)

	RunService.PreRender:Connect(function(delta_time: number)
		run_phase("REACT", delta_time)
	end)
end

return scheduler
