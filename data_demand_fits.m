load('data_demand.mat');

rescale1=data_demand(20:end,:);
minvalx=min(rescale1(:,1));
minvaly=min(rescale1(:,2));
rescale1(:,1)=rescale1(:,1)-minvalx;
rescale1(:,2)=rescale1(:,2)-minvaly;

p1=polyfit(rescale1(:,1),rescale1(:,2),4)
rescale1(:,3)=polyval(p1,rescale1(:,1));

rescale1(:,1)=rescale1(:,1)+minvalx;
rescale1(:,2)=rescale1(:,2)+minvaly;
rescale1(:,3)=rescale1(:,3)+minvaly;


plot(rescale1(:,1),rescale1(:,2),'o');
hold on
plot(rescale1(:,1),rescale1(:,3),'-');



rescale2=data_demand(1:20,:);
minvalx=max(rescale2(:,1));
minvaly=min(rescale2(:,2));
rescale2(:,1)=rescale2(:,1)-minvalx;
rescale2(:,2)=rescale2(:,2)-minvaly;

p2=polyfit(rescale2(:,1),rescale2(:,2),3)
rescale2(:,3)=polyval(p2,rescale2(:,1));

rescale2(:,1)=rescale2(:,1)+minvalx;
rescale2(:,2)=rescale2(:,2)+minvaly;
rescale2(:,3)=rescale2(:,3)+minvaly;


plot(rescale2(:,1),rescale2(:,2),'o');
hold on
plot(rescale2(:,1),rescale2(:,3),'-');
hold off

xlabel('Weight Strength \omega');
ylabel('log (Data)');
title('Data Demand Trends');
legend('Data points (strong weights)',...
    sprintf('Polynomial fit ~ %.2g (w-w_c)^4',p1(1)),...
    'Data points (weak weights)',...
    sprintf('Polynomial fit ~ %.2g (w-w_c)^3',abs(p2(1))));

