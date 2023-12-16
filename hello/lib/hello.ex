defmodule Hello do
  @moduledoc """
  Documentation for `Hello`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Hello.hello()
      :world

  """
  def start(_type, _args) do
    main()
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def main do
    actions = ["Steal", "Persuade", "Intimidate", "Argue"]
    input = IO.gets("What is your name and class? name; class\n")
    if String.trim(input) == "exit" do
      IO.puts("Goodbye!")
      exit(:normal)
    end
    [user_name, class] = String.split(String.trim(input), ";")
    user_name = String.capitalize(String.trim(user_name))
    class = String.capitalize(String.trim(class))
    IO.puts("hello #{user_name} the #{class}")
    IO.puts("What do you want to do?")
    chosen_action = String.capitalize(String.trim(IO.gets(print_options(actions) <> "\n")))
    if (get_class_action_result(class, chosen_action)) do
      IO.puts("#{chosen_action} roll success!")
    else
      IO.puts("You failed to #{chosen_action}!")
    end
    main()
  end

  def print_options(strings) when is_list(strings) do
    Enum.reduce(strings, "", fn(option), acc->
      seperator = if acc == "", do: "", else: " | "
      acc <> seperator <> option
    end)
  end

  def get_class_action_result(class, action) do
    case {class, action} do
      {"Rogue", "Steal"} -> roll_for_success(10, 3)
      {"Bard", "Persuade"} -> roll_for_success(10, 3)
      {"Wizard", "Argue"} -> roll_for_success(10, 3)
      {"Warrior", "Intimidate"} -> roll_for_success(10, 3)
      _ -> roll_for_success(10, 0)
    end
  end

  def roll_for_success(target, modifier) do
    roll_result = Enum.random(1..20)
    IO.puts("You rolled: #{roll_result}, target: #{target}, modifier: #{modifier}")
    roll_result + modifier >= target
  end
end
