defmodule Polls.Guardian do
  @moduledoc false

  use Guardian, otp_app: :polls

  alias Polls.Accounts
  alias Polls.Accounts.User

  require Logger

  @doc ~S"""
  Get `User` representation as string - JWT subject
  """
  def subject_for_token(%User{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  @doc ~S"""
  Get `User` struct from its string form - JWT subject
  """
  def resource_from_claims(%{"sub" => subject}) do
    subject
    |> Accounts.get_user!()
  end
end
