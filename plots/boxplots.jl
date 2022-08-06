using CairoMakie
using DataFrames
using Statistics


function plot_differences(data::Dict; description::String)

    fig = Figure()
    axs = Axis(fig[1, 1])

    sorted_plot_keys = ["Original", "Materialized View", "Materialized View + Index"]

    for (i, key) in enumerate(sorted_plot_keys)
        boxplot!(axs, fill(i, length(data[key])), data[key], width = 0.75)
    end

    speedup_info = calculate_differences([data])
    speedup = round(abs(speedup_info[1, "diff"]); digits = 1)
    text = "Antes = $(round(abs(speedup_info[1, "tempo_original"]); digits = 1))\n" *
        "Depois = $(round(abs(speedup_info[1, "mat_view_mais_indice"]); digits = 1))\n\n" *
        "Speedup de $speedup%"
    text!(axs, 3, mean(data["Original"]);
          text = text,
          align = (:center, :center),
          color = :red)

    axs.ylabel = "Tempo (ms)"
    axs.xticks = (1:length(keys(data)), collect(keys(data)))
    axs.xgridvisible = false
    axs.yticks = 300:100:1800
    axs.title = "Otimização da " * titlecase(replace(description, "_" => " #")) *
        " (5 Execuções em Cada Etapa de Otimização)"

    save("../img/$description.pdf", fig)
end


function calculate_differences(data::AbstractVector)
    differences = DataFrame(
        :query => [],
        :tempo_original => [],
        :mat_view => [],
        :mat_view_mais_indice => [],
        :diff => [],
    )

    for (i, dict) in enumerate(data)
        query = i
        original_mean = mean(dict["Original"])
        mat_view_mean = mean(dict["Materialized View"])
        mat_view_index_mean = mean(dict["Materialized View + Index"])
        overall_diff = (mat_view_index_mean - original_mean) / original_mean * 100
        push!(differences, (query, original_mean, mat_view_mean, mat_view_index_mean, overall_diff))
    end

    return differences
end


function main()

    query_1 = Dict(
        "Original" => [1270.709, 1841.284, 1780.036, 1782.514, 1764.873],
        "Materialized View" => [653.994, 883.632, 888.926, 976.402, 1000.438],
        "Materialized View + Index" => [482.830, 445.895, 457.205, 424.219, 611.046],
    )

    query_2 = Dict(
        "Original" => [1295.805, 1044.942, 1828.106, 1433.316, 1298.502],
        "Materialized View" => [743.965, 874.685, 792.958, 703.529, 732.856],
        "Materialized View + Index" => [352.240, 359.789, 388.097, 352.725, 341.899],
    )

    plot_differences(query_1; description = "query_1")
    plot_differences(query_2; description = "query_2")

    return calculate_differences([query_1, query_2])
end


main()
