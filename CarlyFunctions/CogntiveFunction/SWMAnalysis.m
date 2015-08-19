function [SWM, SWMlabels] = SWMAnalysis( sub, plotflag )
%function [GenAcc GenRT SwitchAcc SwitchRT AccDiff RTDiff]=SWMAnalysis(name)

name=[sub '_SWM.xlsx'];
[num,txt,raw]=xlsread(name);

%% Measures that I have
n=size(num, 1);

%'Running' Type of trial (praclist or mainList)
TrialType=txt(3:n+2, 98);
TrainTrials=sum(strcmp(TrialType, 'praclist'));
n=n-TrainTrials;

% 'Procedure' tells you if a practive or not and how many dots

% 'Probe.ACC', 'Probe2.ACC', 'Probe3.ACC'
dot1=num(TrainTrials+1:end, 69);
dot2=num(TrainTrials+1:end, 78);
dot3=num(TrainTrials+1:end, 87);

correct=nansum([dot1, dot2, dot3], 2);

%General Accuracy
SWM=mean(correct);
SWM0=nansum(correct)/sum(~isnan(correct(:)));
SWM1=nansum(dot1)/sum(~isnan(dot1(:)));
SWM2=nansum(dot2)/sum(~isnan(dot2(:)));
SWM3=nansum(dot3)/sum(~isnan(dot3(:)));

if plotflag
    bar([SWM0 SWM1 SWM2 SWM3])
    set(gca,'XtickL',['All', '1 Dot', '2 Dots', '3 Dots']);
    ylabel('%Correct')
end

SWMlabels={'SPWMAcc'};
end
