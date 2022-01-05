function r = fformat(file_list=false)
        ## All the files must be writted in csv format with the name and the license to be converted 
        ## in a list of structs, those structs must be with the next template
        ## 
        ## @example
        ##   
        ## d = struct (
        ##              "name", "fformat.m"
        ##              "license", "GPL"
        ## );
        ## @endexample
        ##
        ## All the structs must be agrupated in a list pushing one next others with a for loop or whatever 
        ## you take convenient.

        if(nargin==0 || file_list == false)
                ## file list must be expresed with the next notation:
                ## @example
                ## 
                ## color.m : GPL
                ## formating.m : GPL2
                ## text.m : MIT
                ## fformat.m : BSD
                ##
                ## @endexample
                f = fopen("octave_files.csv",'r');
                if(f==-1)
                        r = false;
                        error("octave_files.csv file do not exist, if you want converse files to licensed files, please\
                                pass to the function the list of files or create octave_files.csv file and write in csv \
                                format all the files");
                endif
                file_list = [];
                while (~feof(f))
                        buff = strdissmis(fgetl(f)," ");
                        if(length(buff)==0)
                                continue;
                        endif
                        buff = strsplit(buff,":");
                        if(length(buff) ~= 2)
                                r = false;
                                error("octave_files.csv format is not correct, check if it have a syntax error");
                        endif
                        d = struct (
                                "name", buff(1,1),
                                "license",buff(1,2)
                        );
                        file_list = [file_list , d];
                endwhile
                fclose(f);
        endif
        for a = 1:length(file_list)
                f = formatfile(file_list(a).name,file_list(a).license);
                if(~f)
                        r = false;
                        warning(strcat("error processing the file ",file_list(a).name));
                endif
        endfor
endfunction

function ret = strdissmis(text, pattern)
        ret = "";
        if (nargin ~=2)
                ret = false;
                error("must have 2 args");
        endif
        #if((typeinfo(text) ~= 'string') && (typeinfo(text) ~= 'sq_string'))
        #        ret = false;
        #        error("the two parameters must be string type");
        #endif
        if(typeinfo(pattern) ~= 'string' && typeinfo(pattern)~='sq_string')
                ret = false;
                error("the two parameters must be string type");
        endif
        for a = 1:length(text)
                if(text(a)~=pattern)
                        ret = strcat(ret,text(a));
                endif
        endfor
endfunction 

function r = formatfile(file_name, license_type)
        if (nargin == 0)
                r = false;
                print_usage();
                return;
        endif
        if (nargin == 1)
                license_type = 'GP3';
        endif
        switch (license_type)
                case "GPL"              ## General Public License v1.0
                        license = "licenses/GPLlicense.txt";
                case "GPL2"             ## General Public License v2.0
                        license = "licenses/GPL2license.txt";
                case "GPL3"             ## General Public License v3.0
                        license = "licenses/GPL3license.txt";
                case "MIT"              ## Massachusetts Institute of Technology license
                        license = "licenses/MITlicense.txt";
                case "BSD"              ## Berkeley Software Distribution license
                        license = "licenses/BSDlicense.txt";
                case "NCSA"             ## University of Illinois Open Source license
                        license = "licenses/NCSAlicense.txt";
                case "PHP"              ## PHP license v3.0
                        license = "licenses/PHPlicense.txt"; 
                case "W3C"              ## World Wide Web Consortium license 
                        license = "licenses/W3Clicense.txt";
                case "OpenSSL"          ## OpenSSL license
                        license = "licenses/OpenSSLlicense.txt";
                case "Mozilla"          ## Mozilla license
                        license = "licenses/Mozillalicense.txt";
                case "OSL"              ## Open Software License
                        license = "licenses/OSLlicense.txt"; 
                case "ASL"              ## Apple Software License
                        license = "licenses/ASLlicense.txt";
                case "CDDL"             ## Common Development and Distribution license
                        license = "licenses/CDDLlicense.txt";
                otherwise               ## in otherwise, take GPL v3.0 license
                        license = "licenses/GPL3license.txt";
        endswitch
        
        lic_desc = fopen(license,'r');
        if(lic_desc == -1)
                r = false;
                error("couldn't open license file, maybe not exist or its crashed");
        endif
        f =  fopen(strcat("files/",file_name),'r');
        if(f == -1)
                r = false;
                error("couldn't open file name path");
        endif

        license_text = char(fread(lic_desc,"char")');
        text = char(fread(f,"char")');
        text = strcat(license_text,text);
        fclose(f);
        fclose(lic_desc);

        d = dir;
        exist = false;
        for a=1:length(d)
                if(d(a).isdir == 1)
                        if(strcmp(d(a).name,"licensed"))
                                exist = true;
                        endif
                endif
        endfor
        if(~exist)
                mkdir licensed
        endif

        f = fopen(strcat("licensed/",file_name),'w');
        if(f == -1)
                r = false;
                error("couldn't create file at licensed folder");
        endif
        fwrite(f,text);
        fclose(f);
        r = true;
endfunction
