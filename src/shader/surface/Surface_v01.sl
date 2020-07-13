surface orange_surface (float Ka= 1; float Kd = 0.5; float Ks=0.5;float roughness = 0.1; color specularcolor = 1;)

{


//-----------------------Starting of Shader-----------------------------
  
    normal Nf = faceforward (normalize (N), I);
	vector V = -normalize(I);
	 point PP = transform("object", P);
	 vector NN = normalize(N);
	  


//-------------Testing Colors-------------------------------------------	  
	color green = color (0, 1, 0.000);
    color red = color (1.000, 0, 0.000);
    color blue = color (0,0,1);
    color lightorange = color "rgb" (0.91, 0.522, 0.016);
    color darkorange = color "rgb" (1, 0.502, 0);
    color darkorange2 = color "rgb" (1, 0.537, 0);
    color cadmiumorange = color "rgb" (1, 0.38,0.011);
    color darkgold = color "rgb" (1, 0.725,0.058);
	color tan = color "rgb" (0.541, 0.211, 0.058);
	color brown = color "rgb" (0.54, 0.27,0.74);
    color redlines = color "rgb" (0.93,0.46,0.12);
	color lastcolor = color "rgb" (1,0.54,0);

    
    float dots = float noise(PP*30);
    
    
    color Ct = mix(blue, darkorange, dots);
    
    float ss1 = xcomp(PP);
	float tt1 = ycomp(PP);
	

	Ct =  mix(darkorange,lightorange, ss1);

	float deform = 0;
	float turb_freq = 1;
	float i = 0;

	float fuzz = 0.3;
	float mag=0;
	mag=mix(0,0.4,float noise(PP*85));
	float inSpot=smoothstep(0.3-fuzz,0.7+fuzz,mag);
	
	float disp= smoothstep(0,1.25,inSpot);
	float poremag= disp;
	

	
	Ct = mix(Ct, red,poremag);
	
    
    for(i=0;i<6;i+=1)
        {
		deform +=abs(float noise(PP*turb_freq)-0.5)*2/turb_freq;
        turb_freq *=2.1;
        deform /= length(vtransform("object",NN));
		}
	
	
//--------------------------Stem----------------------------------------

	//--------stemmag is for the small circular dent--------------------
	float stemmag = 0;
	
	//We first find the position of the dent
	float position = smoothstep(0.01,0.04,t);
	
	//If it is in position, we will set the stemmag as 1
	stemmag = mix(0,1,position);
	
	Ct = mix(darkgold, Ct,stemmag);
	
	//--------replace position to add in the main hole------------------
	position = smoothstep(0.008,0.0145,t);
	
	float stemmag1 = mix(0,1,position);
	
	Ct = mix(tan, Ct,stemmag1);
	
	position = smoothstep(0.001,0.0145,t);
	stemmag1 = mix(0,1,position);
	
	Ct = mix(brown, Ct,stemmag1);
	
	position = smoothstep(-0.003,0.0145,t);
	stemmag1 = mix(0,1,position);
	Ct = mix(darkgold, Ct,stemmag1);
	
	position = smoothstep(-0.003,0.0145,t);
	stemmag1 = mix(0,1,position);
	Ct = mix(tan, Ct,stemmag1);
//----------------------------------------------------------------------

//--------------Spokes on Top-------------------------------------------
	
	//First divide the s circularly around the z 
    float ss2=mod(s*7,1);
    //Divide the object along t to create a dented surface
    float tt2=mod((t)*2,1);
    
    float depression=0;
    point centre=point (0.5,0.5,0);
    point here=point (ss2,tt2,0);
    float dist=distance(centre,here);
    


    //Checking if there is a depression
    //depression = inDisk;

    
    depression = mix(0,-1,dist);
    
	Ct = mix(Ct, redlines,dist);
   

    Ct = mix(Ct, lastcolor,deform);
	Oi = Os;
	Ci = Oi * (Ct * (Ka * ambient() + Kd * diffuse(Nf)) + specularcolor * Ks * specular(Nf, V, roughness));



}

