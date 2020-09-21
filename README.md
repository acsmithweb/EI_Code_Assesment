This is a .rb file that contains two classes, ConfigParserService and ParserUtilities
this is done to keep the code clean and readable. Additionally this provides an easy way to allow the config hash
to be directly placed into an existing application. Outside of the two classes is a call made to the 
ConfigParserService initialized with the given filename. This file can be executed by calling 
"ruby config_file_reader filename.cfg" file must be included in the same directory as the .rb file. 
