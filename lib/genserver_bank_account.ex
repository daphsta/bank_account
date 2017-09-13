defmodule GenserverBankAccount do
  use GenServer

  def start_link, do: start_link []
  def start_link(history), do: GenServer.start_link(__MODULE__, history)

  def send_balance(account_pid, pid) do
    GenServer.cast(account_pid, { :send_balance, pid })
  end

  def deposit(account_pid, amount) do
    GenServer.cast(account_pid, {:deposit, amount})
  end

  def withdraw(account_pid, amount) do
    GenServer.cast(account_pid, {:withdraw, amount})
  end

  def handle_cast({ :send_balance, pid }, history) do
    Process.send(pid, {:balance, calc_balance(history)}, [])
    {:noreply, history }
  end

  def handle_cast(event = { :deposit, amount }, history) when amount >= 0 do
    {:noreply, [ event | history ]}
  end

  def handle_cast(event = { :withdraw, amount }, history) when  amount > 0 do
    if calc_balance(history) >= amount do
      {:noreply, [ event | history ]}
    else
      {:noreply, history}
    end
  end

  #pattern match functions
  #
  # def calc_balance(history) do
  #   Enum.reduce(history, 0 , fn({:deposit, amount}, acc) -> acc + amount
  #                               ({:withdraw, amount}, acc) -> acc - amount
  #                             end)
  # end

  def calc_balance(history) do
    Enum.reduce(history, 0, &balance_reducer/2)
  end

  defp balance_reducer({:deposit, amount}, account), do: amount + account
  defp balance_reducer({:withdraw, amount}, account), do: account - amount
end
