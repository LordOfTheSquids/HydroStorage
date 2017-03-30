% Activity X.X.X: Project 2
% File:    MinFlowCalc.m
% Date:    03/30/2017
% By:      Jacob Bartkiewicz
%          jbartkie
%          Andrew Meyer
%          meyer256
%          Haley Nelson
%          nelso310
%          Mark Pollard
%          mpollar
% Section: 04
% Team:    65
%
% ELECTRONIC SIGNATURE
% Jacob Bartkiewicz
% Andrew Meyer
% Haley Nelson
% Mark Pollard
%
% The electronic signatures above indicate that the program
% submitted for evaluation is the combined effort of all
% team members and that each member of the team was an
% equal participant in its creation. In addition, each
% member of the team has a general understanding of
% all aspects of the program development and execution.
% 
% A BRIEF DESCRIPTION OF WHAT THE PROGRAM OR FUNCTION DOES
% Calculates the minimum flow rate required to fill/drain the
% reservoir in a given number of hours, based on system parameters
% hCoeff = 1/2 * (fL/D + bendCoeffs)

function flowRate = MinFlowCalc(Eout, turbEff, grav, resHeight,...
                                resDepth, pipeDiam, hCoeff, drainTime)
    % Calculate the coefficients for the cubic equation for flowRate
    % AQ^3 + BQ^2 + CQ + D = 0
    coeffA = -16 * hCoeff / (pi * pipeDiam^4);
    coeffC = resHeight + resDepth / 2;
    coeffD = -Eout * 1000 / (turbEff * grav * drainTime);
    
    % Thankfully MATLAB has a built in polynomial-solving function
    qVals = roots([coeffA, 0, coeffC, coeffD]);
    
    % Assign flowRate to smallest positive value
    flowRate = qVals(1);
    for i = 2:3
        if (qVals(i) > 0 && (qVals(i) < flowRate || flowRate < 0))
            flowRate = qVals(i);
        end
    end
end