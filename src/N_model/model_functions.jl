# Transport operators
T_DIN(p) = T       # OCIM1
T_PON(p) = T_POP

# Uptake
# 16 times more that the P model
function uptake(DIN, p)
    return @. 16U₀ * DIN/(DIN+16k) * (z≤z₀) * (DIN≥0)
end

# Remin
function remin(PON,p)
    return PON / τPOP # same as POP
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
function G_DIN(DIN, PON, p)
    @unpack D̅I̅N̅, τD̅I̅N̅ = p
    return @. -$uptake(DIN,p) + $remin(PON,p) - $denit(DIN,p) + (D̅I̅N̅ - DIN) / τD̅I̅N̅
end
function G_PON(DIN, PON, p)
    return @. $uptake(DIN,p) - $remin(PON,p) + $fixation(DIN,p)
end

# Problem setup
p = Params()
nb = sum(iswet(grd))

# initial guess
x = [16DIP; 16POP] # initial guess = 16 times the P model optimized values

# state function and its Jacobian
F, ∇ₓF = state_function_and_Jacobian((T_DIN, T_PON), (G_DIN, G_PON), nb)

# problem
prob = SteadyStateProblem(F, ∇ₓF, x, p)
