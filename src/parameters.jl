
import AIBECS: @units, units
import AIBECS: @initial_value, initial_value
import AIBECS: @flattenable, flattenable, flatten
@flattenable @units @initial_value struct Params{Tp} <: AbstractParameters{Tp}
    τden::Tp  |   5.0 | u"d"           | true
    lowO₂::Tp |  0.06 | u"mol/m^3"     | true
    Ufix::Tp  |  10.0 | u"mmol/m^3/yr" | true # about half of 16U₀
    lowN::Tp  |  15.0 | u"mmol/m^3"    | true
    τD̅I̅N̅::Tp  |   1.0 | u"Myr"         | false
    D̅I̅N̅::Tp   | 31.02 | u"mmol/m^3"    | true
end
