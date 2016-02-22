defmodule Rumbl.InfoSys.Supervisor do
	use Supervisor

  def start_link() do
    Supervisor.start_li(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    children = [
      worker(Rumbl.InfoSys, [], restart: :temporary)
    ]
    supervise children, startegy: :simple_one_for_one
  end

end
