//**********************************************
//**********                          **********
//********** niclas.gimber@charite.de **********
//**********                          **********
//**********************************************





//******************************
//*********enter parameters here 
//******************************


//filetype
extention=".nd2"


//****************prepare IJ for analysis
dir=getDirectory("Choose Directory");
files=getFileList(dir);
subfolder=dir+"\\analysis_new2\\";
File.makeDirectory(subfolder);
File.makeDirectory(subfolder+"ROIs\\");
File.makeDirectory(subfolder+"Binaries\\");
File.makeDirectory(subfolder+"Projection\\");
File.makeDirectory(subfolder+"Profiles\\");

//enlargement
enlargeFactor=-5; //in pixels

//size filters
minDapiSize=200; //in pixels
maxDapiSize=10000; // in pixels

//gaussian blur
DapiSigma=10; //in pixels

//autothreshold
auto=false;
threshMethods=newArray("Default dark","Huang dark","Huang dark","Intermodes dark","Intermodes dark","IsoData dark","IJ_IsoData dark","Li dark","MaxEntropy dark","Mean dark","MinError dark","Minimum dark","Moments dark","Otsu dark","Percentile dark","RenyiEntropy dark","Shanbhag dark","Triangle dark","Yen dark");
method="Otsu dark";

//some preparation for the dialoque
stop=false;
i=0;
close("*");
while (stop==false)
	{
	i++;
	if ((indexOf(files[i], extention)) >= 0) 
		{	
		run("Bio-Formats", "  open="+dir+files[i]+" color_mode=Default view=Hyperstack stack_order=XYCZT");
		getDimensions(width, height, channels, slices, frames);
		stop=true;
		}
	}
	close("*");
Threshs=newArray(channels-1);
Thresh_default=1.10;
for (i=0;i<channels-1;i++)
		{
		Threshs[i]=Thresh_default;
		}
//dialogue
Dialog.create("LDL Detector *****niclas.gimber@charite.de******");
  	
  	Dialog.addMessage("File Type");
  	Dialog.addString("extention", extention);
  	Dialog.addMessage("\n");
  	Dialog.addMessage("\n");	
  	
  	Dialog.addMessage("*** Cells will be segmented based on  dapi signal (ch1). ***");
  	Dialog.addMessage("\n");
  	Dialog.addNumber("Enlarge Dapi (negeative values will shrink Dapi) by # pixels, N: ", enlargeFactor);
  	Dialog.addMessage("\n");
  	Dialog.addCheckbox("Exclude nucleus for profiles:", false);
  	Dialog.addMessage("(Nucleoli will always be excluded in projections)");
  	Dialog.addMessage("\n");
  	
  	Dialog.addNumber("Minimal Dapi area (pixels^2: ", minDapiSize);
  	Dialog.addMessage("\n");  	
  	Dialog.addNumber("Maximal Dapi area (pixels^2: ", maxDapiSize);
  	Dialog.addMessage("\n");
  	Dialog.addNumber("Dapi Blur (pixels): ", DapiSigma);  
  	Dialog.addMessage("\n");
	print(channels);
  	for (i=1;i<channels;i++)
		{
		Dialog.addNumber("Biniarize channel "+i+1+": Lower Threshold (0 for no binarization):  ", Threshs[i-1]);
		}
	Dialog.addCheckbox("Autothreshold:", false);
	Dialog.addChoice("Threshold Method: ", threshMethods, method);
	
  	Dialog.show();
  	
	extention = Dialog.getString();  	
	enlargeFactor = Dialog.getNumber();
	excludeNucleus_profiles = Dialog.getCheckbox();
	minDapiSize = Dialog.getNumber();
	maxDapiSize = Dialog.getNumber();
	DapiSigma = Dialog.getNumber();
	auto= Dialog.getCheckbox();
	method=Dialog.getChoice();



  	for (i=1;i<channels;i++)
		{
		Threshs[i-1]=Dialog.getNumber();
		}







roiManager("reset");


run("Set Measurements...", "area mean standard modal min centroid center perimeter fit shape feret's integrated median display redirect=None decimal=9");
run("Input/Output...", "jpeg=85 gif=-1 file=.csv use_file copy_row save_column save_row");


//**************** Main Loop
for (i=0;i<files.length;i++)
	{
	if ((indexOf(files[i], extention)) >= 0) 

		{
		if (File.exists(subfolder+"Binaries\\Dapi_"+files[i]+".tif")==true)
		//if (File.exists(subfolder+"Binaries\\Thresh_ch"+1+"_"+files[i]+".tif")==true)
	{print(files[i]+" already exists");}
		else 

			{
			print(files[i]+" does not exist");
		
			while (nImages>0) 
			{ 
		          selectImage(nImages); 
		          close(); 
		      	} 

				if(isOpen("Results")==true)
				{
		      	close("Results"); 
				}
				
			run("Collect Garbage");
			call("java.lang.System.gc");
	
			run("Bio-Formats", "  open="+dir+files[i]+" color_mode=Default view=Hyperstack stack_order=XYCZT");
			title=getTitle();
	
	
			
			//**********************************************
			//**********Segmentations and Analysis**********
			//**********************************************


			//**********Dapi Segmentation**********
				selectWindow(title);

				run("Z Project...", "projection=[Average Intensity]");
				wait(1000);
				rename("projection");
				wait(1000);
				run("Duplicate...", "title=maxDapi duplicate channels=1");
				selectWindow("maxDapi");

				wait(100);

				setSlice(1);
				run("Select All");
				wait(100);

				run("Select All");
				run("Gaussian Blur...", "sigma="+DapiSigma+"");
				setAutoThreshold("Otsu dark");
				run("Convert to Mask");
				run("Watershed");
				rename("binary");
				run("Select All");
				roiManager("reset");
				selectWindow("binary");
				run("Analyze Particles...", "display exclude clear add");
				run("Analyze Particles...", "size="+minDapiSize+"-"+maxDapiSize+" pixel display exclude clear add");
				selectWindow("binary");
				saveAs("Tiff", subfolder+"Binaries\\Dapi_"+title+".tif");
				//close();


	


				//cut nucleus in LDL channel					    
				if (enlargeFactor!=0)
					{
					counts=roiManager("count");

					//selectWindow(title);
					//for(k=0; k<counts; k++) {
					//	roiManager("Select", k);
					//	setSlice(2);
					//	setForegroundColor(0, 0, 0);
					//	run("Fill", "slice");
					//}

					selectWindow("projection");
					setSlice(2);
					run("Select All");
					run("Clear Results");
					wait(1000);
					run("Measure");
					wait(1000);
					median=getResult("Median", 0);
					print(median);
					run("Clear Results");
					roiManager("Deselect");
					run("Subtract...", "value="+median+" slice");



					
					//for(l=0; l<counts; l++) {
						//roiManager("Select", l);
						//setSlice(2);
						//changeValues(-9999999999999999,999999999999999999,modal); 
					//}

					//enlarge ROIs

					counts=roiManager("count");
					for(m=0; m<counts; m++) {
					    roiManager("Select", m);
					    roiManager("Add");
					    roiManager("Select", m);
					    run("Enlarge...", "enlarge="+enlargeFactor+" pixel");
					    roiManager("Update");
					    }
					    roiManager("Deselect");
					    roiManager("Save", subfolder+"ROIs\\Cells_"+title+"_noRings.zip");
			

					 for(m=0; m<counts; m++) {		  
					    roiManager("Select", newArray(m,m+counts));
					    roiManager("XOR");
					    roiManager("Update");
					    }

				    

					    for(m=0; m<counts; m++) {
					    roiManager("Select", counts);
						roiManager("Delete");
					    }
						




					
				}


				//rename ROIs
				faculty=newArray();
				 n = roiManager("count");
				  for (r=0; r<n; r++) 
				  	{
				  	faculty=Array.concat(faculty,r);
				    roiManager("select", r);  
				    roiManager("Rename", r);
				  	}
			
				  roiManager("Save", subfolder+"ROIs\\Cells_"+title+".zip");


			
			//**********Measure all channels**********			

			selectWindow("projection");
			getDimensions(width, height, channels, slices, frames);
			print(channels);
			for (ch=1;ch<=channels;ch++)
			{
				selectWindow("projection");
				run("Select All");
				run("Duplicate...", "duplicate channels="+ch+"");
				run("Clear Results");
				roiManager("Deselect");
				roiManager("multi-measure measure_all");
				saveAs("Results", ""+subfolder+"Projection\\"+title+"_ch"+ch+"_.csv");
				close("tmp");
				close("Results"); 
			}


			for (ch=1;ch<=channels;ch++)
			{
			//**********profiles  **********
			selectWindow(title);
			run("Select All");
			run("Duplicate...", "duplicate channels="+ch+"");

			
			if (ch>1)//"-1" because dapi has ni thresh
				{
				if (auto==true)
					{

					//setOption("BlackBackground", true);
					run("8-bit");	
					setAutoThreshold(""+method+" no-reset");				
					//run("NaN Background", "slice");		
					run("Convert to Mask", "stack");	
					//run("Invert", "stack");	

					saveAs("Tiff", subfolder+"Binaries\\Thresh_ch"+ch+"_"+title+".tif");
					//resetThreshold();		
					print(ch);					
					}										
				else {

					if (Threshs[ch-2]>0)//"-1" because dapi has no thresh
						{		
														
							setOption("BlackBackground", true);	
							setThreshold(Threshs[ch-2], 999999999);	
							run("Convert to Mask", "stack");
							//run("Invert", "stack");								
							saveAs("Tiff", subfolder+"Binaries\\Thresh_ch"+ch+"_"+title+".tif");						

						}
							
					}	
					
				}
				

							
			



			roiManager("Deselect");			


			if(excludeNucleus_profiles==false)//measuer also above nucleus
				{
				roiManager("Deselect");
				roiManager("Delete");
				roiManager("Open", subfolder+"ROIs\\Cells_"+title+"_noRings.zip");
				}
				for (ri = 0; ri < roiManager("count")-1; ri++) 
					{				
					roiManager("Select", ri);
					roiManager("Select", ri);
					roiManager("multi-measure measure_all");
					saveAs("Results", ""+subfolder+"Profiles\\"+title+"ch"+ch+"_"+ri+".csv");
					close(title+"LDL"+ri+".csv");
					close("Results"); 
					}
				}
	


			


			}
		

	}
close("*");
}





function readArray(columnname)
	{
	storageArray=newArray(nResults);
	for(row=0;row<nResults;row++)
		{
		storageArray[row]=getResult(columnname, row);
		}
		return storageArray;
	}


print("\\Clear");
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
print(year+"-"+month+"-"+dayOfWeek+": "+hour+"-"+minute+"-"+second);
print("extention "+extention);  	
print("enlarge by factor "+enlargeFactor);
print("exclude nucleus (this applies only for profiles) "+excludeNucleus_profiles);
print("minimal dapi size "+minDapiSize);
print("maximum dapi size "+maxDapiSize);
print("blur dapi by sigma "+DapiSigma);
for (st=0;st<lengthOf(Threshs);st++)
	{
	print("Thresholds (dapi excluded)_"+Threshs[st]+"");
	}
print("automatic threshold "+auto);	
print("threshold method (if auto) "+method);	
selectWindow("Log");


saveAs("Text", ""+subfolder+"log.txt");
