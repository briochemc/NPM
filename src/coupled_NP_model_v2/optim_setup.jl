
using WorldOceanAtlasTools, Optim, F1Method

# WOA data
μDINobs3D, σ²DINobs3D = WorldOceanAtlasTools.fit_to_grid(grd, 2018, "nitrate", "annual", "1°", "an")
μDINobs, σ²DINobs = μDINobs3D[iwet], σ²DINobs3D[iwet]
μPO₄obs3D, σ²PO₄obs3D = WorldOceanAtlasTools.fit_to_grid(grd, 2018, "phosphate", "annual", "1°", "an")
μPO₄obs, σ²PO₄obs = μPO₄obs3D[iwet], σ²PO₄obs3D[iwet]
const μx = (μPO₄obs, missing, μDINobs, missing)
const σ²x = (σ²PO₄obs, missing, σ²DINobs, missing)

# param weights
const ωs = [1.0, 0.0, 1.0, 0.0] # the weight for the mismatch (weight of POP = 0)
const ωp = 1e-4

# objective functions
const v = ustrip.(vector_of_volumes(grd))
f, ∇ₓf, ∇ₚf = generate_objective_and_derivatives(ωs, μx, σ²x, v, ωp)

# Use F1 for gradient and Hessian
mem = F1Method.initialize_mem(x, p)
objective(p) = F1Method.objective(f, F, ∇ₓF, mem, p, CTKAlg(), preprint="obj ")
gradient(p) = F1Method.gradient(f, F, ∇ₓf, ∇ₓF, mem, p, CTKAlg(), preprint="grad ")
hessian(p) = F1Method.hessian(f, F, ∇ₓf, ∇ₓF, mem, p, CTKAlg(), preprint="hess ")

# change of variables
λ2p = subfun(typeof(p))
∇λ2p = ∇subfun(typeof(p))
∇²λ2p = ∇²subfun(typeof(p))
p2λ = invsubfun(typeof(p))
λ = p2λ(p)

# variable-changed objective function and derivatives
function obj(λ)
    show(λ2p(λ))
    return objective(λ2p(λ))
end
using LinearAlgebra
function grad(λ)
    return gradient(λ2p(λ)) * Diagonal(∇λ2p(λ))
end
function hess(λ)
    ∇p = Diagonal(∇λ2p(λ)) # for variable change
    ∇²p = Diagonal(∇²λ2p(λ)) # for variable change
    G = vec(gradient(λ2p(λ)))
    H = hessian(λ2p(λ))
    return ∇p * H * ∇p + Diagonal(G) * ∇²p
end

const m = length(p)
grad(s, λ) = s[1:m] .= vec(grad(λ))
hess(s, λ) = s[1:m,1:m] .= hess(λ)
opt = Optim.Options(store_trace = false, show_trace = true, extended_trace = false)


