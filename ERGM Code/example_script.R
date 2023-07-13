# Script for Part 2 of the Network Tutorial


setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(igraph)
library(ergm)
library(sna)
library(statnet)
library(intergraph)
# install.packages("igraph")
# install.packages("ergm")
# install.packages("sna")
# install.packages("statnet")
# install.packages("intergraph")

# 1. ER Simulations ----
set.seed(123)
g <- erdos.renyi.game(50, 1/2)
pdf("Plots/example_er_0_5.pdf")
plot(g)
dev.off()
g <- erdos.renyi.game(50, 1/10)
pdf("Plots/example_er_0_1.pdf")
plot(g)
dev.off()


# 2. ER Simulations with covariates ----

set.seed(13)
n_actors <- 50
x <- abs(rnorm(n = n_actors))
pdf("Plots/density_x.pdf")
plot(density(x, from = 0), main = "", xlab = "x Values")
dev.off()
x_cov <- outer(x,x,function(x,y) { abs(x-y)})
cov_tmp <- graph_from_adjacency_matrix(x_cov, mode = "undirected", weighted = T)
pdf("Plots/covs.pdf")
plot(cov_tmp, edge.width = E(cov_tmp)$weight*0.4,vertex.size = x*5)
dev.off()

expit <- function(x) {exp(x)/(1+exp(x))}
network_mat <- matrix(rbinom(n = length(x_cov), size = 1, prob = expit(-2- x_cov)),nrow = n_actors)
diag(network_mat) <- NA
network_tmp <- graph_from_adjacency_matrix(network_mat, mode = "undirected")
pdf("Plots/net_pos.pdf")
plot(network_tmp, vertex.size = x*5)

dev.off()
network_mat <- matrix(rbinom(n = length(x_cov), size = 1, prob = expit(-6+ 4*x_cov)),nrow = n_actors)
diag(network_mat) <- NA
network_tmp <- graph_from_adjacency_matrix(network_mat, mode = "undirected")
pdf("Plots/net_neg.pdf")
plot(network_tmp, vertex.size = x*5)
dev.off()

# 3. Degree distribution of ER graphs ----

set.seed(2)
sim_net <- simulate(network(50,directed = F,loops = F) ~ edges, coef=c(-2))
ig2 <- intergraph::asIgraph(sim_net)
plot(ig2)
pdf("Plots/degreedist_er.pdf")
sum_net <- summary(sim_net ~ degree(c(0:10)))
plot(y = sum_net, x = 0:10, xlab = "Degree", ylab = "Absolute Frequency", type = "b")
dev.off()

n_actors = 10000
pi = 0.001
sim_net <- erdos.renyi.game(n_actors, pi)
degree_dist_tmp = degree_distribution(sim_net)
x = 0:(length(degree_dist_tmp)-1)

pdf("Plots/degreedist_er_exact.pdf")
plot(x = x,
     degree_dist_tmp*n_actors, xlab = "Degree",
     ylab = "Absolute Frequency", type = "b")
legend(x = 15, y = 1000,legend = c("Observed", "Expected"),
       col = c("black", "red"),lty = c(1,1))
dev.off()

pdf("Plots/degreedist_er_approx.pdf")
plot(x = x,
     degree_dist_tmp*n_actors, xlab = "Degree",
     ylab = "Absolute Frequency", type = "b")
lines(x =x,y =  dbinom(x = x, size = n_actors-1, prob = pi)*n_actors, col = "red")
legend(x = 15, y = 1000,legend = c("Observed", "Expected"),
       col = c("black", "red"),lty = c(1,1))
dev.off()

# 4. Simulations from ERGM models ----

set.seed(123)
sim_net <- simulate(network(50,directed = F,loops = F) ~ edges + degree(2), coef=c(-2, 2))
ig2 <- intergraph::asIgraph(sim_net)
pdf("Plots/net_degree_2.pdf")
plot(ig2)
dev.off()
pdf("Plots/degreedist_2.pdf")
sum_net <- summary(sim_net ~ degree(c(0:10)))
plot(y = sum_net, x = 0:10, xlab = "Degree", ylab = "Absolute Frequency", type = "b")
dev.off()

set.seed(2)
sim_net <- simulate(network(50,directed = F,loops = F) ~ edges + degree(c(0:10)), coef=c(-1, seq(11,-1,length.out = 11)))
ig2 <- intergraph::asIgraph(sim_net)
pdf("Plots/net_degree_25.pdf")
plot(ig2)
dev.off()
pdf("Plots/degreedist_25.pdf")
sum_net <- summary(sim_net ~ degree(c(0:10)))
plot(y = sum_net, x = 0:10, xlab = "Degree", ylab = "Absolute Frequency", type = "b")
dev.off()

set.seed(123)
sim_net <- simulate(network(50,directed = F,loops = F) ~ edges + esp(c(2)), coef=c(-3, 2.5))
ig2 <- intergraph::asIgraph(sim_net)
pdf("Plots/net_esp_25.pdf")
plot(ig2)
dev.off()
pdf("Plots/espdist_25.pdf")
sum_net <- summary(sim_net ~ esp(c(0:10)))
plot(x = 0:10, y = sum_net, xlab = "Edgewise Shared Partners", ylab = "Absolute Frequency", type = "b")
dev.off()

set.seed(123)
sim_net <- simulate(network(50,directed = F,loops = F) ~ edges + dsp(c(2)), coef=c(-3, 2.5))
ig2 <- intergraph::asIgraph(sim_net)
pdf("Plots/net_esp_25.pdf")
plot(ig2)
dev.off()
pdf("Plots/espdist_25.pdf")
sum_net <- summary(sim_net ~ dsp(c(0:10)))
plot(x = 0:10, y = sum_net, xlab = "Edgewise Shared Partners", ylab = "Absolute Frequency", type = "b")
dev.off()


# 5. Examples of Degeneracy in the ERGM ----

values_triangle = seq(from = -1,to =1,length.out = 300)
exp_triangle = numeric(300)
exp_edges = numeric(300)
i = 1
for(i in 1:length(values_triangle)) {
  cat(i,"\n")
  sim_net <- simulate(network(50,directed = F,loops = F) ~ edges + kstar(c(2)),
                      coef=c(-3,values_triangle[i]),nsim = 1000,output = "stats")
  tmp = colMeans(sim_net)
  exp_edges[i] = tmp[1]
  exp_triangle[i] = tmp[2]
}
pdf("Plots/degeneracy_example.pdf",width = 12)
par(mfrow = c(1,2))
plot(values_triangle,exp_triangle, type = "l", xlab = expression(theta["2-star"]),
     ylab = "Expected 2-star statistics")
plot(values_triangle,exp_edges, type = "l", xlab = expression(theta["2-star"]),
     ylab = "Expected number of edges")
dev.off()

set.seed(123)
sim_net1 <- simulate(network(50,directed = F,loops = F) ~ edges + kstar(c(2)),
                    coef=c(-3,0.05))
ig1 <- intergraph::asIgraph(sim_net1)
sim_net2 <- simulate(network(50,directed = F,loops = F) ~ edges + kstar(c(2)),
                     coef=c(-3,0.1))
ig2 <- intergraph::asIgraph(sim_net2)

pdf("Plots/degeneracy_picture.pdf",width = 12)
par(mfrow = c(1,2))
plot(ig1, main = expression(paste(theta["2-star"],"= 0.05")))
plot(ig2, main = expression(paste(theta["2-star"],"= 0.1")))
dev.off()

pdf("Plots/net_esp_25.pdf")
plot(ig2)
dev.off()


# 6. Illustrative example of applying the ERGM ----


data(faux.desert.high)
friendship_network <- as.matrix(faux.desert.high)
friendship_network <- symmetrize(friendship_network, rule="weak")
friendship_network <- network(friendship_network, directed = F)
friendship_network %v% "grade" <- faux.desert.high %v% "grade"
friendship_network %v% "race" <- faux.desert.high %v% "race"
friendship_network %v% "sex" <- faux.desert.high %v% "sex"
isolates <- sna::isolates(friendship_network)
network::delete.vertices(friendship_network, isolates)

friendship_model <- ergm(friendship_network~ edges+
                           gwesp(log(2), fixed = T) +
                           gwdegree(log(2), fixed = T) +
                           nodematch("grade")+
                           nodematch("race")+
                           nodematch("sex"))
summary(friendship_model)
friendship_gof <- gof(friendship_model)

friendship_gof$bds.deg
pdf("Plots/gof_friendship.pdf")
plot(friendship_gof,main = "")
dev.off()

friendship_network %v% "deg_log_log" = log(log(sna::degree(friendship_network)))

pdf("Plots/network_friendship.pdf",width = 20,height= 20)
set.seed(243)
plot(friendship_network,
     mode = "kamadakawai",
     vertex.cex =friendship_network %v% "deg_log_log",
     vertex.col=friendship_network %v% "grade")
dev.off()
