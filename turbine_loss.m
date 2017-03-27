function eLost = turbine_loss(nTurb, eOut)
    eLost = ((1 / nTurb) - 1) * eOut;
end;