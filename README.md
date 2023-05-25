<div id = "header" align = "center">
  <img src = "https://avatars.githubusercontent.com/u/95591065?v=4" width = 90/>
  <div id="badges">
  <a href="https://www.linkedin.com/in/calin-basturea-349a15234/">
    <img src="https://img.shields.io/badge/LinkedIn-blue?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn Badge"/>
  </a>
  </div>
</div>

<div align="center">
  
# Vehicle Routing Problem Solver
    
</div>

This is a Julia script that solves the Vehicle Routing Problem using the JuMP optimization modeling language and the GLPK solver. The VRP is a combinatorial optimization problem that involves determining an optimal set of routes for a fleet of vehicles to serve a set of customers.

<div align="center">
  
# Problem Description
    
</div>

The VRP in this script involves delivering goods to a set of locations from a central depot using a fleet of vehicles. Each location has a demand representing the quantity of goods to be delivered. The objective is to minimize the total distance traveled by the vehicles while satisfying the demand constraints.

## Dataset

The dataset used in this script includes the following information:
    
- `num_locations`: The total number of locations, including the depot.
- `Q`: The capacity of each vehicle.
- `demands`: An array of size num_locations representing the demand at each location.
- `distances`: A matrix of size num_locations x num_locations representing the distances between locations.
- `times`: A square matrix of size `[num_locations]` x `[num_locations]` representing the travel times between locations.

<div align="center">
  
  ## :exclamation: **Note:**
  <span style="color:red"> <strong> This is a small dataset provided as an example.</strong></span> 
  <br>
  Please note that for larger or more complex problem instances, you may need to adjust the variables and constraints in the script accordingly. The current dataset serves as a starting point and can be modified to fit your specific problem requirements.
  
</div>



## Usage

1. Install the required dependencies by running the following command in your Julia environment:

   ```julia
   using Pkg
   Pkg.add("JuMP")
   Pkg.add("GLPK")
   Pkg.add("Plots")
   ```
   
2. Update the dataset in the script according to your problem instance. Modify the num_locations, Q, demands, distances, and times variables to match your specific problem.
   Update the dataset in the script according to your problem instance. Modify the `num_locations`, `Q`, `demands`, `distances`, and `times` variables to match your specific problem.
   
3. Run the script using the Julia interpreter:
```julia
julia vehicle-routing.jl
```
4. The script will output the optimal routes for the vehicles and the total distance traveled. 

![image](https://github.com/calin2244/jl_tema/assets/95591065/a76ab2d1-5b03-4236-92e9-5ff1d903b0ed)

## Decision Variables

The following decision variables are used in the VRP model:

- `x[i,j]`: Binary decision variable indicating whether a vehicle travels from location i to location j.
- `u[i]`: Non-negative decision variable representing the cumulative load of goods at location i.
- `t[i,j]`: Non-negative decision variable representing the arrival time at location j from location i.

## Constraints

The model includes the following constraints:

**Constraint 1: Each location should be visited exactly once as a source.**
```python
@constraint(model, [i=1:num_locations], sum(x[i,j] for j in 1:num_locations) == 1)
```

**Constraint 2: Each location should be visited exactly once as a destination.**
```python
@constraint(model, [j=1:num_locations], sum(x[i,j] for i in 1:num_locations) == 1)
```

**Constraint 3: The cumulative load at each location i should be sufficient to satisfy the demand at that location.**
```python
@constraint(model, [i=1:num_locations], u[i] >= demands[i])
```

**Constraint 4: Capacity constraint: The cumulative load at location `i` minus the cumulative load at location `j` plus the `demand at location j` times the decision variable `x[i,j]` should be less than or equal to the remaining capacity `Q - demands[j]`.**
```python
@constraint(model, [i=1:num_locations, j=2:num_locations], u[i] - u[j] + Q*x[i,j] <= Q - demands[j])
```
**Constraint 5: Arrival time constraint: The arrival time at location `j` from location `i` should be greater than or equal to the arrival time at location `i` plus the travel time from `i to j`, minus the remaining capacity times the decision variable `1 - x[i,j]`.**
```python
@constraint(model, [i=1:num_locations, j=1:num_locations], t[j,i] >= t[i,i] + times[i,j] - Q*(1-x[i,j]))
```
**Constraint 6: Symmetry constraint: The total number of vehicles entering a location i should be equal to the total number of vehicles leaving that location.**
```python
@constraint(model, [i=1:num_locations], sum(x[i,j] for j in 1:num_locations) - sum(x[j,i] for j in 1:num_locations) == 0)
```

<div align="center">
  
# Objective function
    
</div>

**The objective is to minimize the total distance traveled by all vehicles. It is calculated as the sum of the distances between locations weighted by the decision variable `x[i,j]`.**
```python
@objective(model, Min, sum(distances[i,j]*x[i,j] for i in 1:num_locations, j in 1:num_locations))
```

## Results

The script uses the optimization model to find the optimal routes for the vehicles. The results include:

- **Optimal Routes**: The script prints the sequence of locations visited by each vehicle to fulfill the delivery requirements.

- **Total Distance Traveled**: The script displays the total distance traveled by all the vehicles.
