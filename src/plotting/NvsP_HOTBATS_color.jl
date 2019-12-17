
using Plots
pyplot()

HOT = (21.0,-158)
BATS = (31.5,-64)

plt = plot()
#ratioatstation!(1e3PO₄,1e3DIN,grd,HOT..., label="HOT", marker=:diamond, color=1, ms=3, zlims=(0,1000), alpha=0.5)
#ratioatstation!(1e3PO₄,1e3DIN,grd,BATS..., label="BATS", marker=:square, color=2, ms=3, zlims=(0,1000), alpha=0.5)


ratioatstation!(1e3μPO₄obs,1e3μDINobs,grd,HOT..., label="HOT obs", marker=:diamond, color=1, ms=3, zlims=(0,1000), alpha=0.5)
ratioatstation!(1e3μPO₄obs,1e3μDINobs,grd,BATS..., label="BATS obs", marker=:square, color=2, ms=3, zlims=(0,1000), alpha=0.5)

xlabel!("PO₄ (μM)", xtickfontsize=14, xguidefontsize=14) #, xlim=(0,1))
ylabel!("DIN (μM)", ytickfontsize=14, yguidefontsize=14) #, ylim=(0,20), yticks=0:2:20)
plot!(legend=:topleft, legendfontsize=14)

#plot!(plt, dpi=300)
#savefig(plt, "figs/NvsP_upper1000m_coupled_model_optimized.pdf")