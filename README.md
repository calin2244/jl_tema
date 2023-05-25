# Vehicle Routing Problem Solver
This is a Julia script that solves the Vehicle Routing Problem using the JuMP optimization modeling language and the GLPK solver. The VRP is a combinatorial optimization problem that involves determining an optimal set of routes for a fleet of vehicles to serve a set of customers.

<h1 style="text-align: center"> Problem Description </h1>

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
julia transport-localitati.jl
```
4. The script will output the optimal routes for the vehicles and the total distance traveled. 

![image](https://github.com/calin2244/jl_tema/assets/95591065/a76ab2d1-5b03-4236-92e9-5ff1d903b0ed)

