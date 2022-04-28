defmodule Polls.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Polls.Repo

  alias Polls.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Returns if given email and password are valid

  ## Examples
    iex> authenticate("email@email.com", "correct_password")
    {:ok, %User{}}

    iex> authenticate("inexistent_email@email.com", "correct_password")
    {:error, {:not_found, "User not found"}}

    iex> authenticate("email@email.com", "invalid_password")
    {:error, :unauthorized}
  """
  def authenticate_user(email, password) do
    case get_user_by_email(email) do
      nil ->
        Argon2.no_user_verify()
        {:error, {:not_found, "User not found"}}

      user ->
        validate_user_password(user, password)
    end
  end

  defp validate_user_password(%User{encrypted_password: encrypted_password} = user, password) do
    case Argon2.verify_pass(password, encrypted_password) do
      true -> {:ok, user}
      false -> {:error, :unauthorized}
    end
  end
end
