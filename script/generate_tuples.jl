using CSV
using Dates
using Random
using DataFrames
using StatsBase: sample


"""
    generate_customers(n_customers::Int64) :: DataFrame

Generates `n_customers` from pre-conceived names and surnames lists, as well as
information about the phones ans salary ranges.
"""
function generate_customers(n_customers::Int64) :: DataFrame

    names = [
        "Mauricio", "Ana", "Julia", "Carla", "Joao", "Maria", "Carlos", "Jorge",
        "Luana", "Arthur", "Felipe", "Clara", "Luiza", "Nicole", "Augusto", "Caio",
        "Frederico", "Luciana", "Renata", "Renato", "Willian", "Rogerio", "Ricardo",
        "Luciana", "Katia", "Daniel", "Antonio", "Carol", "Vivian", "Wilson",
        "Marcelo", "Roberto", "Bruno", "Gustavo", "Alessandra", "Sofia", "Isabela",
        "Laura", "Thiago", "Tiago", "Rita", "Sergio", "Mario", "Alberto", "Lucia",
        "Giulia", "Simone", "Daniele", "Marta", "Teresa", "Barbara", "Rafael", "Vinicius",
        "Breno", "Brenda", "Pablo", "Vitor", "Yuri", "Lara", "Natalia", "Isadora", 
        "Fabio", "Almir", "Lucas", "Fernando", "Amabile", "Osvaldo", "Sinezio",
        "Andreia", "Almir", "Zacarias", "Deisemara", "Airton", "Julio", "Francisco",
        "Paulo", "Pedro", "Regina", "Hiago", "Marcia", "Beatriz", "Vitoria", "Valeska",
        "Heloisa", "Mariana", "Miquel", "Raquel", "Fernanda", "Leticia", "Tabata", 
        "Guilherme", "Daiane", "Leonardo", "Danilo", "Eduardo", "Luiz", "Alexandre",
        "Cristiane", "Cristina", "Poliana", "Matheus", "Juliano", "Juliana", "Etori",
        "Enrico", "Gabriela", "Everton", "Charles", "Amanda", "Jennifer", "Luciane",
        "Cristina"
    ]

    surnames = [
        "da Silva", "Menezes", "Teixeira", "Lopes", "Ferreira", "Moraes",
        "Lorenzetti", "Ferrari", "Souza", "Oliveira", "Santos", "Lima", "Pereira",
        "Costa", "Rodrigues", "Castro", "Almeida", "Nascimento", "Alves", "Carvalho",
        "Araujo", "Ribeiro", "Schmidt", "Schneider", "Shutz", "Rossi", "Sato", "Gomes",
        "Gomes", "Gonzalez", "Fernandes", "Nogueira", "Ferraz", "Mendes", "Moreno",
        "Borges", "Teteshi", "Simas", "Kropf", "Andrade", "Machado", "Barbosa",
        "Barros", "Batista", "Campos", "Cardoso", "Duarte", "Dias", "Freitas",
        "Garcia", "Gonçalves", "Marques", "Martins", "Medeiros", "Melo", "Miranda",
        "Monteiro", "Camargo", "Correa", "Moreira", "Moura", "Nunes", "Ramos", "Reis",
        "Uehara", "Rocha", "Santana", "Soares", "Vieira", "Bianchi", "Romano", "Villa",
        "Ferri", "Rizzo", "Ferretti", "Bernardi", "Stefanelli", "Milani", "Caruso",
        "Martinelli", "Silvestri", "Lombardi", "Fiore", "Muller", "Morelli", "Gentili",
        "Colombo", "Pelegrino", "Toffoli", "Amorim", "Ambrosio", "Amaral", "Bastos",
        "Cunha", "Queiroz", "Mello", "Nardoni", "Esteves", "Eller", "Fontes",
        "Fonseca", "Ruberti", "Flora", "Harper", "Justi", "Klein", "Lozzano", "Luca",
        "Leite", "Meirelles", "Manoel", "Padovani", "Mantovani", "Moreira", "Nicoletti",
        "Olimpio", "Perez", "Prado","Paes", "Pierri", "Pinheiro", "Quaresma", "Simom",
        "Teles", "Viana", "Vilar", "Watanabe", "Weiss", "Wainer", "Zucatelli", "Zardetto",
        "Bezerra", "Arcuri", "Girardi", "Okada", "Antonelli", "Varella", "Lins",
        "Villasboas", "de Marchi"
    ]

    ddds = ["13", "12", "79", "15", "17", "16", "21", "19", "31", "86", "74"]

    salarios = ["0-2000", "2000-5000", "5000-8000", "8000-12000", "12000+"]

    customers = DataFrame(
        name = Vector{String}(),
        date_of_birth = Vector{String}(),
        salary_range = Vector{String}(),
        phone = Vector{String}(),
    )

    for n in 1:n_customers
        second_names = sample(surnames, 2, replace = false)
        name = "$(rand(names)) $(second_names[1]) $(second_names[2])" 
        birthday = "$(rand(Date(1960, 1, 1):Day(1):Date(2004, 1, 1)))"
        phone_number = "($(rand(ddds))) $(rand(7000:9900))-$(rand(1:9, 4)...)"
        salary_range = rand(salarios)

        push!(customers, (name, birthday, salary_range, phone_number))
    end

    # garanteed to be unique because of 'replace = false'
    customers[!, :cpf] = sample(200_000_000:600_000_000, n_customers, replace = false)

    # changing the order of the columns so they match the ones in the sql definition
    select!(customers, [:cpf, :name, :date_of_birth, :salary_range, :phone])

    return customers
end


"""
    generate_product_customer_interaction(customers::T, products::T, monthrange) where T <: DataFrame

Responsible for generating the interaction between customers and products. This
interaction can be real (in the case of real purchases executed by the customers
in the supermarket) or they can be virtual (as recommendations for the customers).
In both circunstances the same code is utilized for both operations and the meaning
of each generated table (a DataFrame object) relies exclusively on the meaning
assigned by the callee.
"""
function generate_product_customer_interaction(customers::T, products::T, monthrange, recommendation::Bool) where T <: DataFrame
    interactions = DataFrame(
        cpf = Vector{Int}(),
        id = Vector{Int}(),
        date = Vector{String}(),
        quantity = Vector{Int}(),
    )

    # for each month in month range
    for month in monthrange
        # only a subset of customers actually interact with the products
        n_customers = trunc(Int, size(customers, 1) * rand(0.1:0.01:0.45))
        customer_subset_cpfs = sample(customers[:, :cpf], n_customers; replace = false)

        # for every customer select a subset of items for the interaction
        for cpf in customer_subset_cpfs
            n_products = trunc(Int, size(products, 1) * rand(0.02:0.01:0.4))
            item_ids_subset = sample(products[:, :id], n_products; replace = false)
            quantity = rand(1:20, n_products) # quantity bought or recommended

            if recommendation
                interaction_dates_str = Dates.format.(fill(firstdayofmonth(month), n_products) , "yyyy-mm-dd")
            else
                interaction_dates = rand(firstdayofmonth(month):Day(1):lastdayofmonth(month), n_products)
                interaction_dates_str = Dates.format.(interaction_dates,"yyyy-mm-dd") # converting to string
            end

            for tuple in zip(fill(cpf, n_products), item_ids_subset, interaction_dates_str, quantity)
                push!(interactions, tuple)
            end
        end
    end

    # making sure that the order is the same in sql table definition
    select!(interactions, [:cpf, :id, :date, :quantity])

    return sort(interactions, :date)
end


"""
    postprocess_products!(df::DataFrame) :: DataFrame
    
Applies post-processing operations on the downloaded `products.tsv` file producing
both the `product` and `category` tables.

# Returns
- `products::DataFrame`: Dataframe of processed products
- `categories::DataFrame`: Dataframe of processed categories obtained in the rows of `products.tsv`.
"""
function postprocess_products(df::DataFrame)

    products = allowmissing(copy(df))

    categories =  DataFrame(
        id = Vector{Int}(),
        parent_id = Vector{Int}(),
        name = Vector{String}()
    )

    allowmissing!(categories)

    # generaging all unique ids for categories and subcategories
    classifications = collect(skipmissing(union(Set(products.category), Set(products.subcategory))))
    classification_ids = sample(1:9999, length(classifications); replace = false)

    category_id_dict = Dict(Pair.(classifications, classification_ids))

    for row in eachrow(unique(products, [:category, :subcategory]))
        if ismissing(row[:subcategory])
            id = category_id_dict[row[:category]]
            parent_id = missing
            name = row[:category]
        else
            id = category_id_dict[row[:subcategory]]
            parent_id = category_id_dict[row[:category]]
            name = row[:subcategory]

            # adding parent category in case when it exists 
            push!(categories, (parent_id, missing, row[:category]))
        end
        push!(categories, (id, parent_id, name))
    end

    unique!(categories, [:id, :parent_id])

    for row in eachrow(products)
        row[:subcategory] = ismissing(row[:subcategory]) ? row[:category] : row[:subcategory]
    end

    transform!(products, :subcategory => ByRow(v -> category_id_dict[v]) => :category)
    select!(products, Not(:subcategory))

    # generating random prices and ids for the products
    products[!, :price] = sample(1:0.05:300, size(products, 1))
    products[!, :id] = sample(1000:9000, size(products, 1), replace = false)

    # putting columns in the same order as sql table definition
    select!(products, [:id, :category, :name, :brand, :price])

    return products, categories
end


function main()

    !isdir("./out") && mkdir("./out")
    MAX_REGISTRIES = 1_000_000

    customers = generate_customers(3000)
    CSV.write("./out/customers.csv", customers)

    raw_products = CSV.read("./products.tsv", DataFrame; delim = "\t")
    products, categories = postprocess_products(raw_products) 
    CSV.write("./out/products.csv", products)
    CSV.write("./out/categories.csv", categories)

    monthrange = Date(2018, 1, 1):Month(1):Date(2022, 7, 1)

    purchases = generate_product_customer_interaction(customers, products, monthrange, false)
    purchases = purchases[sample(1:size(purchases, 1), MAX_REGISTRIES, replace = false), :]
    CSV.write("./out/purchases.csv", purchases)

    recommendations = generate_product_customer_interaction(customers, products, monthrange, true)
    recommendations = recommendations[sample(1:size(recommendations, 1), MAX_REGISTRIES, replace = false), :]
    CSV.write("./out/recommendations.csv", recommendations)

    @info """

        Products: $(size(products, 1)) rows
        Customers: $(size(customers, 1)) rows
        Categories: $(size(categories, 1)) rows
        Purchases: $(size(purchases, 1)) rows
        Recomendations: $(size(recommendations, 1)) rows
    """
end

main()
