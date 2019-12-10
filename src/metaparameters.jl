using AIBECS, BSON, WorldOceanAtlasTools, Inpaintings

# Circulation grid and transport operator
Circulation = OCIM1
grd, T = Circulation.load()

# Parameters from P model
BSON.@load joinpath(@__DIR__, "..", "data", "parameters.bson") w₀ w′ z₀ τPOP U₀ k
function w() # does not depend on p
    return @. w₀ + w′ * z # same as POP
end
iwet = findall(vec(iswet(grd)))
z = ustrip.(grd.depth_3D[iwet])
T_POP = transportoperator(grd, w=w())

# Oxygen
rawO₂, nobsO₂ = WorldOceanAtlasTools.raw_to_grid(grd, 2018, "oxygen", "annual", "1°", "an")
rawO₂[nobsO₂ .== 0] .= NaN
O₂_3D = fill(NaN, size(grd))
for iz in 1:size(grd)[3]
    O₂_3D[:,:,iz] .= inpaint(rawO₂[:,:,iz])
end
const O₂ = O₂_3D[iwet]

# P model for initial guess 
BSON.@load joinpath(@__DIR__, "..", "data", "uptake.bson") DIP POP
