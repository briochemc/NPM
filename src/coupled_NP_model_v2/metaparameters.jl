using AIBECS, BSON, WorldOceanAtlasTools, Inpaintings

# Circulation grid and transport operator
Circulation = OCIM1
grd, T = Circulation.load()

# iwet and z
iwet = findall(vec(iswet(grd)))
z = ustrip.(grd.depth_3D[iwet])

# Oxygen
rawO₂, nobsO₂ = WorldOceanAtlasTools.raw_to_grid(grd, 2018, "oxygen", "annual", "1°", "an")
rawO₂[nobsO₂ .== 0] .= NaN
O₂_3D = fill(NaN, size(grd))
for iz in 1:size(grd)[3]
    O₂_3D[:,:,iz] .= inpaint(rawO₂[:,:,iz])
end
const O₂ = O₂_3D[iwet]

