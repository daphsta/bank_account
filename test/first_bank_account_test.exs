defmodule FirstBankAccountTest do
  use ExUnit.Case
  alias FirstBankAccount, as: Bank

  test 'Initial balance' do
    pid = spawn(Bank, :start, [])
    Process.send(pid, { :send_balance, self }, [])
    assert_receive { :balance, 0 }
  end

  test 'Can deposit monies' do
    pid = spawn(Bank, :start, [])
    Process.send(pid, { :deposit, 100 }, [])
    Process.send(pid, { :send_balance, self }, [])

    assert_receive { :balance, 100 }
  end

  test 'Can withdraw monies' do
    pid = spawn(Bank, :start, [])
    Process.send(pid, { :deposit, 100 }, [])
    Process.send(pid, { :withdraw, 50 }, [])
    Process.send(pid, { :send_balance, self }, [])

    assert_receive { :balance, 50 }
  end

  test "Can't deposit negative amount" do
    pid = spawn(Bank, :start, [])
    Process.send(pid, { :deposit, 100 }, [])
    Process.send(pid, { :deposit, -100 }, [])
    Process.send(pid, { :send_balance, self }, [])

    assert_receive { :balance, 100 }
  end

  test "Can't withdraw negative amount" do
    pid = spawn(Bank, :start, [])
    Process.send(pid, { :deposit, 100 }, [])
    Process.send(pid, { :withdraw, -150 }, [])
    Process.send(pid, { :send_balance, self }, [])

    assert_receive { :balance, 100 }
  end
end
