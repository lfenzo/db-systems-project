using CairoMakie
using DataFrames
using Statistics
using Dictionaries


function plot_differences(data::Dictionary; description::String)

    fig = Figure()
    axs = Axis(fig[1, 1])

    for (i, vals) in enumerate(values(data))
        boxplot!(axs, fill(i, length(vals)), vals, width = 0.75)
    end

    axs.ylabel = "Tempo (ms)"
    axs.xticks = (1:length(keys(data)), collect(keys(data)))
    axs.xgridvisible = false
    axs.yticks = 300:100:1800
    axs.title = "Otimização da " * titlecase(replace(description, "_" => " #")) *
        " (5 Execuções em Cada Etapa de Otimização)"

    save("../img/$description.pdf", fig)
end


function calculate_differences(data)
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

    # dicts are constructed this way to preserve the order of the keys, so that
    # plotting gets the right order of optimization steps
    query_dict_keys = ["Original", "Materialized View", "Materialized View + Index"]

    query_1_times = [
        [1270.709, 1841.284, 1780.036, 1782.514, 1764.873],
        [653.994, 883.632, 888.926, 976.402, 1000.438],
        [482.830, 445.895, 457.205, 424.219, 611.046],
    ]

    query_2_times = [
        [1295.805, 1044.942, 1828.106, 1433.316, 1298.502],
        [743.965, 874.685, 792.958, 703.529, 732.856],
        [352.240, 359.789, 388.097, 352.725, 341.899],
    ]

    query_1 = Dictionary(query_dict_keys, query_1_times)
    query_2 = Dictionary(query_dict_keys, query_2_times)

    plot_differences(query_1; description = "query_1")
    plot_differences(query_2; description = "query_2")

    return calculate_differences([query_1, query_2])
end


main()
