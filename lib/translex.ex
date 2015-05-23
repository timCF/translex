defmodule Translex do
  use Application
  use Silverb, [{"@defaults", 	Enum.reduce(List.first('a')..List.first('z'), %{}, fn(n,res) -> Map.put(res, to_string([n]), to_string([n])) end)
  								|> Map.merge(Enum.reduce(0..9, %{}, fn(n,res) -> Map.put(res, to_string(n), to_string(n)) end)) }]

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Translex.Worker, [arg1, arg2, arg3])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Translex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def encode(bin, lang \\ :ru) when is_binary(bin) do
	this_dict = dict(lang) |> Map.merge(@defaults)
	String.split(bin, " ")
	|> Stream.map(fn(word) -> 
		String.codepoints(word)
		|> Stream.map(fn(letter) -> 
			case Map.get(this_dict, letter) do
				bin when is_binary(bin) -> bin
				nil -> maybe_uppercase(letter, this_dict)
			end
		   end)
		|> Enum.join
	   end)
	|> Stream.filter(&(&1 != ""))
	|> Enum.join("_")
  end

  defp maybe_uppercase(letter, this_dict) do
  	case Map.get(this_dict, String.downcase(letter)) do
		bin when is_binary(bin) -> String.upcase(bin)
		nil -> ""
  	end
  end

  defp dict(:ru) do
	%{
		"а" => "a",
		"б" => "b",
		"в" => "v",
		"г" => "g",
		"д" => "d",
		"е" => "e",
		"ё" => "jo",
		"ж" => "zh",
		"з" => "z",
		"и" => "i",
		"й" => "j",
		"к" => "k",
		"л" => "l",
		"м" => "m",
		"н" => "n",
		"о" => "o",
		"п" => "p",
		"р" => "r",
		"с" => "s",
		"т" => "t",
		"у" => "u",
		"ф" => "f",
		"х" => "h",
		"ц" => "c",
		"ч" => "ch",
		"ш" => "sh",
		"щ" => "sch",
		"ъ" => "",
		"ы" => "y",
		"ь" => "",
		"э" => "je",
		"ю" => "ju",
		"я" => "ja"
	}
  end

end
