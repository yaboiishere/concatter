defmodule Concatter do
  def read_file(file, ext) do
    read_file(%{}, file, ext)
  end

  def read_file(acc, path, ext) do
    path
    |> Path.basename()
    |> String.match?(~r/^[\._]\w+/)
    |> case do
      true ->
        acc

      false ->
        path
        |> File.dir?()
        |> case do
          true ->
            path
            |> File.ls!()
            |> Enum.map(&Path.join(path, &1))
            |> Enum.reduce(%{}, fn file, inner_acc ->
              inner_acc
              |> read_file(file, ext)
            end)
            |> then(&Map.put(acc, path, &1))

          false ->
            path
            |> Path.basename()
            |> String.split(".")
            |> List.last()
            |> case do
              ^ext ->
                path
                |> File.read!()
                |> then(&Map.put(acc, path, &1))

              _ ->
                acc
            end
        end
    end
  end

  def concat_files(dir, ext) when is_binary(dir) and is_binary(ext) do
    dir
    |> read_file(ext)
    |> concat_files("")
  end

  def concat_files(%{} = files_map, acc) when map_size(files_map) == 0 do
    acc
  end

  def concat_files(%{} = files_map, acc)
      when is_binary(acc) do
    files_map
    |> Enum.reduce(acc, fn
      {_path, %{} = inner_files}, inner_acc ->
        concat_files(inner_files, inner_acc)

      {_path, content}, inner_acc ->
        inner_acc <> content
    end)
  end
end
