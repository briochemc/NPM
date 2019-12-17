
using Plots

pyplot()
plt = ratioatstation(1e3PO₄,1e3DIN,grd,21.0,-158, label="HOT", marker=:diamond, color=:black, ms=6, zlims=(0,1000))
ratioatstation!(1e3PO₄,1e3DIN,grd,31.5,-64, label="BATS", marker=:square, color=:lightgray, ms=6, zlims=(0,1000))


ratioatstation!(1e3μPO₄obs,1e3μDINobs,grd,21.0,-158, label="HOT obs", marker=:diamond, color=:black, ms=3, zlims=(0,1000))
ratioatstation!(1e3μPO₄obs,1e3μDINobs,grd,31.5,-64, label="BATS obs", marker=:square, color=:lightgray, ms=3, zlims=(0,1000))

xlabel!("PO₄ (μM)", xtickfontsize=14, xguidefontsize=14) #, xlim=(0,1))
ylabel!("DIN (μM)", ytickfontsize=14, yguidefontsize=14) #, ylim=(0,20), yticks=0:2:20)
plot!(legend=:topleft, legendfontsize=14)

#plot!(plt, dpi=300)
#savefig(plt, "figs/NvsP_upper1000m_coupled_model_optimized.pdf")