function eLost = turbine_loss(nTurb, eOut)
    arraySize = size(nTurb);
    arraySize = arraySize(2);
    for k= 1:1:arraySize
     eLost(1,k) = ((1 / nTurb(1,k)) - 1) * eOut;
     %fprintf('eLost = %f', eLost(1,k));
    end
end
