%Example For Cog Processing

%% To rebatch use 'CognitiveBatching'

%% To run correlations
close all
clear all

clc
%load('/Users/carlysombric/Desktop/UpdatedCode_6_2015/labTools-master/paramFiles/CogSubs.mat')
load('/Users/carlysombric/Desktop/Temp Storage/ParamFiles/Forget Subs/paramFiles/CogSubs.mat')
groups = {'OldAbruptCognitive'};
params = {'spatialContributionNorm2','stepTimeContributionNorm2','velocityContributionNorm2','netContributionNorm2'};
results = getResults(CogSubs,params,groups,0);

COGparams={'IQ', '3MS', 'SPWMAcc',...
    'WCSNpersev', 'WCSPerPersev', 'WCSPerPersevErr', 'WCSSequencePersec',...
    'WCSIllogicalPersev', 'WCSTotPersev', 'WCSLogicErr', 'WCSSwitchCost', 'WCSNswitch',...
    'ImplicitRecAcc', 'ImplicitRecHigh', 'ImplicitRecLow',...
    'ImplicitExpoAcc', 'ImplicitExpoRTHigh', 'ImplicitExpoRTLow'};
 
COGparams={'ImplicitRecAcc', 'ImplicitRecHigh', 'ImplicitRecLow', 'ImplicitRecRep', 'ImplicitRecTrill',...
    'ImplicitExpoAcc', 'ImplicitExpoRTHigh', 'ImplicitExpoRTLow',...
     'ImplicithighRTSS3',...
    'ImplicithighRTDelta3',...
     'ImplicitlowRTSS3',...
     'ImplicitlowRTDelta3',...
    'ImplicithighAccSS3',...
    'ImplicitlowAccSS3',...
    'ImplicithighAccDelta3',...
    'ImplicitlowAccDelta3'};

COGparams={'WCSTotPersev',  'WCSSwitchCost'};
MetaCorrelations(CogSubs, results,'OGafter',params,COGparams,groups);

% COGparams={'ImplicitExpoRTHigh', 'ImplicitExpoRTLow'};
%COGparams={'ImplicitExpoRTHigh', 'ImplicitExpoRTLow', 'ImplicithighRTSS3', 'ImplicitlowRTSS3'};
% COGparams={'ImplicithighRTSS3'};
%   MetaCorrelations(CogSubs, results,'Strides2SS',params,COGparams,groups);

%%COGparams={'ImplicitRecAcc', 'ImplicitRecLow', 'ImplicitExpoRTHigh', 'ImplicitExpoRTLow'};
%  COGparams={'ImplicithighRTSS3'};
%  MetaCorrelations(CogSubs, results,'PerForget',params,COGparams,groups);


epochs = {'Strides2SS','PerForget','catch','TMsteady','OGafter'};
%epochs = {'PerForget'};
indivSubFlag = 0;
barGroups(CogSubs,results,groups,params,epochs,indivSubFlag)

