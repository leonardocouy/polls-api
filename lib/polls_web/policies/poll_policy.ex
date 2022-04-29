defmodule Polls.PollPolicy do
  @behaviour Bodyguard.Policy

  alias Polls.Accounts.User
  alias Polls.Core.Poll

  def authorize(action, %User{id: user_id}, %Poll{owner_id: owner_id})
    when action in [:update, :delete] and user_id == owner_id,
    do: :ok

  def authorize(_action, _user, _poll), do: :error
end
