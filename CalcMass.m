% Activity X.X.X: 
% File:    filename.m
% Date:    2017
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
%

function massRequired = CalcMass(eOut, turbineLoss, pipeLoss, bendLoss,...
                                 dropHeight, tankDepth)
    massRequired = ((eOut + turbineLoss) * (3.6 * 10^9)) / (9.81...
                    * (dropHeight + tankDepth / 2.0 - pipeLoss...
                    - bendLoss));
end