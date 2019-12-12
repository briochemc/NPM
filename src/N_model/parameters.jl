using Distributions

# Parameters
import AIBECS: @units, units
import AIBECS: @initial_value, initial_value
import AIBECS: @flattenable, flattenable, flatten
@flattenable @units @initial_value struct Params{Tp} <: AbstractParameters{Tp}
    τden::Tp  |   5.0 | u"d"           | true
    lowO₂::Tp |  0.06 | u"mol/m^3"     | true
    Ufix::Tp  |  10.0 | u"mmol/m^3/yr" | true # about half of 16U₀
    lowN::Tp  |  15.0 | u"mmol/m^3"    | true
    τD̅I̅N̅::Tp  |   1.0 | u"Myr"         | false
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
