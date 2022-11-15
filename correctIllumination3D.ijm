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
filesTmp=getFileList(dir);

files=newArray();
for (i=0;i<filesTmp.length;i++)
	{

if ((indexOf(filesTmp[i], extention)) >= 0) 
		{files=Array.concat(files,filesTmp[i]);}
	}

	while (nImages>0) 
			{ 
		          selectImage(nImages); 
		          close(); 
		      	} 
//**************** Main Loop


run("Bio-Formats", "  open="+dir+files[0]+" color_mode=Default view=Hyperstack stack_order=XYCZT");		
rename("sum");

for (i=1;i<files.length;i++)
	{

	if ((indexOf(files[i], extention)) >= 0) 

		{
			
		
						//**********profiles Dapi **********
			
			selectWindow("sum");
			rename("old");
			
			run("Bio-Formats", "  open="+dir+files[i]+" color_mode=Default view=Hyperstack stack_order=XYCZT");		
			new=getTitle();			
			imageCalculator("Add create 32-bit stack", ""+new+"","old");
			rename("sum");
			close(new);
			close("old");
			}
		

	}
run("Divide...", "value="+files.length+" stack");
File.makeDirectory(dir+"illumination_corr");
File.makeDirectory(dir+"illumination_corr/param");
getDimensions(width, height, channels, slices, frames);
run("Gaussian Blur...", "sigma="+(width/20)+" stack");
saveAs("Tiff", dir+"illumination_corr/param/illumination.tif");
rename("background");

print(files.length);
for (i=0;i<files.length;i++)
	{
	run("Bio-Formats", "  open="+dir+files[i]+" color_mode=Default view=Hyperstack stack_order=XYCZT");		
	title=getTitle();
	imageCalculator("Divide create 32-bit stack", title,"background");
	saveAs("Tiff", dir+"illumination_corr/"+title+".tif");
	title2=getTitle();
	close(title);
	close(title2);
	}
close("background");
