defmodule GenserverBankAccountTest do
  use ExUnit.Case
  alias GenserverBankAccount, as: BankAccount

  test 'Initial balance' do
    {:ok, pid} = BankAccount.start_link
    pid
    |> BankAccount.send_balance(self)

    assert_receive { :balance, 0 }
  end

  test 'Can deposit monies' do
    {:ok, pid} = BankAccount.start_link

    pid |> BankAccount.deposit(50)
    pid |> BankAccount.send_balance(self)

   assert_receive { :balance, 50 }
  end

  test 'Can withdraw monies' do
    {:ok, pid} = BankAccount.start_link

    pid |> BankAccount.deposit(150)
    pid |> BankAccount.withdraw(100)
    pid |> BankAccount.send_balance(self)

   assert_receive { :balance, 50 }
  end

  test 'Not allowed to withdraw more than balance' do
    {:ok, pid} = BankAccount.start_link

    pid |> BankAccount.deposit(100)
    pid |> BankAccount.withdraw(120)
    pid |> BankAccount.send_balance(self)

    assert_receive { :balance, 100 }
  end

  test 'Not allowed to deposit $0' do
    {:ok, pid} = BankAccount.start_link

    pid |> BankAccount.deposit(50)
    pid |> BankAccount.deposit(0)
    pid |> BankAccount.send_balance(self)

   assert_receive { :balance, 50 }
  end
end
