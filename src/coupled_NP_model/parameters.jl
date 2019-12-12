using Distributions

# Parameters
import AIBECS: @units, units
import AIBECS: @initial_value, initial_value
import AIBECS: @flattenable, flattenable, flatten
@flattenable @units @initial_value struct Params{Tp} <: AbstractParameters{Tp}
    Uupt::Tp  |  1.15 | u"mmol/m^3/yr" | true
    k::Tp     |  0.06 | u"mmol/m^3"    | true
    τden::Tp  |  3.16 | u"d"           | true
    lowO₂::Tp |   0.6 | u"mmol/m^3"    | true
    Ufix::Tp  |  0.25 | u"mmol/m^3/yr" | true # about half of 16U₀
    lowN::Tp  |  2.73 | u"mmol/m^3"    | true
    τgeo::Tp  |   1.0 | u"Myr"         | false
    D̅I̅P̅::Tp   |  2.18 | u"mmol/m^3"    | false
    D̅I̅N̅::Tp   | 31.02 | u"mmol/m^3"    | false
end

# Assign a lognormal prior to each based on initial value
import AIBECS: @prior, prior
function prior(::Type{T}, s::Symbol) where {T<:Params}
    if flattenable(T, s)
        μ = log(ustrip(upreferred(initial_value(T, s) * units(T, s))))
        return LogNormal(μ ,1.0)
    else
        return nothing
    end
end
prior(::T, s::Symbol) where {T<:AbstractParameters} = prior(T,s)
prior(::Type{T}) where {T<:AbstractParameters} = Tuple(prior(T,s) for s in AIBECS.symbols(T))
prior(::T) where {T<:AbstractParameters} = prior(T)
