function eLoss = pump_loss(nPump, eIn)
    for k:1:size(nPump)(2)
        eLoss(1,k) = ( 1 - nPump(1,k)) * eIn;
    end
end
