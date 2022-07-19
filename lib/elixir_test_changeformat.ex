defmodule ElixirTestChangeformat do
  @doc """
  与えられたパス上に存在する.gtsファイルを読み込み、mapに変換します。
  """
  def gts_to_map(path) do
    data = File.read!(path)

    [[vertices, segments, _triangles] | value] =
      String.trim(data)
      |> String.split(~r/\n|\r\n|\r/)
      |> Enum.map(fn x -> String.split(x) |> Enum.map(fn n -> String.to_integer(n) end) end)

    {vertices_data, data} = Enum.split(value, vertices)

    vertices_data =
      for [x, y, z] <- vertices_data do
        %{x: x, y: y, z: z}
      end

    {segments_data, triangles_data} = Enum.split(data, segments)

    segments_data =
      for [v1, v2] <- segments_data do
        %{v1: v1, v2: v2}
      end

    triangles_data =
      for [v1, v2, v3] <- triangles_data do
        %{v1: v1, v2: v2, v3: v3}
      end

    %{vertices: vertices_data, segments: segments_data, triangles: triangles_data}
  end

  @doc """
  mapをJSON形式に変換し、与えられたファイル名で出力します。
  """
  def map_to_json(filename, map) do
    encoded_data = JSON.encode!(map)
    File.write(filename, encoded_data)
  end
end
