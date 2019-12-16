# Transport operators
# dissolved inorganic P and N are trasnported by circulation
T_PO₄(p) = T
T_DIN(p) = T
# Particulate organic matter transported by T_POM
function w(p) # does not depend on p
    @unpack w₀, w′ = p
    return @. w₀ + w′ * z # same as POP
end
T_POM(p) = transportoperator(grd, w=w(p))
T_POP = T_POM
T_PON = T_POM

# PO₄ Uptake
function uptake_P(PO₄, DIN, p)
    @unpack Uupt, kPO₄, kDIN = p
    return @. Uupt * min(PO₄/(PO₄+kPO₄), DIN/(DIN+kDIN)) * (z≤z₀) * (DIN≥0) * (PO₄≥0)
end
function uptake_N(PO₄, DIN, p)
    @unpack NtoP = p
    return @. NtoP * Uupt * min(PO₄/(PO₄+kPO₄), DIN/(DIN+kDIN)) * (z≤z₀) * (DIN≥0) * (PO₄≥0)
end

# Remin
function remin_P(POP,p)
    @unpack τPOM = p
    return POP / τPOM
end
function remin_N(PON,p)
    @unpack τPOM = p
    return PON / τPOM
end

# N₂ fixation
function fixation(DIN,p)
    @unpack Ufix, lowN = p
    return @. Ufix * exp(-DIN/lowN) * (z≤z₀)
end

# Denitrification
function denit(DIN,p)
    @unpack τden, lowO₂ = p
    return @. DIN/τden * exp(-O₂/lowO₂)
end

# Net sources and sinks
function G_PO₄(PO₄, POP, DIN, PON, p)
    @unpack D̅I̅P̅, τgeo = p
    return @. -$uptake_P(PO₄, DIN, p) + $remin_P(POP,p) + (D̅I̅P̅ - PO₄) / τgeo
end
function G_DIN(PO₄, POP, DIN, PON, p)
    @unpack D̅I̅N̅, τgeo = p
    return @. -$uptake_N(PO₄, DIN, p) + $remin_N(PON,p) - $denit(DIN,p) + (D̅I̅N̅ - DIN) / τgeo
end
function G_POP(PO₄, POP, DIN, PON, p)
    return @. $uptake_P(PO₄, DIN, p) - $remin_P(POP,p)
end
function G_PON(PO₄, POP, DIN, PON, p)
    return @. $uptake_N(PO₄, DIN, p) - $remin_N(PON,p) + $fixation(DIN,p)
end

# Problem setup
p = Params()
nb = sum(iswet(grd))

# initial guess
BSON.@load joinpath(project_root_path, "data", "P_model_external", "uptake.bson") PO₄ POP
BSON.@load joinpath(project_root_path, "data", "N_model", "optimized_N_4plt.bson") DIN PON
x = [PO₄; POP; DIN; PON]

# state function and its Jacobian
F, ∇ₓF = state_function_and_Jacobian((T_PO₄, T_POP, T_DIN, T_PON), (G_PO₄, G_POP, G_DIN, G_PON), nb)

# problem
prob = SteadyStateProblem(F, ∇ₓF, x, p)
