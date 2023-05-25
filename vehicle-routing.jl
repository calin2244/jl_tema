using JuMP, GLPK

# the dataset
num_locations = 6
Q = 12
demands = [2, 1, 3, 2, 1, 2]

# on the main diagonal, we have zeros because the distance from a location to itself is always 0.
distances = [
    0   7  12  15  20  25;
    7   0   5  10  15  18;
   12   5   0   6  10  13;
   15  10   6   0   8  11;
   20  15  10   8   0   6;
   25  18  13  11   6   0;
]

# the same thing applies to the times
times = [
    0  20  25  15  10  20;
   20   0  10  20  25  30;
   25  10   0  15  20  25;
   15  20  15   0  15  20;
   10  25  20  15   0  10;
   20  30  25  20  10   0;
]

# creating the model
model = Model(GLPK.Optimizer)

# adding the decision variables
@variable(model, x[1:num_locations, 1:num_locations], Bin)
@variable(model, u[1:num_locations] >= 0)
@variable(model, t[1:num_locations, 1:num_locations] >= 0)

# adding the constraints
@constraint(model, [i=1:num_locations], sum(x[i,j] for j in 1:num_locations) == 1)
@constraint(model, [j=1:num_locations], sum(x[i,j] for i in 1:num_locations) == 1)
@constraint(model, [i=1:num_locations], u[i] >= demands[i])
@constraint(model, [i=1:num_locations, j=2:num_locations], u[i] - u[j] + Q*x[i,j] <= Q-demands[j])
@constraint(model, [i=1:num_locations, j=1:num_locations], t[j,j] == 0)
@constraint(model, [i=1:num_locations, j=1:num_locations], t[j,i] >= t[i,i] + times[i,j] - Q*(1-x[i,j]))
@constraint(model, [i=1:num_locations, j=2:num_locations], t[j,i] >= t[i,i] + times[i,j] - Q*(1-x[i,j]))
@constraint(model, [i=1:num_locations], sum(x[i,j] for j in 1:num_locations) - sum(x[j,i] for j in 1:num_locations) == 0)

# adding the function objective
@objective(model, Min, sum(distances[i,j]*x[i,j] for i in 1:num_locations, j in 1:num_locations))

# optimize the modelul
optimize!(model)

# show the results
if termination_status(model) == MOI.OPTIMAL
    
    for i in 1:num_locations
        for j in 1:num_locations
            if value(x[i,j]) == 1
                println("De la locația $i la locația $j")
            end
        end
    end

    total_distance = sum(distances[i,j] * value(x[i,j]) for i in 1:num_locations, j in 1:num_locations)
    println("Total distance traveled: $total_distance")
    # the same thing as println("Minimal cost: ", objective_value(model))

    current_location = 1
    visited_locations = [1]
    while true
        next_location = findfirst(j -> value(x[current_location, j]) == 1, 1:num_locations)
        if next_location == 1
            break
        end
        push!(visited_locations, next_location)
        current_location = next_location
    end
    println("Route sequence: $visited_locations")
else
    println("Nu s-a putut optmiza setul de date")
end