clc
clear


imgL = imread('data\scene1.row3.col3.ppm');
imgR = imread('data\scene1.row3.col4.ppm');
imgL = rgb2gray(imgL);
imgR = rgb2gray(imgR);
imshow(imgL);

H = size(imgL,1);
W = size(imgR,2);

dispLevels = 20;
%calculate the raw cost
rawCost = rawCostCalculate(imgL,imgR,dispLevels);

%find path
costCube = zeros(dispLevels,H,W);

for i=1:H
    for j = 1:W
        
        if (j>1)
            priorCostVec =  costCube(:,i,j-1);
            rawCostVec = rawCost(:,i,j);
            path_intensity_grad = abs( double(imgL(i,j)) - double(imgL(i,j-1)) );
            curCostVec = evaluatePath(priorCostVec,rawCostVec,path_intensity_grad);
            costCube(:,i,j)  =  costCube(:,i,j) + curCostVec;
        end
        if (i>1 && j>1)
            priorCostVec =  costCube(:,i-1,j-1);
            rawCostVec = rawCost(:,i,j);
            path_intensity_grad = abs( double(imgL(i,j)) - double(imgL(i-1,j-1)) );
            curCostVec = evaluatePath(priorCostVec,rawCostVec,path_intensity_grad);
            costCube(:,i,j)  =  costCube(:,i,j) + curCostVec;
        end
        if (i>1)
            priorCostVec =  costCube(:,i-1,j);
            rawCostVec = rawCost(:,i,j);
            path_intensity_grad = abs( double(imgL(i,j)) - double(imgL(i-1,j)) );
            curCostVec = evaluatePath(priorCostVec,rawCostVec,path_intensity_grad);
            costCube(:,i,j)  =  costCube(:,i,j) + curCostVec;
        end
        
        if (i>1 && j<=W-j)
            priorCostVec =  costCube(:,i-1,j+1);
            rawCostVec = rawCost(:,i,j);
            path_intensity_grad = abs( double(imgL(i,j)) - double(imgL(i-1,j+1)) );
            curCostVec = evaluatePath(priorCostVec,rawCostVec,path_intensity_grad);
            costCube(:,i,j)  =  costCube(:,i,j) + curCostVec;
        end
    end
end
