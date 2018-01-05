# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RazorTest.Repo.insert!(%RazorTest.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
RazorTest.Repo.delete_all RazorTest.Coherence.User

RazorTest.Coherence.User.changeset(%RazorTest.Coherence.User{}, %{name: "Test User", email: "testuser@example.com", password: "secret", password_confirmation: "secret"})
|> RazorTest.Repo.insert!
RazorTest.Coherence.User.changeset(%RazorTest.Coherence.User{}, %{name: "Anna Sherman", email: "anna.sherman365@gmail.com", password: "password", password_confirmation: "password"})
|> RazorTest.Repo.insert!
RazorTest.Coherence.User.changeset(%RazorTest.Coherence.User{}, %{name: "Joe Sherman", email: "jbsherman365@gmail.com", password: "password", password_confirmation: "password"})
|> RazorTest.Repo.insert!
