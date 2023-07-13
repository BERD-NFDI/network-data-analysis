setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# install.packages("igraph")
# install.packages("ergm")
# install.packages("sna")
# install.packages("statnet")
# install.packages("intergraph")

# Task 1: Load all required packages (statnet, igraph)

# Task 2: Load the file faculty_network.RDS into your environment (hint: maybe check out readRDS)

# Task 3: What additional covariates are provided? Describe and visualize them.


# Task 4: Plot the network using the Fruchterman-Rheingold algorithm and use all additional covariates! 
#         Check out help("plot.network") to see how to modify the plot. 

# Task 5: We next want to model the data with the available information.
#         Check out help("ergm-terms") and state frequently used ways in which nodal attributes
#         can be incorporated. Which ones are reasonable for our network?

# Task 6: Next, we want to estimate an ergm with terms counting the following things:
#         1. Number of edges in the network
#         2. Geometrically weighted DEG-distribution with alpha = log(2)
#         3. Geometrically weighted ESP-distribution with alpha = log(2)
#         4. Absolute difference in wealth between actors
#         5. Homophily based on the same group
#         Specify how to use those terms in ergm!

# Task 7: Try to estimate the ergm with the Stochastic Approximation method.
#         Inspect the function "control.ergm" to decide on the type of estimation algorithm.

# Task 8: Finally, we want to use those estimates as starting values for the MCMLE estimation.

# Task 9: Print a summary of the model and interpret the findings.

# Task 10: Probabilistic models should be able to represent the observed data.
#          Inspect the gof function, plot it, and assess the fit of our model.

# Task 11: The model was fit with MCMC methods. Thus, the estimates are only valid,
#          if the networks are really from the stationary distribution.
#          Further, ML estimates have the property to recover the observed sufficient
#          statistics on average. Use the function "mcmc.diagnostics" on your fitted model,
#          which visualizes the path of sufficient statistics centered around the observed
#          statistics.
