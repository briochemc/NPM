# optimize model
results = optimize(obj, grad, hess, λ, NewtonTrustRegion(), opt)

p_optimized = λ2p(results.minimizer)
prob_optimized = SteadyStateProblem(F, ∇ₓF, x, p_optimized)
s_optimized = solve(prob_optimized, CTKAlg()).u




