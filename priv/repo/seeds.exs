# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ArslaneToNarnia.Repo.insert!(%ArslaneToNarnia.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ArslaneToNarnia.Accounts.User
alias ArslaneToNarnia.Accounts.UserToken
alias ArslaneToNarnia.Logs.Log
alias ArslaneToNarnia.Accounts.UserSeeder

if Mix.env() == :dev do
  ArslaneToNarnia.Repo.delete_all(Log)
  ArslaneToNarnia.Repo.delete_all(UserToken)
  ArslaneToNarnia.Repo.delete_all(User)

  UserSeeder.admin()
  UserSeeder.random_users(20)
end
