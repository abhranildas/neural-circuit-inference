function [] = arrange_DataStrct(idAnimal)

eval(['load data_' idAnimal '/data_gridsearch.mat']);
files = dir(['data_' idAnimal '/partial_data/data_x*.mat']);

nAl = numel(Alpha);
nTh = numel(Theta);
nSp = numel(Space);

for idFile = 1:numel(files)
    idFile
    eval(['load data_' idAnimal '/partial_data/' files(idFile).name]);
    Ncell = size(Ccoef_FR,1);
    
    id_first = 1 + (idFile-1)*nSp*nTh*nAl;
    id_last = idFile*nSp*nTh*nAl;

    for trial = 1:size(Ccoef_FR,2)
        for gcell = 1:Ncell
            CC_FR{gcell,trial}(id_first:id_last,1) = Ccoef_FR{gcell,trial};
            if trial==1 && gcell == 1
                PARAM(id_first:id_last,:) = Params{1};
            end
        end 
        
    end
end

for trial = 1:size(Ccoef_FR,2)
    for gcell = 1:Ncell
        if trial == 1 && gcell == 1
            [~,I] = sort(PARAM(:,3));
            for ii = 1:size(PARAM,2)
                PARAM(:,ii) = PARAM(I,ii);
            end
        end
        CC_FR{gcell,trial} = CC_FR{gcell,trial}(I);
    end
end

for trial = 1:size(Ccoef_FR,2)
    for gcell = 1:Ncell
        if trial == 1 && gcell == 1
            [~,I] = sort(PARAM(:,4));
            for ii = 1:size(PARAM,2)
                PARAM(:,ii) = PARAM(I,ii);
            end
        end
        CC_FR{gcell,trial} = CC_FR{gcell,trial}(I);
    end
end
eval(['save data_' idAnimal '/data_gridsearch.mat -append CC_FR PARAM']);

K_theta = nSp^2;
K_alpha = K_theta*nTh;

for trial = 1:size(Ccoef_FR,2)
    for gcell = 1:Ncell
        for id_alpha = 1:numel(Alpha)

            for id_theta = 1:numel(Theta)

                val = CC_FR{gcell,trial}( 1 + (id_theta-1)*K_theta + (id_alpha-1)*K_alpha : id_theta*K_theta + (id_alpha-1)*K_alpha );
                [maxcc,I] = max(val);            
                CCval_FR{gcell,trial}{id_alpha,1}(id_theta,1) = maxcc;

                XYZ{gcell,1}{id_alpha,1}(id_theta,:) = PARAM(I+(id_theta-1)*K_theta+(id_alpha-1)*K_alpha,1:3);
            end    
        end
    end
end
eval(['save data_' idAnimal '/data_gridsearch.mat -append CCval_FR XYZ']);






