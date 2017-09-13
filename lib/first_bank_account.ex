defmodule FirstBankAccount do
  def start, do: await []

  def await(history) do
    receive do
      event -> await handle_event(event, history)
    end
  end

  def handle_event({ :send_balance, pid }, history) do
    
    Process.send(pid, { :balance, calc_balance(history) }, [])
  end

  def handle_event(event = { :deposit, amount }, history) when amount >= 0 do
    [ event | history ]
  end

  def handle_event(event = { :deposit, amount }, history) when amount < 0 do
    history
  end

  def handle_event(event = { :withdraw, amount }, history) when amount >= 0 do
    [ event | history ]
  end

  def handle_event(event = { :withdraw, amount }, history) when amount < 0 do
    history
  end

  def calc_balance(history) do
   Enum.reduce(history, 0, &balance_reducer/2)
  end

  defp balance_reducer({:deposit, amount}, account) do
    account + amount
  end

  defp balance_reducer({:withdraw, amount}, account) do
    account - amount
  end

  defp balance_reducer(_event, account), do: account
end
