defmodule Pgen do
  @moduledoc """
  Generates xkcd-style password with special rules
  """

  @doc """
  Rules:
  - At least one alphabetic character
  - At least one number
  - At least 8 characters
  - No two identical consecutive characters
  """

  def generate(rules) do
    file_stream = File.stream!("priv/words.txt")

    Enum.filter(file_stream, fn word -> apply_filters(word, rules) end)
    |> Enum.take_random(4)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&maybe_upcase/1)
    |> Enum.join("-")    
  end

  def generate(rules, n) do
    1..n
    |> Enum.map(fn _ -> generate(rules) end)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def apply_filters(word, []) do
    true
  end

  def apply_filters(word, [:no_successive_characters | rules]) do
    case check_successive_characters(word) do
      true ->
        apply_filters(word, rules)
      false ->
        false        
    end
  end

  def check_successive_characters("", _) do
    true
  end

  def check_successive_characters(<<a>>) do
    true
  end  

  def check_successive_characters(<<a, a, _rest::binary>>) do
    false
  end

  def check_successive_characters(<<a, b>>) do
    true
  end
  
  def check_successive_characters(<<_a, rest::binary>>) do
    check_successive_characters(rest)
  end

  def maybe_upcase(word) do
    if :rand.uniform() < 0.33 do
      String.upcase(word)
    else
      word
    end
  end
end
