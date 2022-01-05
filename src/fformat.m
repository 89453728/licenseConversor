function r = fformat(file_list)
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

        if(nargin == 0)
                f = fopen("octave_files.csv",'r');
                ## file list must be expresed with the next notation:
                ## @example
                ## 
                ## color.m : GPL
                ## formating.m : GPL2
                ## text.m : MIT
                ## fformat.m : BSD
                ##
                ## @endexample
                if(f==-1)
                        r = false;
                        error("octave_files.csv file do not exist, if you want converse files to licensed files, please\
                                pass to the function the list of files or create octave_files.csv file and write in csv \
                                format all the files");
                endif
                file_list = [];
                while (~feof(f))
                        buff = strdissmis(fgetl(f),' ');
                        if(length(buff)==0)
                                continue;
                        endif
                        buff = strplit(buff,':');
                        if(length(d) ~= 2)
                                r = false;
                                error("octave_files.csv format is not correct, check if it have a syntax error");
                        endif
                        d = struct (
                                "name", buff(1),
                                "license",buff(2)
                        );
                        file_list = [file_list , d];
                endwhile
        endif
        for a = 1:length(file_list)
                f = formatfile(file_list(a).name,file_list(a).license);
                if(~f)
                        r = false;
                        warning(strcat("error processing the file ",file_list(a).name));
                endif
        endfor
endfunction

function spl = strplit(text,pattern)
        ret = "";
        if (nargin ~=2)
                print_usage();
        endfunction
        if(typeinfo(text) ~= 'string' && typeinfo(text) ~= 'sq_string')
                error("the two parameters must be string type");
        endif
        if(typeinfo(pattern) ~= 'string' && typeinfo(pattern)~='sq_string')
                error("the two parameters must be string type");
        endif
        buff= "";
        spl=[];
        for a=1:length(text)
                if(text(a)~=pattern)
                        buff = strcat(buff,text(a));    
                else
                        spl = [spl ; buff ];
                        buff="";
                endif
        endfor
endfunction 
function ret = strdissmis(text, pattern)
        ret = "";
        if (nargin ~=2)
                print_usage();
        endfunction
        if(typeinfo(text) ~= 'string' && typeinfo(text) ~= 'sq_string')
                error("the two parameters must be string type");
        endif
        if(typeinfo(pattern) ~= 'string' && typeinfo(pattern)~='sq_string')
                error("the two parameters must be string type");
        endif
        for a = 1:length(text)
                if(text(a)~=pattern)
                        ret = strcat(ret,text(a));
                endif
        endfunction
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
                        license = fopen("licenses/GPLlicense.txt",'r');
                case "GPL2"             ## General Public License v2.0
                        license = fopen("licenses/GPL2license.txt",'r');
                case "GPL3"             ## General Public License v3.0
                        license = fopen("licenses/GPL3license.txt",'r');
                case "MIT"              ## Massachusetts Institute of Technology license
                        license = fopen("licenses/MITlicense.txt",'r');
                case "BSD"              ## Berkeley Software Distribution license
                        license = fopen("licenses/BSDlicense.txt",'r');
                case "NCSA"             ## University of Illinois Open Source license
                        license = fopen("licenses/NCSAlicense.txt",'r');
                case "PHP"              ## PHP license v3.0
                        license = fopen("licenses/PHPlicense.txt",'r'); 
                case "W3C"              ## World Wide Web Consortium license 
                        license = fopen("licenses/W3Clicense.txt",'r');
                case "OpenSSL"          ## OpenSSL license
                        license = fopen("licenses/OpenSSLlicense.txt",'r');
                case "Mozilla"          ## Mozilla license
                        license = fopen("licenses/Mozillalicense.txt",'r');
                case "OSL"              ## Open Software License
                        license = fopen("licenses/OSLlicense.txt",'r'); 
                case "ASL"              ## Apple Software License
                        license = fopen("licenses/ASLlicense.txt",'r');
                case "CDDL"             ## Common Development and Distribution license
                        license = fopen("licenses/CDDLlicense.txt",'r');
                otherwise               ## in otherwise, take GPL v3.0 license
                        license = fopen("licenses/GPL3license.txt",'r');
        endswitch
        
        lic_desc = fopen(license,'r');
        if(lic_desc == -1)
                r = false;
                error("couldn't open license file, maybe not exist or its crashed");
        endif
        f =  fopen(file_name,'r');
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
                        if(d(a).name == "licensed")
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
